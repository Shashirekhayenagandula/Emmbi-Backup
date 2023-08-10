@isTest
public class RetailLeadCls_TestClass {
    @isTest
    public  static void testingMethod(){
        
        Retail_State__c retailState = TestDataFactory.createRetailState('Telangana');
        Retail_District__c retailDistrict =TestDataFactory.createRetailDistrict('Ranga Reddy',retailState.Id);
        Retail_Taluka__c retailTaluka =TestDataFactory.createRetailTaluka('Manakondur', retailDistrict.Id, retailState.Id);
        Retail_Customer__c retailCustomer = TestDataFactory.createRetailCustomer();
        Retail_Lead__c retailLead =TestDataFactory.createRetailLead('Other', 'Test Retail Lead', 'Distributor', 'India(+91)', '9432156987', 'Test Village Adilabad', retailTaluka.Id, retailDistrict.Id,retailState.Id,retailCustomer.Id,'Direct');
        
        List<Retail_State__c> createdretailState = [SELECT Id,Name From Retail_State__c where Name='Telangana'];
        System.assert(!createdretailState.isEmpty(),'List should not be empty');
        Assert.areEqual('Telangana', retailState.Name);
        
         Test.startTest();
        RetailLeadCls.getRetailLeadPhoneDetails('9432156987',retailCustomer.Id);
        RetailLeadCls.getRetailLeadPhoneDetails('',retailCustomer.Id);
        RetailLeadCls.getLeadDetails(retailCustomer.Id);
        RetailLeadCls.getLeadDetails(null);
        Test.stopTest();
        
        
    }
}