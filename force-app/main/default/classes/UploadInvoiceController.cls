public with sharing class UploadInvoiceController {
    @AuraEnabled
    public static void uploadFile(Id recordId, String fileName, String base64Data) {
        // Convert the base64 data to Blob
        Blob fileBlob = EncodingUtil.base64Decode(base64Data);

        // Create a new ContentVersion record
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        cv.VersionData = fileBlob;
        cv.FirstPublishLocationId = recordId;
        insert cv;
    }
}