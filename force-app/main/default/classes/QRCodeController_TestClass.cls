@isTest
public class QRCodeController_TestClass 
{
    @isTest
    static void testFetchProductDetails() {
        // Create test data
        try{
             Retail_Product_Group__c retailProdGrup = TestDataFactory.createRetailProductGroup();
        Retail_Product__c retailProduct = TestDataFactory.createRetailProduct(retailProdGrup.id);
        Retail_Warehouse__c retailWarhouse = TestDataFactory.createRetailWarehouse();
        Retail_Inventory__c retailInventory = TestDataFactory.createRetailInventory(retailProdGrup.id,retailWarhouse.id,retailProduct.id);
         
        List<Retail_Inventory__c> result = QRCodeController.fetchProductDetails(retailInventory.Id);
        
        System.assertEquals(1, result.size());
        System.assertEquals(retailInventory.Id, result[0].Id);
        System.assertEquals(retailInventory.Name, result[0].Name);
        System.assertEquals(retailInventory.Add_Qty__c, result[0].Add_Qty__c);
        System.assertEquals(retailInventory.Bundle_No__c, result[0].Bundle_No__c);
        System.assertEquals(retailInventory.Instock__c, result[0].Instock__c);
        System.assertEquals(retailInventory.Product_Name__c, result[0].Product_Name__c);
        System.assertEquals(retailInventory.QR_Code__c, result[0].QR_Code__c);
        System.assertEquals(retailInventory.Sales_Qty__c, result[0].Sales_Qty__c);
        }catch(exception e){
          system.debug('Exception.......'+e.getMessage());
        }
       
    }

    @isTest
    static void testUpdateProductDetails() {
       
        try{
        Retail_Product_Group__c retailProdGrup = TestDataFactory.createRetailProductGroup();
        Retail_Product__c retailProduct = TestDataFactory.createRetailProduct(retailProdGrup.id);
        Retail_Warehouse__c retailWarhouse = TestDataFactory.createRetailWarehouse();
        Retail_Inventory__c retailInventory = TestDataFactory.createRetailInventory(retailProdGrup.id,retailWarhouse.id,retailProduct.id);
      
        String result = QRCodeController.updateProductDetails(10, retailInventory.Id);

        // Retrieve the updated record for verification
        Retail_Inventory__c updatedRetailInv = [SELECT Id, Name, Add_Qty__c, Instock__c, Product_Name__c, QR_Code__c, Sales_Qty__c FROM Retail_Inventory__c WHERE Id = :retailInventory.Id LIMIT 1];

        // Verify the results
        System.assertEquals('Retail Inventory Details Successfully Saved', result);
        System.assertEquals(retailInventory.Sales_Qty__c + 10, updatedRetailInv.Sales_Qty__c);
        System.assertEquals(retailInventory.Add_Qty__c - (retailInventory.Sales_Qty__c + 10), updatedRetailInv.Instock__c);
        }catch(exception e){
          system.debug('Exception.......'+e.getMessage());
        }
    }
}