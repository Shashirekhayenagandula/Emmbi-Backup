@isTest
public class NewOverrideOrderController_TestClass {
    @isTest
    public  static void testingMethod(){
         Retail_State__c retailState = TestDataFactory.createRetailState('Telangana');
        Retail_District__c retailDistrict =TestDataFactory.createRetailDistrict('Ranga Reddy',retailState.Id);
        Retail_Taluka__c retailTaluka =TestDataFactory.createRetailTaluka('Manakondur', retailDistrict.Id, retailState.Id);
        Retail_Warehouse__c retailWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Product_Group__c retailProductGroup = TestDataFactory.createRetailProductGroup();
        Retail_Product__c retailProduct  = TestDataFactory.insertRetailProduct(retailProductGroup.Id);
         Retail_Product__c retailProduct1 = TestDataFactory.createRetailProduct(retailProductGroup.Id);
        Retail_Inventory__c retailInventory =TestDataFactory.createRetailInventory(retailProductGroup.Id,retailWarehouse.Id,retailProduct1.Id);
        Retail_Order__c retailOrder1 =TestDataFactory.createRetailOrderOther('Exec Discount Approval',retailWarehouse.Id);
        Retail_Order__c retailOrder2 =TestDataFactory.createRetailOrder('Exec Discount Approval',retailWarehouse.Id);
        Retail_Order_Product__c  retailOrdPrd = TestDataFactory.createRetailOrdPrd(retailOrder2.Id,retailProductGroup.Id,retailProduct.Id);
        Retail_Order_Product__c  retailOrdPrd1=TestDataFactory.insertRetailOrdPrd(retailOrder2.Id,retailProductGroup.Id,retailProduct.Id);
        Retail_Order_Product__c  retailOrdPrd2=TestDataFactory.insertRetailOrdPrd(retailOrder2.Id,retailProductGroup.Id,retailProduct.Id);
        Retail_Customer__c retailCustomer=TestDataFactory.createRetailCustomer();
        Retail_Lead__c retailLead =TestDataFactory.createRetailLead('Other', 'Test Retail Lead', 'Distributor', 'India(+91)', '9432156987', 'Test Village Adilabad', retailTaluka.Id, retailDistrict.Id,retailState.Id,retailCustomer.Id,'Direct');
        
        Retail_Lead_Visit__c retailLeadVisit =TestDataFactory.createRetailLeadVisit(retailLead.Id);
        
        List<Retail_Warehouse__c> createdretailWarehouse = [SELECT Id,Name From Retail_Warehouse__c where Name='Test WarHouse'];
        System.assert(!createdretailWarehouse.isEmpty(),'List should not be empty');
        Assert.areEqual('Test WarHouse', retailWarehouse.Name);
        
        List<Retail_Order_Product__c> productList = new List<Retail_Order_Product__c> ();
        productList.add(retailOrdPrd);
        List<Retail_Order_Product__c> removeLineItemIds = new List<Retail_Order_Product__c> ();
        productList.add(retailOrdPrd1);
        
        Test.startTest();
        try{
            NewOverrideOrderController.insertOrderWithProduct(productList,retailOrder1);
        }catch(exception e)
        {
        }     
        
       NewOverrideOrderController.upsertOrder(productList,retailOrder2,removeLineItemIds);
        NewOverrideOrderController.fetchProductList(retailOrdPrd2.Id);
        NewOverrideOrderController.getPrevoiusOrders(retailCustomer.Id);
        NewOverrideOrderController.getProductDetails(retailProduct1.Id);
       NewOverrideOrderController.getUnitPrice(retailProduct1.Id,retailWarehouse.Id);
        NewOverrideOrderController.fetchLookupData('test','Retail_Product__c',retailProductGroup.Id);
        NewOverrideOrderController.getMulchProductGroup(retailProductGroup.Id);
        NewOverrideOrderController.getCustomerDetails(retailCustomer.Id);
        NewOverrideOrderController.getLeadVisitOptions(retailCustomer.Id);
        NewOverrideOrderController.getProductOptions(retailProductGroup.Id);
        NewOverrideOrderController.getLeadVisitName(retailLeadVisit.Id);
        NewOverrideOrderController.getProductName(retailProduct1.Id);
        
        
        
        Test.stopTest();
    }
    
}