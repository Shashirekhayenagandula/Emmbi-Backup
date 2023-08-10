global class ResetScheduleDealerAchievement implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Create an instance of the batch Apex class
        ResetDealerAchievements batch = new ResetDealerAchievements();
        	
        // Schedule the batch to run immediately
        Database.executeBatch(batch,10);
    }
}