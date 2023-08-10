@isTest
public class TestDataFactory {
    
    public static Retail_State__c createRetailState(String state){
        Retail_State__c retailState = new Retail_State__c();
        retailState.Name= state;
        insert retailState;
        
        return retailState;
    }
    
    public static Retail_District__c createRetailDistrict(String district,String state){
        Retail_District__c retailDistrict = new Retail_District__c();
        retailDistrict.Name = district;
        retailDistrict.State__c= state;
        Insert retailDistrict;
        
        return retailDistrict;
        
    }
    
    public static Retail_Taluka__c createRetailTaluka(String taluka,String district,String state){
        Retail_Taluka__c retailTaluka = new Retail_Taluka__c();
        retailTaluka.Name=taluka;
        retailTaluka.Add_states__c=state;
        retailTaluka.Add_District__c=district;
        Insert  retailTaluka;
        
        return  retailTaluka;
        
    }
    
    public static Retail_Lead__c createRetailLead(String leadSource,String leadName,String leadType, String countryCode, String phone,String village,string taluka,String district,String state,String customer,string salestype){
        Retail_Lead__c retailLead = new Retail_Lead__c();
        retailLead.Lead_Source__c = leadSource;
        retailLead.Date__c = System.today();
        retailLead.Lead_Name__c=leadName;
        retailLead.Lead_Type__c =leadType;
        retailLead.Country_Code__c =countryCode;
        retailLead.Phone__c=phone;
        retailLead.Village__c=village;
        retailLead.Retail_Lead_Taluka__c=taluka;
        retailLead.Retail_Lead_District__c =district;
        retailLead.RetailLeadState__c=state;
        retailLead.Link_Customer_Id__c=customer;
        retailLead.Sale_Type__c=salestype;
        insert retailLead;
        
        return retailLead;
    }
    public static Retail_Customer__c createRetailCustomer(){
        Retail_Customer__c retailCustomer = new Retail_Customer__c();
        retailCustomer.Name__c='Ravi';
        retailCustomer.Last_Name__c='Chandra';
        retailCustomer.Billing_First_Name__c='Ravi';
        retailCustomer.Billing_Last_Name__c ='Chandra';
        retailCustomer.Shop_Name__c='Patanjali Retail Shop';
        retailCustomer.Shop_Address__c='test Address';
        retailCustomer.Country_Code__c='India(+91)';
        retailCustomer.Phone_Number__c='9632587410';
        retailCustomer.Pin_code__c='500081';
       
        insert retailCustomer;
        return retailCustomer;
        
    }
    
   /* public static Retail_Customer__c retailCustomerNew(){
        Retail_Customer__c retailCustomer = new Retail_Customer__c();
        retailCustomer.Name__c='Ravi';
        retailCustomer.Last_Name__c='Chandra';
        retailCustomer.Billing_First_Name__c='Ravi';
        retailCustomer.Billing_Last_Name__c ='Chandra';
        retailCustomer.Shop_Name__c='Patanjali Retail Shop';
        retailCustomer.Shop_Address__c='test Address';
        retailCustomer.Country_Code__c='India(+91)';
        retailCustomer.Phone_Number__c='9632587410';
        retailCustomer.Pin_code__c='500081';
       
        retailCustomer.Link_Lead_ID__c='';
        insert retailCustomer;
        return retailCustomer;
        
    }*/
    
    public Static Retail_Warehouse__c createRetailWarehouse(){
        Retail_Warehouse__c retailWarehouse = new Retail_Warehouse__c();
        retailWarehouse.Name='Test WarHouse';
        retailWarehouse.Warehouse_Type__c='Avana Warehouse';
        retailWarehouse.Warehouse_Code__c='Avana-DNH-Silvassa';
        retailWarehouse.GST_Number__c='26AAACE3423G1Z3';
        retailWarehouse.POC_Phone_Number__c='9685744123';
        retailWarehouse.Point_of_Contact_POC_Name__c='Test POCName';
        retailWarehouse.POC_Email__c='POCName123@mail.com'; 
        retailWarehouse.Warehouse_Stock_Management_Email__c='POCName123@mail.com'; 
        
        insert retailWarehouse;
        return retailWarehouse;
    }
    
