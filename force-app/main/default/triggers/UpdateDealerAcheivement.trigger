trigger UpdateDealerAcheivement on Opportunity__c ( after update, after delete) {
    
    
 	UpdateDealerAcheivementHandler.acheivementUpdate(Trigger.New);
    //	UpdateDealerAcheivementHandler.acheivementThisMonthUpdate(Trigger.New);
    //	UpdateDealerAcheivementHandler.acheivementMonthsUpdate(Trigger.New);    
   // UpdateDealerAcheivementHandler.CCHelp();
}