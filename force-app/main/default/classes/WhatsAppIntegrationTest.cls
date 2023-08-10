@isTest
public class WhatsAppIntegrationTest  {

    @isTest
    static void testSendWtpMessage() {
        // Create a test lead with a phone number
        Lead__c l =TestSetupMethod.createFarmer();
        database.insert(l);
        
        Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        whatsAppIntegration.sendWtpMessage(l.Id);
        
        Test.stopTest();
        

    }
    
     @isTest
    static void testSendWtpMessage1() {
        // Create a test lead with a phone number
        Lead__c l =TestSetupMethod.createFarmer();
        l.Tehsil__c ='a082w000009l5UJAAY';
        database.insert(l);
        
        Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        whatsAppIntegration.sendWtpMessage(l.Id);
        
        Test.stopTest();
        

    } 
    
    @isTest
    static void testSendWtpMessage2() {
        // Create a test lead with a phone number
        Lead__c l =TestSetupMethod.createFarmer();
        l.Tehsil__c ='a082w000009l5CjAAI';
        database.insert(l);
        
        Test.startTest();
        
        // Call the sendWtpMessage method and pass in the test lead's ID
        whatsAppIntegration.sendWtpMessage(l.Id);
        
        Test.stopTest();
        

    }    
}