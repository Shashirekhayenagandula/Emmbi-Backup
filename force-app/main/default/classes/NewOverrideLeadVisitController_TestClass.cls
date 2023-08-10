@isTest
public class NewOverrideLeadVisitController_TestClass {
    @isTest
    public  static void testingMethod(){
        Retail_State__c retailState = TestDataFactory.createRetailState('Telangana');
        Retail_District__c retailDistrict =TestDataFactory.createRetailDistrict('Ranga Reddy',retailState.Id);
        Retail_Taluka__c retailTaluka =TestDataFactory.createRetailTaluka('Manakondur', retailDistrict.Id, retailState.Id);
        Retail_Customer__c retailCustomer = TestDataFactory.createRetailCustomer();
        Retail_Lead__c retailLead =TestDataFactory.createRetailLead('Other', 'Test Retail Lead', 'Distributor', 'India(+91)', '9432156987', 'Test Village Adilabad', retailTaluka.Id, retailDistrict.Id,retailState.Id,retailCustomer.Id,'Direct');
        Retail_Lead_Visit__c retailLeadVisit =TestDataFactory.createRetailLeadVisit(retailLead.Id);
        Retail_Warehouse__c retailWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Product_Group__c retailProductGroup = TestDataFactory.createRetailProductGroup();
        Retail_Product__c retailProduct  = TestDataFactory.createRetailProduct(retailProductGroup.Id);
        Retail_Lead_Product__c retailLeadPrd=TestDataFactory.createRetailPrd(retailProductGroup.Id);
        
        List<Retail_Warehouse__c> createdretailWarehouse = [SELECT Id,Name From Retail_Warehouse__c where Name='Test WarHouse'];
        System.assert(!createdretailWarehouse.isEmpty(),'List should not be empty');
        Assert.areEqual('Test WarHouse', retailWarehouse.Name);
        
        List<Retail_Lead_Product__c> retailLeadPrdList= new List<Retail_Lead_Product__c>();
        retailLeadPrdList.add(retailLeadPrd);
        
        Test.startTest();
        NewOverrideLeadVisitController.insertLeadVisitWithProduct(retailLeadPrdList,retailLeadVisit,retailLead.Id);
        NewOverrideLeadVisitController.insertLeadVisitOnly(retailLead.Id,retailLeadVisit);
        NewOverrideLeadVisitController.insertLeadVisit(retailLead.Id,retailLeadVisit);
        NewOverrideLeadVisitController.getLeadVisit(retailLeadVisit.Id);
            NewOverrideLeadVisitController.getLinkCustomer(retailCustomer.Id);
        NewOverrideLeadVisitController.getLinkCustomerLead(retailLead.Id);
        NewOverrideLeadVisitController.getProductGroupDetails(retailProductGroup.Id);
        Test.stopTest();
        
    }
}