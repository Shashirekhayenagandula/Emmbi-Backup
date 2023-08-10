trigger RetailLeadTriggerOnPendingDataField on Retail_Lead__c (before insert,before update) {
 public static void updatePendingData(List<Retail_Lead__c> leadsToUpdate) {
        List<Retail_Lead__c> leadsWithBothSaleType = new List<Retail_Lead__c>();
        
        for (Retail_Lead__c lead : leadsToUpdate) {
            if (lead.Sale_Type__c == 'Both') {
                leadsWithBothSaleType.add(lead);
            }
        }
        
        for (Retail_Lead__c lead : leadsToUpdate) {
            if (leadsWithBothSaleType.contains(lead)) {
                if (String.isBlank(lead.Seller_Name__c) && String.isBlank(lead.Link_Customer_Id__c)) {
                    lead.Pending_Data__c = 'Both';
                } else if (String.isBlank(lead.Seller_Name__c)) {
                    lead.Pending_Data__c = 'Seller ID';
                } else if (String.isBlank(lead.Link_Customer_Id__c)) {
                    lead.Pending_Data__c = 'Customer ID';
                }
            }
        }
    }

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            updatePendingData(Trigger.new);
        } else if (Trigger.isUpdate) {
            updatePendingData(Trigger.newMap.values());
        }
    }
}