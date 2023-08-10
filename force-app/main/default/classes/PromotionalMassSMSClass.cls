public  class PromotionalMassSMSClass {
    
    @AuraEnabled
    public static List<Lead__c> LeadFetch(){
        List<Lead__c> LdList=new List<Lead__c>();
        LdList=[select id,Farmer_First_Name__c,Farmer_Last_Name__c,Name,Mobile_Number__c,IsConverted__c from Lead__c Where IsConverted__c=false order by lastmodifieddate];
        if(LdList.size()>0){
            return LdList;
        }
        else{
            return null;
        }
    }

    @AuraEnabled
    public static List<Account> CustomerFetch(){
        List<Account> AcList=new List<Account>();
        AcList=[select id,Farmer_First_Name__c,Name,Customer_No__c,Phone from Account order by lastmodifieddate ];
        if(AcList.size()>0){
            return AcList;
        }
        else{
            return null;
        }
    }

    @AuraEnabled
    public static List<Lead__c> SearchValLeadFetch(String sval){
        String keyVal= sval+'%';
        List<Lead__c> LdList=new List<Lead__c>();
        LdList=[select id,Farmer_First_Name__c,Farmer_Last_Name__c,Name,Mobile_Number__c,IsConverted__c from Lead__c Where Farmer_First_Name__c Like: keyVal AND IsConverted__c=false ];
        if(LdList.size()>0){
            return LdList;
        }
        else{
            return null;
        }
    }

    @AuraEnabled
    public static List<Account> SearchValCustomerFetch(String sval){
        String keyVal=sval+'%';
        List<Account> AcList=new List<Account>();
        AcList=[select id,Farmer_First_Name__c,Name,Customer_No__c,Phone from Account where Farmer_First_Name__c Like: keyVal];
        if(AcList.size()>0){
            return AcList;
        }
        else{
            return null;
        }
    }
    @AuraEnabled
    public static string bulkSMSsend(List<String> MobList,String Msg){
        System.debug('Moblist::::'+MobList);
        System.debug('Message Details::::'+Msg);
        Set<String> Phoneset=new Set<String>();
        if(MobList!=null && MobList.size()>0){
            for(String phn:MobList){
                Phoneset.add(phn);
            }
        }
        System.debug('final phone list:::'+Phoneset);
        if(Phoneset!=null && Msg!=null){
            String res= PromotionalMassSMSClass.msgsend(Phoneset, Msg);
            return res;
        }
        else{
         return 'error';
        }
    }

    public static String msgsend(Set<String> phonelist,String msg){
        Avana_Api_details__mdt apiDetail = [select Username__c,Password__c,smsfrom__c,msg_type__c from Avana_Api_details__mdt where MasterLabel='AvanaOTP'];
            System.debug('apidetails of metadata:::'+apiDetail);
            System.debug('msg before:::'+msg);
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            String smsfrom = apiDetail.smsfrom__c;
            String username = apiDetail.username__c;
            String password = apiDetail.password__c;
            string msgtype = apiDetail.msg_type__c;
            //String encodedmsg= EncodingUtil.urlEncode(msg, 'UTF-8').replaceAll('\\+','%20');
            String encodedmsg=msg.replaceAll(' ','%20');
            System.debug('encoded mesg:::::'+encodedmsg);
            String finalprephonelist=phonelist.toString();
            //String endpoint='https://web.insignsms.com/api/sendsms?username='+username+'&password='+password+'&senderid='+senderID+'&message='+encodedmsg+'&numbers='+finalprephonelist.replaceAll(' ','%20')+'&dndrefund='+1;
            String endpoint='http://websms.one97.net/sendsms/sms_request.php?username='+username+'&password='+password+'&smsfrom='+smsfrom+'&content='+encodedmsg+'&receiver='+finalprephonelist.replaceAll(' ','%20')+'&msg_type='+msgtype;
            system.debug('endpoint details formation:::'+endpoint);
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            HttpResponse res = http.send(req);
            System.debug(endpoint);
            System.debug(res.getStatusCode());
            System.debug(res.getBody());
            if(res.getStatusCode()==200){
                return 'success';
            }
            else {
                return 'failure';
            }
    }
}