public class PdfClass {
    public List<ContentVersion> PreConVrsnList {get;set;}
    public List<ContentVersion> PostConVrsnList {get;set;}
    public Id recId=Apexpages.currentPage().getparameters().get('id');
    public List<ContentDocumentLink> cclist {get;set;}
    public List<Opportunity__c> enlist{get;set;}
    
    public PdfClass(ApexPages.StandardController controller) {
        System.debug('record id of object:::::'+recId);
        enlist=[select id,Customer__c,Customer__r.name,Customer__r.Farmer_First_Name__c,Customer__r.Farmer_Middle_Name__c,Customer__r.Address__c,Customer__r.State__c,Lead__c,
                Customer__r.Tehsil__r.Name,Customer__r.District__c,Customer__r.Phone,Customer__r.Alternate_Mobile_No__c,Customer__r.Aadhar_Number__c,Product_Name__c,Pondliner_Size_Requested_Required_Sq_Mt__c,Pond_Size_Sq_Mtr__c,
                Murughas_Bag_Qty__c,Customer__r.Distributor__c,Customer__r.Pin_Code__c,Customer__r.Dealer__r.Name,Invoice_done__c,Invoice_Date__c,Quality_person__r.Name,Pre_Visit_Date__c,Pre_Visit_Done_By__r.Name,
                Remarks__c,Installation_Date__c,Name_of_Operator__c,Certificate_Valid_Till__c,Farmer_feedback__c from opportunity__c where id=:recId];
        
        System.debug('details of enquiry::::::'+enlist);
        if(enlist[0].Customer__c!=null){
            cclist = new List<ContentDocumentLink>(); 
            cclist=[select contentdocumentId,linkedentityid from ContentDocumentLink where linkedentityid =:recId ];
        system.debug('contentdocumentlink details:::'+cclist);
        	Set<Id> conid=new Set<Id>();
            for(ContentDocumentLink co:cclist){
                conid.add(co.ContentDocumentId);
            }
        System.debug('conid:::'+conid);
        	 If(!cclist.isEmpty()){
                PreConVrsnList=[select id,versiondata,title,filetype from ContentVersion where contentdocumentId in:conid AND title LIKE '%PreImage%' ORDER BY LastModifiedDate DESC LIMIT 1];
                System.debug('PRE content Version details::::::'+PreConVrsnList);
                PostConVrsnList=[select id,versiondata,title,filetype from ContentVersion where contentdocumentId in:conid AND title LIKE '%PostImage%' ORDER BY LastModifiedDate DESC LIMIT 1]; 
              	System.debug('POST content Version details::::::'+PostConVrsnList);
        	}
            //FileIds=pdfWithDocumrnt();
        }
        
    }
    
   /* public List<ContentVersion> pdfWithDocumrnt(){
        system.debug('OppId:::'+recId);
        //string FileId; 
        List<ContentVersion> conlist = new List<ContentVersion>();
        Set<Id> conid=new Set<Id>();
        for(ContentDocumentLink co:cclist){
            conid.add(co.ContentDocumentId);
        }
        System.debug('conid:::'+conid);
        system.debug('contentdocumentId details:::'+cclist);
        //string preImg='%'+'PreImage'+'%';
        //string pstImg='%'+'PostImage'+'%';
        If(!cclist.isEmpty()){
            conlist=[select id,versiondata,title,filetype from ContentVersion where contentdocumentId in:conid AND (title LIKE '%PreImage%' OR title LIKE '%PostImage%')];
            //FileId=conlist[0].Id;
            System.debug('content Version details::::::'+conlist);
            //system.debug('FileID:::'+FileId);
        }
        return conlist;
    }*/
    
    public PageReference goBack(){
        Id OppiD = ApexPages.currentPage().getParameters().get('id');
        PageReference pg = new PageReference('/'+OppiD);
        return pg;
    }
}