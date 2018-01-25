({
    genTRX : function (component){
        var recordId = component.get("v.recordId");
        var action = component.get("c.genTRX");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                    component.set("v.successMessage",returnValue.msj);
                    component.set("v.success",true);
                    component.set("v.info",false);
                }else {
                    component.set("v.info",false);
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                }
           }
       });
       $A.enqueueAction(action);
    },
})