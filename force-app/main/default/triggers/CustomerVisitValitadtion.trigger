trigger CustomerVisitValitadtion on Retail_Customer_Visit__c (before update ,before insert) 
{
   for(Retail_Customer_Visit__c RCV : trigger.new)
   {
       if(RCV.Level_of_Interest__c == 'Cold Lead')
       {
          if(RCV.Reason_for_Cold_Lead__c == null) 
          { 
              RCV.addError('Please enter the reason for losing this sale!');
          }
       }
       else if(RCV.Level_of_Interest__c == 'Interested')
       {
          if(RCV.Follow_up_Date__c == null) 
          {
              RCV.addError('Please enter a follow-up date!');
          }
       }
    }
}