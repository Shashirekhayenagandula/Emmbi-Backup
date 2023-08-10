/* ───────────────────────────────────────────────────────────────────────────────
* @Description      : 
* @Author           : 
* @Company          : Venerate Solutions
* @created          : 
* @Last Modified By : 
* @Last Modified On : 
* @Modification Log : 
* ─────────────────────────────────────────────────────────────────────────────────
*/

global class LostLeadBatch implements Database.Batchable<sObject>,schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC){
        String OppStage='Not Interested';
        String query='SELECT Id, Farmer_First_Name__c,Lost_Lead__c,(SELECT Id, Name FROM Opportunity__r WHERE Opportunity_Stage__c=\''+OppStage+'\') FROM Lead__c Where ID Not IN (SELECT Lead__c FROM Opportunity__c WHERE Opportunity_Stage__c!=\''+OppStage+'\')';
        System.debug('Build Query::::'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead__c> Leadlist){
        List<Lead__c> updateLeadList=new List<Lead__c>();
        System.debug('Leadlist Size::::::::'+Leadlist.size()+' details::::'+Leadlist);
        for(Lead__c ld: Leadlist){
            if(ld.Opportunity__r.size()>0){
                Lead__c ll=new Lead__c();
                ll.id=ld.id;
                ll.Lost_Lead__c=true;
                updateLeadList.add(ll);
            }
        }        
        system.debug('updateLeadList Size::'+updateLeadList.size()+ 'details updatelist::'+updateLeadList);
        try{
            if(updateLeadList!=null && updateLeadList.size()>0){
       		 Database.Update(updateLeadList,false);
            }
        } catch(Exception e){
            System.debug('Something Wrong::'+e.getMessage()+'Line No:: '+e.getLineNumber());
        }               
    }
     global void finish(Database.BatchableContext BC){
         System.debug('LostLeadBatch finished');
    }
    
    global void execute(SchedulableContext sc) {
        LostLeadBatch lostLdbatch = new LostLeadBatch();
        ID batchprocessid = Database.executeBatch(lostLdbatch,500);
    }
}