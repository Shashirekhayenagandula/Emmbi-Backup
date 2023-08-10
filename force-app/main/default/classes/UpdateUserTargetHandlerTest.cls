@isTest
private class UpdateUserTargetHandlerTest {
  /*  @testSetup
    static void createTestData() {
        User u = new User(
        FirstName = 'John',
        LastName = 'Doe',
        Email = 'john.doe@example.com',
        Username = 'john.doe@example.com',
        ProfileId = '00e2w000001MpKL'
        );
        insert u;
        
        Distributor__c d = new Distributor__c(
            Name = 'Test Akash',
            Distributor_Contact_Person__c ='Akash',
            Distributor_Mobile__c ='0000000000',
            Credit_Limit__c = 25000,
            Active__c =True
        );
        
        insert d;

        
        Dealer__c child1 = new Dealer__c(
            Name = 'Test Child 1',
            Dealer_Mobile__c = '0000000000', 
            Distributor__c = d.Id,
            Dealer_Address__c ='ddddd',
            Active__c =true,
            Employee_Name__c =u.Id,
            Monthly_Target__c = 15000,
            Weekly_Target__c = 3000

            );
            
        Dealer__c child2 = new Dealer__c(
            Name = 'Test Child 2',
            Dealer_Mobile__c = '0000000000', 
            Distributor__c = d.Id,
            Dealer_Address__c ='ddddd',
            Active__c =true,
            Employee_Name__c =u.Id,
            Monthly_Target__c = 20000,
            Weekly_Target__c = 5000


            );    
        
       
        insert new List<Dealer__c>{child1, child2};
    }

    
     @isTest
    static void testTargetUpdate() {
        User u = new User(
        FirstName = 'John',
        LastName = 'Doe',
        Email = 'john.doe@example.com',
        Username = 'john0002.doe@example.com',
        ProfileId = '00e2w000001MpKL',
        EmailEncodingKey= 'ISO-8859-1',
        LanguageLocaleKey= 'en_US',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey= 'America/Los_Angeles',
        Alias = 'jodfe'    
        );
        
        insert u;
        
        // Ensure Total_Amount__c is initially 0
        System.assertEquals(null, u.Monthly_Target__c);
        System.assertEquals(null, u.Weekly_Target__c);
        
        Distributor__c d = new Distributor__c(
            Name = 'Test Akash',
            Distributor_Contact_Person__c ='Akash',
            Distributor_Mobile__c ='0000000000',
            Credit_Limit__c = 25000,
            Active__c =True
        );
        
        insert d;
        
        // Insert a new child record
        Dealer__c newChild = new Dealer__c(
            Name = 'Test Child 1',
            Dealer_Mobile__c = '0000000000', 
            Distributor__c = d.Id,
            Dealer_Address__c ='ddddd',
            Active__c =true,
            Employee_Name__c =u.Id,
            Monthly_Target__c = 15000,
            Weekly_Target__c = 3000

            );
            
        insert newChild;
        
        // Ensure Total_Amount__c is updated correctly
        User parent = [SELECT Id, Monthly_Target__c,Weekly_Target__c FROM User WHERE Id = :u.Id];
        System.assertEquals(15000, parent.Monthly_Target__c);
        System.assertEquals(3000, parent.Weekly_Target__c);
        
        // Update an existing child record
        Dealer__c existingChild = [SELECT Id, Monthly_Target__c,Weekly_Target__c  FROM Dealer__c WHERE Employee_Name__c = :u.Id LIMIT 1];
        existingChild.Monthly_Target__c = 20000;
        existingChild.Weekly_Target__c = 3500;
        
        update existingChild;
        
        // Ensure Total_Amount__c is updated correctly
        parent = [SELECT Id, Monthly_Target__c,Weekly_Target__c FROM User WHERE Id = :u.Id];
        System.assertEquals(20000, parent.Monthly_Target__c);
        System.assertEquals(3500, parent.Weekly_Target__c);
        
        // Delete a child record
      delete existingChild;
        
        // Ensure Total_Amount__c is updated correctly
       // parent = [SELECT Id, Monthly_Target__c,Weekly_Target__c FROM User WHERE Id = :u.Id];
        System.assertEquals(0, parent.Monthly_Target__c);
        System.assertEquals(0, parent.Weekly_Target__c);
    }

    
 static testMethod void test1()
  {
             
      Test.startTest();
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
         database.insert(dea);
      	 
        
         Dealer_with_Tehsil__c deteh= TestSetupMethod.createDealerWithTehsils(teh.Id,dea.Id);
         database.insert(deteh);
         
      	 
         dea.Last_Three_Month_Target__c =2500;
      	 update dea;
       
      
      // UpdateUserTargetHandler.CCHelp(); 
        
      test.stopTest();
  }*/
   @isTest
    public static void testTargetUpdate() {
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
         database.insert(dea);
      	 
        
        Test.startTest();
        dea.Employee_Names__c=emp.Id;
        database.update(dea);
        Test.stopTest();
        
        // Query the updated Employee__c records
        Employee__c e = [SELECT Id, Employee_Monthly_Target__c, Employee_Monthly_Achievement__c,
                                              Last_Three_Month_Achievement__c, Last_Three_Month_Target__c,
                                              Previous_Month_Achievement__c, Previous_Month_Target__c
                                              FROM Employee__c WHERE Id =: emp.Id];
        
        // Assert the expected values
        
            // Perform assertions for target and achievement fields
            System.assertEquals(1500, e.Employee_Monthly_Target__c);
            System.assertEquals(0, e.Previous_Month_Target__c);
            System.assertEquals(0, e.Last_Three_Month_Target__c);
            System.assertEquals(1000, e.Employee_Monthly_Achievement__c);
            System.assertEquals(0, e.Previous_Month_Achievement__c);
            System.assertEquals(0, e.Last_Three_Month_Achievement__c);
        
    }
    
     @isTest
    static void testUpdateDealerMonthlyTarget() {
        
      
        Test.startTest();
        UpdateUserTargetHandler.CCHelp();
        Test.stopTest();
            }
    
}