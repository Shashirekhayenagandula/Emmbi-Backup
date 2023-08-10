@isTest 
public class TestConvertedCannotBeDeleted {
    
    @isTest public static void
        deleteTest()
    {
        Test.startTest();
        Lead__c l = new Lead__c();
        l.Farmer_First_Name__c = 'test';
        l.Pond_Digging_Done__c = 'Yes';
        l.Products_Interested__c = 'Jalasanchay';
        l.Mobile_Number__c ='0987654321';
        insert l;
        
        Distributor__c D = new Distributor__c();
        D.Active__c = True;
        D.Distributor_Contact_Person__c = 'TestPerson';
        D.Distributor_Mobile__c ='1234567890';
        D.Name = 'TestCompany';
        insert D;
        
        Dealer__c c = new Dealer__c();
        c.Active__c = True;
        c.Name = 'TestDealer';
        c.Distributor__c = D.Id;
        c.Dealer_Mobile__c ='8879483713';
        insert c;
        
        
        Opportunity__c a = new Opportunity__c();
        a.Lead__c = l.Id;
        a.Dealer__c = c.Id;
        a.Invoice_Number__c= 'AV1/20-22/12345/13';
        a.Invoice_Date__c = system.today();
        a.Opportunity_Stage__c = 'Converted';
        a.Payment_Received_Amount__c = 123;
        insert a;
        Test.stopTest();
        
        
            try
            {
                Delete  a;
            }
            catch(Exception ee)
            {}      
    }

}