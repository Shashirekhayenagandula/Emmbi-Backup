trigger UpdateEmpStatusbsdOnCheckbox on Retail_Employee__c (before insert, before update) 
{
    for(Retail_Employee__c RE : trigger.new)
    {
        if(RE.Employee_status_checkbox__c == true)
        {
            RE.Employee_Status__c = 'Inactive';
        }
        else if(RE.Employee_status_checkbox__c == false)
        {
             RE.Employee_Status__c = 'Active';
        }
    }
}