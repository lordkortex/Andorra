({
    loadFieldNames: function(cmp){
        var actionFN = cmp.get("c.getCompactLayoutFieldNames");
        actionFN.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === "SUCCESS") {
                cmp.set("v.Claim_Labels", response.getReturnValue());
                console.log(cmp.get("v.Claim_Labels"));
            } else {
                console.log('Problem getting the Compact Layout Field Names, response state: ' + state);
            }
        });
        $A.enqueueAction(actionFN);               
    },
    applyScrollCSS: function(cmp) {
        var cmpTarget = cmp.find('changeIt');
        $A.util.addClass(cmpTarget, 'fixPosIndex');
    },
	removeScrollCSS: function(cmp) {
        var cmpTarget = cmp.find('changeIt');
        $A.util.removeClass(cmpTarget, 'fixPosIndex');
    }
})