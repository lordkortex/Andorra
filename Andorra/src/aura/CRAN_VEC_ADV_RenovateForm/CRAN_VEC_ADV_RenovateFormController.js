({
	doInit : function(component, event, helper) {
		helper.doInit(component);
    },
	next : function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.stepDisable","disable");
		helper.crearOrdenModificacionCuestionario(component);
	},
    cancel : function(component, event, helper) {
    	var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
    },
    descartar : function(component, event, helper) {
        component.set("v.showDescartar",false);
		helper.descartarForm(component);
    },

    volver : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },

    onSelectChange : function(component, event, helper) {
        component.set("v.stepDisable","disable");
        component.set("v.idBpAvaloq",component.find("InputSelectBP").get("v.value")); 
        component.set('v.showErrorServices',false);
        if(component.find("InputSelectBP").get("v.value")!='000')
            component.set("v.info",true);
            helper.recuperarCuestionarios(component);
        var selectBp = component.find("InputSelectBP");
        if(selectBp.get("v.value")!='000')
            component.set("v.disableListForms",false);

    },
    onSelectChangeForm : function(component, event, helper) {
        var selectForm = component.find("InputSelectForm");
        var selectBp = component.find("InputSelectBP");

        if(selectForm.get("v.value")=='000'){
            component.set("v.stepDisable","disable");
        }
        else{
            if(selectBp.get("v.value")!='000'){
                component.set("v.stepDisable","notDisable");
            }
        }
        component.set("v.idFormSelect",component.find("InputSelectForm").get("v.value"));
    }
    
})