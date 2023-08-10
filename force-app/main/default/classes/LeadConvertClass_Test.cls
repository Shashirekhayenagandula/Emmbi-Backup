@isTest
public class LeadConvertClass_Test {
    public static testMethod void LeadConvertedTest()
    {

        Distributor__c dd=new Distributor__c();
        dd.Name='test';
        dd.Distributor_Email__c='abac@gmail.com';
        insert dd;
        
        Dealer__c Dl= new Dealer__c();
        Dl.Name='sangv';
        dl.Distributor__c=dd.id;
        insert Dl;
        
        Tehsil__c Tl= new Tehsil__c();
        Tl.Dealer__c=Dl.Id;
        Tl.Name='hgfg';
        insert Tl;

        
        Account acc=new Account();
        acc.name='avana';
        acc.Phone='9739924466';
        insert acc;
        
        
        Lead__c ld= new Lead__c();
        ld.Farmer_Last_Name__c='H';
        ld.Farmer_Middle_Name__c='s';
        ld.Farmer_First_Name__c='S';
        ld.Address__c='indiranagar';
        ld.Mobile_Number__c='9876594421';
        ld.Stages__c='New';
        ld.Distributor_Email__c='abac@gmail.com';
        ld.Dealer__c=Dl.id;
        ld.Tehsil__c=Tl.id;
        insert ld;
        
        
        Opportunity__c opp = new Opportunity__c();
        //opp.name='test';
        opp.Customer__c=acc.Id;
        opp.Lead__c=ld.Id;
        opp.Payment_Received_Amount__c=100;
        opp.Opportunity_Stage__c='Converted';    
        
        insert opp;
        
        
      
        LeadConvertClass.getLeadName(ld.Id);
        LeadConvertClass.OppTest(ld.Id);
        LeadConvertClass.OppStageTest(ld.Id);
        LeadConvertClass.LeadCnvrt(ld.Id,ld.Farmer_First_Name__c);
        
        
        
    }     
       
    public static testMethod void LeadConvertedTest1()
    {
        
        Distributor__c dd=new Distributor__c();
        dd.Name='test';
        dd.Distributor_Email__c='abac@gmail.com';
        insert dd;
        
        Dealer__c Dl= new Dealer__c();
        Dl.Name='sangv';
        dl.Distributor__c=dd.id;
        insert Dl;
        
        Tehsil__c Tl= new Tehsil__c();
        Tl.Dealer__c=Dl.Id;
        Tl.Name='hgfg';
        insert Tl;
        
        Account acc=new Account();
        acc.name='avana';
        acc.Phone='9739924466';
        insert acc;

        
        Lead__c ld= new Lead__c();
        ld.Farmer_Last_Name__c='H';
        ld.Farmer_Middle_Name__c='s';
        ld.Farmer_First_Name__c='S';
        ld.Address__c='indiranagar';
        ld.Mobile_Number__c='9739924466';
        ld.Stages__c='New';
        ld.Distributor_Email__c='abac@gmail.com';
        ld.Dealer__c=Dl.id;
        ld.Tehsil__c=Tl.id;
        insert ld;
        
        
        
        
      
        LeadConvertClass.getLeadName(ld.Id);
        LeadConvertClass.OppTest(ld.Id);
        LeadConvertClass.OppStageTest(ld.Id);
        LeadConvertClass.LeadCnvrt(ld.Id,ld.Farmer_First_Name__c);
        
        
    }     
                  
}