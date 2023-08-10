global class SendWhatsappToEmp implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful  {
    
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id,Name, Mobile_Number__c,Balance__c,Employee_Monthly_Target__c,Active__c,Employee_Monthly_Achievement__c from Employee__c Where Active__c = true AND Mobile_Number__c != null]);
    } 
    
    global void execute(Database.BatchableContext BC,List<Employee__c> emp){
		List<HttpRequest> requests = new List<HttpRequest>();

       for(Employee__c c: emp){
            
            	String a = String.valueOf(c.Employee_Monthly_Target__c);
           		String b = String.valueOf(c.Employee_Monthly_Achievement__c);
           		String d = String.valueOf(c.Balance__c);

				Map<String, Object> requestBody = new Map<String, Object>{
				'apiKey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzNDUxZjBlMWUxNTFiMzJlZTEwMDdhNiIsIm5hbWUiOiJFbW1iaSBJbmR1c3RyaWVzIEx0ZCIsImFwcE5hbWUiOiJBaVNlbnN5IiwiY2xpZW50SWQiOiI2MzQ1MWYwZTFlMTUxYjMyZWUxMDA3YTUiLCJhY3RpdmVQbGFuIjoiQkFTSUNfVFJJQUwiLCJpYXQiOjE2NjU0NzQzMTh9.h4mVDuzXmzOz7e36Lz4OwasGB7iq7vFSR79tTL2-BZw',
				'campaignName' => 'Message For Dealer And Emp',
				'destination' => '+91'+c.Mobile_Number__c,
				'userName' => c.Name,
			    'templateParams' => new List<Object>{c.Name,a,b,d}
				};
				HttpRequest request = new HttpRequest();
                request.setMethod('POST');
               
                request.setEndpoint('https://backend.aisensy.com/campaign/t1/api'); 
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Connection', 'keep-alive');

				String requestBodyJson = JSON.serialize(requestBody);				
				system.debug(requestBodyJson);
				request.setBody(requestBodyJson); 
           		request.setTimeOut(20000);
           
           		requests.add(request);
				               
               
        }

		 List<HttpResponse> responses = new List<HttpResponse>();
        Http http = new Http();
        for (HttpRequest request : requests) {
            responses.add(http.send(request));
        }

		for (HttpResponse response : responses) {
            if (response.getStatusCode() == 200) {
                System.debug('WhatsApp message sent successfully.');
            } else {
                System.debug('WhatsApp message failed. Response: ' + response.getBody());
            }
        }		 
               
        
    }
    
    global void finish(Database.BatchableContext BC){
        
        System.debug('Task Done !!!');
        
    }
   
}