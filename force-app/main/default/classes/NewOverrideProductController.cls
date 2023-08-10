public class NewOverrideProductController {
        
        @AuraEnabled
        public static String insertProductWithInventory(List<Retail_Inventory__c> inventoryList, Retail_Product__c product) {
            try {
                List<Retail_Inventory__c> lstiv = new List<Retail_Inventory__c>();
                System.debug('inventoryList'+inventoryList);
                System.debug('product'+product);
                if (Schema.sObjectType.Retail_Product__c.isCreateable()) {
                    insert product;
                }
                
                String productId = product.Id;
                String productGroup = product.Retail_Product_Group__c;
                try{
                    for (Retail_Inventory__c inv : inventoryList) {
                        Retail_Inventory__c inventory = new Retail_Inventory__c();
                        //System.debug('inv===='+inv.Name);
                        inventory.Product_Name__c = product.Id;
                        if (inv.Date__c == null || inv.Date__c == Date.newInstance(0, 0, 0)) {
                            inventory.Date__c = System.Today();
                        } else {
                            inventory.Date__c = inv.Date__c;
                        }
                        inventory.Warehouse_Code__c = inv.Warehouse_Code__c;
                        inventory.Retailer_Price__c = inv.Retailer_Price__c;
                        inventory.Distributor_Price__c = inv.Distributor_Price__c;
                        inventory.Retailer_MOQ__c = inv.Retailer_MOQ__c;
                        inventory.Distributor_MOQ__c = inv.Distributor_MOQ__c;
                        inventory.Notification_Threshold_Value__c = inv.Notification_Threshold_Value__c;
                        inventory.Add_Qty__c = inv.Add_Qty__c;
                        inventory.Sales_Qty__c = inv.Sales_Qty__c;
                       // if(inv.Instock__c != null){
                        inventory.Instock__c = inv.Instock__c;
                       // }
                        inventory.Pending_QC_Stock__c = inv.Pending_QC_Stock__c;
                        inventory.Saleable_Stock__c = inv.Saleable_Stock__c;
                        inventory.QC_Instock__c = inv.QC_Instock__c;
                        inventory.Availability__c = inv.Availability__c;
                        inventory.Product_Group__c = product.Retail_Product_Group__c;
                        
                        
                        lstiv.add(inventory);
                    }
                    
                    if (!lstiv.isEmpty() && Schema.sObjectType.Retail_Inventory__c.isCreateable()) {
                        insert lstiv;
                    }  
                    System.debug('productId11'+productId);
                    System.debug('Hiii prodduct11');
                    
                    
                    
                }
                catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
                System.debug('productId'+productId);
                System.debug('Hiii prodduct');
                
                return productId;
            } 
            catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
        
        @AuraEnabled(cacheable=true)
        public static List<Retail_Inventory__c> findInventoryList(String recordId) {
            List<Retail_Inventory__c> inventoryListData = [SELECT Id,Date__c,Warehouse_Code__c,Image_Testing__c,Availability__c,QC_Instock__c,QC_Failed_Stock__c,Saleable_Stock__c,Pending_QC_Stock__c,Instock__c,Sales_Qty__c,Add_Qty__c,Notification_Threshold_Value__c,Retailer_Price__c,Distributor_Price__c,Retailer_MOQ__c,Distributor_MOQ__c FROM Retail_Inventory__c WHERE Product_Name__c =: recordId];
            System.debug('This is inventoryListData ===>'+inventoryListData);
            System.debug(inventoryListData.size());
            return inventoryListData;
            
            
        }
        
        
        @AuraEnabled
        public static void upsertProduct(List<Retail_Inventory__c> inventoryList , Retail_Product__c product,List<Retail_Inventory__c> removeLineItemIds) {
            try {
                System.debug('product' + product);
                System.debug('product Id' + product.Id);
                System.debug('inventoryList1========' + inventoryList);
                if(product.Id!=null){
                    System.debug('product Id' + product.Id);
                    update product;
                }
                System.debug('inventoryList2======' + inventoryList.size());
                if(inventoryList.size()>0){
                    System.debug('inventoryList3======' + inventoryList.size());
                    if (Schema.sObjectType.Retail_Inventory__c.isUpdateable() || Schema.sObjectType.Retail_Inventory__c.isCreateable()) {
                        System.debug('inventoryList3======' + inventoryList.size());
                        //System.debug('inventoryList Id==123=='+inventoryList[1]);
                        upsert inventoryList;
                    }
                }
                if (removeLineItemIds.size() > 0) {
                    System.debug('removeLineItemIds======' + removeLineItemIds.size());
                    if (Schema.sObjectType.Retail_Inventory__c.isDeletable()) {
                        delete removeLineItemIds;
                    }
                }
                
            } catch (Exception e) {
                // throw new AuraHandledException(e.getMessage());
                System.debug('Error ===>'+e.getMessage()+' Linenumber===>104'+e.getlinenumber());
            }
            
        }
        
        
        
        
        
        
    }