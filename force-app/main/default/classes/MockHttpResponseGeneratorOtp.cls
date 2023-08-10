@isTest
global class MockHttpResponseGeneratorOtp implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('http://websms.one97.net/sendsms/sms_request.php?username=EmmbiIndust&password=embi123inds&smsfrom=TestAM&content=नमस्कार%20ग्राहक,%20आपण%20समाधानी%20असल्यास%20कृपया%20आमच्या%20कार्यकारीला%20ओटीपी%20%20द्या,%20अन्यथा%20ओटीपी%20प्रदान%20करू%20नका%2078155&receiver=9876594421&msg_type=4', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        //res.setHeader('Content-Type', 'application/json');
        res.setBody('ACCEPTED,8939194440,2');
        res.setStatusCode(200);
        return res;
    } 
}