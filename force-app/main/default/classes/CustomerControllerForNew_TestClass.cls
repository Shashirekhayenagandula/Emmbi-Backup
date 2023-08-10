@isTest
public class CustomerControllerForNew_TestClass {
     @isTest
    public  static void testingMethod(){
        Retail_State__c retailState = TestDataFactory.createRetailState('Telangana');
        Retail_District__c retailDistrict =TestDataFactory.createRetailDistrict('Ranga Reddy',retailState.Id);
        Retail_Taluka__c retailTaluka =TestDataFactory.createRetailTaluka('Manakondur', retailDistrict.Id, retailState.Id);
        Retail_Warehouse__c retailWarehouse = TestDataFactory.createRetailWarehouse();
         Retail_Customer__c retailCustomer=TestDataFactory.createRetailCustomer();
        Retail_Lead__c retailLead =TestDataFactory.createRetailLead('Other', 'Test Retail Lead', 'Distributor', 'India(+91)', '9432156987', 'Test Village Adilabad', retailTaluka.Id, retailDistrict.Id,retailState.Id,retailCustomer.Id,'Direct');
        Retail_Order__c retailOrder2 =TestDataFactory.retailOrdCustId('Exec Discount Approval',retailWarehouse.Id,retailCustomer.Id);
        
        List<Retail_Warehouse__c> createdretailWarehouse = [SELECT Id,Name From Retail_Warehouse__c where Name='Test WarHouse'];
        System.assert(!createdretailWarehouse.isEmpty(),'List should not be empty');
        Assert.areEqual('Test WarHouse', retailWarehouse.Name);
        
        Test.startTest();
        CustomerControllerForNew.getLeadDetails(retailLead.Id);
        CustomerControllerForNew.getCustomerDetails(retailLead.Id);
        CustomerControllerForNew.updateLead(retailLead.Id);
        CustomerControllerForNew.getCustomerPhoneDetails('9632587410');
        CustomerControllerForNew.OrderRelatedCustomer(retailCustomer.Id);
        Test.stopTest();
        
        
    }
    
}