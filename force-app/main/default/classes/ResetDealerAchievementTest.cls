@isTest
public class ResetDealerAchievementTest {

     @isTest
     public static void UpdateDealerAcheivTest() {
        
         
         Distributor__c dis= TestSetupMethod.createDistributor();
         database.insert(dis);
         
         Manager__c m =new Manager__c();
         m.Name ='Test Emmbi';
         database.insert(m);
         
         Cluster_Sales_Manager__c c =new Cluster_Sales_Manager__c();
         c.Name ='Test Emmbi';
         c.Manager__c = m.Id;
         database.insert(c);
         
         Employee__c emp= TestSetupMethod.createEmployee();
         emp.Cluster_Sales_Manager__c =c.Id;
         database.insert(emp); 
         
         Dealer__c dea= TestSetupMethod.createDealerWithoutUser(dis.Id);
         dea.Employee_Names__c = emp.Id;
         database.insert(dea);
         
         District__c dist= TestSetupMethod.createDistrict();
         database.insert(dist);
    
         Tehsil__c teh= TestSetupMethod.createTehsils(dist.Id);
         database.insert(teh);    
         
         List<Dealer_with_Tehsil__c> testRecords = new List<Dealer_with_Tehsil__c>();
        for (Integer i = 0; i < 100; i++) {
            testRecords.add(new Dealer_with_Tehsil__c(Name = 'Test Record ' + i, Previous_Month_Achievement__c = 100,
                                                     This_Month_Achievement__c = 50,Last_Three_Month_Achievement__c = 5000,
                                                     Dealer__c=dea.Id,Tehsil_Name__c =teh.Id));
        }
        insert testRecords;
         
       
       /* Test.startTest();
        ResetDealerAchievements batchJob = new ResetDealerAchievements();
        Database.executeBatch(batchJob, 10);*/
         
         String cronExpression = '0 0 0 14 6 ? 2023'; // Runs on March 15, 2023 at midnight
        String jobId = System.schedule('MyResetBatch', cronExpression, new ResetScheduleDealerAchievement());

        List<CronTrigger> triggers = [SELECT Id, CronExpression, CronJobDetail.Name, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(1, triggers.size());
        CronTrigger trigg = triggers[0];
        System.assertEquals(cronExpression, trigg.CronExpression);

       // Test.stopTest();  
        
         
         
     }
	
}