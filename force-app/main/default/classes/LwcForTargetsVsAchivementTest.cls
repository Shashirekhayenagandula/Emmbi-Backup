@isTest
public class LwcForTargetsVsAchivementTest {
   /*     
    @isTest
    public static void completedTargetList() {
          User newUser = TestSetupMethod.createUser();
         database.insert(newUser);
         
         Distributor__c dis= TestSetupMethod.createDistributor();
         database.insert(dis);
         
         Dealer__c dea= TestSetupMethod.createDealer(newUser.Id,dis.Id);
      	 dea.Three_Month_Achievement__c = 2500;
         database.insert(dea);
        
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getFirstStageTargetList();
        
        Test.stopTest();	
    
    }
     @isTest
    public static void completedTargetList1() {
          User newUser = TestSetupMethod.createUser();
         database.insert(newUser);
         
         Distributor__c dis= TestSetupMethod.createDistributor();
         database.insert(dis);
         
         Dealer__c dea= TestSetupMethod.createDealer(newUser.Id,dis.Id);
      	 dea.Three_Month_Achievement__c = 45500;
         database.insert(dea);
        
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getSecondStageTargetList();
        
        Test.stopTest();	
    
    }
    @isTest
    public static void completedTargetList2() {
          User newUser = TestSetupMethod.createUser();
         database.insert(newUser);
         
         Distributor__c dis= TestSetupMethod.createDistributor();
         database.insert(dis);
         
         Dealer__c dea= TestSetupMethod.createDealer(newUser.Id,dis.Id);
      	 dea.Three_Month_Achievement__c = 45500;
         database.insert(dea);
         
         Dealer__c deaF= TestSetupMethod.createDealer(newUser.Id,dis.Id);
      	 deaF.Three_Month_Achievement__c = 25500;
         database.insert(deaF);	
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getThirdStageTargetList();
        
        Test.stopTest();	
    
    }
    @isTest
    public static void completedTargetList9() {
          User newUser = TestSetupMethod.createUser();
         database.insert(newUser);
         
         Distributor__c dis= TestSetupMethod.createDistributor();
         database.insert(dis);
         
         Dealer__c dea= TestSetupMethod.createDealer(newUser.Id,dis.Id);
      	 dea.Three_Month_Achievement__c = 45500;
         database.insert(dea);
         
         Dealer__c deaF= TestSetupMethod.createDealer(newUser.Id,dis.Id);
      	 deaF.Three_Month_Achievement__c = 25500;
         database.insert(deaF);	
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getFourStageTargetList();
        
        Test.stopTest();	
    
    }
    @isTest
    public static void completedTargetList10() {
          User newUser = TestSetupMethod.createUser();
         database.insert(newUser);
         
         Distributor__c dis= TestSetupMethod.createDistributor();
         database.insert(dis);
         
         Dealer__c dea= TestSetupMethod.createDealer(newUser.Id,dis.Id);
      	 dea.Three_Month_Achievement__c = 45500;
         database.insert(dea);
         
         Dealer__c deaF= TestSetupMethod.createDealer(newUser.Id,dis.Id);
      	 deaF.Three_Month_Achievement__c = 25500;
         database.insert(deaF);	
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getAllTargetList();
        
        Test.stopTest();	
    
    }
    @isTest
    public static void completedTargetList3() {
          User newUser = TestSetupMethod.createUser();
         newUser.Three_Month_Achievement__c= 200000;
         database.insert(newUser);
         
        
        
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getFirstStageEmpTargetList();
        
        Test.stopTest();	
    
    } 
    @isTest
    public static void completedTargetList4() {
          User newUser = TestSetupMethod.createUser();
         newUser.Three_Month_Achievement__c= 200000;
         database.insert(newUser);
         
        
        
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getSecondStageEmpTargetList();
        
        Test.stopTest();	
    
    }
    @isTest
    public static void completedTargetList7() {
          User newUser = TestSetupMethod.createUser();
         newUser.Three_Month_Achievement__c= 200000;
         database.insert(newUser);
         
        
        
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getThirdStageEmpTargetList();
        
        Test.stopTest();	
    
    }
    @isTest
    public static void completedTargetList8() {
          User newUser = TestSetupMethod.createUser();
         newUser.Three_Month_Achievement__c= 200000;
         database.insert(newUser);
         
        
        
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getForthStageEmpTargetList();
        
        Test.stopTest();	
    
    }
    @isTest
    public static void completedTargetList5() {
          User newUser = TestSetupMethod.createUser();
         newUser.Three_Month_Achievement__c= 100000;
         database.insert(newUser);
         
        
        
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getAllTargetEmpTargetList();
        
        Test.stopTest();	
    
    }
    */
    
   @isTest
    public static void completedTargetList() {
         District__c di =TestSetupMethod.createDistrict();
         database.insert(di);
        
         Tehsil__c teh = TestSetupMethod.createTehsils(di.Id);
         database.insert(teh);
         
         Distributor__c dis= TestSetupMethod.createDistributor();
         database.insert(dis);
        
         Employee__c emp =TestSetupMethod.createEmployee();
         database.insert(emp);
        
         Dealer__c dea= TestSetupMethod.createDealerWithoutUser(dis.Id);
      	 dea.Employee_Names__c=emp.Id;
         dea.Last_Three_Month_Target__c =2500;
         database.insert(dea);
        
         Dealer_with_Tehsil__c deteh= TestSetupMethod.createDealerWithTehsils(teh.Id,dea.Id);
         database.insert(deteh);
        
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getFirstStageTargetList();
        LwcForTargetsVsAchivement.getSecondStageTargetList();
        LwcForTargetsVsAchivement.getThirdStageTargetList();
        LwcForTargetsVsAchivement.getFourStageTargetList();
        LwcForTargetsVsAchivement.getAllTargetList();
        LwcForTargetsVsAchivement.getMonthFirstStageTargetList();
        LwcForTargetsVsAchivement.getMonthSecondStageTargetList();
        LwcForTargetsVsAchivement.getMonthThirdStageTargetList();
        LwcForTargetsVsAchivement.getMonthFourStageTargetList();
        LwcForTargetsVsAchivement.getMonthAllTargetList();
        
        Test.stopTest();	
    
    }   
    
    @isTest
    public static void empCompletedTargetList() {
                
         Employee__c emp =TestSetupMethod.createEmployee();
         emp.Previous_Month_Target__c=1500;
         emp.Last_Three_Month_Target__c=1500;
         emp.Employee_Monthly_Target__c=3000;
         database.insert(emp);
      
         Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        LwcForTargetsVsAchivement.getFirstStageEmpTargetList();
        LwcForTargetsVsAchivement.getSecondStageEmpTargetList();
        LwcForTargetsVsAchivement.getThirdStageEmpTargetList();
        LwcForTargetsVsAchivement.getForthStageEmpTargetList();
        LwcForTargetsVsAchivement.getAllTargetEmpTargetList();
        LwcForTargetsVsAchivement.getMonthFirstStageEmpTargetList();
        LwcForTargetsVsAchivement.getMonthSecondStageEmpTargetList();
        LwcForTargetsVsAchivement.getMonthThirdStageEmpTargetList();
        LwcForTargetsVsAchivement.getMonthForthStageEmpTargetList();
        LwcForTargetsVsAchivement.getMonthAllTargetEmpTargetList();
        
        Test.stopTest();	
    
    }  
    
}