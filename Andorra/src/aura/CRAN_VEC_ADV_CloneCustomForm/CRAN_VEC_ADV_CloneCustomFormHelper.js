({
	cloneCF : function(component) {
		var actionInit = component.get("c.cloneCustomForm");
        actionInit.setParams({
            "customFormId": component.get("v.recordId")
        });
        actionInit.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                    var idRecord = returnValue.id;
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": idRecord,
                        "slideDevName": "Detail"
                    });
                    navEvt.fire();
                }else{
                    alert(returnValue.messageError);
                }
            }
        });
        $A.enqueueAction(actionInit);
	}
})