    public Static Retail_Product_Group__c createRetailProductGroup(){
        Retail_Product_Group__c retailProductGroup = new Retail_Product_Group__c ();
        retailProductGroup.Name='Avana Mulch Film';
        
        Insert retailProductGroup;
        return retailProductGroup;
        
    }
    public Static Retail_Product__c createRetailProduct (String prdGrp){
        Retail_Product__c retailProduct  = new Retail_Product__c();
        retailProduct.Retail_Product_Group__c = prdGrp;
        retailProduct.Product_Code__c='BFT-LNR-5.0-1.5';
        retailProduct.Selling_Price__c=23000;
        retailProduct.Product_Name__c='Biofloc Tank Liner 5.0x1.5';
        retailProduct.Std_Package_Size__c=30;
        
        Insert retailProduct;
        return retailProduct;
    }
    public Static Retail_Product__c insertRetailProduct (String prdGrp){
        Retail_Product__c retailProduct  = new Retail_Product__c();
        retailProduct.Retail_Product_Group__c = prdGrp;
        retailProduct.Product_Code__c='BFT-LNR-5.0-1.5';
        retailProduct.Selling_Price__c=23000;
        retailProduct.Product_Name__c='Biofloc Tank Liner 5.0x1.5';
        retailProduct.Std_Package_Size__c=30;
        
        
        return retailProduct;
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
    public static Retail_Order__c createRetailOrder(String Status,String warehouse){
        System.debug('Status 116-->'+Status);
        Retail_Order__c retailOrder= new Retail_Order__c();
        retailOrder.Order_Date__c= system.today();
        retailOrder.Order_Type__c='Retail Products';
        retailOrder.Dispatch_Warehouse__c=warehouse;
        retailOrder.Freight_Charge_Bearer_values__c='Avana';
        retailOrder.Prefered_Transport_Company__c='AMRUT LOGISTICS (ARCO)';
        retailOrder.Closest_Tranport_Branch__c='hyd';
        retailOrder.Credit__c=1000;
        retailOrder.Sub_Total__c=1000;
        retailOrder.Net_Total__c=1000;
        retailOrder.Advance__c=0;
        retailOrder.Status__c=Status;
        retailOrder.OwnerId = UserInfo.getUserId();
        retailOrder.Order_Discount__c=0.0;
        
        Insert retailOrder;
        return retailOrder;
        
    }
    public static Retail_Order__c retailOrdCustId(String Status,String warehouse,String customerId){
        System.debug('Status 116-->'+Status);
        Retail_Order__c retailOrder= new Retail_Order__c();
        retailOrder.Order_Date__c= system.today();
        retailOrder.Order_Type__c='Retail Products';
        retailOrder.Dispatch_Warehouse__c=warehouse;
        retailOrder.Freight_Charge_Bearer_values__c='Avana';
        retailOrder.Prefered_Transport_Company__c='AMRUT LOGISTICS (ARCO)';
        retailOrder.Closest_Tranport_Branch__c='hyd';
        retailOrder.Credit__c=1000;
        retailOrder.Sub_Total__c=1000;
        retailOrder.Net_Total__c=1000;
        retailOrder.Advance__c=0;
        retailOrder.Status__c=Status;
        retailOrder.OwnerId = UserInfo.getUserId();
        retailOrder.Order_Discount__c=0.0;
        retailOrder.Retail_Customer__c=customerId;
        
        Insert retailOrder;
        return retailOrder;
        
    }
    
    public static Retail_Order__c updateRetailOrder(String Status,String orderId, String warehouse,String customerId){
        System.debug('Status 116-->'+Status);
        Retail_Order__c retailOrder= new Retail_Order__c();
        if(Status=='Payment Approved'){
            retailOrder.Id = orderId;
        }
        if(status=='Awaiting Accounts'){
            retailOrder.Id = orderId;
        }
        if(status=='Upload Packing List'){
            retailOrder.Id = orderId;
        }
        if(status=='Production Approved'){
            retailOrder.Id = orderId;
        }
        if(status=='Ready For Dispatch'){
            retailOrder.Id = orderId;
        }
        if(status=='Dispatched Awaiting Final Payment'){
            retailOrder.Id = orderId;
        }
        if(status=='Completed'){
            retailOrder.Id = orderId;
            
        }
        retailOrder.Retail_Customer__c=customerId;
        retailOrder.Order_Date__c= system.today();
        retailOrder.Order_Type__c='Retail Products';
        retailOrder.Dispatch_Warehouse__c=warehouse;
        retailOrder.Freight_Charge_Bearer_values__c='Avana';
        retailOrder.Prefered_Transport_Company__c='AMRUT LOGISTICS (ARCO)';
        retailOrder.Closest_Tranport_Branch__c='hyd';
        retailOrder.Credit__c=1000;
        retailOrder.Sub_Total__c=1000;
        retailOrder.Net_Total__c=1000;
        retailOrder.Advance__c=0;
        retailOrder.Status__c=Status;
        retailOrder.OwnerId = UserInfo.getUserId();
        retailOrder.Order_Discount__c=0.0;
        
        Update retailOrder;
        return retailOrder;
        
    }
    
    
    public static Retail_Order__c createRetailOrderOther(String Status,String warehouse){
        Retail_Order__c retailOrder= new Retail_Order__c();
        retailOrder.Order_Date__c= system.today()+1;
        retailOrder.Order_Type__c='Retail Products';
        retailOrder.Dispatch_Warehouse__c=warehouse;
        retailOrder.Freight_Charge_Bearer_values__c='Avana';
        retailOrder.Prefered_Transport_Company__c='AMRUT LOGISTICS (ARCO)';
        retailOrder.Closest_Tranport_Branch__c='hyd';
        retailOrder.Credit__c=5472;
        retailOrder.Sub_Total__c=6080;
        retailOrder.Net_Total__c=5472;
        retailOrder.Advance__c=0;
        retailOrder.Status__c=Status;
        retailOrder.OwnerId = UserInfo.getUserId();
        retailOrder.Order_Discount__c=10;
        Retail_Customer__c customer =createRetailCustomer();
        retailOrder.Retail_Customer__c=customer.Id;
        return retailOrder;
        
    }
    
    public static Retail_Lead_Visit__c createRetailLeadVisit(String leadName){
        Retail_Lead_Visit__c retailLeadVisit = new Retail_Lead_Visit__c();
        retailLeadVisit.Lead_Name__c=leadName;
        retailLeadVisit.Level_of_Interest__c='Cold Lead';
        retailLeadVisit.Sale_Type__c='Indirect';
        retailLeadVisit.Lead_Type__c='Retailer';
        retailLeadVisit.Follow_up_Date__c=system.today();
        retailLeadVisit.Reason_for_Cold_Lead__c='Price too high';
        
        Insert retailLeadVisit;
        Return retailLeadVisit;
    }
    
    public static Retail_Lead_Product__c createRetailPrd(String prdGrp){
        Retail_Lead_Product__c retailLeadPrd = new Retail_Lead_Product__c();
        retailLeadPrd.Retail_Product_Group__c=prdGrp;
        retailLeadPrd.Quantity__c='20';
        insert retailLeadPrd;
        return retailLeadPrd;
        
    }
    
    public static Retail_Order_Product__c createRetailOrdPrd(string ordId, String prdGrp,String product){
        Retail_Order_Product__c  retailOrdPrd = New Retail_Order_Product__c();
        retailOrdPrd.Retail_Order__c =ordId;
        retailOrdPrd.Product_Group__c =prdGrp;
        retailOrdPrd.Product__c = product;
        retailOrdPrd.Net_Total_for_Product__c = 2500;
        retailOrdPrd.Product_Discount__c = 0;
        retailOrdPrd.Sub_Total__c = 2500;
        retailOrdPrd.Weight_Kg__c = 2;
        retailOrdPrd.Discounted_Kg_Rate__c = 0;
        retailOrdPrd.Kg_Rate__c = 100;
        retailOrdPrd.Unit_Price__c = 2500;
        retailOrdPrd.Discounted_Unit_Price__c = 2500;
        retailOrdPrd.Quantity__c = 2;
        retailOrdPrd.Std_Pkg_Sizes__c = 1;
        retailOrdPrd.Hole_Spacing__c = 'Test';
        retailOrdPrd.HoleType__c = 'Straight';
        return retailOrdPrd;
        
    }
    
     public static Retail_Order_Product__c insertRetailOrdPrd(string ordId, String prdGrp,String product){
        Retail_Order_Product__c  retailOrdPrd = New Retail_Order_Product__c();
        retailOrdPrd.Retail_Order__c =ordId;
        retailOrdPrd.Product_Group__c =prdGrp;
        retailOrdPrd.Product__c = product;
        retailOrdPrd.Net_Total_for_Product__c = 2500;
        retailOrdPrd.Product_Discount__c = 0;
        retailOrdPrd.Sub_Total__c = 2500;
        retailOrdPrd.Weight_Kg__c = 2;
        retailOrdPrd.Discounted_Kg_Rate__c = 0;
        retailOrdPrd.Kg_Rate__c = 100;
        retailOrdPrd.Unit_Price__c = 2500;
        retailOrdPrd.Discounted_Unit_Price__c = 2500;
        retailOrdPrd.Quantity__c = 2;
        retailOrdPrd.Std_Pkg_Sizes__c = 1;
        retailOrdPrd.Hole_Spacing__c = 'Test';
        retailOrdPrd.HoleType__c = 'Straight';
         Insert retailOrdPrd;
        return retailOrdPrd;
        
    }
    
}