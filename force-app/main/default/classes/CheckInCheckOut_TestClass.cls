@isTest
public class CheckInCheckOut_TestClass {
    public static testMethod void CheckInCheckOut_Test()
    {
        Id  userId=UserInfo.getUserId();
        
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
        acc.Farmer_First_Name__c='s';
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
        ld.IsConverted__c=false;
        insert ld;
        
        Opportunity__c opp = new Opportunity__c();
        //opp.name='test';
        opp.Customer__c=acc.Id;
        opp.Lead__c=ld.Id;
        opp.Opportunity_Stage__c='Contact Later';     
        insert opp;
        
        Complaint__c cmpt=new Complaint__c();
        cmpt.Complaint_Type_New__c='Faulty fabric - Manufacturing';
        cmpt.Complaint_Source__c='Toll Free Number';
        cmpt.Description__c='test';
        cmpt.Stages__c='New';
        cmpt.Enquiry__c=opp.Id;
        insert cmpt;
        
        double lat=13.0032828;
        double lon=77.6663746;
        //CheckInCheckout.createEvent(ld.Id,lat,lon);
        //CheckInCheckout.createEvent(acc.Id,lat,lon);
        //CheckInCheckout.createEvent(opp.Id,lat,lon);
        CheckInCheckout.Checkin(opp.Id, lat, lon);
        CheckInCheckout.Checkin(acc.Id, lat, lon);
        CheckInCheckout.Checkin(cmpt.Id, lat, lon);
        CheckInCheckout.CheckOut(opp.Id, lat, lon);
         CheckInCheckout.CheckOut(acc.Id, lat, lon);
         CheckInCheckout.CheckOut(cmpt.Id, lat, lon);
        
    }

}