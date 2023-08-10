public class NewOverrideOrderReturnController {
     @AuraEnabled
    public static String insertOrderWithProduct(List<Retail_Order_Return_Product__c> productList, Retail_Order_Return_Form__c order) {
        try {
            List<Retail_Order_Return_Product__c> lstiv = new List<Retail_Order_Return_Product__c>();
				System.debug('productList'+productList);
            System.debug('order'+order);
            if (Schema.sObjectType.Retail_Order_Return_Form__c.isCreateable()) {
                insert order;
            }            String orderId = order.Id;
            try{
             for (Retail_Order_Return_Product__c pro : productList) {
                Retail_Order_Return_Product__c product = new Retail_Order_Return_Product__c();
                System.debug('pro===='+pro.Name);
                product.Retail_Order_Return_Form__c = order.Id;
                product.Product_Group__c = pro.Product_Group__c;
                product.Products__c = pro.Products__c;
                product.Hole_Type__c = pro.Hole_Type__c;
                product.Hole_Spacing__c = pro.Hole_Spacing__c;
                product.Std_Pkg_Sizes__c = pro.Std_Pkg_Sizes__c;
                product.Quantity__c = pro.Quantity__c;
                product.Unit_Price__c = pro.Unit_Price__c;
                product.Kg_Rate__c = pro.Kg_Rate__c;
                product.Discounted_Kg_Rate__c = pro.Discounted_Kg_Rate__c;
                product.Weight_Kg__c = pro.Weight_Kg__c;
                product.Sub_Total__c = pro.Sub_Total__c;
                product.Product_Discount__c = pro.Product_Discount__c;
                product.Net_Total_for_Product__c = pro.Net_Total_for_Product__c;
                product.Return_Quantity__c = pro.Return_Quantity__c;
                product.Return_Weight__c = pro.Return_Weight__c;
                product.Return_Net_Total_for_Product__c = pro.Return_Net_Total_for_Product__c;
               
                lstiv.add(product);
            }
                if (!lstiv.isEmpty() && Schema.sObjectType.Retail_Order_Return_Product__c.isCreateable()) {
                insert lstiv;
            }
            }
             catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

            return orderId;
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
     @AuraEnabled(cacheable=true)
    public static List<Retail_Order_Return_Product__c> fetchProductList(String recordId) {
        System.debug('recordId55'+recordId);
        return [select id,Retail_Order_Return_Form__c ,Discounted_Kg_Rate__c , Discounted_Unit_Price__c, Hole_Spacing__c , Hole_Type__c, Kg_Rate__c, Name, Net_Total_for_Product__c,  Products__c , Product_Discount__c , Product_Group__c, Quantity__c, Std_Pkg_Sizes__c, Sub_Total__c, Weight_Kg__c ,Unit_Price__c ,Return_Net_Total_for_Product__c, Return_Quantity__c, Return_Weight__c from Retail_Order_Return_Product__c where Retail_Order_Return_Form__c =:recordId];
   }

}