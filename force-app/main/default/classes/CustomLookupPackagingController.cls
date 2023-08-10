public class CustomLookupPackagingController {
    @AuraEnabled(cacheable=true)
    public static List<Retail_Employee__c> searchRecords(String searchTerm) {
        String searchKey = '%' + searchTerm + '%'; 

        return [SELECT Id, Name FROM Retail_Employee__c WHERE Name LIKE :searchKey];
    }

}