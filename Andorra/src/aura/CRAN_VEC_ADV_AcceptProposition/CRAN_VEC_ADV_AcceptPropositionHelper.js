({    
    doInit :function(component) {
    	component.set("v.error",false);
		var action = component.get("c.acceptOppOnlyServiceSign");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                component.set("v.info",false);
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                   var urlEvent = $A.get("e.force:navigateToURL");
                   urlEvent.setParams({
                        "url": "/one/one.app#/sObject/" + component.get("v.recordId") + "/view"
                   });
                   urlEvent.fire();
                 }else{
                    component.set("v.info",false);
                	component.set("v.errorMessage",returnValue.messageError);
                	component.set("v.error",true);
                 }
             }
        });
        $A.enqueueAction(action);
	}    

})