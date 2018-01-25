({
	doInit : function(component, event, helper) {
        debugger;
//console.log('has id ' + component.get("v.recordId"));
		var recordId = component.get("v.recordId");
        var action = component.get("c.getMobilePhoneInfo");
	    action.setParams({ 
            recId : component.get("v.recordId") 
        }); 
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();    
            
            if (component.isValid() && state === "SUCCESS") {

                var phones = response.getReturnValue();
                var phoneNumberContentEl = component.find("phoneNumberContent").getElement();
                var htmlContent = '';

                for (var key in phones) {
                    htmlContent += '<h2 class="slds-text-heading_small">' + key + '</h2><div class="slds-text-body_regular slds-text-color_weak slds-m-bottom_small">' + $A.get("$Label.c.CRAN_VAS_KER_MobilePhone") + ': ' + phones[key] + '</div>';
                }

                phoneNumberContentEl.innerHTML = htmlContent;
                helper.toggle(component, "modalSpinner");
                helper.toggle(component, "phoneNumberContainer");

            } else if (component.isValid() && state === "INCOMPLETE") { 
                helper.printErrors(null);   
            } else if (component.isValid() && state === "ERROR") {  
                helper.printErrors(response.getError());                
            }

    	});

        $A.enqueueAction(action);

	},
    cancel : function () {
        $A.get("e.force:closeQuickAction").fire();
    },
    confirm : function (component, event, helper) {
        helper.executeDocuSign(component);
    }
})