({
    handleChange : function(component, event, helper) {
        console.log('In pageReference HANDLER '+component.get("v.recordId"));
        $A.get('e.force:refreshView').fire();
    }, reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})