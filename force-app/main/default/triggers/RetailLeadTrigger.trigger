trigger RetailLeadTrigger on Retail_Lead__c (before insert, before update) {
    if(trigger.isBefore && trigger.isUpdate){
        RetailLeadTriggerHelper.updateSaleType(trigger.new, trigger.oldMap);
        RetailLeadTriggerHelper.updatePendingData(trigger.new);
        //RetailLeadTriggerHelper.handleBeforeInsertUpdate(Trigger.new);


    }
    /*if(Trigger.isBefore || Trigger.isInsert){
       
        RetailLeadTriggerHelper.handleBeforeInsertUpdate(Trigger.new);


    }*/
}