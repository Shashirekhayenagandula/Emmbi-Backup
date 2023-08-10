trigger UpdateUserTarget on Dealer__c( after update, after delete) {
   
	  // UpdateUserTargetHandler.targetUpdate(Trigger.New);
     //  UpdateUserTargetHandler.CCHelp();
   	 	 UpdateUserTargetHandler.targetUpdate(Trigger.New);
   	
}