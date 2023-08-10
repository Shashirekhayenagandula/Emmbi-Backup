trigger LeadVisitTrigger on Retail_Lead_Visit__c (after insert,after update) {
    if((trigger.isInsert || trigger.isUpdate) && trigger.isAfter){
        LeadvisitTriggerHandler.handleAfterInsert(Trigger.new);
    }
}