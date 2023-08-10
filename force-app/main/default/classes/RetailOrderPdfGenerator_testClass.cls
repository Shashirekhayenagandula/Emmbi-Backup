@isTest
public class RetailOrderPdfGenerator_testClass {
    @isTest
    public  static void testingMethod(){
        Retail_Warehouse__c retailWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Customer__c retailCustomer=TestDataFactory.createRetailCustomer();
        Retail_Order__c retailOrder2 =TestDataFactory.customerId('Exec Discount Approval',retailWarehouse.Id,retailCustomer.Id);
        
        List<Retail_Warehouse__c> createdretailWarehouse = [SELECT Id,Name From Retail_Warehouse__c where Name='Test WarHouse'];
        System.assert(!createdretailWarehouse.isEmpty(),'List should not be empty');
        Assert.areEqual('Test WarHouse', retailWarehouse.Name);
        
        Test.startTest();
        RetailOrderPdfGenerator.generateAndSendEmail(retailOrder2.Id);
        RetailOrderPdfGenerator.generateAndSendEmailForProblematic(retailOrder2.Id);
        Test.stopTest();
    }
}