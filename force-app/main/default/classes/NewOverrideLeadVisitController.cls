public class NewOverrideLeadVisitController {
    @AuraEnabled
    public static String insertLeadVisitWithProduct(List<Retail_Lead_Product__c> productList, Retail_Lead_Visit__c leadVisit,Id leadId) {
        try {
            List<Retail_Lead_Product__c> lstiv = new List<Retail_Lead_Product__c>();
				System.debug('productList'+productList);
            System.debug('leadVisit'+leadVisit);
            if (Schema.sObjectType.Retail_Lead_Visit__c.isCreateable()) {
                upsert leadVisit;
            }

            String leadVisitId = leadVisit.Id;
            if(leadId!=null){
                Retail_Lead__c leadDetails=[SELECT Id,RetailLeadState__c, Retail_Lead_District__c,Is_Converted__c, Retail_Lead_Taluka__c,Village__c,Lead_Name__c,Phone__c FROM Retail_Lead__c WHERE Id = :leadId LIMIT 1];
					leadDetails.Is_Converted__c='Yes';
            		update leadDetails;
            System.debug('leadDetails'+leadDetails);
        }
            
            for (Retail_Lead_Product__c pro : productList) {
                Retail_Lead_Product__c product = new Retail_Lead_Product__c();
                System.debug('pro===='+pro.Name);
                product.Retail_Lead_Visit__c = leadVisit.Id;
                product.Retail_Product_Group__c = pro.Retail_Product_Group__c;
                product.Quantity__c = pro.Quantity__c;
                lstiv.add(product);
            }

            if (!lstiv.isEmpty() && Schema.sObjectType.Retail_Lead_Product__c.isCreateable()) {
                upsert lstiv;
            }

            return leadVisitId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static String insertLeadVisitOnly(Id leadId,Retail_Lead_Visit__c leadVisit) {
          System.debug('leadId'+leadId);
         Retail_Lead__c leadDetails=new Retail_Lead__c();
        
        try {
            if(leadId!=null){
               leadDetails=[SELECT Id,RetailLeadState__c, Retail_Lead_District__c,Is_Converted__c, Retail_Lead_Taluka__c,Village__c,Lead_Name__c,Phone__c FROM Retail_Lead__c WHERE Id = :leadId LIMIT 1];
					leadDetails.Is_Converted__c='Yes';
            		update leadDetails;
            System.debug('leadDetails'+leadDetails);
        }
            if (Schema.sObjectType.Retail_Lead_Visit__c.isCreateable()) {
                upsert leadVisit;
            }

             String leadVisitId = leadVisit.Id;
           return leadVisitId;  
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
     @AuraEnabled
     public static String insertLeadVisit(Id leadId,Retail_Lead_Visit__c leadVisit) {
          System.debug('leadId'+leadId);
             try {
            if (Schema.sObjectType.Retail_Lead_Visit__c.isCreateable()) {
                upsert leadVisit;
            }

             String leadVisitId = leadVisit.Id;
           return leadVisitId;  
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        
    }   

    @AuraEnabled(cacheable = true)
    public static Retail_Product_Group__c getProductGroupDetails(String productGroupId) {
        System.debug('productGroupId====' + productGroupId);
        Retail_Product_Group__c productGroup = [SELECT Id, Name FROM Retail_Product_Group__c WHERE Id = :productGroupId WITH SECURITY_ENFORCED];
        System.debug('productGroup==========' + productGroup);
        return productGroup;
    }
   
        @AuraEnabled(cacheable = true)
         public static Retail_Lead_Visit__c getLeadVisit(String leadVisitId) {
             
			Retail_Lead_Visit__c leadVisit=[SELECT Id,Date__c, Order_ID__c,Follow_up_Date__c, Lead_Name__c, Lead_Type__c, Level_of_Interest__c, Linked_Customer__c, Seller_ID__c, Sale_Type__c, Retail_Product_Group__c,Other_Reason_For_Cold__c,Reason_for_Cold_Lead__c FROM Retail_Lead_Visit__c WHERE Id =:leadVisitId  WITH SECURITY_ENFORCED ];
             return leadVisit;
         }
    @AuraEnabled(cacheable = true)
	public static Retail_Customer__c getLinkCustomer(String leadId) {
    List<Retail_Customer__c> linkCustomers = [SELECT Id, Link_Lead_ID__c FROM Retail_Customer__c WHERE Link_Lead_ID__c = :leadId LIMIT 1];
   
    if (!linkCustomers.isEmpty()) {
        return linkCustomers[0];
      
    }
    
    return null;
}
    @AuraEnabled(cacheable = true)
public static Retail_Lead__c getLinkCustomerLead(String leadId) {
    List<Retail_Lead__c>  leadDetails = [SELECT Id, Lead_Name__c,Lead_Type__c,Seller_Name__c FROM Retail_Lead__c WHERE Id =:leadId LIMIT 1];
    
    if (!leadDetails.isEmpty()) {
       
        return leadDetails[0];
    }
    
    return leadDetails[0];
}

}