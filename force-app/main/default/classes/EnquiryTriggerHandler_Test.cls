@isTest
public class EnquiryTriggerHandler_Test {
    public static testMethod void EnquiryTriggerMethod(){
        AvanaTrigger__c tokenCustomSetting = new AvanaTrigger__c();         
        tokenCustomSetting.Name = 'EnquiryTrigger__c';        
        tokenCustomSetting.EnquiryTrigger__c = true;        
        insert tokenCustomSetting;
        
        Lead__c ld= new Lead__c();
        ld.Farmer_Last_Name__c='H';
        ld.Farmer_Middle_Name__c='s';
        ld.Farmer_First_Name__c='S';
        ld.Address__c='indiranagar';
        ld.Mobile_Number__c='9876594421';
        ld.Stages__c='New';
        ld.Distributor_Email__c='abac@gmail.com';
        ld.IsConverted__c=false;
        ld.Lost_Lead__c=true;
        insert ld;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Lead__c=ld.Id;
        opp.Opportunity_Stage__c='Not Interested';
        opp.Opportunity_Lost_to__c='Price too high';
        insert opp;
        
        opp.Opportunity_Stage__c='Closed Without OTP';
        update opp;
    }
}