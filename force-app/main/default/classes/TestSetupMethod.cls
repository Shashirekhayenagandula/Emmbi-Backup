@isTest
public class TestSetupMethod {
    @isTest
    public static User createUser() {
    
        User u = new User();
        u.FirstName = 'John';
        u.LastName = 'Doe';
        u.Email = 'john.doe@example.com';
        u.Username = 'john.doedfbfb@example.com';
        u.ProfileId = '00e2w000001MpKL';
        u.EmailEncodingKey= 'ISO-8859-1';
        u.LanguageLocaleKey= 'en_US';
        u.LocaleSidKey= 'en_US';
        u.TimeZoneSidKey= 'America/Los_Angeles';
        u.Alias = 'jodfe';
        return u;
    
    }
    @isTest
     public static Distributor__c createDistributor() {
    
        Distributor__c d = new Distributor__c();
            d.Name = 'Test Akash';
            d.Distributor_Contact_Person__c ='Akash';
            d.Distributor_Mobile__c ='0000000000';
            d.Credit_Limit__c = 25000;
            d.Active__c =True;
     		
         return d;
    
    }
    
     public static Dealer__c createDealer(Id userId,Id distributorId) {
         
        Dealer__c deal = new Dealer__c();
            deal.Name = 'Test Child 1';
            deal.Dealer_Mobile__c = '0000000000'; 
            deal.Distributor__c = distributorId;
            deal.Dealer_Address__c ='ddddd';
            deal.Active__c =true;
            deal.Employee_Names__c =userId;
            deal.Monthly_Target__c = 15000;
            deal.Weekly_Target__c = 3000;
         return deal;
    }
    public static Dealer__c createDealerWithoutUser(Id distributorId) {
         
        Dealer__c deal = new Dealer__c();
            deal.Name = 'Test Child 1';
            deal.Dealer_Mobile__c = '0000000000'; 
            deal.Distributor__c = distributorId;
            deal.Dealer_Address__c ='ddddd';
            deal.Active__c =true;
            deal.Monthly_Target__c = 15000;
            deal.Weekly_Target__c = 3000;
         return deal;
    }
    
     public static Employee__c createEmployee() {
         
       Employee__c emp = new Employee__c();
        
            emp.Name = 'Test';
            emp.Mobile_Number__c = '7744839497';
            emp.Employee_Email__c = 'test@example.com';
            emp.Employee_Monthly_Target__c = 1500;
      		emp.Employee_Monthly_Achievement__c =1000;
            
          return emp;
    }
    
    
    
    @isTest
     public static Lead__c createFarmer() {
    
        Lead__c l = new Lead__c();	
        l.Farmer_First_Name__c = 'Akash Chavan';
        l.Mobile_Number__c = '9111000000';
        l.Pond_Digging_Done__c = 'Yes';
        l.Tehsil__c = 'a082w000009l4t9AAA';
        l.Products_Interested__c = 'Jalasanchay';
        return l;
    
    }
    
    @isTest
     public static District__c createDistrict() {
    
        District__c l = new District__c();	
        l.Name = 'Sindhudurg';
        l.State__c = 'Maharashtra';
        
        return l;

    }
    
    
     public static Tehsil__c createTehsils(Id disId) {
    
        Tehsil__c l = new Tehsil__c();	
        l.District__c = disId;
        l.Name = 'Devgad';
        
        return l;

    }
    
    @isTest
     public static Product__c createProduct() {
    
        Product__c p = new Product__c();	
        p.Name = 'Jalasanchay-Type2-2x4m';
        p.Product_Name__c = 'Jalasanchay';
        p.Product_Group__c = 'Pond Liner';
        p.Unit_of_Sale__c = 'Sq M';
        p.Product_For__c= 'Avana Products'; 
       
        return p;
    
    }
    
    
    
     public static Opportunity__c createProductInformation(Id DealerId,Id ProductId,Id FarmerId) {
    
        Opportunity__c o = new Opportunity__c();
        RecordType logRecordTypeId = [select developerName from RecordType WHERE DeveloperName = 'Jalasanchay'];               
        o.RecordtypeId = logRecordTypeId.Id;
        o.Opportunity_Stage__c = 'Interested';
        o.Jalasanchay_Product_Type__c = 'Jalasanchay';
        o.Dealer__c = DealerId;
        o.Invoice_Date__c = Date.today()-31;
        o.Product__c= ProductId;
        o.Lead__c =FarmerId;
        
        o.Pondliner_Size_Requested_Required_Sq_Mt__c = 250;
        return o;
    
    }
    
      public static List<Dealer_with_Tehsil__c> createListDealerWithTehsil(Id tehsilId,Id dealerId) {
        List<Dealer_with_Tehsil__c> AccountList = new List<Dealer_with_Tehsil__c>();
        for(integer i = 0; i<10 ; i++) {
            Dealer_with_Tehsil__c dwt = new Dealer_with_Tehsil__c();
            dwt.Tehsil_Name__c =tehsilId;
            dwt.Dealer__c = dealerId;
           
         }
        return AccountList;
    }
    
    public static Dealer_with_Tehsil__c createDealerWithTehsils(Id tehsilId,Id dealerId) {
    
        Dealer_with_Tehsil__c l = new Dealer_with_Tehsil__c();	
        l.Tehsil_Name__c = tehsilId;
        l.Dealer__c = dealerId;
        l.This_Month_Achievement__c=1000;
        l.Previous_Month_Achievement__c=1500;
        l.Last_Three_Month_Achievement__c=2000;
        
        return l;

    }
    
    public static List<Dealer__c> createListDealer(Id distributorId,Id EmpId) {
        List<Dealer__c> dealerList = new List<Dealer__c>();
        for(integer i = 0; i<10 ; i++) {
            Dealer__c deal = new Dealer__c();
            deal.Name = 'Test Child 1';
            deal.Dealer_Mobile__c = '0000000000'; 
            deal.Distributor__c = distributorId;
            deal.Dealer_Address__c ='ddddd';
            deal.Active__c =true;
            deal.Employee_Names__c=EmpId;
            
           dealerList.add(deal);
         }
        return dealerList;
    }
    
    public static List<Employee__c> createListEmployee() {
         
      
            List<Employee__c> EmpList = new List<Employee__c>();
        for(integer i = 0; i<10 ; i++) {
            Employee__c emp = new Employee__c();
            emp.Name = 'Test';
            emp.Mobile_Number__c = '7744839497';
            emp.Employee_Email__c = 'test@example.com';
            emp.Employee_Monthly_Target__c = 1500;
      		emp.Employee_Monthly_Achievement__c =1000;
            
            EmpList.add(emp);
          
         }
        return EmpList;
    
    }
    

}