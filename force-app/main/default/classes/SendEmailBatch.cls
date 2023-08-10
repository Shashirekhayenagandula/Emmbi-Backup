global class SendEmailBatch implements Database.Batchable<sObject> {
    
    
     global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query the records you want to send emails to

        return Database.getQueryLocator([SELECT Id, Name, Employee_Email__c,Employee_Monthly_Target__c,Active__c,Employee_Monthly_Achievement__c FROM Employee__c Where Active__c = true AND Employee_Email__c != null ]);
    }

    global void execute(Database.BatchableContext BC, List<Employee__c> scope) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        // Iterate over the records and add email messages to list
        for (Employee__c c : scope) {
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            Decimal a = c.Employee_Monthly_Target__c - c.Employee_Monthly_Achievement__c;
            if(a<0){
                a=0;
            }
            
            email.setToAddresses(new String[]{c.Employee_Email__c});
            email.setOrgWideEmailAddressId('0D2C500000000E8KAI');
            email.setSubject('Target Details: '+ ' ' +c.Name);
            email.setPlainTextBody('Hello ' + c.Name + ',\n\n'
                + 'Hope you had a wonderful month till now.\n\n'
               // + 'Your Area of Operation is : ' + c.Name + '\n'
                + 'Your Target for the month is : ' + c.Employee_Monthly_Target__c + '\n'    
                + 'You have Completed: ' + c.Employee_Monthly_Achievement__c + '\n'
                + 'Your Balance for the month is :'+ a +'\n\n'
                + 'In case you have any difficulty in reaching the target please speak to your manager for support.\n\n'                   
                + 'Warm Regards,'+'\n' 
                +  'Avana Operations Team \n');
            System.debug(email);
            emailList.add(email);
        }
        
        // Send the email messages
        Messaging.sendEmail(emailList);
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Task Finished !!');
    }
    
    
   /* global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query the records you want to send emails to

        return Database.getQueryLocator([SELECT Id, Name, Dealer_Email__c,Active__c,Weekly_Target__c,Weekly_Achievement__c,Monthly_Target__c,This_Month_Achievement__c FROM Dealer__c Where Monthly_Target__c != null AND Dealer_Email__c != null AND Active__c != false]);
    }

    global void execute(Database.BatchableContext BC, List<Dealer__c> scope) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        // Iterate over the records and add email messages to list
        for (Dealer__c c : scope) {
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            Decimal a = c.Monthly_Target__c - c.This_Month_Achievement__c;
            if(a<0){
                a=0;
            }
            
            email.setToAddresses(new String[]{c.Dealer_Email__c});
            email.setOrgWideEmailAddressId('0D2C500000000E8KAI');
            email.setSubject('Target Not Completed: ' +c.Name);
            email.setPlainTextBody('Hello ' + c.Name + ',\n\n'
                + 'Hope you had a wonderful month till now.\n\n'
                + 'Your Area of Operation is : ' + c.Name + '\n'
                + 'Your Target for the month is : ' + c.Monthly_Target__c + '\n'    
                + 'You have Completed: ' + c.This_Month_Achievement__c + '\n'
                + 'Your Balance for the month is :'+ a +'\n\n'
                + 'In case you have any difficulty in raching the target please speak to your manager for the support.\n\n'                   
                + 'Warm Regards,'+'\n' 
                +  'Avana Operations Team \n');
            System.debug(email);
            emailList.add(email);
        }
        
        // Send the email messages
        Messaging.sendEmail(emailList);
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Task Finished !!');
    }*/
}