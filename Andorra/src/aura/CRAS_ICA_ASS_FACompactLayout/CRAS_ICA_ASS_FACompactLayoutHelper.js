({
    loadFieldNames: function(cmp){
        var actionFN = cmp.get("c.getCompactLayoutFieldNames");
        actionFN.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === "SUCCESS") {
                cmp.set("v.Fin_Account_Fields", response.getReturnValue());
            } else {
                console.log('Problem getting the Compact Layout Field Names, response state: ' + state);
            }
        });
        $A.enqueueAction(actionFN);               
    },
    loadPolicyHolder: function(cmp){
        var actionPH = cmp.get("c.getFinAccountPolicyHolder");
        actionPH.setParams({"finAccId": cmp.get("v.recordId")});
        actionPH.setCallback(this, function(response) {
            var state = response.getState();

            if(cmp.isValid() && state === "SUCCESS") {
                cmp.set("v.PH", response.getReturnValue());
            } else {
                console.log('Problem getting the Compact Layout Field Names, response state: ' + state);
            }
        });
        $A.enqueueAction(actionPH);               
    },
	applyScrollCSS: function(cmp) {
        var cmpTarget = cmp.find('changeIt');
        $A.util.addClass(cmpTarget, 'fixPosIndex');
    },
	removeScrollCSS: function(cmp) {
        var cmpTarget = cmp.find('changeIt');
        $A.util.removeClass(cmpTarget, 'fixPosIndex');
    },
    toggleSpinner: function (cmp, spinnerId) {
        var spinner = cmp.find(spinnerId);
        $A.util.toggleClass(spinner, "slds-hide");
    }

})