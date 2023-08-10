@isTest
public class ComplaintClose_TestClass {
    public static testMethod void ComplaintClose_Test()
    {
        Account acc=new Account();
        acc.name='avana';
        acc.Farmer_First_Name__c='s';
        acc.Phone='9739924466';
        insert acc;
        
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
        ld.Mobile_Number__c='9739924466';
        ld.Tehsil__c=Tl.id;
        ld.Products_Interested__c='Jalasanchay';
        insert ld;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Lead__c=ld.Id;
        opp.Opportunity_Stage__c='Contact Later';     
        insert opp;
        
        Complaint__c cmpt=new Complaint__c();
        cmpt.Complaint_Type_New__c='Faulty fabric - Manufacturing';
        cmpt.Complaint_Source__c='Toll Free Number';
        cmpt.Description__c='test';
        cmpt.Stages__c='Closed without OTP';
        cmpt.Enquiry__c=opp.Id;
        insert cmpt;
        
        Complaint__c cmpt1=new Complaint__c();
        cmpt1.Complaint_Type_New__c='Faulty fabric - Manufacturing';
        cmpt1.Complaint_Source__c='Toll Free Number';
        cmpt1.Description__c='test';
        cmpt1.Stages__c='Closed without OTP';
        cmpt1.Enquiry__c=opp.Id;
        insert cmpt1;
        
        Integration_Detail__c indt=new Integration_Detail__c();
        indt.Name='123456';
        indt.Mobile_Phone__c='4545367890';
        indt.Complaint__c=cmpt.Id;
        insert indt;
        
        string otp='123456';
        ComplaintClose.CloseComplaint(cmpt.Id, otp);
       // ComplaintClose.CloseComplaint(cmpt1.Id, otp);
       
    }
    
    public static testMethod void ComplaintClose_Test1()
    {
        Account acc=new Account();
        acc.name='avana';
        acc.Farmer_First_Name__c='s';
        acc.Phone='9739924466';
        insert acc;
        
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
        ld.Mobile_Number__c='9739924466';
        ld.Tehsil__c=Tl.id;
        ld.Products_Interested__c='Jalasanchay';
        insert ld;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Lead__c=ld.Id;
        opp.Opportunity_Stage__c='Contact Later';     
        insert opp;
        
        Complaint__c cmpt=new Complaint__c();
        cmpt.Complaint_Type_New__c='Faulty fabric - Manufacturing';
        cmpt.Complaint_Source__c='Toll Free Number';
        cmpt.Description__c='test';
        cmpt.Stages__c='Closed without OTP';
        cmpt.Enquiry__c=opp.Id;
        insert cmpt;
 
        Integration_Detail__c indt=new Integration_Detail__c();
        indt.Name='123456';
        indt.Mobile_Phone__c='4545367890';
        indt.Complaint__c=cmpt.Id;
        insert indt;
 
        ComplaintClose.CloseComplaint(cmpt.Id, '123457');
       
    }

}