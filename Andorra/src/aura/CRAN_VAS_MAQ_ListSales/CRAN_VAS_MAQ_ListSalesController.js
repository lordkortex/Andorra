({
	listSales : function(component, event, helper) {
        
        
       var action = component.get("c.getSales");
        
        action.setCallback(this, function(response) {
            var state = response.getState();                  
            if (component.isValid() && state == 'SUCCESS') {
                component.set("v.oppts",
                              response.getReturnValue());
                var res = response.getReturnValue();  
                
            } else {
                console.log('Failed with state: '+state);
            }  
            
        });
        $A.enqueueAction(action);

        action = component.get("c.getListViewId"); 
        action.setCallback(this, function(response) {
            var state = response.getState();                  
            if (component.isValid() && state == 'SUCCESS') {
                component.set("v.viewAllId",
                              response.getReturnValue());
                
            } else {
                console.log('Failed with state: '+state);
            }  
            
        });
        
        $A.enqueueAction(action);
	},
})