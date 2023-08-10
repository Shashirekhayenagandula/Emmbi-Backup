public class UploadFileCls
{
    @AuraEnabled  
   public static string saveContact(Retail_Upload_Commercial_Invoice__c invoiceRec, string file, string fileName) {  
     string contactId;  
     try{  
       Insert invoiceRec;  
       contactId = invoiceRec.Id;  
       String base64File = EncodingUtil.urlDecode(file, 'UTF-8');     
       ContentVersion contentVersionRec = new ContentVersion();  
       contentVersionRec.Title = fileName;  
       contentVersionRec.PathOnClient = '/' + fileName;  
       contentVersionRec.FirstPublishLocationId = invoiceRec.Id;  
       contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);  
       contentVersionRec.IsMajorVersion = true;  
       Insert contentVersionRec;  
     } catch(Exception ex){  
       system.debug('Exception===>'+ex.getMessage());  
     }  
     return contactId;  
   }    
    //////////////////////////////
       @AuraEnabled  
   public static string saveContacttt(Retail_Upload_Commercial_Invoice__c invoiceRec, string file, string fileName) {  
     string contactId;  
     try{ 
         
         List<ContentVersion> cvList = new List<ContentVersion>();
       Insert invoiceRec;  
       contactId = invoiceRec.Id;  
       String base64File = EncodingUtil.urlDecode(file, 'UTF-8');     
       ContentVersion contentVersionRec = new ContentVersion();  
       contentVersionRec.Title = fileName;  
       contentVersionRec.PathOnClient = '/' + fileName;  
       contentVersionRec.FirstPublishLocationId = invoiceRec.Id;  
       contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);  
       contentVersionRec.IsMajorVersion = true; 
         cvList.add(contentVersionRec);
       Insert cvList;  
     } catch(Exception ex){  
       system.debug('Exception===>'+ex.getMessage());  
     }  
     return contactId;  
   } 
    
    ////////////////////
     @AuraEnabled  
   public static string saveContactt(Retail_Upload_Shipment_tracking_Info__c shipmentRec, string file, string fileName) {  
     string contactId;  
     try{  
       Insert shipmentRec;  
       contactId = shipmentRec.Id;  
       String base64File = EncodingUtil.urlDecode(file, 'UTF-8');     
       ContentVersion contentVersionRec = new ContentVersion();  
       contentVersionRec.Title = fileName;  
       contentVersionRec.PathOnClient = '/' + fileName;  
       contentVersionRec.FirstPublishLocationId = shipmentRec.Id;  
       contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);  
       contentVersionRec.IsMajorVersion = true;  
       Insert contentVersionRec;  
     } catch(Exception ex){  
       system.debug('Exception===>'+ex.getMessage());  
     }  
     return contactId;  
   } 
    
    /////////////////////////UploadStandard packing size
      @AuraEnabled  
   public static string savePacSize(Retail_Update_standard_packaging_size__c shipmentRec, string file, string fileName) {  
     string contactId;  
     try{  
       Insert shipmentRec;  
       contactId = shipmentRec.Id;  
       String base64File = EncodingUtil.urlDecode(file, 'UTF-8');     
       ContentVersion contentVersionRec = new ContentVersion();  
       contentVersionRec.Title = fileName;  
       contentVersionRec.PathOnClient = '/' + fileName;  
       contentVersionRec.FirstPublishLocationId = shipmentRec.Id;  
       contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);  
       contentVersionRec.IsMajorVersion = true;  
       Insert contentVersionRec;  
     } catch(Exception ex){  
       system.debug('Exception===>'+ex.getMessage());  
     }  
     return contactId;  
   } 
    
}