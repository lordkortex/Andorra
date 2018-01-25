({
	getResponses : function(component) {
        var actionGetResponses = component.get("c.getApexResponses");
        actionGetResponses.setParams({
      		"recordId": component.get("v.recordId"),
    	});

        actionGetResponses.setCallback(this, function(response) {
            var state = response.getState();
	        if(component.isValid() && state == "SUCCESS"){
                var opts = [];
                
                var jsonResponse = JSON.parse(response.getReturnValue());
                if(jsonResponse.success == true){
                	var responses = jsonResponse.suitableTestResponds;
					component.set("v.responses",responses);
                    console.log('responses: ' + responses);
    	            for(var i=0;i<responses.length;i++){
                        if(i == 0){
                            opts.push({"class": "optionClass", "label": responses[i].Name, "value": i});
                        }else{
                            opts.push({"class": "optionClass", "label": responses[i].Name + " Status " + responses[i].CRAN_VEC_ADV_P_Acceptance_Status__c, "value": i});
                        }
            	    }
                	console.log('opts: ' + opts);
	                var inputsel = component.find("InputSelectDynamic");
    	            inputsel.set("v.options", opts);                

                    component.set('v.attContact',jsonResponse.contact);

                    if(responses.length<1)
                        component.set("v.step",2);
                }
                else component.set("v.step",2);
	        }
    	});
    	$A.enqueueAction(actionGetResponses);
    }

})