@isTest
public class PdfClass_Test {
    public static testMethod void PdfClassTest()
    {
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        
        Distributor__c dd=new Distributor__c();
        dd.Name='test';
        dd.Distributor_Email__c='abac@gmail.com';
        insert dd;
        
        Dealer__c Dl= new Dealer__c();
        Dl.Name='sangv';
        Dl.Distributor__c=dd.id;
        insert Dl;
        
        Tehsil__c Tl= new Tehsil__c();
        Tl.Dealer__c=Dl.Id;
        Tl.Name='hgfg';
        insert Tl;
        
        Account acc=new Account();
        acc.name='avana';
        acc.Farmer_First_Name__c='Pritam';
        acc.Farmer_Middle_Name__c='A';
        acc.Address__c='indiranagar';
        acc.Phone='9743443434';
        acc.Alternate_Mobile_No__c='9778906453';
        acc.Aadhar_Number__c='123434345656';
        acc.Pin_Code__c='588899';
        acc.Dealer__c=Dl.id;
        insert acc;
        
        
      Opportunity__c opp = new Opportunity__c();
        opp.Product_Name__c='jhasjg';
        opp.Pondliner_Size_Requested_Required_Sq_Mt__c=0.00;
        opp.Pond_Size_Sq_Mtr__c='20';
        opp.Murughas_Bag_Qty__c=5.0;
        opp.Invoice_done__c=true;
        opp.Invoice_Date__c = Date.newInstance(2016, 12, 9);
        opp.Quality_person__c=u.Id;
        opp.Pre_Visit_Date__c=Date.newInstance(2016, 12, 9);
        opp.Pre_Visit_Done_By__c=u.id;
        opp.Remarks__c='fg';
        opp.Installation_Date__c=Date.newInstance(2016, 12, 9);
        opp.Name_of_Operator__c='ASHHG02-Sunil Dongardive';
        opp.Farmer_feedback__c='Satisfied';
        opp.Customer__c=acc.id;
        
        insert opp;
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
     ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';          
        cv.VersionData =beforeblob;          
        insert cv;        

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];


        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=opp.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        contentlink.Visibility = 'AllUsers';
        insert contentlink;
        
        PageReference pageRef = Page.AttachImagePDF;
        pageRef.getParameters().put('id', opp.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        PdfClass testAccPlan = new PdfClass(sc);
        testAccPlan.goBack();
        
        
    }

}