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
    toggleSpinner: function (cmp, spinnerId) {
        var spinner = cmp.find(spinnerId);
        $A.util.toggleClass(spinner, "slds-hide");
    }
})