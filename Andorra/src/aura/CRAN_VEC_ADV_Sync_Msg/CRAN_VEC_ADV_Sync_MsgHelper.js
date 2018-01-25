({    
    doInit: function(component){
        var action = component.get("c.QuoteMessage");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();
                component.set("v.fStat", respuesta[0]);                  
                component.set("v.fInvA", respuesta[1]); 
                component.set("v.fCurr", respuesta[2]);                
                component.set("v.fIpl",  respuesta[3]);
            }
        });
	    $A.enqueueAction(action);
    },    
    
})