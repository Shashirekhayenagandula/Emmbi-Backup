public with sharing class customLookupController {

    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject) {
        String myQuery = null;
        if(myObject == 'Case')
        {
            system.debug('entered case');
             myQuery = 'Select Id, CaseNumber from '+myObject+' Where CaseNumber Like  \'%' + searchTerm + '%\' AND LIMIT 5';
        
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, CaseNumber from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT 5';
            } 
            else {
                myQuery = 'Select Id, CaseNumber from '+myObject+' Where CaseNumber Like  \'%' + searchTerm + '%\' LIMIT 5';
            }
		}
        else if(myObject == 'Invoice')
        {
            system.debug('entered Invoice');
             myQuery = 'Select Id, InvoiceNumber from '+myObject+' Where InvoiceNumber Like  \'%' + searchTerm + '%\' AND LIMIT 5';
        
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, InvoiceNumber from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT 5';
            } 
            else {
                myQuery = 'Select Id, InvoiceNumber from '+myObject+' Where InvoiceNumber Like  \'%' + searchTerm + '%\' LIMIT 5';
            }
		}
        else
        {
            myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND LIMIT 5';
        
            if(searchTerm == null || searchTerm == '')
            {
                myQuery = 'Select Id, Name from '+myObject+' Where Name != NULL ORDER BY Name DESC LIMIT 5';
            } 
            else {
                myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' LIMIT 5';
            }
		}
                  
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
   /* @AuraEnabled(cacheable=true)
    public static List<sObject> searchpillname(String modObjName, string modObjId) 
    {
        List<Sobject> rec=new List<Sobject>();
        string myQuery2 = 'Select Id, Name from '+modObjName+' Where Id IN:'+modObjId;
        List<sObject> lookUpList2 = database.query(myQuery2);
        return lookUpList2;
    }*/
}