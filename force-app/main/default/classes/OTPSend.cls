public class OTPSend {
    @future (callout=true)
    public static void sendOtp(String phone,string objId){
        Avana_Api_details__mdt apiDetail = [select Username__c,Password__c,smsfrom__c,msg_type__c from Avana_Api_details__mdt where MasterLabel='AvanaOTP'];
        System.debug('apidetails of metadata:::'+apiDetail);
        Complaint__c cc=[select id,OTP_Language__c from Complaint__c where id=:objId limit 1];
        system.debug('otp language::::::'+cc.OTP_Language__c);
        String msgdetails=OTPLangugaeFetch.getlablelang(cc.OTP_Language__c);
        System.debug('fetched message:::::'+msgdetails);
        String otp = String.valueOf((Integer)Math.floor(Math.random()*1000000)); //generating 6 digit OTP
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String smsfrom = apiDetail.smsfrom__c;
        String username = apiDetail.username__c;
        String password = apiDetail.password__c;
        string msgtype = apiDetail.msg_type__c;
        String endpoint;
        if(Test.isRunningTest()){
            endpoint='http://websms.one97.net/sendsms/sms_request.php?username=EmmbiIndust&password=embi123inds&smsfrom=TestAM&content=नमस्कार%20ग्राहक,%20आपण%20समाधानी%20असल्यास%20कृपया%20आमच्या%20कार्यकारीला%20ओटीपी%20%20द्या,%20अन्यथा%20ओटीपी%20प्रदान%20करू%20नका%2078155&receiver=9876594421&msg_type=4';
        }else{
            System.debug('inisde else:::');
            endpoint='http://websms.one97.net/sendsms/sms_request.php?username='+username+'&password='+password+'&smsfrom='+smsfrom+'&content='+msgdetails.replaceAll(' ','%20')+'%20'+ otp+'&receiver='+phone+'&msg_type='+msgtype;
        }
        system.debug('endpoint details formation:::'+endpoint);
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        System.debug(endpoint);
        System.debug('the otp is '+otp);
        System.debug(res.getStatusCode());
        System.debug(res.getBody());
        
        if(res.getStatusCode()==200) {
            Integration_Detail__c msg = new Integration_Detail__c();
            msg.Name = otp;
            msg.Mobile_Phone__c = phone;
            msg.Response_Body__c = res.getBody();
            msg.Complaint__c=objId;
            insert msg;
        }
 
    
    }
}