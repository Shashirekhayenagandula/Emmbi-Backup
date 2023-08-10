@isTest(seeAllData=false)
public Class UpdateDealerAchievementTest {

  static testMethod void test1()
  {
             
      Test.startTest();
    
   UpdateDealerAcheivementHandler.CCHelp();
   
                                
      test.stopTest();
  }
    
    @isTest
     public static void UpdateDealerAcheivTest() {
         User newUser = TestSetupMethod.createUser();
         database.insert(newUser);
         
         Distributor__c dis= TestSetupMethod.createDistributor();
         database.insert(dis);
         
         Dealer__c dea= TestSetupMethod.createDealer(newUser.Id,dis.Id);
         database.insert(dea);
         
         Product__c p= TestSetupMethod.createProduct();
         database.insert(p);
         
         Lead__c l =TestSetupMethod.createFarmer();
         database.insert(l);
         
         Opportunity__c Pi= TestSetupMethod.createProductInformation(dea.Id,p.Id,l.Id);
         database.insert(Pi);
         
         delete Pi;
         
        
        }
  

}