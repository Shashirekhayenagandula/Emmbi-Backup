public with sharing class ReusableMultiSelectLookupController {
   /* @AuraEnabled
    public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper) {
        try {
            if(inputWrapper != null){
                string filterCriteria='';
                List<String> searchKeywordList = inputWrapper.searchString.split(' ');
                for(String kw : searchKeywordList){
                    filterCriteria += inputWrapper.fieldApiName + ' LIKE \'%'+kw+'%\' OR ';
                }
                if(string.isNotBlank(inputWrapper.otherFieldApiName) && inputWrapper.searchByOtherField){
                    for(String kw : searchKeywordList){
                    filterCriteria+= inputWrapper.otherFieldApiName + ' LIKE \'%'+kw+'%\' OR ';
                    }
                }
                filterCriteria = filterCriteria.removeEnd(' OR ');
                String fieldsToQuery = 'SELECT Id, ';
                if(string.isNotBlank(inputWrapper.fieldApiName)){
                    fieldsToQuery = fieldsToQuery + inputWrapper.fieldApiName;
                }
                if(string.isNotBlank(inputWrapper.otherFieldApiName)){
                    fieldsToQuery = fieldsToQuery + ', ' + inputWrapper.otherFieldApiName;
                }
                String query = fieldsToQuery + ' FROM '+ inputWrapper.objectApiName;
                if(String.isNotBlank(inputWrapper.parentFieldApiName) && String.isNotBlank(inputWrapper.parentRecordId)){
                    query += ' WHERE '+ inputWrapper.parentFieldApiName+ ' = \''+ inputWrapper.parentRecordId + '\'';
                    query += ' AND (' + filterCriteria+' ) Order By '+ inputWrapper.fieldApiName+' Limit 10';
                } 
                else {
                    query += ' WHERE '+ filterCriteria+' Order By '+ inputWrapper.fieldApiName+' Limit 10';
                }
                System.debug('query==>'+query);
                List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
                for(SObject s : Database.query(query)) {
                    ResultWrapper wrap = new ResultWrapper();
                    wrap.mainField = (String)s.get(inputWrapper.fieldApiName);
                    //wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
                    wrap.id = (String)s.get('id');
                    returnWrapperList.add(wrap);
                }
                System.debug('returnWrapperList==>'+returnWrapperList);
                return returnWrapperList;
            }
            return null;
        } catch (Exception err) {
            System.debug(err.getStackTraceString());
            throw new AuraHandledException(err.getMessage());
        }
    }


    

    @AuraEnabled
    public static void saveDataApex(Map<String, Object> recordData,Map<String, Object> lookupfields) {
        system.debug('lookupfields==entered');
        system.debug('lookupfields=='+lookupfields);
        // Extract the field values from the recordData map
        //String field1Value = (String)recordData.get('Lead_Owner__c');
        String field2Value = (String)recordData.get('Lead_Source__c');
       // String field3Value = (String)recordData.get('Name');
        Date field4Value = (Date)recordData.get('Date__c');
        String field5Value = (String)recordData.get('Lead_Type__c');
        String field6Value = (String)recordData.get('Lead_Name__c');
        String field7Value = (String)recordData.get('Phone__c');
        String field8Value = (String)recordData.get('Village__c');
        String field9Value = (String)recordData.get('Is_Converted__c');
        Date field10Value = (Date)recordData.get('Last_Order_Date__c');
        String field11Value = (String)recordData.get('Sale_Type__c');
        String field12Value = (String)recordData.get('Pending_Data__c');
       
      
        // Retrieve more field values as needed

        // Perform the necessary operations to store the data in the database
        // You can create new records, update existing records, etc.
        // Example: Insert a new record
        Retail_Lead__c obj = new Retail_Lead__c();
       // obj.Lead_Owner__c = field1Value;
        obj.Lead_Source__c = field2Value;
       // obj.Name = field3Value;
        obj.Date__c = field4Value;
        obj.Lead_Type__c = field5Value;
        obj.Lead_Name__c = field6Value;
        obj.Phone__c = field7Value;
        obj.Village__c = field8Value;
        obj.Is_Converted__c = field9Value;
        obj.Last_Order_Date__c = field10Value;
        obj.Sale_Type__c = field11Value;
        obj.Pending_Data__c = field12Value;
      

        // Set more field values as needed
        insert obj;
    }

    public class ResultWrapper{
        @AuraEnabled public String mainField{get;set;}
        @AuraEnabled public String subField{get;set;}
        @AuraEnabled public String id{get;set;}
    }

    public class SearchWrapper {
        @AuraEnabled public String objectApiName{get;set;}
        @AuraEnabled public String fieldApiName{get;set;}
        @AuraEnabled public String otherFieldApiName{get;set;}
        @AuraEnabled public String searchString{get;set;}
        @AuraEnabled public String parentRecordId{get;set;}
        @AuraEnabled public String parentFieldApiName{get;set;}
        @AuraEnabled public Boolean searchByOtherField{get;set;}
    }*/
}