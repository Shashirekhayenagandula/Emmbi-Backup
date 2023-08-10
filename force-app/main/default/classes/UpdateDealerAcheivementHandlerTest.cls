@isTest
public class UpdateDealerAcheivementHandlerTest {
  /* 
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
         
           
        Dealer__c parent = [SELECT Id, Three_Month_Achievement__c,Weekly_Achievement__c,This_Month_Achievement__c FROM Dealer__c WHERE Id = :dea.Id];
         System.assertEquals(0, parent.Three_Month_Achievement__c);
       //  System.assertEquals(0, parent.Weekly_Achievement__c);
          System.assertEquals(0, parent.This_Month_Achievement__c);
        Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 4850;
       // Pi.Invoice_Date__c =null; 
        update Pi;
         
        Dealer__c parent1 = [SELECT Id, Three_Month_Achievement__c FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(4850, parent1.Three_Month_Achievement__c); 
         
        Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 6890;
        update Pi;
         
        Dealer__c parent2 = [SELECT Id, Three_Month_Achievement__c FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(6890, parent2.Three_Month_Achievement__c);  
         
        Opportunity__c Py= TestSetupMethod.createProductInformation(dea.Id,p.Id,l.Id);
        database.insert(Py);  
         
        Dealer__c parent3 = [SELECT Id, Three_Month_Achievement__c FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(6890, parent3.Three_Month_Achievement__c);   
         
        Py.Pondliner_Size_Requested_Required_Sq_Mt__c = null;
        update Py;
        Dealer__c parent4 = [SELECT Id, Three_Month_Achievement__c FROM Dealer__c WHERE Id = :dea.Id];
        System.assertEquals(6890, parent4.Three_Month_Achievement__c); 
         
        
        }
    @isTest
     public static void UpdateDealerAcheivTest1() {
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
         
         Opportunity__c Pi1= TestSetupMethod.createProductInformation(dea.Id,p.Id,l.Id);
         database.insert(Pi1);
         
          Dealer__c parent = [SELECT Id, January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,May_Achievement__c,
			June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                              FROM Dealer__c WHERE Id = :dea.Id];
         System.assertEquals(0, parent.March_Achievement__c);
       //  System.assertEquals(0, parent.Weekly_Achievement__c);
          System.assertEquals(0, parent.January_Achievement__c);
        Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 4850;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 4, 25);
        update Pi;
         
        Dealer__c parent1 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(4850, parent1.April_Achievement__c); 
        
        Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 5, 25);
        update Pi; 
        
        Dealer__c parent2 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent2.May_Achievement__c); 
       
        
        Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 2, 25);
        update Pi; 
        
        Pi1.Pondliner_Size_Requested_Required_Sq_Mt__c = 4850;
       // Pi.Invoice_Date__c =null; 
       	Pi1.Invoice_Date__c = Date.newInstance(2023, 3, 25);
        update Pi1; 
         
        Dealer__c parent3 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent3.February_Achievement__c); 
         System.assertEquals(4850, parent3.March_Achievement__c);
         
         
         Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 1, 25);
        update Pi; 
        
        Dealer__c parent4 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent4.January_Achievement__c); 
         
         
         Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 3, 25);
        update Pi; 
        
        Dealer__c parent5 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent5.March_Achievement__c); 
         
         
         Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 6, 25);
        update Pi; 
        
        Dealer__c parent6 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent6.June_Achievement__c); 
         
         
         Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 7, 25);
        update Pi; 
        
        Dealer__c parent7 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent7.July_Achievement__c); 
         
         
         Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 8, 25);
        update Pi; 
        
        Dealer__c parent8 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent8.August_Achievement__c); 
         
         
         Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 9, 25);
        update Pi; 
        
        Dealer__c parent9 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent9.September_Achievement__c); 
         
         
         Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 10, 25);
        update Pi; 
        
        Dealer__c parent10 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent10.October_Achievement__c); 
         
         
         Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 11, 25);
        update Pi; 
        
        Dealer__c parent11 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent11.November_Achievement__c); 
         
         
         Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 450;
       // Pi.Invoice_Date__c =null; 
       	Pi.Invoice_Date__c = Date.newInstance(2023, 12, 25);
        update Pi; 
        
        Dealer__c parent12 = [SELECT Id,January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,
                             May_Achievement__c,June_Achievement__c,July_Achievement__c,August_Achievement__c,
                              September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c
                             FROM Dealer__c WHERE Id = :dea.Id]; 
        System.assertEquals(450, parent12.December_Achievement__c); 
         
         
      
         
     }
 
*/
    
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
         
         District__c dist= TestSetupMethod.createDistrict();
         database.insert(dist);
    
         Tehsil__c teh= TestSetupMethod.createTehsils(dist.Id);
         database.insert(teh);  
         
         Dealer_with_Tehsil__c dwt =new Dealer_with_Tehsil__c();
     	 dwt.Tehsil_Name__c =teh.Id;
         dwt.Dealer__c = dea.Id;
         database.insert(dwt);
         
           
        Dealer_with_Tehsil__c parent = [SELECT Id, This_Month_Achievement__c,Previous_Month_Achievement__c,Last_Three_Month_Achievement__c FROM Dealer_with_Tehsil__c WHERE Id = :dwt.Id];
         System.assertEquals(0, parent.This_Month_Achievement__c);
         System.assertEquals(0, parent.Previous_Month_Achievement__c);
         System.assertEquals(0, parent.Last_Three_Month_Achievement__c);
		
        Pi.Dealer_with_Tehsil__c = dwt.Id;
        Pi.Pondliner_Size_Requested_Required_Sq_Mt__c = 4850;
        update Pi;

        Dealer_with_Tehsil__c parent1 = [SELECT Id, This_Month_Achievement__c,Previous_Month_Achievement__c,Last_Three_Month_Achievement__c FROM Dealer_with_Tehsil__c WHERE Id = :dwt.Id]; 
        System.assertEquals(4850, parent1.Previous_Month_Achievement__c); 
        System.assertEquals(0, parent1.This_Month_Achievement__c);
        System.assertEquals(4850, parent1.Last_Three_Month_Achievement__c); 
        
       
        }  

}