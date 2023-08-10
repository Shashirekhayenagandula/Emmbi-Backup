public class RetailLeadTriggerHelper {
    public static void updateSaleType(List<Retail_Lead__c> newRetailLeadsList, Map<Id,Retail_Lead__c> oldRetailLeadsMap){
        System.debug('Test');
        for(Retail_Lead__c retails : newRetailLeadsList){
            if(oldRetailLeadsMap.containsKey(retails.Id) && retails.Sale_Type__c != oldRetailLeadsMap.get(retails.Id).Sale_Type__c){
                if((retails.Sale_Type__c == 'Indirect' && oldRetailLeadsMap.get(retails.Id).Sale_Type__c == 'Direct') || (retails.Sale_Type__c == 'Direct' && oldRetailLeadsMap.get(retails.Id).Sale_Type__c == 'Indirect')){
                    retails.Sale_Type__c = 'Both';
                }
                else if(oldRetailLeadsMap.get(retails.Id).Sale_Type__c == 'Both'){
                    retails.Sale_Type__c = 'Both';
                }
            }
        }
    }
    
    public static void updatePendingData(List<Retail_Lead__c> newRetailLeadsList2){
        for(Retail_Lead__c retails2 : newRetailLeadsList2){
            //1
                if(retails2.Sale_Type__c == 'Both'){
                    if(retails2.Seller_Name__c == null && retails2.Link_Customer_Id__c == null){
                        retails2.Pending_Data__c = 'Both';
                    }
                    else if(retails2.Seller_Name__c == null && retails2.Link_Customer_Id__c != null){
                        retails2.Pending_Data__c = 'Seller Id';
                    }
                    else if(retails2.Seller_Name__c != null && retails2.Link_Customer_Id__c == null){
                        retails2.Pending_Data__c = 'Customer Id';
                    }
                }
            
            
            //2
            
            if(retails2.Sale_Type__c == 'Direct' && retails2.Link_Customer_Id__c == null){
                retails2.Pending_Data__c = 'Customer Id';
            }
            
            //3
            
            if(retails2.Sale_Type__c == 'Indirect' && retails2.Seller_Name__c == null){
                retails2.Pending_Data__c = 'Seller Id';
            }
            

        }
                
    }
    
    //To check the Phone number uniqueness
  /*  public static void handleBeforeInsertUpdate(List<Retail_Lead__c> newLeads) {
        
        for (Retail_Lead__c lead : newLeads) {
            if (lead.Phone__c == null || lead.Phone__c.length() != 10) {
                lead.Phone__c.addError('Phone number must be 10 digitsss.');
            }
        }
        
        
        
        
        
        
        Set<String> phoneNumbers = new Set<String>();
        
        for (Retail_Lead__c lead : newLeads) {
            if (!String.isBlank(lead.Phone__c)) {
                phoneNumbers.add(lead.Phone__c);
            }
        }
        
        Map<String,Retail_Lead__c> existingLeads = new Map<String,Retail_Lead__c>([
            SELECT Id,Phone__c
            FROM Retail_Lead__c
            WHERE Phone__c IN: phoneNumbers
            
            
        ]);
        
        for (Retail_Lead__c lead : newLeads) {
            if (!String.isBlank(lead.Phone__c) && existingLeads.containsKey(lead.Phone__c) &&
                (lead.Phone__c != existingLeads.get(lead.Phone__c).Phone__c)) {
                lead.Phone__c.addError('Phone number already exists in a different record.');
            }
        }
    }*/
    
    
}