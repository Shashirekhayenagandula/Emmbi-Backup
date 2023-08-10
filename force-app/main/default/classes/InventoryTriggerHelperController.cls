public class InventoryTriggerHelperController {
    public static Boolean isInventoryInstockUpdate = true;
    public static void handleSendEmailAfterUpdate(List<Retail_Inventory__c> newInventories) {
        System.debug('Method Entered');
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'surender@dhruvsoft.com'];
        List<Retail_Inventory__c> inventoryToUpdate = new List<Retail_Inventory__c>();
        
        for (Retail_Inventory__c newInventory : newInventories) {
            
            if (newInventory.Availability__c == 'Low Stock') {
                inventoryToUpdate.add(newInventory);
                
                System.debug('+newInventory.Owner.name'+newInventory.OwnerId);
                User SalesOwner=[Select Id,Name,Email from user where id =:newInventory.OwnerId limit 1];
                Retail_Warehouse__c WarehouseDeatils=[SELECT Id, Name, Warehouse_Type__c, GST_Number__c, Point_of_Contact_POC_Name__c, POC_Phone_Number__c, POC_Email__c FROM Retail_Warehouse__c where Id=:newInventory.Warehouse_Code__c limit 1];
                Retail_Product__c productDetails=[SELECT Id, Name,Product_Name__c from Retail_Product__c where Id=:newInventory.Product_Name__c limit 1];
                List<String> toaddresses=New List<String>();
                System.debug('UserList toaddresses'+toaddresses);
                Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
                toaddresses.add('shashirekha@dhruvsoft.com'); 
                toaddresses.add('thanmayee@dhruvsoft.com'); 
                // toaddresses.add(SalesOwner.Email); 
                mymail.setToAddresses(toaddresses);
                String subject = newInventory.Name+' Order Received- Low Stock in '+WarehouseDeatils.Name+' of '+productDetails.Product_Name__c; 
                mymail.setSubject(subject);
                
                String EmailBody = '<html><body>';
                EmailBody += 'Dear Warehouse Stock Management Team,<br/>';
                EmailBody += '<p><p/>';
                EmailBody += 'The stock in '+WarehouseDeatils.Name+' for the product '+productDetails.Product_Name__c+' is running low. ';
                EmailBody += 'Please place an order if you need to get it from another Avana warehouse. <br/>';
                EmailBody += 'Else add product using this link: ';
                EmailBody +='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+newInventory.Id+'" target="_blank">Add Inventory</a>. ';
                EmailBody +='<p><p/>';
                EmailBody +='<b>Warm Regards,</b><br/>';
                EmailBody +='<b>Avana Operations Team</b><br/>';
                EmailBody += '</body></html>';
                mymail.setHtmlBody(EmailBody);
                
                mymail.setOrgWideEmailAddressId(owea.get(0).Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
                
            }
        }
        
    }
    
  /*   public static void handleInventoryUpdate(List<Retail_Inventory__c> newInventories, Map<Id, Retail_Inventory__c> oldInventories) {
        List<Retail_Inventory__c> inventoriesToUpdate = new List<Retail_Inventory__c>();

        // Handle before insert and before update scenarios
        if (Trigger.isInsert || Trigger.isUpdate) {
            for (Retail_Inventory__c inventory : newInventories) {
                Retail_Inventory__c newInstance = new Retail_Inventory__c();
                newInstance.Id = inventory.Id;
                Decimal addQty = inventory.Add_Qty__c != null ? inventory.Add_Qty__c : 0;
                Decimal salesQty = inventory.Sales_Qty__c != null ? inventory.Sales_Qty__c : 0;
                newInstance.Instock__c = addQty - salesQty;
                inventoriesToUpdate.add(newInstance);
            }
        }

        // Handle before delete scenario
        if (Trigger.isDelete) {
            for (Retail_Inventory__c inventory : newInventories) {
                // In before delete trigger, oldInventories contains the records before they are deleted.
                Decimal addQty = oldInventories.get(inventory.Id).Add_Qty__c != null ? oldInventories.get(inventory.Id).Add_Qty__c : 0;
                Decimal salesQty = oldInventories.get(inventory.Id).Sales_Qty__c != null ? oldInventories.get(inventory.Id).Sales_Qty__c : 0;
                inventory.Instock__c = addQty - salesQty;
                inventoriesToUpdate.add(inventory);
            }
        }

        // Update the records with the calculated values
        if (!inventoriesToUpdate.isEmpty()) {
            update inventoriesToUpdate;
        }
    }*/
    
    
    public static void updateInstockAtInventory(List<Retail_Inventory__c> inventoryList){
        List<Retail_Inventory__c> newInstanceList = new  List<Retail_Inventory__c>();
       	isInventoryInstockUpdate = false;
        //if(isInvUpdate){
        for(Retail_Inventory__c invData : inventoryList){
            Retail_Inventory__c newInstance = new Retail_Inventory__c();
            newInstance.Id = invData.Id;
            if(invData.Add_Qty__c != null && invData.Sales_Qty__c != null){
            newInstance.Instock__c = invData.Add_Qty__c - invData.Sales_Qty__c;
            }else{
              newInstance.Instock__c = 0;  
            }
            
            if(invData.Net_Weight__c != null && invData.Tare_Weight__c != null){
            newInstance.Gross_Weight__c = invData.Net_Weight__c + invData.Tare_Weight__c;
            }else{
                newInstance.Gross_Weight__c = 0;
            }
            newInstanceList.add(newInstance);
        }
        update newInstanceList;
       // }
    }
    
    
    
    
    
    
    
    public static void updateParentTotalInStock(List<Retail_Inventory__c> inventoryRecords) {
        Set<Id> productId = new Set<Id>();
        List<Retail_Product__c> retPro = new List<Retail_Product__c>();
        //List<Retail_Inventory__c> retInventory = new List<Retail_Inventory__c>();
        //Map<Id, Decimal> sumValue = new Map<Id, Decimal>();
        //Decimal inStock = 0;
        
        for(Retail_Inventory__c reInv : inventoryRecords){
            productId.add(reInv.Product_Name__c);
        }
        
        List<AggregateResult> agglist = [select Product_Name__c pn, sum(Instock__c) instock from Retail_Inventory__c where Product_Name__c IN: productId group by Product_Name__c];
      /*  List<Retail_Inventory__c> retailInventoryList = [SELECT id,Instock__c FROM Retail_Inventory__c];
        for(Retail_Inventory__c retInv : retailInventoryList){
            retInv.Instock__c = retInv.Add_Qty__c-retInv.Sales_Qty__c;
            retailInventoryList.add(retInv);
        }
        Update retailInventoryList;*/

        
        for(AggregateResult agg : agglist){
            Retail_Product__c rp = new Retail_Product__c();
            rp.Id = (Id) agg.get('pn');
            rp.Total_In_Stock__c = (Decimal) agg.get('instock');
            retPro.add(rp);
        }
        Update retPro;
        
    }
}