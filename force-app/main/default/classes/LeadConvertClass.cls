public with sharing class LeadConvertClass {
    @AuraEnabled
    public static Lead__c getLeadName( string lId) {
        Lead__c ld=[select Farmer_First_Name__c,Stages__c from Lead__c where id=:lId];
        string CustomerName=ld.Farmer_First_Name__c;
        system.debug('NAME:::'+CustomerName);
        return ld ;
    }
    
    @AuraEnabled
    public static Boolean OppTest( string lId){
        List<Opportunity__c> oplt=[Select Id from Opportunity__c where Lead__c=:lId];
        if(oplt.size()>0){
            return true;
        }
        else{
            return false;
        }
    }
    
    @AuraEnabled
    public static Boolean OppStageTest(string lId){
        List<Opportunity__c> opStageList=[select id,Name from Opportunity__c where Lead__c=:lId and Opportunity_Stage__c='Converted' ];
        if(opStageList.size()>0){
            return true;
        }
        else{
            return false;
        }
    }
    
    @AuraEnabled
    public static string  LeadCnvrt( string ldId, string fName){
        Lead__c lds=[select id,Farmer_First_Name__c,Stages__c,Mobile_Number__c,Lead_Source__c,Address__c,Alternate_Mobile_No__c,Dealer__c,Tehsil__c from Lead__c where id =:ldId];
        List<Opportunity__c> opList=[select id,Name from Opportunity__c where Lead__c=:ldId and Opportunity_Stage__c='Converted' ];
        List<Account> acnt=[select id,Phone from Account where Phone=:lds.Mobile_Number__c];
        system.debug('Acc Phn::'+acnt);
        system.debug('oppList::'+opList);
        List<Opportunity__c> getopplist=LeadConvertClass.getrelatedopp(ldId);
        System.debug('related opportunity:::'+getopplist);
        String Statusofcheck;        
        /*  if(acnt.size()>0 && acnt!=null){
System.debug('inside duplicate:::');
Statusofcheck='duplicate';
System.debug('Statusofcheck::::'+Statusofcheck);
return Statusofcheck;
}
else{*/
        List<Account> acclist=new List<Account>();
        if(opList.size()>0 && opList!=null){
            System.debug('inside if oppo:::');
            Account acc=new Account();
            /*if(mName!=null){
                acc.name=fName+' '+mName+' '+lName;
            }else{
                acc.name=fName+' '+lName;
            }*/
            acc.Name=fName;
            //acc.Farmer_Middle_Name__c=mName;
            acc.Phone=lds.Mobile_Number__c;
            acc.Alternate_Mobile_No__c=lds.Alternate_Mobile_No__c;
            //acc.Dealer__c=lds.Dealer__c;
            acc.Tehsil__c=lds.Tehsil__c;
            acc.Lead_Source__c=lds.Lead_Source__c;
            acc.Address__c=lds.Address__c;
            acclist.add(acc);
        }       
        if(acclist.size()>0 && acclist!=null){
            System.debug('inside acclist::::::'+acclist);
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            Database.SaveResult[] saveResultList = Database.insert(acclist, dml);
            
            // Iterate through saveResultList based on isSuccess capture the failed records
            for (Database.SaveResult sr : saveResultList) {
                if (sr.isSuccess()==true) {
                    lds.IsConverted__c=true;
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + acclist[0].Id);
                    lds.Stages__c='Converted';
                    update lds;
                    List<Opportunity__c> listupdateopp=new List<Opportunity__c>();
                    if(getopplist.size()>0 && getopplist!=null){
                        for(Opportunity__c opp:getopplist){
                            opp.Customer__c=sr.getId();
                            listupdateopp.add(opp);
                        }
                        System.debug('final update opplist:::::'+listupdateopp);
                        if(listupdateopp.size()>0 && listupdateopp!=null){
                            update listupdateopp;
                        }
                    }
                    //Statusofcheck=sr.getId();
                    /********modified:21-10-20 start********/   
                    if(acnt.size()>0 && acnt!=null){
                        Statusofcheck=sr.getId()+'duplicate';
                        system.debug('AccId with Duplicate:::'+Statusofcheck);
                    }
                    else{
                        Statusofcheck=sr.getId();
                        system.debug('Only acc Id:::'+Statusofcheck);
                    }
                    /********modified:21-10-20 end********/        
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                        Statusofcheck='error';
                    }
                }
            }
        }
        
        return Statusofcheck; 
        //}    
    }
    
    @AuraEnabled
    public static List<Opportunity__c>  getrelatedopp( string leadId){
        System.debug('lead id:::'+leadId);
        List<Opportunity__c> opplist=[select id,Lead__c from opportunity__c where Lead__c =:leadId];
        if(opplist.size()>0 && opplist!=null){
            return opplist;
        }
        else{
            return null;
        }
        
    }
}