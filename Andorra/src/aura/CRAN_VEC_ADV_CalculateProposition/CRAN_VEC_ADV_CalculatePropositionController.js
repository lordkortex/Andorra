({    
	doInit : function(component, event, helper) {
		component.set("v.info",true);
		helper.doInit(component);
    },
    next : function(component, event, helper) {
    	component.set("v.info",true);
		helper.doCalculate(component);
	},
    cancel : function(component, event, helper) {
    	var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
    }
 
})