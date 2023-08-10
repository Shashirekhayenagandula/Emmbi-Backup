@isTest
public class ComplainTTriggerHandler_TestClass {
    public static testMethod void ComplainTTriggerHandler_Test()
    {  
        AvanaTrigger__c tokenCustomSetting = new AvanaTrigger__c();         
        tokenCustomSetting.Name = 'ComplaintTrigger__c';        
        tokenCustomSetting.ComplaintTrigger__c = true;        
        insert tokenCustomSetting;
        
         Distributor__c dd=new Distributor__c();
        dd.Name='test';
        dd.Distributor_Email__c='abac@gmail.com';
        insert dd;
        
        Dealer__c Dl= new Dealer__c();
        Dl.Name='sangv';
        Dl.Distributor__c=dd.id;
        insert Dl;
        
        Tehsil__c Tl= new Tehsil__c();
        Tl.Dealer__c=Dl.Id;
        Tl.Name='hgfg';
        insert Tl;
        
        Lead__c ld=new Lead__c();
        ld.Farmer_First_Name__c='test';
        ld.Mobile_Number__c='1234567890';
        ld.Tehsil__c=Tl.id;
        ld.Products_Interested__c='Jalasanchay';
        insert ld;
        
        Account acc=new Account();
        acc.name='avana';
        acc.Farmer_First_Name__c='Pritam';
        acc.Farmer_Middle_Name__c='A';
        acc.Address__c='indiranagar';
        acc.Phone='9876594421';
        acc.Alternate_Mobile_No__c='9778906453';
        acc.Aadhar_Number__c='123434345656';
        acc.Pin_Code__c='588899';
        acc.Dealer__c=Dl.id;
        insert acc;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Lead__c=ld.Id;
        opp.Opportunity_Stage__c='Not Interested'; 
        opp.Opportunity_Lost_to__c='Price too high';
        insert opp;
        
        list<Complaint__c> cmp=new list<Complaint__c>();
        Complaint__c cmpt=new Complaint__c();
        cmpt.Complaint_Type__c='Faulty fabric - Manufacturing';
        cmpt.Complaint_Source__c='Toll Free Number';
        cmpt.Description__c='test';
        cmpt.Stages__c='Ongoing';
        cmpt.Complaint_Due_to__c = 'Company';
        //cmpt.Customer__c=acc.id;
        cmpt.Enquiry__c=opp.id;
        insert cmpt;
        system.debug('cmpt'+cmpt);
       
        
        
        
        
        Test.startTest();
        cmpt.Stages__c='Closed without OTP';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOtp());
        database.update(cmpt,false);
		       
        test.stopTest();
        system.debug('updatecmpt'+cmpt);
        
        
       
    }
    


}