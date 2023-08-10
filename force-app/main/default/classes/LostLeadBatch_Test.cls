@isTest
public class LostLeadBatch_Test {
    public static testMethod void LostLeadBatch_MethodTest(){
        Id  userId=UserInfo.getUserId();
        
        Lead__c ld= new Lead__c();
        ld.Farmer_Last_Name__c='H';
        ld.Farmer_Middle_Name__c='s';
        ld.Farmer_First_Name__c='S';
        ld.Address__c='indiranagar';
        ld.Mobile_Number__c='9876594421';
        ld.Stages__c='New';
        ld.Distributor_Email__c='abac@gmail.com';
        ld.IsConverted__c=false;
        insert ld;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Lead__c=ld.Id;
        opp.Opportunity_Stage__c='Not Interested'; 
        opp.Opportunity_Lost_to__c='Price too high';
        insert opp;
        
        Test.startTest();
        LostLeadBatch lostLdBt= new LostLeadBatch(); 
        DataBase.executeBatch(lostLdBt,200);
        SchedulableContext sc = null;
        lostLdBt.execute(sc);
        Test.stopTest(); 
    }

}