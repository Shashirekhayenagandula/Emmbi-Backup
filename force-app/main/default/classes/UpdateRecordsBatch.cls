public class UpdateRecordsBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator('SELECT Id,Achivement__c,Invoice_Date__c FROM Opportunity__c where Invoice_Date__c = LAST_N_MONTHS:3');
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity__c> scope) {
        
        update scope;
    }
    
    public void finish(Database.BatchableContext bc) {
        // Any post-processing logic can be added here
    }
}