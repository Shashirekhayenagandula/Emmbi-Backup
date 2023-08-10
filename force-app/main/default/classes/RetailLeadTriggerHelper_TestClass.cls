@isTest
public class RetailLeadTriggerHelper_TestClass {
	@isTest
    public  static void testingMethod(){
        
        
        Retail_State__c retailState = TestDataFactory.createRetailState('Telangana');
        Retail_District__c retailDistrict =TestDataFactory.createRetailDistrict('Ranga Reddy',retailState.Id);
        Retail_Taluka__c retailTaluka =TestDataFactory.createRetailTaluka('Manakondur', retailDistrict.Id, retailState.Id);
        Retail_Customer__c retailCustomer = TestDataFactory.createRetailCustomer();
        
        Retail_Lead__c retailLead1 =TestDataFactory.createRetailLead('Other', 'Test Retail Lead1', 'Distributor', 'India(+91)', '9432156987', 'Test Village Adilabad1', retailTaluka.Id, retailDistrict.Id,retailState.Id,retailCustomer.Id,'Direct');
        Retail_Lead__c retailLead2 =TestDataFactory.createRetailLead('Other', 'Test Retail Lead2', 'Distributor', 'India(+91)', '9432156987', 'Test Village Adilabad2', retailTaluka.Id, retailDistrict.Id,retailState.Id,null,'Indirect');
        Retail_Lead__c retailLead3 =TestDataFactory.createRetailLead('Other', 'Test Retail Lead3', 'Distributor', 'India(+91)', '9432156987', 'Test Village Adilabad3', retailTaluka.Id, retailDistrict.Id,retailState.Id,null,'Both');
        Retail_Lead__c retailLead4 =TestDataFactory.createRetailLead('Other', 'Test Retail Lead4', 'Distributor', 'India(+91)', '9432156987', 'Test Village Adilabad4', retailTaluka.Id, retailDistrict.Id,retailState.Id,null,'Direct');
        
        List<Retail_State__c> createdretailState = [SELECT Id,Name From Retail_State__c where Name='Telangana'];
        System.assert(!createdretailState.isEmpty(),'List should not be empty');
        Assert.areEqual('Telangana', retailState.Name);
        
        List<Retail_Lead__c> retailLeads = new List<Retail_Lead__c>();
        retailLeads.add(retailLead1);
        retailLeads.add(retailLead2);
        retailLeads.add(retailLead3);
         retailLeads.add(retailLead4);

        // Update Sale_Type__c field for some records
        retailLeads[0].Sale_Type__c = 'Indirect';
        retailLeads[1].Sale_Type__c = 'Both';
        
        // Call the method to be tested
        Map<Id, Retail_Lead__c> oldRetailLeadsMap = new Map<Id, Retail_Lead__c>([SELECT Id, Sale_Type__c FROM Retail_Lead__c WHERE Id IN :retailLeads]);
        
        
        Test.startTest();
        RetailLeadTriggerHelper.updateSaleType(retailLeads, oldRetailLeadsMap);
        RetailLeadTriggerHelper.updatePendingData(retailLeads);
        Test.stopTest();
        
    }
}