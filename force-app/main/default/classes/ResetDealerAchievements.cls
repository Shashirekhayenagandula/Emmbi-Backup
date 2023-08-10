public class ResetDealerAchievements implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Last_Three_Month_Achievement__c,Previous_Month_Achievement__c,This_Month_Achievement__c FROM Dealer_with_Tehsil__c';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Dealer_with_Tehsil__c> records) {
        List<Dealer_with_Tehsil__c> recordsToUpdate = new List<Dealer_with_Tehsil__c>();
        for (Dealer_with_Tehsil__c record : records) {
            record.Last_Three_Month_Achievement__c = 0;
            record.Previous_Month_Achievement__c = 0;
            record.This_Month_Achievement__c = 0;
            recordsToUpdate.add(record);
        }
        update recordsToUpdate;
    }
    public void finish(Database.BatchableContext bc) {
    // Perform any post-processing actions after all batches are completed
    
    // Create a new email message
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    
    // Set the recipients of the email message
    email.setToAddresses(new List<String>{ 'akash.chavan@emmbi.com' });
    
    // Set the subject and body of the email message
    email.setSubject('Batch Job Completed Successfully');
    email.setPlainTextBody('The Reset batch job has completed successfully.');
    
    // Send the email message
    Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
    
    // Check the results of the email send operation
    for (Messaging.SendEmailResult result : results) {
        if (!result.isSuccess()) {
            // Handle any errors that occurred during the email send operation
            System.debug('Email send error: ' + result.getErrors());
        }
    }
}
}