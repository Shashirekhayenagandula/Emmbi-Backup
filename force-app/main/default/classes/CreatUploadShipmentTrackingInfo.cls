public class CreatUploadShipmentTrackingInfo 
{
 @AuraEnabled
    public static List<Retail_Upload_Shipment_tracking_Info__c> newuploadShipmentTracking(list<Retail_Upload_Shipment_tracking_Info__c> uploadShipmentTracking){
         
        List<Retail_Upload_Shipment_tracking_Info__c> ref = new List< Retail_Upload_Shipment_tracking_Info__c> ();
        try {
            for(Retail_Upload_Shipment_tracking_Info__c rf :uploadShipmentTracking )
            {
                if (Schema.sObjectType.Retail_Upload_Shipment_tracking_Info__c.isCreateable())
                {
                    ref.add(rf); 
                }
            }
            if(ref.size()>0)
            {
                Insert ref;
            }
            return ref; 
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static String getObjectName(String recId){
        
        Id recordId = recId;
        String objName;
        Schema.SObjectType orderObject = Schema.Retail_Order__c.getSObjectType();
       // Schema.SObjectType quotationObject = Schema.DMS_Quotation__c.getSObjectType();
        Schema.SObjectType record = recordId.getsobjecttype();
        objName = (record == orderObject) ? String.valueOf(record) : null;
        return objName;
    }
}