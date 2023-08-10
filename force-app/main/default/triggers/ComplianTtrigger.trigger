trigger ComplianTtrigger on Complaint__c (before update) {
    if(AvanaTrigger__c.getInstance().ComplaintTrigger__c==true){
        System.debug('inside Trigger Active::::');
        new ComplainTTriggerHandler().run();
    }

}