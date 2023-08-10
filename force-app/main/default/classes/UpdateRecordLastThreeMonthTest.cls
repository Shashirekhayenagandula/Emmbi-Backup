@isTest
public class UpdateRecordLastThreeMonthTest {
@isTest
    public static void UpdateLastThreeMonthTest(){
        
        Test.startTest();
        User newUser = TestSetupMethod.createUser();
         database.insert(newUser);
         
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
         
         Product__c p= TestSetupMethod.createProduct();
         database.insert(p);
         
         Lead__c l =TestSetupMethod.createFarmer();
         database.insert(l);
        
         District__c dist= TestSetupMethod.createDistrict();
         database.insert(dist);

         Tehsil__c teh= TestSetupMethod.createTehsils(dist.Id);
         database.insert(teh);
        
         Dealer_with_Tehsil__c dwt =new Dealer_with_Tehsil__c();
     	 dwt.Tehsil_Name__c =teh.Id;
         dwt.Dealer__c = dea.Id;
		 database.insert(dwt);
         
         Opportunity__c Pi= TestSetupMethod.createProductInformation(dea.Id,p.Id,l.Id);
         database.insert(Pi);
         Pi.Dealer_with_Tehsil__c = dwt.Id;
         update Pi;
         
         String cronExpression = '0 0 0 14 6 ? 2023'; // Runs on March 15, 2023 at midnight
        String jobId = System.schedule('MyResetBatchJob', cronExpression, new UpdateRecordLastThreeMonth());

        List<CronTrigger> triggers = [SELECT Id, CronExpression, CronJobDetail.Name, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(1, triggers.size());
        CronTrigger trigg = triggers[0];
        System.assertEquals(cronExpression, trigg.CronExpression);
        
        Test.stopTest();
        
    }
    
}