({

    loadAction: function(cmp, helper, uri, target){
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
    loadActionParam: function(cmp, helper, uri, target, param, value, rpp){
        var actionParam = cmp.get(uri);
        actionParam.setParams({"finAccId": value});
        actionParam.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === "SUCCESS") {
                cmp.set(target, response.getReturnValue());
                var nop = parseInt(response.getReturnValue()/rpp)+1;
                cmp.set("v.numberOfPages",nop);
                
               
                if (nop>1){
                    for(var i=1;i < nop+1; i++){
                        //create dynamic button
                        $A.createComponent(
                            "ui:button",
                            {
                                "aura:id": "pagButton" + i,
                                "label": i,
                                "press": cmp.getReference("c.handlePress")
                            },
                            function(newButton, status, errorMessage){
                                //Add the new button to the body array
                                if (status === "SUCCESS") {
                                    var body = cmp.get("v.body");
                                    body.push(newButton);
                                    cmp.set("v.body", body);
                                }
                                else if (status === "INCOMPLETE") {
                                    console.log("No response from server or client is offline.")
                                    // Show offline error
                                }
                                else if (status === "ERROR") {
                                    console.log("Error: " + errorMessage);
                                    // Show error message
                                }
                            }
                        );
    
                    }
                }
                
                if (target == "v.RecordsCount"){
                    cmp.loadRecordsMethod();
                }
            } else {
                console.log('Problem getting ' + uri + ', response state: ' + state);
            }
        });
        $A.enqueueAction(actionParam);               
    },
    
	toggleSpinner: function (cmp, spinnerId) {
        var spinner = cmp.find(spinnerId);
        if(!$A.util.hasClass(spinner, "slds-hide")){
        	$A.util.toggleClass(spinner, "slds-hide");
        }
    }
    

     
})