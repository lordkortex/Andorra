({
	queryAccount : function(component) {
		component.set("v.error",false);
		var actionQueryAccount = component.get("c.queryAccountApex");
        actionQueryAccount.setParams({
            "recordId": component.get("v.recordId")
        });
        actionQueryAccount.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                	console.log('acc: ' + returnValue.account);
					component.set("v.account",returnValue.account);
                }else{
                	component.set("v.errorMessage",returnValue.messageError); 
                	component.set("v.error",true);
                }
            }
        });
        $A.enqueueAction(actionQueryAccount);
	},
	signContract : function(component) {
		component.set("v.error",false);
		var actionQueryAccount = component.get("c.signContractApex");
        actionQueryAccount.setParams({
            "account": component.get("v.account")
        });
        actionQueryAccount.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                   var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/one/one.app#/sObject/"+component.get("v.recordId")+"/view"
                    });
                    urlEvent.fire();
                }else{
                	component.set("v.errorMessage",returnValue.messageError);
                	component.set("v.error",true);
                }
            }
        });
        $A.enqueueAction(actionQueryAccount);
	}
})