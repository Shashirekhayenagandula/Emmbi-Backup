trigger OrderStatusMailingTrigger on Retail_Order__c (after update,before update,after Insert) {
    if(Trigger.isAfter && Trigger.isUpdate){
        List<Retail_Order__c> newOrders = Trigger.new;
    Map<Id, Retail_Order__c> oldOrderMap = Trigger.oldMap;

    // Call the helper method to handle the Status change and send the email
    HelperForOrderStatusMaillingController.handleStatusChangeAndSendEmail(newOrders, oldOrderMap);
    }
    /*if(Trigger.isBefore){
        List<Retail_Order__c> newOrders = Trigger.new;
    Map<Id, Retail_Order__c> oldOrderMap = Trigger.oldMap;

    // Call the helper method to handle the Status change and send the email
    HelperForOrderStatusMaillingController.StatusUpdationForUsers(newOrders, oldOrderMap);
    }*/
    if(Trigger.isAfter &&  Trigger.isInsert){
       List<Retail_Order__c> newOrders = Trigger.new;
        
         // Call the helper method to handle the Status change and send the email
    HelperForOrderStatusMaillingController.handleStatusInsertOrder(newOrders); 
    }
    
   
}