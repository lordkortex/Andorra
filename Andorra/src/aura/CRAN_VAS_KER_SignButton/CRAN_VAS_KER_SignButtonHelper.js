({
    executeDocuSign : function (component) {
        
        var helper = this;
        var action = component.get("c.startSignatureProcess");

        helper.toggle(component, "modalSpinner");

        action.setParams({ id : component.get("v.recordId") });  
        action.setCallback(this, function(response) {
            
            var state = response.getState();    
            
            if (component.isValid() && state === "SUCCESS") {

                var obj = response.getReturnValue();

                if (typeof obj == 'string') {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": obj                
                    });
                    urlEvent.fire();

                    $A.get("e.force:closeQuickAction").fire();
                } else {
                    helper.printErrors(obj.message);
                }              

            } else if (component.isValid() && state === "INCOMPLETE") { 
                helper.printErrors(null);   
            } else if (component.isValid() && state === "ERROR") {  
                helper.printErrors(response.getError());                
            }

        });

        $A.enqueueAction(action);

    },    
    showToast : function(title, type, message) {

        var toastEvent = $A.get("e.force:showToast");               

        toastEvent.setParams({
            "title": title,
            "type" : type,
            "message": message
        });

        toastEvent.fire();
    },     
    printErrors: function(errors) {

        var msg = $A.get("$Label.c.CRAN_VAS_KER_UnknownError");

        if (errors) {
            msg = '';

            if (typeof errors == 'string') {
                msg = errors;
            } else {
                for (var i = 0; i < errors.length; i++) {
                    msg += errors[i].message + "\n";
                    console.log("Error message: " + errors[i].message);
                }
            }
        } else {
            console.log("Unknown error");
        }

        this.showToast($A.get("$Label.c.CRAN_VAS_MAQ_ErrorTitle"), "error", msg);
        $A.get("e.force:closeQuickAction").fire();    
    },
    toggle: function (component, elementId) {
        var element = component.find(elementId);
        $A.util.toggleClass(element, "slds-hide");
    }
})