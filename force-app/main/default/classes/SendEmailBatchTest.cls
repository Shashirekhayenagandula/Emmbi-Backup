@isTest
private class SendEmailBatchTest {
	 @isTest static void testSendEmailBatch() {
       Test.startTest();
         List<Employee__c> emp = new List<Employee__c>();
        for (Integer i = 0; i < 20; i++) {
            emp.add(new Employee__c(Name = 'Test'+ i, Mobile_Number__c = '7744839497', Employee_Email__c = 'test' + i + '@example.com',Active__c=True,
                                  Employee_Monthly_Target__c = 1500,Employee_Monthly_Achievement__c =1000));
            
            
        }
        insert emp;
        
		String cronExpression = '0 0 0 20 5 ? 2023'; // Runs on March 15, 2023 at midnight
        String jobId = System.schedule('MyEmailBatchJobs', cronExpression, new SendEmailScheduler());

        List<CronTrigger> triggers = [SELECT Id, CronExpression, CronJobDetail.Name, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(1, triggers.size());
        CronTrigger trigg = triggers[0];
        System.assertEquals(cronExpression, trigg.CronExpression);

        Test.stopTest();  
         
         
         
         
         
         // Insert test records
      /*	Test.startTest();
        List<Dealer__c> dealer = new List<Dealer__c>();
        User newUser = TestSetupMethod.createUser();
        database.insert(newUser);
         
        Distributor__c dis= TestSetupMethod.createDistributor();
        database.insert(dis);
        
        for (Integer i = 0; i < 200; i++) {
            dealer.add(new Dealer__c(Name = 'Test'+ i, Dealer_Mobile__c = '7744839497', Dealer_Email__c = 'test' + i + '@example.com',
                                   Distributor__c = dis.Id,Dealer_Address__c='ddddd',
                                  Active__c = true,Employee_Name__c = newUser.Id ,
                                  Monthly_Target__c = 1500,Weekly_Target__c =1000));
            
            
        }
        insert dealer;
        
		String cronExpression = '0 0 0 16 5 ? 2023'; // Runs on March 15, 2023 at midnight
        String jobId = System.schedule('MyEmailBatchJob', cronExpression, new SendEmailScheduler());

        List<CronTrigger> triggers = [SELECT Id, CronExpression, CronJobDetail.Name, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(1, triggers.size());
        CronTrigger trigg = triggers[0];
        System.assertEquals(cronExpression, trigg.CronExpression);

        Test.stopTest(); 
        
         
       List<Messaging.SingleEmailMessage> sentEmails = [SELECT Id, ToAddress, Subject, HtmlBody FROM Messaging.SingleEmailMessage WHERE ToAddress IN :dealer];
        System.assertEquals(200, sentEmails.size());
        for (Messaging.SingleEmailMessage email : sentEmails) {
            System.assertEquals('Test Email Subject', email.Subject);
            System.assertEquals('Test Email Body', email.HtmlBody);
        }
        
         */
    }
   
    

}