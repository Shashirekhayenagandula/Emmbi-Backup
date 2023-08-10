public class NewOverrideOrderController {
    
    @AuraEnabled
    public static String insertOrderWithProduct(List<Retail_Order_Product__c> productList, Retail_Order__c order) {
        try {
             OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'surender@dhruvsoft.com'];
            List<Retail_Order_Product__c> lstiv = new List<Retail_Order_Product__c>();
            System.debug('productList'+productList);
            System.debug('order'+order);
            
            if (Schema.sObjectType.Retail_Order__c.isCreateable()) {
                
                    insert order;
                     System.debug('After Insert order 14 '+order);
               
               
            }
            Retail_Order__c orderDetails=[SELECT Id, Name,Status__c FROM Retail_Order__c where Id=:order.Id];
            System.debug('order 14'+order);
             System.debug('order 14 Name'+order.Name);
           /* if(order.Status__c=='Exec Discount Approval'){
              
            
            Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
            String[] toaddresses = new String[] {'shashirekha@dhruvsoft.com'}; 
                mymail.setToAddresses(toAddresses);
            mymail.setSubject('Order Status');
            mymail.setPlainTextBody('Order Status is Changes to '+order.Status__c);
            mymail.setOrgWideEmailAddressId(owea.get(0).Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });   
            }
            
           else if(order.Status__c=='Awaiting Exec Approval'){
                System.debug('Testing Else if 26');
             
            Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
            String[] toaddresses = new String[] {'shashirekha@dhruvsoft.com'}; 
                //mymail.setToAddresses(toAddresses);
            String subject = order.Name+' Order Received - '+order.Status__c;
           mymail.setSubject(subject);
			mymail.setOrgWideEmailAddressId(owea.get(0).Id);
            String EmailBody = '<html><body>';
EmailBody +='Dear '+order.Owner.name+',<br/>';
			EmailBody +='<p></p>';
			EmailBody +='Your order '+ order.Name+' is currently awaiting credit approval. Please continue to check the status of your order on this page : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+order.Id+'" target="_blank">Order</a><br/>';
			EmailBody +='<p></p>';
			EmailBody +='<b>Warm Regards,</b><br/>';
			EmailBody +='<b>Avana Operations Team</b><br/>';
			EmailBody += '</body></html>';
			mymail.setHtmlBody(EmailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });   
            }
            
            else if(order.Status__c=='Awaiting Accounts'){
                           
            Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
            String[] toaddresses = new String[] {'shashirekha@dhruvsoft.com'}; 
                mymail.setToAddresses(toAddresses);
            mymail.setSubject('Order Status');
            mymail.setPlainTextBody('Order Status is Changes to '+order.Status__c);
            mymail.setOrgWideEmailAddressId(owea.get(0).Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });   
            }*/
             if(order.Retail_Customer__c!=null){
               String CustomerId=order.Retail_Customer__c;
               Date OrderDate=order.Order_Date__c;
                System.debug('order.Retail_Customer__c'+order.Retail_Customer__c);
                Retail_Customer__c CustomerDetails=[Select Id,Last_Order_Date__c from Retail_Customer__c where Id=:CustomerId limit 1];
                if(OrderDate!=null){
                    CustomerDetails.Last_Order_Date__c=OrderDate;
                    update CustomerDetails;
                }
                
            }
            
            String orderId = order.Id;
            try{
                for (Retail_Order_Product__c pro : productList) {
                    Retail_Order_Product__c product = new Retail_Order_Product__c();
                    System.debug('pro===='+pro.Name);
                    product.Retail_Order__c = order.Id;
                    product.Product_Group__c = pro.Product_Group__c;
                    product.Product__c = pro.Product__c;
                    product.Net_Total_for_Product__c = pro.Net_Total_for_Product__c;
                    product.Product_Discount__c = pro.Product_Discount__c;
                    product.Sub_Total__c = pro.Sub_Total__c;
                    product.Weight_Kg__c = pro.Weight_Kg__c;
                    product.Discounted_Kg_Rate__c = pro.Discounted_Kg_Rate__c;
                    product.Kg_Rate__c = pro.Kg_Rate__c;
                    product.Unit_Price__c = pro.Unit_Price__c;
                    product.Discounted_Unit_Price__c = pro.Discounted_Unit_Price__c;
                    product.Quantity__c = pro.Quantity__c;
                    product.Std_Pkg_Sizes__c = pro.Std_Pkg_Sizes__c;
                    product.Hole_Spacing__c = pro.Hole_Spacing__c;
                    product.HoleType__c = pro.HoleType__c;
                    lstiv.add(product);
                }
                if (!lstiv.isEmpty() && Schema.sObjectType.Retail_Order_Product__c.isCreateable()) {
                    insert lstiv;
                }
            }
            catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
            
            return orderId;
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static String upsertOrder(List<Retail_Order_Product__c> productList , Retail_Order__c order, List<Retail_Order_Product__c> removeLineItemIds) {
        try {
            System.debug('order' + order);
            System.debug('order Id' + order.Id);
            System.debug('productList1========' + productList);
            if(order.Id!=null){
                 System.debug('order Id' + order.Id);
                update order;
            }
            System.debug('productList2======' + productList.size());
            if(productList.size()>0){
                System.debug('productList3======' + productList.size());
                if (Schema.sObjectType.Retail_Order_Product__c.isUpdateable() || Schema.sObjectType.Retail_Order_Product__c.isCreateable()) {
                     System.debug('productList3======' + productList.size());
                    System.debug('productList Id==123=='+productList[0].Id);
                    upsert productList;
                }
            }
            String orderId = order.Id;
             System.debug('orderId' + orderId);
           if (removeLineItemIds.size() > 0) {
                 System.debug('removeLineItemIds======' + removeLineItemIds.size());
                if (Schema.sObjectType.Retail_Order_Product__c.isDeletable()) {
                    delete removeLineItemIds;
                }
            }
            
            return orderId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Retail_Order_Product__c> fetchProductList(String recordId) {
        System.debug('recordId55'+recordId);
        return [select Id,Retail_Order__c,Discounted_Kg_Rate__c, Discounted_Unit_Price__c, Hole_Spacing__c, HoleType__c, Kg_Rate__c, Name, Net_Total_for_Product__c, Product__c, Product_Discount__c, Product_Group__c, Quantity__c,Std_Pkg_Sizes__c, Sub_Total__c, Weight_Kg__c,Unit_Price__c from Retail_Order_Product__c where Retail_Order__c =:recordId];
    }
     @AuraEnabled(cacheable=true)
    public static String getPrevoiusOrders(String customerId){
        
		List<Retail_Order__c> orderDetails=[select id,Retail_Customer__c from Retail_Order__c where Retail_Customer__c=:customerId];  
        if(orderDetails.size()>0){
             return orderDetails[0].Id;
        }
        return null;
    }
   @AuraEnabled(cacheable=true)
    public static Retail_Product__c getProductDetails(String productId){
		Retail_Product__c productDetails=[select id,Std_Package_Size__c from Retail_Product__c where id=:productId limit 1];  
        if(productDetails!=null){
             return productDetails;
        }
        return null;
    } 
     @AuraEnabled(cacheable=true)
    public static Retail_Inventory__c getUnitPrice(String productId,String dispatchWarehouseId){
        if(productId!=null && dispatchWarehouseId!=null){
          List<Retail_Inventory__c> inventoryDetails=[Select id,Product_Name__c,Instock__c,Warehouse_Code__c,Retailer_Price__c from Retail_Inventory__c where (Product_Name__c =:productId) and (Warehouse_Code__c =:dispatchWarehouseId)]; 
        if(inventoryDetails.size()>0){
             return inventoryDetails[0];
        }  
        }
		
        return null;
    } 
     @AuraEnabled(cacheable=true)
    public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName ,string productGroupId) {    
        List <sObject> returnList = new List <sObject>();
        string sWildCardText = '%' + searchKey + '%';
        string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText and Retail_Product_Group__c=:productGroupId order by createdDate DESC';
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        return returnList;
    }
     @AuraEnabled(cacheable=true)
    public static Boolean getMulchProductGroup(String productGroupId){
        Boolean isMulchFilm=false;
		List<Retail_Product_Group__c> productDetails=[select id,Name from Retail_Product_Group__c where (id=:productGroupId) and (Name='Avana Mulch Film')];  
        System.debug('productDetails'+productDetails);
        if(productDetails.size()>0){
            isMulchFilm=true;
             return isMulchFilm;
        }
        return isMulchFilm;
    }
    @AuraEnabled(cacheable=true)
    public static Retail_Customer__c getCustomerDetails(String customerId){
        Retail_Customer__c customerDetails=new Retail_Customer__c();
        if(customerId!=null){
         customerDetails=[select Id,PAN_Number__c,GST_Number__c from Retail_Customer__c where id=:customerId limit 1];  
        if(customerDetails!=null){
             return customerDetails;
        }   
        }
		
        return customerDetails;
    }
    @AuraEnabled(cacheable=true)
    public static List<Retail_Lead_Visit__c> getLeadVisitOptions(String customerId){
       List<Retail_Lead_Visit__c> leadVisitDetails=new List<Retail_Lead_Visit__c>();
        if(customerId!=null){
        leadVisitDetails=[select Id,Linked_Customer__c,Name from Retail_Lead_Visit__c where Linked_Customer__c=:customerId]; 
            System.debug('leadVisitDetails.size'+leadVisitDetails.size());
        if(leadVisitDetails.size()>0){
             return leadVisitDetails;
        }   
        }
        return leadVisitDetails;
    }
     @AuraEnabled(cacheable=true)
    public static List<Retail_Product__c> getProductOptions(String productGroupId){
       List<Retail_Product__c> productDetails=new List<Retail_Product__c>();
        if(productGroupId!=null){
        productDetails=[select Id,Retail_Product_Group__c,Product_Name__c,Status__c from Retail_Product__c where (Retail_Product_Group__c=:productGroupId) AND (Status__c='Active')]; 
            System.debug('productDetails.size'+productDetails.size());
        if(productDetails.size()>0){
             return productDetails;
        }   
        }
        return productDetails;
    }
    @AuraEnabled(cacheable=true)
    public static Retail_Lead_Visit__c getLeadVisitName(String leadVisitId){
       Retail_Lead_Visit__c getLeadVisitName=new Retail_Lead_Visit__c();
        if(leadVisitId!=null){
        getLeadVisitName=[select Id,Name from Retail_Lead_Visit__c where Id=:leadVisitId limit 1]; 
            System.debug('getLeadVisitName.size'+getLeadVisitName);
        if(getLeadVisitName!=null){
             return getLeadVisitName;
        }   
                         }
        return null;
                         
    }
     @AuraEnabled(cacheable=true)
    public static Retail_Product__c getProductName(String productId){
       Retail_Product__c getProduct=new Retail_Product__c();
        if(productId!=null){
        getProduct=[select Id,Name,Product_Name__c from Retail_Product__c where Id=:productId limit 1]; 
            System.debug('getProduct.size'+getProduct);
        if(getProduct!=null){
             return getProduct;
        }   
                         }
        return null;
                         
    }                    
                         
}