public class CustomerControllerForNew {
     @AuraEnabled(cacheable=true)
    public static Retail_Lead__c getLeadDetails(Id masterId) {
        Retail_Lead__c leadDetails=[SELECT Id,RetailLeadState__c, Retail_Lead_District__c, Retail_Lead_Taluka__c,Village__c,Lead_Name__c,Phone__c FROM Retail_Lead__c WHERE Id = :masterId LIMIT 1];
    return leadDetails;
    }
     @AuraEnabled(cacheable=true)
     public static Retail_Customer__c getCustomerDetails(Id masterId) {
         System.debug('masterId==========='+masterId);
        	Retail_Customer__c customerDetails=new Retail_Customer__c();
         if(masterId!=null || masterId!=''){
       List<Retail_Customer__c> customerDetails1=[SELECT Id,Link_Lead_ID__c FROM Retail_Customer__c WHERE Link_Lead_ID__c = :masterId LIMIT 1];
         System.debug('customerDetails============'+customerDetails);
            if (customerDetails1.size()>0){
                customerDetails=customerDetails1[0];
             return customerDetails;
             }
             else{
                  return customerDetails;
             }
         }
        return customerDetails;
    }
      @AuraEnabled
    public static Retail_Lead__c updateLead(Id leadId) {
        System.debug('leadId'+leadId);
        Retail_Lead__c leadDetails=new Retail_Lead__c();
        if(leadId!=null){
                   leadDetails=[SELECT Id,RetailLeadState__c, Retail_Lead_District__c,Is_Converted__c, Retail_Lead_Taluka__c,Village__c,Lead_Name__c,Phone__c FROM Retail_Lead__c WHERE Id = :leadId LIMIT 1];
					leadDetails.Is_Converted__c='Yes';
            		update leadDetails;
            System.debug('leadDetails'+leadDetails);
        }
        
    return leadDetails;
    }
     @AuraEnabled(cacheable=true)
     public static Retail_Customer__c getCustomerPhoneDetails(String phone) {
         System.debug('phone==========='+phone);
        	Retail_Customer__c customerDetails=new Retail_Customer__c();
         if(phone!=null || phone!=''){
       List<Retail_Customer__c> customerDetails1=[SELECT Id,Link_Lead_ID__c,Phone_Number__c FROM Retail_Customer__c WHERE Phone_Number__c = :phone LIMIT 1];
         System.debug('customerDetails============'+customerDetails);
            if (customerDetails1.size()>0){
                customerDetails=customerDetails1[0];
             return customerDetails;
             }
             else{
                  return customerDetails;
             }
         }
        return customerDetails;
    }
      @AuraEnabled(cacheable=true)
     public static Retail_Customer__c getCustomerEmailDeatils(String email) {
         System.debug('email==========='+email);
        	Retail_Customer__c customerDetails=new Retail_Customer__c();
         if(email!=null || email!=''){
       List<Retail_Customer__c> customerDetails1=[SELECT Id,Link_Lead_ID__c,Email__c FROM Retail_Customer__c WHERE Email__c = :email LIMIT 1];
         System.debug('customerDetails============'+customerDetails);
            if (customerDetails1.size()>0){
                customerDetails=customerDetails1[0];
             return customerDetails;
             }
             else{
                  return customerDetails;
             }
         }
        return customerDetails;
    }
    	@AuraEnabled(cacheable=true)
      public static Retail_Order__c OrderRelatedCustomer(Id recordId) {
        System.debug('recordId'+recordId);
        Retail_Order__c orderDetails=new Retail_Order__c();
        if(recordId!=null){
               orderDetails=[SELECT Id,Retail_Customer__c,Order_Date__c from Retail_Order__c where Retail_Customer__c=:recordId ORDER BY Order_Date__c DESC limit 1];
            System.debug('orderDetails'+orderDetails);
        }
          if(orderDetails.Order_Date__c!=null){
               return orderDetails;
          }
    return orderDetails;
    }
    
}