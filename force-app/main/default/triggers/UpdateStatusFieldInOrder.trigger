trigger UpdateStatusFieldInOrder on Retail_Upload_Commercial_Invoice__c (After insert) 
{
    try{
         List<Retail_Order__c> accounts = new List<Retail_Order__c>();
    Set<ID> accountIDs = new Set<ID>();
    for(Retail_Upload_Commercial_Invoice__c con : Trigger.new){
        accountIDs.add(con.Select_Order__c);
    }    
    for(Retail_Order__c acc : [SELECT Id, Name,Status__c, Sales_Owner__c ,(SELECT Id, Name, Select_Order__c,Ready_for_dispatch__c FROM Retail_Upload_Commercial_Invoices__r) FROM Retail_Order__c where ID IN: accountIDs]){
        
        for(Retail_Upload_Commercial_Invoice__c con : acc.Retail_Upload_Commercial_Invoices__r){
           // acc.Ready_for_dispatch__c == true;
        }
        acc.Status__c = 'Ready For Dispatch';
        accounts.add(acc);
    }
    update accounts;
    }catch(exception e){
        System.debug('Exception'+e.getMessage());
    }
   
}