trigger UpdateOrderReturnObject on Retail_Upload_Credit_Note__c (after insert, before insert) 
{
    set<Id> orderReturnIds = new set<Id>();
    
    for (Retail_Upload_Credit_Note__c child : Trigger.new) {
        orderReturnIds.add(child.Id);
    }
    
    List<Retail_Order_Return_Form__c> parentsToUpdate = [SELECT Id, Status__c FROM Retail_Order_Return_Form__c WHERE Id IN :orderReturnIds];
    
    for (Retail_Order_Return_Form__c parent : parentsToUpdate) {
        parent.Status__c = 'Return Complete';
    }
    
    update parentsToUpdate;
    system.debug('Updatedd');
}