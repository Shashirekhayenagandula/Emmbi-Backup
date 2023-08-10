public class TestDataFactory2 
{
   public static Retail_Order__c createRetailOrderOther(String Status,String warehouse){
        Retail_Order__c retailOrder= new Retail_Order__c();
        retailOrder.Order_Date__c= system.today()+1;
        retailOrder.Order_Type__c='Retail Products 1';
        retailOrder.Freight_Charge_Bearer_values__c='Avana';
        retailOrder.Prefered_Transport_Company__c='AMRUT LOGISTICS (ARCO)1';
        retailOrder.Closest_Tranport_Branch__c='hyd';
        retailOrder.Credit__c=1000;
        retailOrder.Sub_Total__c=1000;
        retailOrder.Net_Total__c=1000;
        retailOrder.Advance__c=0;
        retailOrder.Status__c='production Approved';
        retailOrder.OwnerId = UserInfo.getUserId();
        retailOrder.Order_Discount__c=0.0;
       
        return retailOrder;
        
    }
     public static Retail_Inventory__c createRetailInventory(String prdGrp,String warehouse,String product ){
        Retail_Inventory__c retailInventory = new Retail_Inventory__c();
        retailInventory.Product_Group__c=prdGrp; 
        retailInventory.Warehouse_Code__c=warehouse;
        retailInventory.Product_Name__c = product; 
        retailInventory.Add_Qty__c = 20;
        retailInventory.Availability__c='Low Stock';
        retailInventory.OwnerId = UserInfo.getUserId();
        insert retailInventory;
        return retailInventory;
        
    }
    
    
    

}