public class LeadvisitTriggerHandler {
    public static void handleAfterInsert(List<Retail_Lead_Visit__c> newLeadvisits) {
        List<Retail_Lead__c> leadsToUpdate = new List<Retail_Lead__c>();
        for(Retail_Lead_Visit__c retails : newLeadvisits){
            if(retails.Lead_Name__c != null){
                Retail_Lead__c parentLead = new Retail_Lead__c();
                parentLead.Id = retails.Lead_Name__c;
                parentLead.Sale_Type__c = retails.Sale_Type__c;
                leadsToUpdate.add(parentLead);
            }
        }
        Map<Id,Retail_Lead__c> leadsToUpdateMap = new Map<Id,Retail_Lead__c>(leadsToUpdate);
        // Perform the bulk update of Lead records
        if (!leadsToUpdateMap.isEmpty()) {
            update leadsToUpdateMap.values(); 
        }
    }
}