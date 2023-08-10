public with sharing class RetailLeadCls {
  /* public static List<Retail_Lead__c> retailLeadDataCapture() {
        List<Retail_Lead__c> leadData = [SELECT Id,Lead_Owner__c,Lead_Source__c,Name,Date__c,Lead_Type__c,Seller_Name__c,Lead_Name__c,Phone__c,RetailLeadState__r.Name,Retail_Lead_District__r.Name,Retail_Lead_Taluka__r.Name,Village__c,Is_Converted__c,Last_Order_Date__c,Sale_Type__c,Pending_Data__c,InterestedProducts__c FROM Retail_Lead__c];
        System.debug('leadData===>'+leadData);
        return leadData;
    }*/
    
     @AuraEnabled(cacheable=true)
     public static Retail_Lead__c getRetailLeadPhoneDetails(String phone,Id linkedCustomerId) {
         System.debug('phone==========='+phone);
        	Retail_Lead__c leadDetails=new Retail_Lead__c();
         if(phone!=null || phone!=''){
       List<Retail_Lead__c> leadDetails1=[SELECT Id,Phone__c,Link_Customer_Id__c FROM Retail_Lead__c WHERE Phone__c = :phone LIMIT 1];
         System.debug('leadDetails============'+leadDetails);
            if (leadDetails1.size()>0){
                leadDetails=leadDetails1[0];
             return leadDetails;
             }
             else{
                  return leadDetails;
             }
         }
        return leadDetails;
    }

    @AuraEnabled(cacheable=true)
     public static Retail_Lead__c getLeadDetails(Id masterId) {
         System.debug('masterId==========='+masterId);
         Retail_Lead__c leadDetails=new Retail_Lead__c();
         if(masterId!=null || masterId!=''){
       List<Retail_Lead__c> leadDetails1=[SELECT Id,Link_Customer_Id__c FROM Retail_Lead__c WHERE Link_Customer_Id__c = :masterId LIMIT 1];
         System.debug('leadDetails============'+leadDetails);
            if (leadDetails1.size()>0){
              leadDetails=leadDetails1[0];
             return leadDetails;
             }
             else{
                  return leadDetails;
             }
         }
        return leadDetails;
    }


@AuraEnabled(cacheable=true)
    public static List<Retail_District__c> getDistrictOptions(String stateId){
       List<Retail_District__c> districtDetails=new List<Retail_District__c>();
        if(stateId!=null){
        districtDetails=[SELECT Id, State__c, Name FROM Retail_District__c WHERE State__c=:stateId]; 
            System.debug('districtDetails.size'+districtDetails.size());
        if(districtDetails.size()>0){
             return districtDetails;
        }   
        }
        return districtDetails;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Retail_Taluka__c> getTalukaOptions(String districtId){
       List<Retail_Taluka__c> talukaDetails=new List<Retail_Taluka__c>();
        if(districtId!=null){
        talukaDetails=[SELECT Id, Add_District__c, Name FROM Retail_Taluka__c WHERE Add_District__c=:districtId]; 
            System.debug('talukaDetails.size'+talukaDetails.size());
        if(talukaDetails.size()>0){
             return talukaDetails;
        }   
        }
        return talukaDetails;
    }



}