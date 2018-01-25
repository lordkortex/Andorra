({
    
	doInit : function(component, event, helper) {
		component.set("v.info",false);
        component.set("v.error",false);
		helper.helperCheckStatus(component);
    },  

    cancelDiscard : function(component, event, helper) {
    	var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
    },

    discardOpp : function(component, event, helper) {
        helper.helperdiscardOpp(component);        
    }
    
})