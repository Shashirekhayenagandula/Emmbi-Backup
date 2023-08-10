trigger LeadTriggerHandler on Lead__c(after insert) {
    
    Id farmerId;
    
    if(Trigger.isInsert){
        
        for (Lead__c l : Trigger.New){
            farmerId=l.Id;
        }
        
    }
    
    whatsAppIntegration.sendWtpMessage(farmerId);

}