public class RetailOrderPdfController {
    
    public static Retail_Order__c retailOrder{get;set;}
    public static List<Retail_Order_Product__c> retailOrderList{get;set;}

    public RetailOrderPdfController(){
        String recId = ApexPages.CurrentPage().getParameters().get('id');
        retailOrder = [SELECT Id, OwnerId, Name, Sales_Owner__c, Net_Total__c, Order_Date__c, Freight_Charge_Bearer_values__c, Expected_Delivery_Date_Customer__c, 
                       Dispatch_Warehouse__c,Dispatch_Warehouse__r.Name,Retail_Customer__c,Retail_Customer__r.Name__c,Retail_Customer__r.District__c,
                       Retail_Customer__r.District__r.Name,Retail_Customer__r.Shop_Name__c,Retail_Customer__r.Taluka__c,Comments__c, Retail_Customer__r.Taluka__r.Name,Advance__c, 
                       Cash_on_Delivery__c, Credit__c, Sub_Total__c, Order_Discount__c FROM Retail_Order__c where Id =:recId];
        system.debug('retailOrder'+retailOrder);
        
        
         
        retailOrderList=[SELECT Id, Name, HoleType__c, Quantity__c, Unit_Price__c, Sub_Total__c, Retail_Order__c, Net_Total_for_Product__c, 
                         Product_Discount__c, Product__c,Product__r.Product_Name__c, Product_Group__c, Hole_Spacing__c, Std_Pkg_Sizes__c, Discounted_Unit_Price__c, 
                         Kg_Rate__c, Discounted_Kg_Rate__c, Weight_Kg__c FROM Retail_Order_Product__c where Retail_Order__c=:retailOrder.Id];
        
        system.debug('retailOrderList'+retailOrderList);
    }

}