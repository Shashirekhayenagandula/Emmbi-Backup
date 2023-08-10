public class LwcForTargetsVsAchivement {
   
	/*
    @AuraEnabled
    public static List<Dealer__c> getNotCompletedTargetList(){
        List <Dealer__c> getNotCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetList = [Select Id,Name,Three_Month_Achievement__c,Three_Months_Target__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetList ){
            	
            if(dea.Three_Month_Achievement__c < dea.Three_Months_Target__c){
                getNotCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getNotCompletedTarget);
        return getNotCompletedTarget ;
        
    }
    
     @AuraEnabled
    public static List<Dealer__c> getCompletedTargetList(){
        
        List <Dealer__c> getCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetLists = [Select Id,Name,Three_Month_Achievement__c,Three_Months_Target__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetLists){
            	
            if(dea.Three_Month_Achievement__c >= dea.Three_Months_Target__c){
                getCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedTarget);
        return getCompletedTarget ;
    }
    
     @AuraEnabled
    public static List<Dealer__c> getAllTargetList(){
        
       List<Dealer__c> targetsList = [Select Id,Name,Three_Month_Achievement__c,Three_Months_Target__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        
        System.debug(targetsList);
        return targetsList ;
        
    }
    
	@AuraEnabled
    public static List<User> getNotCompletedEmpTargetList(){
        List <User> getNotCompletedEmpTarget=new List<User>();
       List<User> targetList = [Select Id,Name,Three_Month_Achievement__c,ProfileName__c,Three_Months_Target__c from User where IsActive !=false AND ProfileName__c = 'Sales Custom Profile'  order By Name Asc];
        for (User dea :targetList ){
            	
            if(dea.Three_Month_Achievement__c < dea.Three_Months_Target__c){
                getNotCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getNotCompletedEmpTarget);
        return getNotCompletedEmpTarget ;
        
    }
    
	@AuraEnabled
    public static List<User> getCompletedEmpTargetList(){
        List <User> getCompletedEmpTarget=new List<User>();
       List<User> targetList = [Select Id,Name,Three_Month_Achievement__c,ProfileName__c,Three_Months_Target__c from User where IsActive !=false AND ProfileName__c = 'Sales Custom Profile'  order By Name Asc];
        for (User dea :targetList ){
            	
            if(dea.Three_Month_Achievement__c >= dea.Three_Months_Target__c){
                getCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedEmpTarget);
        return getCompletedEmpTarget ;
        
    }
    
    @AuraEnabled
    public static List<User> getAllTargetEmpTargetList(){
       List <User> getAllTargetEmp=new List<User>();
       List<User> targetList = [Select Id,Name,Three_Month_Achievement__c,ProfileName__c,Three_Months_Target__c from User where IsActive !=false AND ProfileName__c = 'Sales Custom Profile'  order By Name Asc];
       
        System.debug(targetList);
        return targetList;
        
    }
  */ 
     @AuraEnabled
    public static List<Dealer__c> getFirstStageTargetList(){
        List <Dealer__c> getNotCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetList = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetList ){
            	
            if(dea.Quarterly_Percentage_Of_Achievement__c < 40){ 
                getNotCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getNotCompletedTarget);
        return getNotCompletedTarget ;
        
    }
    
     @AuraEnabled
    public static List<Dealer__c> getSecondStageTargetList(){
        
        List <Dealer__c> getCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetLists = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetLists){
            	
            if(dea.Quarterly_Percentage_Of_Achievement__c >= 40 && dea.Quarterly_Percentage_Of_Achievement__c < 60 ){
                getCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedTarget);
        return getCompletedTarget ;
    }
    
    @AuraEnabled
    public static List<Dealer__c> getThirdStageTargetList(){
        
        List <Dealer__c> getCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetLists = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetLists){
            	
            if(dea.Quarterly_Percentage_Of_Achievement__c >= 60 && dea.Quarterly_Percentage_Of_Achievement__c < 80 ){
                getCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedTarget);
        return getCompletedTarget ;
    }
    
    @AuraEnabled
    public static List<Dealer__c> getFourStageTargetList(){
        List <Dealer__c> getNotCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetList = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetList ){
            	
            if(dea.Quarterly_Percentage_Of_Achievement__c >= 80){ 
                getNotCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getNotCompletedTarget);
        return getNotCompletedTarget ;
        
    }
    
     @AuraEnabled
    public static List<Dealer__c> getAllTargetList(){
        
       List<Dealer__c> targetsList = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        
        System.debug(targetsList);
        return targetsList ;
        
    }
    
	@AuraEnabled
    public static List<Employee__c> getFirstStageEmpTargetList(){
        List <Employee__c> getNotCompletedEmpTarget=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
        for (Employee__c dea :targetList ){
            	
            if(dea.Quarterly_Percentage_Of_Achievement__c < 40){
                getNotCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getNotCompletedEmpTarget);
        return getNotCompletedEmpTarget ;
        
    }
    
	@AuraEnabled
    public static List<Employee__c> getSecondStageEmpTargetList(){
        List <Employee__c> getCompletedEmpTarget=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
        for (Employee__c dea :targetList ){
            	
            if(dea.Quarterly_Percentage_Of_Achievement__c >= 40 && dea.Quarterly_Percentage_Of_Achievement__c < 60){
                getCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedEmpTarget);
        return getCompletedEmpTarget ;
        
    }
    
    @AuraEnabled
    public static List<Employee__c> getThirdStageEmpTargetList(){
        List <Employee__c> getCompletedEmpTarget=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
        for (Employee__c dea :targetList ){
            	
            if(dea.Quarterly_Percentage_Of_Achievement__c >= 60 && dea.Quarterly_Percentage_Of_Achievement__c < 80){
                getCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedEmpTarget);
        return getCompletedEmpTarget ;
        
    }
    
     @AuraEnabled
    public static List<Employee__c> getForthStageEmpTargetList(){
        List <Employee__c> getCompletedEmpTarget=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
        for (Employee__c dea :targetList ){
            	
            if(dea.Quarterly_Percentage_Of_Achievement__c >= 80){
                getCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedEmpTarget);
        return getCompletedEmpTarget ;
        
    }
    
    @AuraEnabled
    public static List<Employee__c> getAllTargetEmpTargetList(){
       List <Employee__c> getAllTargetEmp=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Last_Three_Month_Achievement__c,Last_Three_Month_Target__c,Quarterly_Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
       
        System.debug(targetList);
        return targetList;
        
    }
    
     @AuraEnabled
    public static List<Dealer__c> getMonthFirstStageTargetList(){
        List <Dealer__c> getNotCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetList = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetList ){
            	
            if(dea.Percentage_Of_Achievement__c < 40){ 
                getNotCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getNotCompletedTarget);
        return getNotCompletedTarget ;
        
    }
    
     @AuraEnabled
    public static List<Dealer__c> getMonthSecondStageTargetList(){
        
        List <Dealer__c> getCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetLists = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetLists){
            	
            if(dea.Percentage_Of_Achievement__c >= 40 && dea.Percentage_Of_Achievement__c < 60 ){
                getCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedTarget);
        return getCompletedTarget ;
    }
    
    @AuraEnabled
    public static List<Dealer__c> getMonthThirdStageTargetList(){
        
        List <Dealer__c> getCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetLists = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetLists){
            	
            if(dea.Percentage_Of_Achievement__c >= 60 && dea.Percentage_Of_Achievement__c < 80 ){
                getCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedTarget);
        return getCompletedTarget ;
    }
    
    @AuraEnabled
    public static List<Dealer__c> getMonthFourStageTargetList(){
        List <Dealer__c> getNotCompletedTarget=new List<Dealer__c>();
       List<Dealer__c> targetList = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        for (Dealer__c dea :targetList ){
            	
            if(dea.Percentage_Of_Achievement__c >= 80){ 
                getNotCompletedTarget.add(dea);
            }
            
        	}
        System.debug(getNotCompletedTarget);
        return getNotCompletedTarget ;
        
    }
    
     @AuraEnabled
    public static List<Dealer__c> getMonthAllTargetList(){
        
       List<Dealer__c> targetsList = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c,Active__c from Dealer__c where Active__c !=false order By Name Asc];
        
        System.debug(targetsList);
        return targetsList ;
        
    }
    
    @AuraEnabled
    public static List<Employee__c> getMonthFirstStageEmpTargetList(){
        List <Employee__c> getNotCompletedEmpTarget=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
        for (Employee__c dea :targetList ){
            	
            if(dea.Percentage_Of_Achievement__c < 40){
                getNotCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getNotCompletedEmpTarget);
        return getNotCompletedEmpTarget ;
        
    }
    
	@AuraEnabled
    public static List<Employee__c> getMonthSecondStageEmpTargetList(){
        List <Employee__c> getCompletedEmpTarget=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
        for (Employee__c dea :targetList ){
            	
            if(dea.Percentage_Of_Achievement__c >= 40 && dea.Percentage_Of_Achievement__c < 60){
                getCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedEmpTarget);
        return getCompletedEmpTarget ;
        
    }
    
    @AuraEnabled
    public static List<Employee__c> getMonthThirdStageEmpTargetList(){
        List <Employee__c> getCompletedEmpTarget=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
        for (Employee__c dea :targetList ){
            	
            if(dea.Percentage_Of_Achievement__c >= 60 && dea.Percentage_Of_Achievement__c < 80){
                getCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedEmpTarget);
        return getCompletedEmpTarget ;
        
    }
    
     @AuraEnabled
    public static List<Employee__c> getMonthForthStageEmpTargetList(){
        List <Employee__c> getCompletedEmpTarget=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
        for (Employee__c dea :targetList ){
            	
            if(dea.Percentage_Of_Achievement__c >= 80){
                getCompletedEmpTarget.add(dea);
            }
            
        	}
        System.debug(getCompletedEmpTarget);
        return getCompletedEmpTarget ;
        
    }
    
    @AuraEnabled
    public static List<Employee__c> getMonthAllTargetEmpTargetList(){
       List <Employee__c> getAllTargetEmp=new List<Employee__c>();
       List<Employee__c> targetList = [Select Id,Name,Previous_Month_Achievement__c,Previous_Month_Target__c,Percentage_Of_Achievement__c from Employee__c where Active__c !=false order By Name Asc];
       
        System.debug(targetList);
        return targetList;
        
    }
}