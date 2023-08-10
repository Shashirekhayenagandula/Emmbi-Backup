trigger ConvertedCannotBeDeleted on Opportunity__c (before delete) {
  for(Opportunity__c objOpp: trigger.old){
   if(objOpp.Opportunity_Stage__c == 'Converted')
     {
      objOpp.addError('You cannot delete a Converted Product.');
     }
}
}