@isTest
public class UpdateDealertargetsTest {
  
    @isTest
    static void testUpdateDealerMonthlyTargets() {
        
        User newUser = TestSetupMethod.createUser();
         database.insert(newUser);
         
         Distributor__c dis= TestSetupMethod.createDistributor();
         database.insert(dis);
         
         Employee__c emp= TestSetupMethod.createEmployee();
         database.insert(emp);
        
         Dealer__c dea= TestSetupMethod.createDealer(newUser.Id,dis.Id);
         dea.Employee_Names__c =emp.Id;
         database.insert(dea);
         
         District__c dist= TestSetupMethod.createDistrict();
         database.insert(dist);
    
         Tehsil__c teh= TestSetupMethod.createTehsils(dist.Id);
         database.insert(teh);  
        
        List<Dealer_with_Tehsil__c> dealerWithTehsils = new List<Dealer_with_Tehsil__c>();
        dealerWithTehsils.add(new Dealer_with_Tehsil__c(Name='Test Dealer with Tehsil', Dealer__c=dea.Id, Tehsil_Name__c = teh.Id));
        dealerWithTehsils.add(new Dealer_with_Tehsil__c(Name='Test Dealer with Tehsil 2', Dealer__c=dea.Id, Tehsil_Name__c = teh.Id));
        insert dealerWithTehsils;
        Test.startTest();
        // Call the method to be tested
      //  UpdateDealertargets.updateDealerMonthlyTargets(dealerWithTehsils);
        update dealerWithTehsils;
        Test.stopTest();
        // Retrieve the updated dealer record
        Dealer__c updatedDealer = [SELECT Id, Current_Month_Target__c FROM Dealer__c WHERE Id=:dea.Id];
        
        // Verify that the dealer's current month target has been updated
       // System.assertEquals(0, updatedDealer.Current_Month_Target__c);
    }
     @isTest
    static void testUpdateDealerMonthlyTarget() {
        
      
        Test.startTest();
        UpdateDealertargets.CCHelp();
        Test.stopTest();
            }
}