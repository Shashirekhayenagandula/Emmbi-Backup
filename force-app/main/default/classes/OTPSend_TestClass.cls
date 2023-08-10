@isTest
public class OTPSend_TestClass {
    public static testMethod void OTPSend_Test()
    {
         Account acc=new Account();
        acc.name='avana';
        acc.Farmer_First_Name__c='s';
        acc.Phone='9876594421';
        insert acc;
        
        Complaint__c cmpt=new Complaint__c();
        cmpt.Complaint_Type__c='Faulty fabric - Manufacturing';
        cmpt.Complaint_Source__c='Toll Free Number';
        cmpt.Description__c='test';
        cmpt.Stages__c='Completed';
        cmpt.Customer__c=acc.Id;
        insert cmpt;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOtp());
        OTPSend.sendOtp(acc.Phone, cmpt.Id);
        test.stopTest();
        
    }

}