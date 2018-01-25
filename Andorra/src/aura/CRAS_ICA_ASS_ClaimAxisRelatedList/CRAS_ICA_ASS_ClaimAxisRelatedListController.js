({
    doInit : function(component, event, helper) {
        var action = '';
        
        action = component.get("c.callAxis");
        action.setParams({"claimsId": component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.Claims", response.getReturnValue()); 
                
                var result = component.get("v.Claims");
                var total = 0;
                
                for(var i = 0; i < result.length; i++)
                {
                    total += parseFloat(result[i].Total);
                }
                
                component.set("v.TotalUnbound", total); 
                component.set("v.RecordsCount", response.getReturnValue().length);
                helper.toggleSpinner(component, "listSpinner");
            } else {
                console.log('Problem getting the Records (' + relatedList + '), response state: ' + state);
                component.set("v.RecordsCount", 0);
                helper.toggleSpinner(component, "listSpinner");
            }
        });
        
        $A.enqueueAction(action);
    }
})