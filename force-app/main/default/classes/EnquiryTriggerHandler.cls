public class EnquiryTriggerHandler extends TriggerHandler{
    public override void afterUpdate(){
        Opportunity__c OldEnq;
        Set<Id> setLeadId= new Set<Id>();
        for(Opportunity__c newEnq: (List<Opportunity__c>)trigger.new){
            OldEnq=(Opportunity__c)trigger.oldMap.get(newEnq.Id);
            if(newEnq.Opportunity_Stage__c != OldEnq.Opportunity_Stage__c && newEnq.Opportunity_Stage__c !='Not Interested'){
                    setLeadId.add(newEnq.Lead__c);
                }
        }
        System.debug('setLeadId::'+setLeadId);
        
        List<Lead__c> leadList=[select id,Lost_Lead__c from Lead__c where Id In:setLeadId AND Lost_Lead__c=true];
        System.debug('enqList::'+leadList);
        
        if(leadList!=null && leadList.size()>0){
            for(Lead__c ld: leadList){
                ld.Lost_Lead__c=false;
            }
        }
        System.debug('leadList::'+leadList);
        try{
            if(leadList!=null && leadList.size()>0){
               update leadList;
            }
        }catch(Exception e){
            System.debug('Something Wrong::'+e.getMessage()+'Line No:: '+e.getLineNumber());
        }
    }   
}