({
	loadAction: function(cmp, helper, uri, target){
        var actionFN = cmp.get(uri);
        actionFN.setParams({"accId": cmp.get("v.recordId")});
        actionFN.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === "SUCCESS") {
                if (target){
                	cmp.set(target, response.getReturnValue());    
                }else {
                    console.log('call: ' + uri + ' - completed successfully. Result: ' + response.getReturnValue());
                }
            } else {
                console.log('Problem getting ' + uri + ', response state: ' + state);
            }
        });
        $A.enqueueAction(actionFN);               
    },
})