trigger DealerWithTehsilTrigger on Dealer_with_Tehsil__c (after update,after delete) {
	
    UpdateDealertargets.updateDealerMonthlyTargets(Trigger.new);
  
}