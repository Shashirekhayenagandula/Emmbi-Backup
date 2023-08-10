@isTest
public class OrderStatusMaillingController_TestClass {
    
    @isTest
    public static void testHandleStatusChangeAndSendEmail1() {
        
        // Create test data for Retail_Warehouse__c
        Retail_Warehouse__c retailWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Product_Group__c retailProductGroup = TestDataFactory.createRetailProductGroup();
        Retail_Product__c retailProduct  = TestDataFactory.createRetailProduct(retailProductGroup.Id);
        Retail_Customer__c retailCustomer=TestDataFactory.createRetailCustomer();
        Retail_Order__c retailOrder1=TestDataFactory.createRetailOrder('Awaiting Accounts',retailWarehouse.Id);
        Retail_Order__c retailOrder2=TestDataFactory.createRetailOrder('Exec Discount Approval',retailWarehouse.Id);
        Retail_Order__c retailOrder3=TestDataFactory.createRetailOrder('Payment Approved',  retailWarehouse.Id);
        Retail_Order__c retailOrder4=TestDataFactory.createRetailOrder('Upload Packing List',  retailWarehouse.Id);
        Retail_Order__c retailOrder5=TestDataFactory.createRetailOrder('Production Approved',  retailWarehouse.Id);
        
        // Map of old order records
        Map<Id, Retail_Order__c> oldOrderMap = new Map<Id, Retail_Order__c>{retailOrder1.Id => retailOrder1,
            retailOrder2.Id => retailOrder2,
            retailOrder3.Id => retailOrder3,
            retailOrder4.Id => retailOrder4,
            retailOrder5.Id => retailOrder5};
                
                // To Update Status of  same order   
                Retail_Order__c retailOrderNew1=TestDataFactory.updateRetailOrder('Payment Approved', retailOrder1.Id, retailWarehouse.Id,retailCustomer.Id);
        Retail_Order__c retailOrderNew2=TestDataFactory.updateRetailOrder('Awaiting Accounts', retailOrder2.Id, retailWarehouse.Id,retailCustomer.Id);
        Retail_Order__c retailOrderNew3=TestDataFactory.updateRetailOrder('Upload Packing List', retailOrder3.Id, retailWarehouse.Id,retailCustomer.Id);
        Retail_Order__c retailOrderNew4=TestDataFactory.updateRetailOrder('Production Approved', retailOrder4.Id, retailWarehouse.Id,retailCustomer.Id);
        Retail_Order__c retailOrderNew5=TestDataFactory.updateRetailOrder('Ready For Dispatch', retailOrder5.Id, retailWarehouse.Id,retailCustomer.Id);
        
        
        List<Retail_Order__c> newOrdersList1 = new List<Retail_Order__c>{retailOrderNew1,retailOrderNew2,retailOrderNew3,retailOrderNew4,retailOrderNew5};
            
            
            Test.startTest();
        HelperForOrderStatusMaillingController.handleStatusChangeAndSendEmail(newOrdersList1, oldOrderMap);
        
        Test.stopTest();
        
    }
    @isTest
    public static void testHandleStatusChangeAndSendEmail2() {
        // Create test data for Retail_Warehouse__c 
        Retail_Warehouse__c retailWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Product_Group__c retailProductGroup = TestDataFactory.createRetailProductGroup();
        Retail_Product__c retailProduct  = TestDataFactory.createRetailProduct(retailProductGroup.Id);
        Retail_Customer__c retailCustomer=TestDataFactory.createRetailCustomer();
        Retail_Order__c retailOrder6=TestDataFactory.createRetailOrder('Ready For Dispatch',  retailWarehouse.Id);
        Retail_Order__c retailOrder7=TestDataFactory.retailOrdCustId('Dispatched Awaiting Final Payment',retailWarehouse.Id,retailCustomer.Id);
        
        // Map of old order records
        Map<Id, Retail_Order__c> oldOrderMap = new Map<Id, Retail_Order__c>{retailOrder6.Id => retailOrder6,retailOrder7.Id => retailOrder7  };
            
        // To Update Status of  same order   
        Retail_Order__c retailOrderNew6=TestDataFactory.updateRetailOrder('Dispatched Awaiting Final Payment', retailOrder6.Id, retailWarehouse.Id,retailCustomer.Id);
        Retail_Order__c retailOrderNew7=TestDataFactory.updateRetailOrder('Completed', retailOrder7.Id, retailWarehouse.Id,retailCustomer.Id);  
        List<Retail_Order__c> newOrdersList1 = new List<Retail_Order__c>{retailOrderNew6,retailOrderNew7};
            
        Test.startTest();
        HelperForOrderStatusMaillingController.handleStatusChangeAndSendEmail(newOrdersList1, oldOrderMap);
        HelperForOrderStatusMaillingController.handleStatusChangeAndSendEmail(newOrdersList1, oldOrderMap);
        Test.stopTest();        
    }
    
    @isTest
    public static void handleStatusInsertOrderTest(){
        
        Retail_Warehouse__c retailWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Product_Group__c retailProductGroup = TestDataFactory.createRetailProductGroup();
        Retail_Product__c retailProduct  = TestDataFactory.createRetailProduct(retailProductGroup.Id);
        Retail_Order__c retailOrder1=TestDataFactory.createRetailOrder('Awaiting Accounts',retailWarehouse.Id);
        Retail_Order__c retailOrder2=TestDataFactory.createRetailOrder('Awaiting Exec Approval',retailWarehouse.Id);
        
        List<Retail_Order__c> newOrdersList2 = new List<Retail_Order__c>{retailOrder1,retailOrder2}; 
            
            Test.startTest();
        HelperForOrderStatusMaillingController.handleStatusInsertOrder(newOrdersList2);
        Test.stopTest(); 
    }
     @isTest
    public static void StatusUpdationForUsersTest(){
         Retail_Warehouse__c retailWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Product_Group__c retailProductGroup = TestDataFactory.createRetailProductGroup();
        Retail_Product__c retailProduct  = TestDataFactory.createRetailProduct(retailProductGroup.Id);
        Retail_Customer__c retailCustomer=TestDataFactory.createRetailCustomer();
        Retail_Order__c retailOrder6=TestDataFactory.createRetailOrder('Exec Discount Approval',  retailWarehouse.Id);
       
        
        // Map of old order records
        Map<Id, Retail_Order__c> oldOrderMap = new Map<Id, Retail_Order__c>{retailOrder6.Id => retailOrder6 };
            
        // To Update Status of  same order   
        Retail_Order__c retailOrderNew6=TestDataFactory.updateRetailOrder('Awaiting Accounts', retailOrder6.Id, retailWarehouse.Id,retailCustomer.Id);
       
        List<Retail_Order__c> newOrdersList1 = new List<Retail_Order__c>{retailOrderNew6};
            
        Test.startTest();
        
        HelperForOrderStatusMaillingController.StatusUpdationForUsers(newOrdersList1, oldOrderMap);
        Test.stopTest(); 
    }
}