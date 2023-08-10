trigger UniqueEmail on Retail_Employee__c (before insert,before update) {
 
    if(trigger.isInsert && trigger.isBefore){
        List<Retail_Employee__c> lContactList = Trigger.New;
        Unique_Email.conEmail(lContactList);
    }
    if(trigger.isUpdate && trigger.isBefore){      
        Unique_Email.conEmailUpdate(trigger.new,trigger.oldMap);
    }
   

}