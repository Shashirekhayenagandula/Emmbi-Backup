@isTest 
public class ScheduleSendWhatsAppDealerAndEmpTest {
    
    @isTest 
    static void testSendEmailBatch() {
       Test.startTest();
         List<Employee__c> emp = new List<Employee__c>();
        for (Integer i = 0; i < 30; i++) {
            emp.add(new Employee__c(Name = 'Test'+ i, Mobile_Number__c = '7744839497', Employee_Email__c = 'test' + i + '@example.com',
                                  Employee_Monthly_Target__c = 1500,Employee_Monthly_Achievement__c =1000));
            
            
        }
        insert emp;
        
		String cronExpression = '0 0 0 20 5 ? 2023'; // Runs on May 19, 2023 at midnight
        String jobId = System.schedule('MyEmailBatchJobs', cronExpression, new ScheduleSendWhatsappDealerAndEmp());

        List<CronTrigger> triggers = [SELECT Id, CronExpression, CronJobDetail.Name, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(1, triggers.size());
        CronTrigger trigg = triggers[0];
        System.assertEquals(cronExpression, trigg.CronExpression);

        Test.stopTest(); 
         
     }  
    @isTest
    static void testSendWhatsappToEmp() {
        // Create test data
        
        List<Employee__c> employees = new List<Employee__c>();
        for (Integer i = 0; i < 10; i++) {
            Employee__c emp = new Employee__c();
            emp.Name = 'Employee ' + i;
            emp.Mobile_Number__c = '123456789' + String.valueOf(i);
            emp.Active__c = true;
            employees.add(emp);
        }
        insert employees;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Start the batch
        Test.startTest();
        SendWhatsappToEmp batch = new SendWhatsappToEmp();
        Database.executeBatch(batch,10); // Use a smaller batch size for testing
        Test.stopTest();
        
        // Verify the results
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob];
        System.assertEquals(2, jobs.size(), 'One batch job should be created');
        
        // Perform additional assertions as needed
    }
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            // Create a mock response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"success": true}');
            response.setStatusCode(200);
            return response;
        }
    }

}