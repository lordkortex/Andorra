({    
    doInit :function(component) {
    	component.set("v.error",false);
		var action = component.get("c.sign");
        action.setParams({
            "objId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                  //Actualizamos la pagina actual para refrescar el Salespath
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                        "url": "/one/one.app#/sObject/" + component.get("v.recordId") + "/view"
                   });
                   urlEvent.fire();
                }else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",true);
                  component.set("v.info",false);
                }
             }
             component.set("v.info",false);
        });
        $A.enqueueAction(action);
	}    

})