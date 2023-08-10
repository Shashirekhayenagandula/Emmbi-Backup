global class UpdateRecordLastThreeMonth implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Create an instance of the batch Apex class
        UpdateRecordsBatch batch = new UpdateRecordsBatch();
        
        // Schedule the batch to run immediately
        Database.executeBatch(batch,10);
       
    }
}