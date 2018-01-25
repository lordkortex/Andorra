({
	doInit : function(component, event, helper) {
        helper.loadFieldNames(component);
        
		var action = component.get("c.getClaimDetails");
        action.setParams({"claimId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.Claim_Data", response.getReturnValue());
            } else {
                console.log('Problem getting the Compact Layout, response state: ' + state);
            }
        });

        $A.enqueueAction(action);
	}
    
    
})