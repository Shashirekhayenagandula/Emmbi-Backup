trigger InventoryTrigger on Retail_Inventory__c (before insert,before update,before delete,after insert,after update,after delete) {
    if(trigger.isInsert && trigger.isBefore){  
        for(Retail_Inventory__c inv:trigger.new)
        {
            if(inv.Instock__c > inv.Notification_Threshold_Value__c){
                inv.Availability__c = 'Instock';
            }
            else if(inv.Instock__c < inv.Notification_Threshold_Value__c){
                inv.Availability__c = 'Low Stock'; 
            }
            else if(inv.Instock__c == inv.Notification_Threshold_Value__c){
                inv.Availability__c = 'Instock'; 
            }
            else{
                inv.Availability__c = ''; 
            }
        }
    }
    if(trigger.isUpdate && trigger.isBefore){  
        for(Retail_Inventory__c inv:trigger.new)
        {
            if(trigger.oldMap.get(inv.Id).Instock__c != inv.Instock__c || trigger.oldMap.get(inv.Id).Notification_Threshold_Value__c != inv.Notification_Threshold_Value__c){
                system.debug('Entered into before update inventory trigger');
                if(inv.Instock__c > inv.Notification_Threshold_Value__c){
                    inv.Availability__c = 'Instock';
                }
                else if(inv.Instock__c < inv.Notification_Threshold_Value__c){
                    inv.Availability__c = 'Low Stock'; 
                }
                else if(inv.Instock__c == inv.Notification_Threshold_Value__c){
                    inv.Availability__c = 'Instock'; 
                }
                else{
                    inv.Availability__c = ''; 
                }
            }
        }
    }
     if(Trigger.isAfter && Trigger.isUpdate){
        List<Retail_Inventory__c> newInventory = Trigger.new;
  
    // Call the helper method to handle the Status change and send the email
    InventoryTriggerHelperController.handleSendEmailAfterUpdate(newInventory);
    }
    
    
  if (Trigger.isInsert || Trigger.isUpdate) {
        // Handle insert or update events
        InventoryTriggerHelperController.updateParentTotalInStock(Trigger.new);
    } else if (Trigger.isDelete) {
        // Handle delete events
        InventoryTriggerHelperController.updateParentTotalInStock(Trigger.old);
    }
 /*  if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        InventoryTriggerHelperController.handleInventoryUpdate(Trigger.new, Trigger.oldMap);
    }*/
    
    if(Trigger.isUpdate && Trigger.isAfter){
        if(InventoryTriggerHelperController.isInventoryInstockUpdate){
        InventoryTriggerHelperController.updateInstockAtInventory(Trigger.new);
        }
    }
    
}