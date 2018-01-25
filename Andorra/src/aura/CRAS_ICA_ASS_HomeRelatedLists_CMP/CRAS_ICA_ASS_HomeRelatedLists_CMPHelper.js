({

    loadAction: function(cmp, helper, uri, target, valueArray){
        var actionFN = cmp.get(uri);
        actionParam.setParams({"objName": valueArray[0],
                               "listViewName": valueArray[1]});
       
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
    
    loadActionParam: function(cmp, helper, uri, target, param, value, rpp, valueArray){
        var actionParam = cmp.get(uri);
        actionParam.setParams({"objName": valueArray[0],
                               "listViewName": valueArray[1],
                               "providerName": valueArray[2],
                               "recordId": valueArray[3]});
        actionParam.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === "SUCCESS") {
                cmp.set(target, response.getReturnValue());
                var nop = Math.round(parseInt(response.getReturnValue()/rpp)+1);
                console.log(nop);
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
                    cmp.doLoadRecordsMethod();
                }
            } else {
                console.log(response.getError()[0]);
                console.log(response.getError()[0].message);
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