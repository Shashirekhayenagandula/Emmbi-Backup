public with sharing class ComplaintClose {
    public ComplaintClose() {
        
    }
    @AuraEnabled
    public static string CloseComplaint(String ObjId,String OTPNO){
        System.debug('complaint Id::::'+ObjId);
        System.debug('OTP no::::'+OTPNO);
        List<Complaint__c> fetchComp=[select id,stages__c,IsClosed__c from Complaint__c where id=:ObjId ];
        List<Complaint__c> cclist=new List<Complaint__c>();
        if(fetchComp[0].stages__c=='Closed without OTP'){
            
            Integration_Detail__c checkIt=[select Name,Mobile_Phone__c,Response_Body__c,Complaint__c from Integration_Detail__c where Complaint__c=:ObjId order by createddate desc limit 1];
            
            if(checkIt.Name==OTPNO && checkIt.Name!=null){
                for(Complaint__c cc:fetchComp){
                    cc.IsClosed__c=true;
                    cc.stages__c='Closed with OTP';
                    cclist.add(cc);
                }
            }
            
            if(cclist.size()>0 && cclist!=null){
                update cclist;
                return 'success';
            }
            else{
                return 'error';
            }
        }
        else{
            return 'genpwd';
        }
        
        
    }
}