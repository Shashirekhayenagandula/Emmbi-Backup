trigger Autocheck on ContentDocumentLink (after insert) 
{
    string tempParentId;
    Set<Id> setParentId = new Set<Id>();
    List<Visit__c> Visitlst = new List<Visit__c>();
 for (ContentDocumentLink cdl : trigger.new ) {
            tempParentId = cdl.LinkedEntityId;
     
            if (tempParentId != null) {
                System.debug('Debug : found a0X');
                System.debug('Debug : content document id ' + cdl.ContentDocumentId);
                setParentId.add(cdl.LinkedEntityId);
            }
        }
Visitlst = [select Id , Upload_Photo_of_Visit__c from Visit__c where Id IN :setParentId];
     
     For(Visit__c e : Visitlst)
     {
        e.Upload_Photo_of_Visit__c = True;
     }

     update Visitlst;
}