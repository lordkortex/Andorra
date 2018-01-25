({  
    doInit : function(component, event, helper) {
        var recoId = component.get("v.recordId");
        helper.doInit(component, recoId);
    },   
    
    createIPL : function(component, event, helper) {
        component.set("v.error", false);
        component.set("v.errorMessage", "");
        var newIPL = component.get("v.objNew");
		helper.createIPL(component, newIPL);
    },
    
    cancel : function(component, event, helper) {
    	var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
    },
    
    handleComponentEvent : function(component, event, helper) {
       var selectedAssetGetFromEvent = event.getParam("assetByEvent");
       component.set("v.error", false);
       component.set("v.errorMessage", "");
	   component.set("v.Id" , selectedAssetGetFromEvent.Id);   
	},
})