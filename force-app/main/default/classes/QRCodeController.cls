public with sharing class QRCodeController {
    @AuraEnabled(cacheable=true)
    public static List<Retail_Inventory__c> fetchProductDetails(String ProductId){
        Datetime fiveMinutesAgo = Datetime.now().addMinutes(-5);
        return [SELECT Id, Name, Add_Qty__c, Bundle_No__c, Instock__c, Product_Name__c, QR_Code__c, Sales_Qty__c FROM Retail_Inventory__c where Id=:ProductId AND LastModifiedDate <= :fiveMinutesAgo LIMIT 1];
    }
    @AuraEnabled
    public static String updateProductDetails(Integer Quantity, String ProductId){
        try{
            List<Retail_Inventory__c> RetailInv = [SELECT Id, Name, Add_Qty__c, Bundle_No__c, Instock__c, Product_Name__c, QR_Code__c, Sales_Qty__c FROM Retail_Inventory__c where Id=:ProductId LIMIT 1];
            RetailInv[0].Sales_Qty__c = RetailInv[0].Sales_Qty__c + Quantity;
            //RetailInv[0].Instock__c = RetailInv[0].Add_Qty__c - RetailInv[0].Sales_Qty__c;
            if(Schema.SobjectType.Retail_Inventory__c.isCreateable()){
                update RetailInv;
                return 'Retail Inventory Details Successfully Saved';
            }
            else {
                return 'You don\'t have sufficient permissions on the Retail Inventory Object to perform Edit operation. Please contact your System Administrator';
            }
        }
        catch(Exception e){
			ApexPages.addMessages(e);
            System.debug('Exception: '+e+', Stack Trace:'+e.getStackTraceString());
            return null;
        }
        
    }
}