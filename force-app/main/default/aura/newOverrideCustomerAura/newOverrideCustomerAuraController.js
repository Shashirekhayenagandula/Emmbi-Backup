({
    handleChange : function(component, event, helper) {
        console.log('In pageReference HANDLER ');
        $A.get('e.force:refreshView').fire();
    }
    
})
({
    handleRefreshView: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})