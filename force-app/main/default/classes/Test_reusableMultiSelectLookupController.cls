@isTest
public class Test_reusableMultiSelectLookupController {
    @isTest
    static void testFetchRecords() {

        Account testAccount = new Account(Name = 'Test Account',Phone='123445667');
        insert testAccount;
        
        ReusableMultiSelectLookupController.SearchWrapper inputWrapper = new ReusableMultiSelectLookupController.SearchWrapper();
        inputWrapper.objectApiName = 'Account';
        inputWrapper.fieldApiName = 'Name';
        inputWrapper.searchString = 'Test';
        inputWrapper.otherFieldApiName='Phone';
        inputWrapper.parentFieldApiName='AccountId';
        inputWrapper.parentRecordId='';
        inputWrapper.searchByOtherField=false;
        
        List<ReusableMultiSelectLookupController.ResultWrapper> result = ReusableMultiSelectLookupController.fetchRecords(inputWrapper);
        
        System.assertEquals(1, result.size());
        System.assertEquals('Test Account', result[0].mainField);
        System.assertEquals(testAccount.Id, result[0].id);
    }
}