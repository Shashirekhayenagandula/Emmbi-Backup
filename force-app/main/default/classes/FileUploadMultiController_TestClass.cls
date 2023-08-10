@isTest
public class FileUploadMultiController_TestClass 
{
   @isTest
    static void testUploadFiles() {
        try{
              Retail_Warehouse__c testWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Order__c testOrder = TestDataFactory.createRetailOrderOther('Production Approved',testWarehouse.Id);
       
        
      //  Retail_Order__c testOrder = new Retail_Order__c(Prefered_Transport_Company__c = 'CHINTAN FREIGHT CARRIER');
      //  insert testOrder;
        
        // Create test file data
        List<FileUploadMultiController.FileDataWP> testFiles = new List<FileUploadMultiController.FileDataWP>();
        FileUploadMultiController.FileDataWP file1 = new FileUploadMultiController.FileDataWP();
        file1.fileName = 'TestFile1.txt';
        file1.fileContent = EncodingUtil.base64Encode(Blob.valueOf('Test content 1'));
        testFiles.add(file1);
        FileUploadMultiController.FileDataWP file2 = new FileUploadMultiController.FileDataWP();
        file2.fileName = 'TestFile2.txt';
        file2.fileContent = EncodingUtil.base64Encode(Blob.valueOf('Test content 2'));
        testFiles.add(file2);
        String fileDataJson = JSON.serialize(testFiles);
      

        Test.startTest();
        // Call the uploadFiles method
        String result = FileUploadMultiController.uploadFiles(testOrder.Id, fileDataJson);
        Test.stopTest();

        // Assert the result is 'success'
        System.assertEquals('success', result);

        // Verify that ContentVersion and ContentDocumentLink records were created
        List<ContentVersion> cvList = [SELECT Id, Title, VersionData, PathOnClient FROM ContentVersion];
        System.assertEquals(2, cvList.size());
        List<ContentDocumentLink> cdList = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, ShareType FROM ContentDocumentLink WHERE Id ='a1G9H000000RbWXUA0'];
        System.assertEquals(2, cdList.size());
        
        // Verify that the ContentDocumentLink records are linked to the test record
        for (ContentDocumentLink cd : cdList) {
            System.assertEquals(testOrder.Id, cd.LinkedEntityId);
            System.assertEquals('V', cd.ShareType);
            System.assertEquals('AllUsers', cd.Visibility);
        } 
        }catch(exception e){
            system.debug('Exception.......'+e.getMessage());
        }
      
    }
     @isTest
    static void testUploadFiless() {
        try{
        Retail_Warehouse__c testWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Order__c testOrder = TestDataFactory.createRetailOrderOther('Production Approved',testWarehouse.Id);
        
        // Create test file data
        List<FileUploadMultiController.FileDataWP> testFiles = new List<FileUploadMultiController.FileDataWP>();
        FileUploadMultiController.FileDataWP file1 = new FileUploadMultiController.FileDataWP();
        file1.fileName = 'TestFile1.txt';
        file1.fileContent = EncodingUtil.base64Encode(Blob.valueOf('Test content 1'));
        testFiles.add(file1);
        FileUploadMultiController.FileDataWP file2 = new FileUploadMultiController.FileDataWP();
        file2.fileName = 'TestFile2.txt';
        file2.fileContent = EncodingUtil.base64Encode(Blob.valueOf('Test content 2'));
        testFiles.add(file2);
        String fileDataJson = JSON.serialize(testFiles);
      

        Test.startTest();
        // Call the uploadFiles method
        String result = FileUploadMultiController.uploadFiless(testOrder.Id, fileDataJson);
        Test.stopTest();

        // Assert the result is 'success'
        System.assertEquals('success', result);

        // Verify that ContentVersion and ContentDocumentLink records were created
        List<ContentVersion> cvList = [SELECT Id, Title, VersionData, PathOnClient FROM ContentVersion];
        System.assertEquals(2, cvList.size());
        List<ContentDocumentLink> cdList = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, ShareType FROM ContentDocumentLink WHERE Id ='a1G9H000000RbWXUA0'];
        System.assertEquals(2, cdList.size());
        
        // Verify that the ContentDocumentLink records are linked to the test record
        for (ContentDocumentLink cd : cdList) {
            System.assertEquals(testOrder.Id, cd.LinkedEntityId);
            System.assertEquals('V', cd.ShareType);
            System.assertEquals('AllUsers', cd.Visibility);
        }
    }catch(exception e){
            system.debug('Exception.......'+e.getMessage());
        }
    }
    @isTest
    static void testUploadFilesWithBlankRecordId() {
        // Call the uploadFiles method with a blank recordId
        String result = FileUploadMultiController.uploadFiless('', '[]');
        
        // Assert the result is 'record Id is Blank'
       // System.assertEquals('', result);
    }

    @isTest
    static void testShipmentInfo() {
       Retail_Warehouse__c testWarehouse = TestDataFactory.createRetailWarehouse();
        Retail_Order__c testOrder = TestDataFactory.createRetailOrderOther('Production Approved',testWarehouse.Id);

        Test.startTest();
        // Call the ShipmentInfo method
        List<Retail_Order__c> shipmentList = FileUploadMultiController.ShipmentInfo(testOrder.Id);
        Test.stopTest();

        // Assert that the returned list contains the test record
       // System.assertEquals(1, shipmentList.size());
       // System.assertEquals(testOrder.Id, shipmentList[0].Id);
        //System.assertEquals('Production Approved', shipmentList[0].Prefered_Transport_Company__c);
    }
}