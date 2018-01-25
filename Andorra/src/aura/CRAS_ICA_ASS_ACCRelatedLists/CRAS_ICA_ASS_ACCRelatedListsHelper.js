({
    loadAction: function(cmp, uri, target){
        var actionFN = cmp.get(uri);
        actionFN.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === "SUCCESS") {
                cmp.set(target, response.getReturnValue());
            } else {
                console.log('Problem getting ' + uri + ', response state: ' + state);
            }
        });
        $A.enqueueAction(actionFN);               
    },
    loadActionParam: function(cmp, uri, target, param, value){
        var actionParam = cmp.get(uri);
        actionParam.setParams({"accId": value});
        actionParam.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === "SUCCESS") {
                cmp.set(target, response.getReturnValue());
            } else {
                console.log('Problem getting ' + uri + ', response state: ' + state);
            }
        });
        $A.enqueueAction(actionParam);               
    },
	toggleSpinner: function (cmp, spinnerId) {
        var spinner = cmp.find(spinnerId);
        $A.util.toggleClass(spinner, "slds-hide");
    }
})