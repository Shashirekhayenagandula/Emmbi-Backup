public class HelperForOrderStatusMaillingController {
    public static void handleStatusChangeAndSendEmail(List<Retail_Order__c> newOrders, Map<Id, Retail_Order__c> oldOrderMap) {
        System.debug('Method Entered');
        System.debug('Method Entered 4'+newOrders);
        System.debug('Method Entered 5'+oldOrderMap);
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'surender@dhruvsoft.com'];
        List<Retail_Order__c> ordersToUpdate = new List<Retail_Order__c>();
        List<Retail_Order__c> ordersToSendEmail = new List<Retail_Order__c>();
        for (Retail_Order__c newOrder : newOrders) {
            Retail_Order__c oldOrder = oldOrderMap.get(newOrder.Id);
            System.debug('oldOrder.Status__c'+oldOrder);
            System.debug('newOrder.Status__c'+newOrder.Status__c);
            System.debug('oldOrder.Status__c'+oldOrder.Status__c);
            if (newOrder.Status__c != oldOrder.Status__c) {
                ordersToUpdate.add(newOrder);
                if ((oldOrder.Status__c == 'Awaiting Accounts' && newOrder.Status__c == 'Payment Approved')||(oldOrder.Status__c == 'Exec Discount Approval' && newOrder.Status__c == 'Payment Approved') || (oldOrder.Status__c == 'Awaiting Exec Approval' && newOrder.Status__c == 'Payment Approved')) {
                    
                    System.debug('+newOrder.Owner.name'+newOrder.OwnerId);
                    User SalesOwner=[Select Id,Name,Email from user where id =:newOrder.OwnerId limit 1];
                    List<String> toaddresses=New List<String>();
                    System.debug('UserList toaddresses'+toaddresses);
                    Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                    toaddresses.add('shashirekha@dhruvsoft.com'); 
                    toaddresses.add('thanmayee@dhruvsoft.com'); 
                    // toaddresses.add(SalesOwner.Email); 
                    mymail.setToAddresses(toaddresses);
                    String subject = newOrder.Name+' Status: '+newOrder.Status__c+' -Prepare for Dispatch'; 
                    mymail.setSubject(subject);
                    
                    String EmailBody = '<html><body>';
                    EmailBody += 'Dear '+SalesOwner.Name+',<br/>';
                    EmailBody += '<p><p/>';
                    EmailBody +='The payment for this order '+newOrder.Name+' is approved. It is now being prepared for dispatch. Please continue to check the status of your order on this page : ';
                    EmailBody +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBody +='<p><p/>';
                    EmailBody +='<b>Warm Regards,</b><br/>';
                    EmailBody +='<b>Avana Operations Team</b><br/>';
                    EmailBody += '</body></html>';
                    mymail.setHtmlBody(EmailBody);
                    mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
                    
                    List<String> toaddressesForProduction= HelperForOrderStatusMaillingController.getMailAddresses('Production');
                    System.debug('toaddressesForProduction'+toaddressesForProduction);
                    Retail_Warehouse__c WarehouseDeatils=[SELECT Id, Name, Warehouse_Type__c, GST_Number__c, Point_of_Contact_POC_Name__c, POC_Phone_Number__c, POC_Email__c FROM Retail_Warehouse__c where Id=:newOrder.Dispatch_Warehouse__c];
                    Messaging.SingleEmailMessage mailProduction = new Messaging.SingleEmailMessage();
                    toaddressesForProduction.add('shashirekha@dhruvsoft.com'); 
                    toaddressesForProduction.add('thanmayee@dhruvsoft.com'); 
                    mailProduction.setToAddresses(toaddressesForProduction);
                    String EmailBodyProduction = '<html><body>';
                    EmailBodyProduction += 'Dear Production Team,<br/>';
                    EmailBodyProduction += '<p><p/>';
                    EmailBodyProduction +='The Payment is approved for this order '+newOrder.Name+'. You may reach the '+WarehouseDeatils.Name+'. The Point of Contact for this warehouse is, '+WarehouseDeatils.Point_of_Contact_POC_Name__c+', on '+WarehouseDeatils.POC_Phone_Number__c+'. ';
                    EmailBodyProduction +='Please check stock availability. If stock is available for this order then please change the status to “Upload Packaging List” on this order Page: ';
                    EmailBodyProduction +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBodyProduction +='<p><p/>';
                    EmailBodyProduction +='<b>Warm Regards,</b><br/>';
                    EmailBodyProduction +='<b>Avana Operations Team</b><br/>';
                    EmailBodyProduction += '</body></html>';
                    mailProduction.setHtmlBody(EmailBodyProduction);
                    mailProduction.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailProduction }); 
                    
                }
                else if ((oldOrder.Status__c == 'Exec Discount Approval' && newOrder.Status__c == 'Awaiting Accounts')||(oldOrder.Status__c == 'Awaiting Exec Approval' && newOrder.Status__c == 'Awaiting Accounts')) {
                    System.debug('+newOrder.Owner.name'+newOrder.OwnerId);
                    user SalesOwner=[Select Id,Name,Email from user where id =:newOrder.OwnerId limit 1];
                    List<String> toaddresses= HelperForOrderStatusMaillingController.getMailAddresses('Accounts');
                    System.debug('UserList toaddresses'+toaddresses);
                    Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                    toaddresses.add('shashirekha@dhruvsoft.com'); 
                    toaddresses.add('thanmayee@dhruvsoft.com'); 
                    // toaddresses.add(SalesOwner.Email); 
                    mymail.setToAddresses(toaddresses);
                    String subject = newOrder.Name+' Order Received - '+newOrder.Status__c;
                    mymail.setSubject(subject);
                    
                    String EmailBody = '<html><body>';
                    EmailBody += 'Dear '+SalesOwner.Name+',<br/>';
                    EmailBody += '<p><p/>';
                    EmailBody +='Your order '+newOrder.Name+' is currently Awaiting Advance Approval. <br/><br/>Please continue to check the status of your order on this page : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBody +='<p><p/>';
                    EmailBody +='<b>Warm Regards,</b><br/>';
                    EmailBody +='<b>Avana Operations Team</b><br/>';
                    EmailBody += '</body></html>';
                    mymail.setHtmlBody(EmailBody);
                    mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
                }
                else if(oldOrder.Status__c == 'Payment Approved' && newOrder.Status__c == 'Upload Packing List'){
                    
                    System.debug('+newOrder.Owner.name'+newOrder.OwnerId);
                    User SalesOwner=[Select Id,Name,Email from user where id =:newOrder.OwnerId limit 1];
                    List<String> toaddresses=New List<String>();
                    System.debug('UserList toaddresses'+toaddresses);
                    Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                    toaddresses.add('shashirekha@dhruvsoft.com'); 
                    toaddresses.add('thanmayee@dhruvsoft.com'); 
                    // toaddresses.add(SalesOwner.Email); 
                    mymail.setToAddresses(toaddresses);
                    String subject = newOrder.Name+' Status: '+newOrder.Status__c+' -Prepare for Dispatch'; 
                    mymail.setSubject(subject);
                    
                    String EmailBody = '<html><body>';
                    EmailBody += 'Dear '+SalesOwner.Name+',<br/>';
                    EmailBody += '<p><p/>';
                    EmailBody +='The payment for this order '+newOrder.Name+' is approved. It is now being prepared for dispatch. Please continue to check the status of your order on this page : ';
                    EmailBody +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBody +='<p><p/>';
                    EmailBody +='<b>Warm Regards,</b><br/>';
                    EmailBody +='<b>Avana Operations Team</b><br/>';
                    EmailBody += '</body></html>';
                    mymail.setHtmlBody(EmailBody);
                    mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
                    
                }
                else if((oldOrder.Status__c == 'Upload Packing List' && newOrder.Status__c == 'Production Approved')|| (oldOrder.Status__c == 'Packing List in Process' && newOrder.Status__c == 'Production Approved')){
                    
                    List<String> toaddressesForCommercial= HelperForOrderStatusMaillingController.getMailAddresses('Commercial');
                    System.debug('toaddressesForCommercial'+toaddressesForCommercial);
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    toaddressesForCommercial.add('shashirekha@dhruvsoft.com'); 
                    toaddressesForCommercial.add('thanmayee@dhruvsoft.com'); 
                    mail.setToAddresses(toaddressesForCommercial);
                    String subject = newOrder.Name+' Status: '+newOrder.Status__c; 
                    mail.setSubject(subject);
                    
                    String EmailBody = '<html><body>';
                    EmailBody += 'Dear Commercial Team,<br/>';
                    EmailBody += '<p><p/>';
                    EmailBody +='This order '+newOrder.Name+' is in stock. Please upload commercial invoice on this page : ';
                    EmailBody +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/o/Retail_Upload_Commercial_Invoice__c/list?filterName=00B9H000000T3qYUAS" target="_blank">Retail Upload Commercial Invoice page</a>. ';
                    EmailBody +='You may view the status of the order on this page. ';
                    EmailBody +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBody +='<p><p/>';
                    EmailBody +='<b>Warm Regards,</b><br/>';
                    EmailBody +='<b>Avana Operations Team</b><br/>';
                    EmailBody += '</body></html>';
                    mail.setHtmlBody(EmailBody);
                    
                    mail.setHtmlBody(EmailBody);
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
                }
                else if(oldOrder.Status__c == 'Production Approved' && newOrder.Status__c == 'Ready For Dispatch'){
                    System.debug('+newOrder.Owner.name'+newOrder.OwnerId);
                    User SalesOwner=[Select Id,Name,Email from user where id =:newOrder.OwnerId limit 1];
                    List<String> toaddresses=New List<String>();
                    System.debug('UserList toaddresses'+toaddresses);
                    Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                    toaddresses.add('shashirekha@dhruvsoft.com'); 
                    toaddresses.add('thanmayee@dhruvsoft.com'); 
                    // toaddresses.add(SalesOwner.Email); 
                    mymail.setToAddresses(toaddresses);
                    String subject = newOrder.Name+' Status: '+newOrder.Status__c; 
                    mymail.setSubject(subject);
                    
                    String EmailBody = '<html><body>';
                    EmailBody += 'Dear '+SalesOwner.Name+',<br/>';
                    EmailBody += '<p><p/>';
                    EmailBody +='Your order '+newOrder.Name+' is ready for dispatch.It is awaiting transporter to carry it away. Please continue to check the status of your order on this page : ';
                    EmailBody +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBody +='<p><p/>';
                    EmailBody +='<b>Warm Regards,</b><br/>';
                    EmailBody +='<b>Avana Operations Team</b><br/>';
                    EmailBody += '</body></html>';
                    mymail.setHtmlBody(EmailBody);
                    mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
                    
                    List<String> toaddressesForProduction= HelperForOrderStatusMaillingController.getMailAddresses('Commercial');
                    System.debug('toaddressesForProduction'+toaddressesForProduction);
                    
                    Messaging.SingleEmailMessage mailProduction = new Messaging.SingleEmailMessage();
                    toaddressesForProduction.add('shashirekha@dhruvsoft.com');
                    toaddressesForProduction.add('thanmayee@dhruvsoft.com'); 
                    mailProduction.setToAddresses(toaddressesForProduction);
                    String subjectProduction = newOrder.Name+' Status: '+newOrder.Status__c; 
                    mailProduction.setSubject(subjectProduction);
                    
                    String EmailBodyCommercial = '<html><body>';
                    EmailBodyCommercial += 'Dear Transport Team,<br/>';
                    EmailBodyCommercial += '<p><p/>';
                    EmailBodyCommercial +='This order '+newOrder.Name+' is ready for dispatch. Please acquire transporter info and upload on this page : ';
                    EmailBodyCommercial +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/o/Retail_Upload_Shipment_tracking_Info__c/list?filterName=Recent" target="_blank">Avana Shipment Tracking Info</a><br/>';
                    EmailBodyCommercial +='<p><p/>';
                    EmailBodyCommercial +='<b>Warm Regards,</b><br/>';
                    EmailBodyCommercial +='<b>Avana Operations Team</b><br/>';
                    EmailBodyCommercial += '</body></html>';
                    mailProduction.setHtmlBody(EmailBodyCommercial);
                    mailProduction.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailProduction }); 
                    
                }
                else if(oldOrder.Status__c == 'Ready For Dispatch' && newOrder.Status__c == 'Dispatched Awaiting Final Payment'){
                    System.debug('+newOrder.Owner.name'+newOrder.OwnerId);
                    user SalesOwner=[Select Id,Name,Email from user where id =:newOrder.OwnerId limit 1];
                    List<String> toaddresses= HelperForOrderStatusMaillingController.getMailAddresses('Accounts');
                    System.debug('UserList toaddresses'+toaddresses);
                    Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                    toaddresses.add('shashirekha@dhruvsoft.com'); 
                    toaddresses.add('thanmayee@dhruvsoft.com'); 
                    // toaddresses.add(SalesOwner.Email); 
                    mymail.setToAddresses(toaddresses);
                    String subject = newOrder.Name+' Status - Dispatched Awaiting Final Payment '; 
                    mymail.setSubject(subject);
                    
                    String EmailBody = '<html><body>';
                    EmailBody += 'Dear Account Team,<br/>';
                    EmailBody += '<p><p/>';
                    EmailBody += 'This order '+newOrder.Name+' is awaiting for final payment. Once the final payment is received, ';
                    EmailBody +='Please change the status of for this order on this page : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBody +='<p><p/>';
                    EmailBody +='<b>Warm Regards,</b><br/>';
                    EmailBody +='<b>Avana Operations Team</b><br/>';
                    EmailBody += '</body></html>';
                    mymail.setHtmlBody(EmailBody);
                    mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
                    
                }
                else if(oldOrder.Status__c == 'Dispatched Awaiting Final Payment' && newOrder.Status__c == 'Completed'){
                    System.debug('+newOrder.Owner.name'+newOrder.OwnerId);
                    User SalesOwner=[Select Id,Name,Email from user where id =:newOrder.OwnerId limit 1];
                    List<String> toaddresses=New List<String>();
                    System.debug('UserList toaddresses'+toaddresses);
                    Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                    toaddresses.add('shashirekha@dhruvsoft.com'); 
                    toaddresses.add('thanmayee@dhruvsoft.com'); 
                    // toaddresses.add(SalesOwner.Email); 
                    mymail.setToAddresses(toaddresses);
                    String subject = newOrder.Name+' is out for delivery '; 
                    mymail.setSubject(subject);
                    
                    String EmailBody = '<html><body>';
                    EmailBody += 'Dear '+SalesOwner.Name+',<br/>';
                    EmailBody += '<p><p/>';
                    EmailBody += 'The order '+newOrder.Name+' is dispatched and will be delivered soon. ';
                    EmailBody += 'You may check the status of your order on this order Page: ';
                    EmailBody +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBody +='<p><p/>';
                    EmailBody +='<b>Warm Regards,</b><br/>';
                    EmailBody +='<b>Avana Operations Team</b><br/>';
                    EmailBody += '</body></html>';
                    mymail.setHtmlBody(EmailBody);
                    mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
                    /********Customer Mail**********/
                    
                    Messaging.SingleEmailMessage mailCustomer = new Messaging.SingleEmailMessage();
                    Retail_Customer__c CustomerDetails=[Select id,Name,Name__c,Last_Name__c,Email__c from Retail_Customer__c where Id=:newOrder.Retail_Customer__c ];
                    System.debug('CustomerDetails.Email__c== 258'+CustomerDetails.Email__c);
                    List<String> toaddressesForCustomer=new List<String>();
                    toaddressesForCustomer.add('shashirekha@dhruvsoft.com'); 
                    toaddressesForCustomer.add('thanmayee@dhruvsoft.com');
                    if(Test.isRunningTest()) { 
                        
                    } else {
                       toaddressesForCustomer.add(CustomerDetails.Email__c);
                    }
                    
                    mailCustomer.setToAddresses(toaddressesForCustomer);
                    
                    String customerSubject = newOrder.Name+' is out for delivery '; 
                    mailCustomer.setSubject(customerSubject);
                    
                    String customerEmailBody = '<html><body>';
                    customerEmailBody += 'Dear '+CustomerDetails.Name__c+' ' + CustomerDetails.Last_Name__c+',';
                    customerEmailBody += '<p><p/>';
                    customerEmailBody += 'Your order '+newOrder.Name+' is out for delivery and will be delivered soon. ';
                    customerEmailBody += 'Thank you for your order. It was a pleasure doing business with you.';
                    customerEmailBody +='<p><p/>';
                    customerEmailBody +='<b>Warm Regards,</b><br/>';
                    customerEmailBody +='<b>Avana Operations Team</b><br/>';
                    customerEmailBody += '</body></html>';
                    mailCustomer.setHtmlBody(customerEmailBody);
                    mailCustomer.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailCustomer });
                    
                }
                
                
            }
            
        }
        // Send email to the specified email address for relevant orders
        if (!ordersToSendEmail.isEmpty()) {
            sendEmailForOrders(ordersToSendEmail);
        }
    }
    
    private static void sendEmailForOrders(List<Retail_Order__c> orders) {
        String recipientEmail = '1234@gmail.com';
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'surender@dhruvsoft.com'];
        
        Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
        String[] toaddresses = new String[] {'shashirekha@dhruvsoft.com'};
            toaddresses.add('thanmayee@dhruvsoft.com'); 
        mymail.setToAddresses(toaddresses);
        mymail.setSubject('Order Status');
        mymail.setOrgWideEmailAddressId(owea.get(0).Id);
        mymail.setPlainTextBody('Hello,\n\nThe following orders have been updated to "Awaiting Accounts":\n\n');
        
        for (Retail_Order__c order : orders) {
            mymail.setPlainTextBody(mymail.getPlainTextBody() + 'Order ID: ' + order.Name + '\n');
            // You can add more order details as needed
        }
        
        Messaging.sendEmail(new List<Messaging.Email> { mymail });
    }
    public static void StatusUpdationForUsers(List<Retail_Order__c> newOrders, Map<Id, Retail_Order__c> oldOrderMap) {
        System.debug('Method Entered');
        List<Retail_Order__c> ordersToUpdate = new List<Retail_Order__c>();
        List<Retail_Order__c> ordersToSendEmail = new List<Retail_Order__c>();
        User MakarandUser=[Select Name,Email from user where Email='makrand.appalwar@emmbi.com.invalid'];
        
        String currentUserEmail = UserInfo.getUserEmail(); 
        System.debug('currentUserEmail: ' + currentUserEmail);
        
        for (Retail_Order__c newOrder : newOrders) {
            Retail_Order__c oldOrder = oldOrderMap.get(newOrder.Id);
            System.debug('oldOrder: ' + oldOrder);
            
            if (newOrder.Status__c != oldOrder.Status__c) {
                System.debug('newOrder.Status__c: ' + newOrder.Status__c);
                ordersToUpdate.add(newOrder);
                
                if ((oldOrder.Status__c == 'Exec Discount Approval' || oldOrder.Status__c == 'Awaiting Exec Approval') && (currentUserEmail == 'akash.chavan@emmbi.com' || currentUserEmail == MakarandUser.Email) && (newOrder.Status__c == 'Awaiting Accounts' || newOrder.Status__c == 'Payment Approved')) {
                    newOrder.Status__c = 'Awaiting Accounts';
                    System.debug('Entered into If Condition');
                } else {
                    // Use addError to stop the update and display a custom error message
                    newOrder.addError('You Cannot Change the Status of Order');
                }
            }
        }
    }
    
    
    public static void handleStatusInsertOrder(List<Retail_Order__c> newOrders) {
        System.debug('Method Entered');
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'surender@dhruvsoft.com'];
        List<Retail_Order__c> ordersToUpdate = new List<Retail_Order__c>();
        //  List<Retail_Order__c> ordersToSendEmail = new List<Retail_Order__c>();
        
        for (Retail_Order__c newOrder : newOrders) {
            if(newOrder.Status__c=='Awaiting Exec Approval'){ 
                System.debug('+newOrder.Owner.name'+newOrder.OwnerId);
                User SalesOwner=[Select Id,Name,Email from user where id =:newOrder.OwnerId limit 1];
                User MakarandUser=[Select Name,Email from user where Email='makrand.appalwar@emmbi.com.invalid'];
                System.debug('MakarandUser'+MakarandUser.Name);
                System.debug('MakarandUser'+MakarandUser.Email);
                List<String> toaddresses= new List<String>();
                System.debug('UserList toaddresses'+toaddresses);
                Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                toaddresses.add(MakarandUser.Email); 
                toaddresses.add('shashirekha@dhruvsoft.com'); 
                toaddresses.add('thanmayee@dhruvsoft.com'); 
                // toaddresses.add(SalesOwner.Email); 
                mymail.setToAddresses(toaddresses);
                String subject = newOrder.Name+' Order Received - '+newOrder.Status__c;
                mymail.setSubject(subject);
                mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                String EmailBody = '<html><body>';
                EmailBody +='Dear '+MakarandUser.Name+',<br/>';
                EmailBody +='<p></p>';
                EmailBody +='Your order '+ newOrder.Name+' is currently awaiting credit approval. Please continue to check the status of your order on this page : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                EmailBody +='<p></p>';
                EmailBody +='<b>Warm Regards,</b><br/>';
                EmailBody +='<b>Avana Operations Team</b><br/>';
                EmailBody += '</body></html>';
                mymail.setHtmlBody(EmailBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });   
            }
            
            else if(newOrder.Status__c=='Awaiting Accounts'){
                System.debug('+newOrder.Owner.name'+newOrder.OwnerId);
                user SalesOwner=[Select Id,Name,Email from user where id =:newOrder.OwnerId limit 1];
                List<String> toaddresses= HelperForOrderStatusMaillingController.getMailAddresses('Accounts');
                System.debug('UserList toaddresses'+toaddresses);
                Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                toaddresses.add('shashirekha@dhruvsoft.com'); 
                toaddresses.add('thanmayee@dhruvsoft.com'); 
                // toaddresses.add(SalesOwner.Email); 
                mymail.setToAddresses(toaddresses);
                String subject = newOrder.Name+' Order Received - '+newOrder.Status__c;
                mymail.setSubject(subject);
                
                String EmailBody = '<html><body>';
                EmailBody += 'Dear '+SalesOwner.Name+',<br/>';
                EmailBody += '<p><p/>';
                EmailBody +='Your order '+newOrder.Name+' is currently Awaiting Advance Approval. <br/><br/>Please continue to check the status of your order on this page : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                EmailBody +='<p><p/>';
                EmailBody +='<b>Warm Regards,</b><br/>';
                EmailBody +='<b>Avana Operations Team</b><br/>';
                EmailBody += '</body></html>';
                mymail.setHtmlBody(EmailBody);
                mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });   
            }
            
            else if(newOrder.Status__c=='Exec Discount Approval'){
                RetailOrderPdfGenerator.generateAndSendEmail(newOrder.Id);
            } 
            else if(newOrder.Status__c=='Payment Approved')
            {
             System.debug('+newOrder.Owner.name'+newOrder.OwnerId);
                    User SalesOwner=[Select Id,Name,Email from user where id =:newOrder.OwnerId limit 1];
                    List<String> toaddresses=New List<String>();
                    System.debug('UserList toaddresses'+toaddresses);
                    Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                    toaddresses.add('shashirekha@dhruvsoft.com'); 
                    toaddresses.add('thanmayee@dhruvsoft.com'); 
                    // toaddresses.add(SalesOwner.Email); 
                    mymail.setToAddresses(toaddresses);
                    String subject = newOrder.Name+' Status: '+newOrder.Status__c+' -Prepare for Dispatch'; 
                    mymail.setSubject(subject);
                    
                    String EmailBody = '<html><body>';
                    EmailBody += 'Dear '+SalesOwner.Name+',<br/>';
                    EmailBody += '<p><p/>';
                    EmailBody +='The payment for this order '+newOrder.Name+' is approved. It is now being prepared for dispatch. Please continue to check the status of your order on this page : ';
                    EmailBody +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBody +='<p><p/>';
                    EmailBody +='<b>Warm Regards,</b><br/>';
                    EmailBody +='<b>Avana Operations Team</b><br/>';
                    EmailBody += '</body></html>';
                    mymail.setHtmlBody(EmailBody);
                    mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
                    
                    List<String> toaddressesForProduction= HelperForOrderStatusMaillingController.getMailAddresses('Production');
                    System.debug('toaddressesForProduction'+toaddressesForProduction);
                    Retail_Warehouse__c WarehouseDeatils=[SELECT Id, Name, Warehouse_Type__c, GST_Number__c, Point_of_Contact_POC_Name__c, POC_Phone_Number__c, POC_Email__c FROM Retail_Warehouse__c where Id=:newOrder.Dispatch_Warehouse__c];
                    Messaging.SingleEmailMessage mailProduction = new Messaging.SingleEmailMessage();
                    toaddressesForProduction.add('shashirekha@dhruvsoft.com'); 
                    toaddressesForProduction.add('thanmayee@dhruvsoft.com'); 
                    mailProduction.setToAddresses(toaddressesForProduction);
                    String EmailBodyProduction = '<html><body>';
                    EmailBodyProduction += 'Dear Production Team,<br/>';
                    EmailBodyProduction += '<p><p/>';
                    EmailBodyProduction +='The Payment is approved for this order '+newOrder.Name+'. You may reach the '+WarehouseDeatils.Name+'. The Point of Contact for this warehouse is, '+WarehouseDeatils.Point_of_Contact_POC_Name__c+', on '+WarehouseDeatils.POC_Phone_Number__c+'. ';
                    EmailBodyProduction +='Please check stock availability. If stock is available for this order then please change the status to “Upload Packaging List” on this order Page: ';
                    EmailBodyProduction +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
                    EmailBodyProduction +='<p><p/>';
                    EmailBodyProduction +='<b>Warm Regards,</b><br/>';
                    EmailBodyProduction +='<b>Avana Operations Team</b><br/>';
                    EmailBodyProduction += '</body></html>';
                    mailProduction.setHtmlBody(EmailBodyProduction);
                    mailProduction.setOrgWideEmailAddressId(owea.get(0).Id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailProduction }); 
                       
            }
            if(newOrder.Has_this_Customer_faced_issues_with_orde__c=='Yes'){
                System.debug('newOrder.Has_this_Customer_faced_issues_with_orde__c'+newOrder.Has_this_Customer_faced_issues_with_orde__c);
                RetailOrderPdfGenerator.generateAndSendEmailForProblematic(newOrder.Id);   
                
            }
        }
    }
    public static List<String> getMailAddresses(String groupName){
        List<String> idList = new List<String>();
        List<String> mailToAddresses = new List<String>(); 
        
        Group gp = [SELECT (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Name =: groupName];
        for (GroupMember gm : gp.GroupMembers) {
            idList.add(gm.UserOrGroupId);
        }
        List<User> userList = [SELECT Email FROM User WHERE Id IN :idList and IsActive=True];
        for(User u : userList) {
            mailToAddresses.add(u.email);
        } 
        system.debug('Mail to address from group--->'+mailToAddresses);
        return mailToAddresses;
    }
    
}