trigger leadIsConvertedFieldTrigger on Retail_Lead__c (before insert, before update) {
    //In the lead visit, if the level of interest is “Converted “ then the lead is converted Picklist should be yes
    Boolean isConvertedBasedOnCustomerID = false;
    Set<Id> leadVisitIds = new Set<Id>(); // Set to store Lead Visit record Ids
    Map<Id, Boolean> leadIdToConvertedMap = new Map<Id, Boolean>(); // Map to store Lead Ids and their conversion status
    if(isConvertedBasedOnCustomerID == false){
    for (Retail_Lead__c lead : Trigger.new) {
        if (lead.Lead_Visit__c != null) {
            leadVisitIds.add(lead.Lead_Visit__c); // Collect Lead Visit record Ids from Lead records
        }
    }
    
    if (!leadVisitIds.isEmpty()) {
        List<Retail_Lead_Visit__c> leadVisits = [SELECT Id, Level_of_Interest__c, Lead_Name__c FROM Retail_Lead_Visit__c WHERE Id IN :leadVisitIds]; // Query related Lead Visit records
        
        for (Retail_Lead_Visit__c visit : leadVisits) {
            if (visit.Level_of_Interest__c == 'Converted') {
                leadIdToConvertedMap.put(visit.Lead_Name__c, true); // Store Lead Id and its conversion status
            }
        }
    }
    
    for (Retail_Lead__c lead : Trigger.new) {
        if (leadIdToConvertedMap.containsKey(lead.Id)) {
            lead.Is_Converted__c = 'No'; // Update Is_Converted__c field to 'Yes' if Lead is associated with a converted Lead Visit
            isConvertedBasedOnCustomerID = true;

        } else {
            lead.Is_Converted__c = 'Yes'; // Update Is_Converted__c field to 'No' if Lead is not associated with a converted Lead Visit
            isConvertedBasedOnCustomerID = true;

        }
    }
       
    }
    
    
   // Creation of lead: When the link customer id field is not equal to null then is converted should be “Yes” or else “No”
    if(isConvertedBasedOnCustomerID == false){
    for (Retail_Lead__c lead : Trigger.new) {
        if (lead.Link_Customer_Id__c != null) {
            lead.Is_Converted__c = 'Yes';
        } else {
            lead.Is_Converted__c = 'No';
        }
    }
  }
    
}