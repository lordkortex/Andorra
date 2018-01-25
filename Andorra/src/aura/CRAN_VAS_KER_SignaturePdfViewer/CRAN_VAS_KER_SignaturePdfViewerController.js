({
	doInit2 : function(component, event, helper) {
		var recID = component.get("v.recordId");
        var action = component.get("c.getSignatures");
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            component.set("v.signatureList", data);
        });
        $A.enqueueAction(action);
	 } 
     
})