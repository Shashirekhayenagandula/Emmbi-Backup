public class RetailOrderPdfGenerator {
    

    @future(callout=true)
    public static void generateAndSendEmail(Id orderId) {
        Retail_Order__c newOrder = [SELECT Id, Name, OwnerId, Status__c FROM Retail_Order__c WHERE Id = :orderId];
        User SalesOwner = [SELECT Id, Name, Email FROM User WHERE Id = :newOrder.OwnerId LIMIT 1];
        User MakarandUser = [SELECT Name, Email FROM User WHERE Email = 'makrand.appalwar@emmbi.com.invalid'];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'surender@dhruvsoft.com'];
        List<String> toAddresses = new List<String>();
        toAddresses.add(MakarandUser.Email);
        toAddresses.add('shashirekha@dhruvsoft.com');
        toAddresses.add('thanmayee@dhruvsoft.com');

        Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
        mymail.setToAddresses(toAddresses);
        String subject = newOrder.Name + ' Order Received - ' + newOrder.Status__c;
        mymail.setSubject(subject);

        String emailBody = '<html><body>';
        emailBody += 'Dear ' + SalesOwner.Name + ',<br/>';
        emailBody += '<p></p>';
        emailBody += 'Your new order has been successfully placed. The order number is ' + newOrder.Name + '. It is currently awaiting Managers discount approval. ';
        emailBody += 'Please continue to check the status of your order on this page: <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + newOrder.Id + '" target="_blank">Order</a><br/>';
        emailBody += '<p></p>';
        emailBody += '<b>Warm Regards,</b><br/>';
        emailBody += '<b>Avana Operations Team</b><br/>';
        emailBody += '</body></html>';

        mymail.setHtmlBody(emailBody);

        Blob pdfBlob = generatePDF(newOrder.Id);

        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setContentType('application/pdf');
        efa.setFileName('Invoice_of_Test.pdf');
        efa.setInline(false);
        efa.setBody(pdfBlob);

        mymail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
        mymail.setOrgWideEmailAddressId(owea.get(0).Id);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
    }
    @future(callout=true)
    public static void generateAndSendEmailForProblematic(Id orderId) {
        Retail_Order__c newOrder = [SELECT Id, Name, OwnerId, Status__c FROM Retail_Order__c WHERE Id = :orderId];
        User SalesOwner = [SELECT Id, Name, Email FROM User WHERE Id = :newOrder.OwnerId LIMIT 1];
        User SalilUser=[Select Name,Email from user where Email='salil.kulkarni@emmbi.com.invalid'];
                System.debug('SalilUser'+SalilUser.Name);
                System.debug('SalilUser'+SalilUser.Email);
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'surender@dhruvsoft.com'];
        List<String> toAddresses = new List<String>();
       
        toAddresses.add('shashirekha@dhruvsoft.com');
        toAddresses.add('thanmayee@dhruvsoft.com');
		 toAddresses.add(SalilUser.Email);
        Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
        mymail.setToAddresses(toAddresses);
      String subject = newOrder.Name+' Status - New Order for a customer with problematic previous dispatch received'; 
       mymail.setSubject(subject);
	   
		String EmailBody = '<html><body>';
	   EmailBody += 'Dear '+SalilUser.Name+',<br/>';
	   EmailBody += '<p><p/>';
	   EmailBody +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newOrder.Id+'" target="_blank">Order</a><br/>';
	   EmailBody +='<p><p/>';
	   EmailBody +='<b>Warm Regards,</b><br/>';
	   EmailBody +='<b>Avana Operations Team</b><br/>';
	   EmailBody += '</body></html>';
	   mymail.setHtmlBody(EmailBody);

        Blob pdfBlob = generatePDFForProblematic(newOrder.Id);

        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setContentType('application/pdf');
        efa.setFileName('Invoice_of_Test.pdf');
        efa.setInline(false);
        efa.setBody(pdfBlob);

        mymail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
        mymail.setOrgWideEmailAddressId(owea.get(0).Id);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
    }
    public static Blob generatePDFForProblematic(Id orderId) {
        // Generate the PDF content using the Visualforce page
        PageReference pdfPage = Page.Problematic_Previous_OrderTemplate;
        pdfPage.getParameters().put('id', orderId);
        pdfPage.setRedirect(true);
         if(Test.isRunningTest()) { 
           return blob.valueOf('Unit.Test');
        } else {
             return pdfPage.getContentAsPDF();
        }
    }

    public static Blob generatePDF(Id orderId) {
        // Generate the PDF content using the Visualforce page
        PageReference pdfPage = Page.Embi_Order_Template;
        pdfPage.getParameters().put('id', orderId);
        pdfPage.setRedirect(true);
        if(Test.isRunningTest()) { 
           return blob.valueOf('Unit.Test');
        } else {
             return pdfPage.getContentAsPDF();
        }
    }

}