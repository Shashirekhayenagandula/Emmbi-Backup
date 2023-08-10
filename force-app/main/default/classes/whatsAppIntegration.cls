public class whatsAppIntegration {
    
    @Future(Callout = true)
    public static void sendWtpMessage(Id recId){
        try{   
       Lead__c l = [Select Id, Farmer_First_Name__c,State__c,Mobile_Number__c from Lead__c where Id =: recId];
            if(l.Mobile_Number__c != null && l.State__c =='Maharashtra'){
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
               
                request.setEndpoint('https://backend.aisensy.com/campaign/t1/api'); 
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Connection', 'keep-alive');
				Map<String, Object> requestBody = new Map<String, Object>{
				'apiKey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzNDUxZjBlMWUxNTFiMzJlZTEwMDdhNiIsIm5hbWUiOiJFbW1iaSBJbmR1c3RyaWVzIEx0ZCIsImFwcE5hbWUiOiJBaVNlbnN5IiwiY2xpZW50SWQiOiI2MzQ1MWYwZTFlMTUxYjMyZWUxMDA3YTUiLCJhY3RpdmVQbGFuIjoiQkFTSUNfVFJJQUwiLCJpYXQiOjE2NjU0NzQzMTh9.h4mVDuzXmzOz7e36Lz4OwasGB7iq7vFSR79tTL2-BZw',
				'campaignName' => 'WhatsApp Message Marathi',
				'destination' => '+91'+l.Mobile_Number__c,
				'userName' => l.Farmer_First_Name__c
				// 'templateParams' => new List<Object>{l.Farmer_First_Name__c}
				};
				
				String requestBodyJson = JSON.serialize(requestBody);				
				system.debug(requestBodyJson);
				request.setBody(requestBodyJson);                
                request.setTimeOut(20000);
                Http http = new Http();
                HTTPResponse resp;
                resp = http.send(request); 
                system.debug(resp.getbody());
                
            }else if(l.Mobile_Number__c != null && (l.State__c =='Andhra Pradesh' ||
                                                   l.State__c =='Karnataka' ||
                                                   l.State__c =='Tamil Nadu' ||
                                                   l.State__c =='Telangana' ||
                                                   l.State__c =='Kerala')){
                
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
               
                request.setEndpoint('https://backend.aisensy.com/campaign/t1/api'); 
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Connection', 'keep-alive');
				Map<String, Object> requestBody = new Map<String, Object>{
				'apiKey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzNDUxZjBlMWUxNTFiMzJlZTEwMDdhNiIsIm5hbWUiOiJFbW1iaSBJbmR1c3RyaWVzIEx0ZCIsImFwcE5hbWUiOiJBaVNlbnN5IiwiY2xpZW50SWQiOiI2MzQ1MWYwZTFlMTUxYjMyZWUxMDA3YTUiLCJhY3RpdmVQbGFuIjoiQkFTSUNfVFJJQUwiLCJpYXQiOjE2NjU0NzQzMTh9.h4mVDuzXmzOz7e36Lz4OwasGB7iq7vFSR79tTL2-BZw',
				'campaignName' => 'WhatsApp Message English',
				'destination' => '+91'+l.Mobile_Number__c,
				'userName' => l.Farmer_First_Name__c
				// 'templateParams' => new List<Object>{l.Farmer_First_Name__c}
				};
				
				String requestBodyJson = JSON.serialize(requestBody);				
				system.debug(requestBodyJson);
				request.setBody(requestBodyJson);                
                request.setTimeOut(20000);
                Http http = new Http();
                HTTPResponse resp;
                resp = http.send(request); 
                system.debug(resp.getbody());
                
            }else if(l.Mobile_Number__c != null){
                
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
               
                request.setEndpoint('https://backend.aisensy.com/campaign/t1/api'); 
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Connection', 'keep-alive');
				Map<String, Object> requestBody = new Map<String, Object>{
				'apiKey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzNDUxZjBlMWUxNTFiMzJlZTEwMDdhNiIsIm5hbWUiOiJFbW1iaSBJbmR1c3RyaWVzIEx0ZCIsImFwcE5hbWUiOiJBaVNlbnN5IiwiY2xpZW50SWQiOiI2MzQ1MWYwZTFlMTUxYjMyZWUxMDA3YTUiLCJhY3RpdmVQbGFuIjoiQkFTSUNfVFJJQUwiLCJpYXQiOjE2NjU0NzQzMTh9.h4mVDuzXmzOz7e36Lz4OwasGB7iq7vFSR79tTL2-BZw',
				'campaignName' => 'WhatsApp Message HIndi',
				'destination' => '+91'+l.Mobile_Number__c,
				'userName' => l.Farmer_First_Name__c
				// 'templateParams' => new List<Object>{l.Farmer_First_Name__c}
				};
				
				String requestBodyJson = JSON.serialize(requestBody);				
				system.debug(requestBodyJson);
				request.setBody(requestBodyJson);                
                request.setTimeOut(20000);
                Http http = new Http();
                HTTPResponse resp;
                resp = http.send(request); 
                system.debug(resp.getbody());
                
            }
            
            
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    }

}