({
    doInit : function(component, event, helper) {
		var action = component.get("c.getRecordById");
        
        action.setParams({
            recordId:component.get("v.recordId")
        });
        
        console.log('recordId:'+component.get("v.recordId"));
        
        action.setCallback(this, function(response){
            helper.processData(response, component, event, helper)
        });
        
        $A.enqueueAction(action);
	}
})