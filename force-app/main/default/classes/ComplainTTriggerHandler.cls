public class ComplainTTriggerHandler extends TriggerHandler {
    public override void beforeUpdate(){
        System.debug('before update::::');
        Map<Id,String> mapofAccount=new Map<Id,String>();
        List<Complaint__c> complist=new List<Complaint__c>();
        Complaint__c compOld;
        Set<Id> setcmpId=new Set<Id>();
        for(Complaint__c compNew:(List<Complaint__c>)trigger.new){
            compOld=(Complaint__c)trigger.oldMap.get(compNew.Id);
            if(compNew.Stages__c!=compOld.Stages__c && compNew.Stages__c=='Closed without OTP'){
                setcmpId.add(compNew.Id);
            }
            
        }
        System.debug('set of complaintId::'+setcmpId);
        if(setcmpId.size()>0 && setcmpId!=null){
         complist=[select id,Enquiry__c,Enquiry__r.Lead__c,Enquiry__r.Lead__r.Mobile_Number__c from Complaint__c where id in:setcmpId];
        System.debug('complist::::'+complist);
        }
        if(complist!=null &&complist.size()>0){
            for(Complaint__c cc:complist){
                mapofAccount.put(cc.Enquiry__c,cc.Enquiry__r.Lead__r.Mobile_Number__c);
            }
        }
        System.debug('mapofAccount:::'+mapofAccount);
        
        for(Complaint__c compNew:(List<Complaint__c>)trigger.new){
            compOld=(Complaint__c)trigger.oldMap.get(compNew.Id);
            if(compNew.Stages__c!=compOld.Stages__c && compNew.Stages__c=='Closed without OTP'){
                 System.debug('Inside Close Without OTP:::'+compNew.Enquiry__c);
                 System.debug('mapofAccount.containsKey(compNew.Enquiry__r.Lead__c)::'+mapofAccount.containsKey(compNew.Enquiry__c));
                if(compNew.Enquiry__c!=null && mapofAccount.containsKey(compNew.Enquiry__c)){
                    System.debug('Inside class call method:::::');
                    OTPSend.sendOtp(mapofAccount.get(compNew.Enquiry__c),compNew.Id);                    
                }
                else{
                    compNew.addError('Please Update Lead in Product Informations in this complaint');
                }
                
            }
            
        }
   
    }

}