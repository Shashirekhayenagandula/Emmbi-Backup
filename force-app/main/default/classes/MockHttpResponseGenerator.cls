@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('http://websms.one97.net/sendsms/sms_request.php?username=EmmbiIndust&password=embi123inds&smsfrom=TestAM&content=s&receiver={9876594421}&msg_type=4', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        //res.setHeader('Content-Type', 'application/json');
        res.setBody('<Response><Success><Code>AVANA-200504171918-MzA2MTA=</Code><Message> Request sent successfully</Message></Success></Response>');
        res.setStatusCode(200);
        return res;
    } 
}