global class ScheduleSendWhatsappDealerAndEmp implements schedulable {
    
    global void execute(SchedulableContext sc) {
        // Create an instance of the batch Apex class
        SendWhatsappToEmp batch = new SendWhatsappToEmp();
        
        // Schedule the batch to run immediately
       // Database.executeBatch(batch);
        Database.executeBatch(batch, 10);
    }

}