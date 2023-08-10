public class LeadControllerForEdit {
    @AuraEnabled(cacheable=true)
    public static Retail_Lead__c leadRecords(String leadRecordId){
        System.debug('leadRecId-->'+leadRecordId);
        Retail_Lead__c Query = [SELECT Id,Lead_Name__c,Lead_Type__c,Lead_Visit__c,Link_Customer_Id__c FROM Retail_Lead__c WHERE Id=:leadRecordId LIMIT 1];
        System.debug('Query-->'+Query);
        return Query;
    }

}