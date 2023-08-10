public with sharing class NewPackingListController {

    @AuraEnabled(cacheable=true)
     public static List<Retail_Order__c> getApprovedOrders() {
        return [SELECT Id, Name, Status__c FROM Retail_Order__c WHERE Status__c IN ('Upload Packing List', 'Packing List in Process')];
    }


    @AuraEnabled(cacheable=true)
    public static List<Retail_Employee__c> getEmployerRecords() {
        return [SELECT Id, Name FROM Retail_Employee__c];
    }
     @AuraEnabled(cacheable=true)
     public static String getCurrentUserName() {
         String currentUserName = [SELECT Id, CommunityNickname FROM User where Id =: UserInfo.getUserId() LIMIT 1].CommunityNickname;
         return currentUserName;
     }


    @AuraEnabled
    public static String insertPackingList(String supervisor, String completeValue, String invoiceNo, String address,
                                         Date dispatchDate, String orderId, String addCustomer, String vehicleNumber,
                                         String comments, List<Retail_Bundle__c> inventories) {

          
        System.debug('addCustomer: 26'+addCustomer);
         System.debug('completeValue: 27'+completeValue);                                     
        Retail_Packaging_List__c newPackingList = new Retail_Packaging_List__c();

        newPackingList.Supervisor__c = supervisor;
        newPackingList.Complete__c = completeValue;
        newPackingList.Invoice_No__c = invoiceNo;
        newPackingList.Address__c = address;
        newPackingList.Dispatch_Date__c = dispatchDate;
        newPackingList.Order_ID__c = orderId;
        newPackingList.Add_Customer__c = addCustomer;
        newPackingList.Vehicle_Number__c = vehicleNumber;
        newPackingList.Comments__c = comments;
        //newPackingList.Time__c = timeVal;
        newPackingList.Time__c = Time.newInstance(System.now().hour(), System.now().minute(), System.now().second(), 0);



        Insert newPackingList;
        Retail_Order__c updateOrder = new Retail_Order__c();
        updateOrder = [SELECT Id, Name, Status__c FROM Retail_Order__c WHERE Id =:orderId LIMIT 1];
        if(newPackingList.Complete__c == 'Yes')
            updateOrder.Status__c = 'Production Approved';
        else {
            updateOrder.Status__c = 'Packing List in Process';
        }
        update updateOrder;

        List<Retail_Bundle__c> bundlesToInsert = new List<Retail_Bundle__c>();
        
        System.debug('inventories==>'+inventories);
        System.debug('newPackingList.Id=>'+newPackingList.Id);
        for (Retail_Bundle__c inventory : inventories) {
            Retail_Bundle__c bundle = new Retail_Bundle__c();
            bundle.Packing_List__c = newPackingList.Id;
            // bundle.Inventory__c = inventory.Id;
            bundle.QR_Code__c = inventory.QR_Code__c;
            bundle.Quantity__c = inventory.Quantity__c;
            bundle.Add_Product__c = inventory.Add_Product__c;
            bundle.Order_Product_Quantity__c = inventory.Order_Product_Quantity__c;
            bundle.Net_Weight__c = inventory.Net_Weight__c;
            bundle.Tare_Weight__c = inventory.Tare_Weight__c;
            bundle.Gross_Weight__c = inventory.Gross_Weight__c;
            bundle.Remarks__c = inventory.Remarks__c;
            bundle.Get_Lot_No__c = inventory.Get_Lot_No__c;
               
            bundlesToInsert.add(bundle);
        }
       System.debug('bundlesToInsert-->159'+bundlesToInsert);
        if (!bundlesToInsert.isEmpty()) {           
            insert bundlesToInsert;
        }

        return newPackingList.Id;

    }
     @AuraEnabled(cacheable=true)
    public static List<Retail_Inventory__c> fetchInventoryRecords(String orderId) {
        List<Retail_Inventory__c> inventoryList = new List<Retail_Inventory__c>();

        Map<Id, Decimal> orderProductQuantity = new Map<Id, Decimal>();

        String orderDispatchWarehouse = [SELECT Id, Dispatch_Warehouse__c FROM Retail_Order__c WHERE Id = :orderId LIMIT 1].Dispatch_Warehouse__c;

        // Step 1: Fetch Retail Order Product records based on the given Order Id
        List<Retail_Order_Product__c> orderProducts = [SELECT Id, Name, Product__c, Quantity__c
                                                       FROM Retail_Order_Product__c
                                                       WHERE Retail_Order__c = :orderId];

        // Step 2: Collect Product Ids from Retail Order Product records
        Set<Id> productIds = new Set<Id>();
        for (Retail_Order_Product__c orderProduct : orderProducts) {
            productIds.add(orderProduct.Product__c);
            orderProductQuantity.put(orderProduct.Product__c, orderProduct.Quantity__c);
            System.debug('orderProduct.Product__c => ' + orderProduct.Product__c + ' == orderProduct.Quantity__c => ' + orderProduct.Quantity__c);
        }

        // Step 3: Fetch Retail Inventory records based on the Retail Product records
        List<Retail_Inventory__c> inventories = [SELECT Id, Name, 
                                                   Product_Name__c, Product_Group__c,
                                                   Weight_kg__c, Net_Weight__c, Tare_Weight__c, Gross_Weight__c, Warehouse_Code__c, Remarks__c, Lot_No__c, Bundle_No__c, QR_Code__c, Quality_Check_Status__c,
                                                   Availability__c, Add_Supplier__c, Sales_Qty__c, Instock__c
                                                   FROM Retail_Inventory__c
                                                   WHERE Product_Name__c IN :productIds AND Warehouse_Code__c = :orderDispatchWarehouse];

        inventoryList.addAll(inventories);
        System.debug('inventoryList'+inventoryList);

        return inventoryList;
    }

    //Method to return Inventory Records
   /* @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> fetchInventoryRecords(String orderId) {
    List<Map<String, Object>> inventoryList = new List<Map<String, Object>>();

    Map<Id, Decimal> orderPRoductQuantity = new Map<Id, Decimal>();

    String orderDispatchWarehouse = [SELECT Id, Dispatch_Warehouse__c FROM Retail_Order__c WHERE Id =:orderId LIMIT 1].Dispatch_Warehouse__c;

    // Step 1: Fetch Retail Order Product records based on the given Order Id
    List<Retail_Order_Product__c> orderProducts = [SELECT Id, Name, Product__c, Quantity__c
                                                   FROM Retail_Order_Product__c
                                                   WHERE Retail_Order__c = :orderId];

    // Step 2: Collect Product Ids from Retail Order Product records
    Set<Id> productIds = new Set<Id>();
    for (Retail_Order_Product__c orderProduct : orderProducts) {
        productIds.add(orderProduct.Product__c);
        orderPRoductQuantity.put(orderProduct.Product__c, orderProduct.Quantity__c);
        System.debug('orderProduct.Product__c=>'+orderProduct.Product__c+'== orderProduct.Quantity__c==>'+orderProduct.Quantity__c);
    }

    // Step 3: Fetch Retail Inventory records based on the Retail Product records
    List<Retail_Inventory__c> inventories = [SELECT Id, Name, 
                                               Product_Name__c, Product_Group__c,
                                              Weight_kg__c, Net_Weight__c, Tare_Weight__c, Gross_Weight__c, Warehouse_Code__c, Remarks__c, Lot_No__c, Bundle_No__c, QR_Code__c, Quality_Check_Status__c,
                                              Availability__c, Add_Supplier__c, Sales_Qty__c, Instock__c
                                              FROM Retail_Inventory__c
                                              WHERE Product_Name__c IN :productIds AND Warehouse_Code__c =: orderDispatchWarehouse];

    // Step 4: Prepare data for LWC consumption
    for (Retail_Inventory__c inventory : inventories) {
        Map<String, Object> inventoryData = new Map<String, Object>();
        inventoryData.put('Order_Product_Qty', orderPRoductQuantity.get(inventory.Product_Name__c));
        System.debug('==>'+orderPRoductQuantity.get(inventory.Product_Name__c));
        inventoryData.put('Tare_Weight__c', inventory.Tare_Weight__c);
        inventoryData.put('Net_Weight__c', inventory.Net_Weight__c);
        inventoryData.put('Gross_Weight__c', inventory.Gross_Weight__c);
        inventoryData.put('Remarks__c', inventory.Remarks__c);
        inventoryData.put('Lot_No__c', inventory.Lot_No__c);
        inventoryData.put('Add_Supplier__c', inventory.Add_Supplier__c);
        inventoryData.put('Id', inventory.Id);
        inventoryData.put('Name', inventory.Name);
        inventoryData.put('Product_Name__c', inventory.Product_Name__c);
        inventoryData.put('Bundle_No__c', inventory.Bundle_No__c);
        inventoryData.put('QR_Code__c', inventory.QR_Code__c);
        inventoryData.put('Instock__c', inventory.Instock__c);
        inventoryData.put('Quantity__c',0);
		 inventoryData.put('Order_Product_Quantity__c',0);

        inventoryList.add(inventoryData);
    }
    System.debug('return list'+inventoryList);
    System.debug('inventories-->86'+inventories);
   
    return inventoryList;

}*/
    

//Method to return Customer Details
@AuraEnabled(cacheable=true)
public static Retail_Customer__c  getCustomerDetails(String orderId){
    List<Retail_Order__c> ordersWithCustomer  = [
        SELECT Id, Name, Retail_Customer__r.Shop_Name__c, Retail_Customer__r.Shop_Address__c,
               Retail_Customer__r.Billing_First_Name__c, Retail_Customer__r.Billing_Last_Name__c,Retail_Customer__r.Village__c,
               Retail_Customer__r.State__r.Name, Retail_Customer__r.Taluka__r.Name,
               Retail_Customer__r.District__r.Name, Retail_Customer__r.Pin_code__c
        FROM Retail_Order__c
        WHERE Id =:orderId LIMIT 1];
    System.debug('customerRecords-->100' + ordersWithCustomer[0].Retail_Customer__r.State__r.Name);
    if (!ordersWithCustomer.isEmpty()) {
        return ordersWithCustomer[0].Retail_Customer__r;
    } else {
        return null; // Return null if no customer record is found
    }
}

// @AuraEnabled
// public static void updateInventoryRecords(List<Retail_Inventory__c> inventoriesToUpdate) {
//     System.debug('inventoriesToUpdate-->140'+inventoriesToUpdate);
//     update inventoriesToUpdate;
// }


// @AuraEnabled
// public static void createBundles (String packingListId, List<Retail_Inventory__c> inventories){
//     List<Retail_Bundle__c> bundlesToInsert = new List<Retail_Bundle__c>();
        
//         System.debug('inventories==>'+inventories);
//         System.debug('packingListId=>'+packingListId);
//         for (Retail_Inventory__c inventory : inventories) {
//             Retail_Bundle__c bundle = new Retail_Bundle__c();
//             bundle.Packing_List__c = packingListId;
//             // bundle.Inventory__c = inventory.Id;
//             bundle.Add_Product__c = inventory.Product_Name__c;
//             bundle.Bundle_No__c = inventory.Bundle_No__c;
//             bundle.Quantity__c = inventory.Instock__c;
//             bundle.Net_Weight__c = inventory.Net_Weight__c;
//             bundle.Tare_Weight__c = inventory.Tare_Weight__c;
//             bundle.Gross_Weight__c = inventory.Gross_Weight__c;
//             bundle.Remarks__c = inventory.Remarks__c;
//             bundle.Get_Lot_No__c = inventory.Lot_No__c;
//             bundle.Add_Supplier__c = inventory.Add_Supplier__c;
               
//             bundlesToInsert.add(bundle);
//         }
//        System.debug('bundlesToInsert-->159'+bundlesToInsert);
//         if (!bundlesToInsert.isEmpty()) {           
//             insert bundlesToInsert;
//         }
// }
   
    public class InventoryAndOrderProductWrapper {
    @AuraEnabled
    public List<Retail_Inventory__c> inventories;
    @AuraEnabled
    public List<Retail_Order_Product__c> orderProducts;

    public InventoryAndOrderProductWrapper(List<Retail_Inventory__c> inventories, List<Retail_Order_Product__c> orderProducts) {
        this.inventories = inventories;
        this.orderProducts = orderProducts;
    }
}

}