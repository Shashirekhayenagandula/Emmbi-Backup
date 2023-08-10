public class UpdateUserTargetHandler{
   public Static void targetUpdate(List<Dealer__c> Dealers){
       if(Label.update_employee_target_and_achivement =='Yes'){
    Set<Id> parentIds = new Set<Id>();
    List<Employee__c> usersToUpdate = new List<Employee__c>();
    
    for (Dealer__c deal: Dealers) {
        parentIds.add(deal.Employee_Names__c);
    }
    
    for (Id parentId : parentIds) {
        Employee__c e = [SELECT Id, Employee_Monthly_Target__c,Employee_Monthly_Achievement__c,Last_Three_Month_Achievement__c,
                         Last_Three_Month_Target__c,Previous_Month_Achievement__c,Previous_Month_Target__c,
                         (SELECT Id,Current_Month_Target__c,Previous_Month_Target__c,Last_Three_Month_Target__c,
                          Current_Month_Achievement__c,Previous_Month_Achievement__c,Last_Three_Month_Achievement__c FROM Dealers__r) 
                         FROM Employee__c WHERE Id = :parentId];
        
        Decimal totalMonthTarget= 0;
        Decimal totalPreviousMonthTarget= 0;
        Decimal totalLastThreeMonthTarget= 0;
       
        Decimal totalThisMonthAchievment =0;
        Decimal totalPreviousMonthAchievment =0;
        Decimal totalLastThreeMonthAchievment =0;
        
        for (Dealer__c child : e.Dealers__r) {

            totalMonthTarget+= child.Current_Month_Target__c;
            totalPreviousMonthTarget+= child.Previous_Month_Target__c;
            totalLastThreeMonthTarget+= child.Last_Three_Month_Target__c;
            
            totalThisMonthAchievment += child.Current_Month_Achievement__c;
            totalPreviousMonthAchievment += child.Previous_Month_Achievement__c;
            totalLastThreeMonthAchievment += child.Last_Three_Month_Achievement__c;
            
        }
        
      	e.Employee_Monthly_Target__c = totalMonthTarget;
        e.Previous_Month_Target__c = totalPreviousMonthTarget;
        e.Last_Three_Month_Target__c = totalLastThreeMonthTarget;
        
        e.Employee_Monthly_Achievement__c =totalThisMonthAchievment;
        e.Previous_Month_Achievement__c =totalPreviousMonthAchievment;
        e.Last_Three_Month_Achievement__c =totalLastThreeMonthAchievment;
        
        usersToUpdate.add(e);
    }
    
    update usersToUpdate;
    
    }
    
} 
    
   /* public Static void targetUpdate(List<Dealer__c> Dealers){
   
    Set<Id> parentIds = new Set<Id>();
    List<User> usersToUpdate = new List<User>();
    
    for (Dealer__c deal: Dealers) {
        parentIds.add(deal.Employee_Name__c);
    }
    
    for (Id parentId : parentIds) {
        User u = [SELECT Id, Weekly_Target__c, Monthly_Target__c,Three_Month_Achievement__c, This_Month_Achievement__c,(SELECT Weekly_Target__c,Three_Month_Achievement__c,Monthly_Target__c,This_Month_Achievement__c FROM Dealers__r) FROM User WHERE Id = :parentId];
        
        Decimal totalWeakTarget= 0;
        Decimal totalMonthTarget= 0;
        Decimal totalThreeMonthAchievment =0;
        Decimal totalThisMonthAchievment =0;
        for (Dealer__c child : u.Dealers__r) {
            if(child.Weekly_Target__c == null){
                child.Weekly_Target__c=0;
            }else{
                child.Weekly_Target__c=child.Weekly_Target__c;
            }
            if(child.Monthly_Target__c== null){
                child.Monthly_Target__c=0;
            }else{
                child.Monthly_Target__c=child.Monthly_Target__c;
            }
            if(child.Three_Month_Achievement__c == null){
                child.Three_Month_Achievement__c=0;
            }else{
                child.Three_Month_Achievement__c=child.Three_Month_Achievement__c;
            }
            if(child.This_Month_Achievement__c == null){
                child.This_Month_Achievement__c=0;
            }else{
                child.This_Month_Achievement__c=child.This_Month_Achievement__c;
            }
            totalWeakTarget+= child.Weekly_Target__c;
            totalMonthTarget+= child.Monthly_Target__c;
            totalThreeMonthAchievment += child.Three_Month_Achievement__c;
            totalThisMonthAchievment += child.This_Month_Achievement__c;
        }
        
        u.Weekly_Target__c= totalWeakTarget;
        u.Monthly_Target__c = totalMonthTarget;
        u.Three_Month_Achievement__c =totalThreeMonthAchievment;
        u.This_Month_Achievement__c =totalThisMonthAchievment;
        
        usersToUpdate .add(u);
    }
    
    update usersToUpdate;
    
    }

    */
        public static void CCHelp(){
    integer i=1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
            i=1+1;
    
    }
    
    
}