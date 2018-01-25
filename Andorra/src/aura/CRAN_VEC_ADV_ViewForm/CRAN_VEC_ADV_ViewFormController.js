({
    doInit : function(component, event, helper) {
        helper.recuperarCuestionariosDone(component, event, helper);
    },
	nextView : function(component, event, helper) {
        component.set("v.error",false);
        component.set("v.info",true);
		helper.printPdf(component);
	},
    cancel : function(component, event, helper) {
    	var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
    },
    onSelectChangeFormView : function(component, event, helper) {
         component.set("v.error",false);
        var selectForm = component.find("InputViewSelectForm");
        if(selectForm.get("v.value")=='000'){
            component.set("v.stepDisable","disable");
        }else{
            component.set("v.stepDisable","notDisable");
        }
        component.set("v.idFormSelect",component.find("InputViewSelectForm").get("v.value"));
    }
})