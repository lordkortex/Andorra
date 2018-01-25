({
    doInit : function(component, event, helper) {
        var action = component.get("c.getObjectInfo");        
        
        action.setParams({
            recordId: component.get("v.recordId"),
            fieldNames: component.get("v.fieldNames")
        });
        
        action.setCallback(this, function(response) {
            helper.toggleSpinner(component);
            helper.processData(response, component, event, helper);
            helper.toggleSpinner(component);
            
        });      
        
        $A.enqueueAction(action);
        
        
    },
    afterLoad : function(component, event, helper)  {
        
        if (window.$lColorBox == undefined)
            window.$lColorBox = jQuery.noConflict();	        
        $lColorBox("body").on("click", "button[title=Save]",  function(ev) {
            $lColorBox("button.hidden-refresh").trigger("click");
        }); 
        
    },
    refreshComponent: function(component, event, helper)  {
        
        window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    
                    var action = component.get("c.getObjectInfo");        
                    
                    action.setParams({
                        recordId: component.get("v.recordId"),
                        fieldNames: component.get("v.fieldNames")
                    });
                    helper.toggleSpinner(component);
                    action.setCallback(this, function(response) {

                        helper.processData(response, component, event);
                        helper.toggleSpinner(component);
                    });      
                    
                    $A.enqueueAction(action);
                }
            }), 1000
        );
        
    }
    
})