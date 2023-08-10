global class SendEmailScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Create an instance of the batch Apex class
        SendEmailBatch batch = new SendEmailBatch();
        
        // Schedule the batch to run immediately
       // Database.executeBatch(batch);
        Database.executeBatch(batch, 20);
    }
}