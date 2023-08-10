@isTest
public class InventTrigHelperController_TestClass {
    @isTest
    public  static void testinghandleSendEmailAfterUpdate(){
        Retail_Warehouse__c retailWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Product_Group__c retailProductGroup = TestDataFactory.createRetailProductGroup();
        Retail_Product__c retailProduct  = TestDataFactory.createRetailProduct(retailProductGroup.Id);
        Retail_Inventory__c retailInventory = TestDataFactory.createRetailInventory(retailProductGroup.Id,retailWarehouse.Id,retailProduct.Id) ;
        
        List<Retail_Inventory__c> retailInventoryList = new List<Retail_Inventory__c>();
        retailInventoryList.add(retailInventory);
        
        List<Retail_Warehouse__c> createdretailWarehouse = [SELECT Id,Name From Retail_Warehouse__c where Name='Test WarHouse'];
        System.assert(!createdretailWarehouse.isEmpty(),'List should not be empty');
        Assert.areEqual('Test WarHouse', retailWarehouse.Name);
        
        Test.startTest();
        InventoryTriggerHelperController.handleSendEmailAfterUpdate(retailInventoryList);
        InventoryTriggerHelperController.updateInstockAtInventory(retailInventoryList);
        Test.stopTest();
            
    }
    
}