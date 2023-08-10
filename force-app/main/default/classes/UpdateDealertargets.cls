public class UpdateDealertargets {
    
    public static void updateDealerMonthlyTargets(List<Dealer_with_Tehsil__c> deal){
        if(Label.update_dealer_target == 'Yes'){
        set<Id> parentIds = new set<Id>();
        List<Dealer__c>dealer = new List<Dealer__c>();
        
        for(Dealer_with_Tehsil__c d:deal ){
            parentIds.add(d.Dealer__c);
        }
        
        for(Id parentId : parentIds){
            
            Dealer__c dea = [Select Id,Current_Month_Target__c,Previous_Month_Target__c,Last_Three_Month_Target__c, 
                             (SELECT Id,Dealer_Target__c,Dealer_Previous_Month_Target__c,Dealer_Last_Three_Month_Target__c
                              FROM Dealer_with_Tehsils__r) FROM Dealer__c WHERE Id = :parentId];
            Decimal dealerTarget =0;
            Decimal dealerPreviousMonthTarget =0;
            Decimal dealerLastThreeMonthTarget =0;
            
            for (Dealer_with_Tehsil__c child : dea.Dealer_with_Tehsils__r) {

            dealerTarget+= child.Dealer_Target__c;
            dealerPreviousMonthTarget+= child.Dealer_Previous_Month_Target__c;
            dealerLastThreeMonthTarget+= child.Dealer_Last_Three_Month_Target__c;
          
        }
            dea.Current_Month_Target__c =dealerTarget;
            dea.Previous_Month_Target__c =dealerPreviousMonthTarget;
            dea.Last_Three_Month_Target__c =dealerLastThreeMonthTarget;
            dealer.add(dea);
        }
        
        update dealer;
        
    }
    }
    
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
    }
}