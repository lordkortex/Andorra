({
	doInit : function(component, event, helper) {
		helper.doInit(component);
    },
	nextView : function(component, event, helper) {

		//oculto mensajes de error y warning
		component.set('v.showErrorServices',false);
		component.set('v.showWarningServices',false);

		var myAmount = component.find("InputAmount").get("v.value");

		//comprueba validacion de campos
		if(component.find("InputName").get("v.value")==""){
			component.set("v.info",false);
			component.set('v.messageWarningServicesMsg','Debes completar el campo Opportunity');
        	component.set('v.showWarningServices',true);
		} else if(component.find("InputMethod").get("v.value")=='000'){
	
					component.set('v.messageWarningServicesMsg','Debes completar el campo Investment Method');
		        	component.set('v.showWarningServices',true);

		} else if((Number.isInteger(myAmount) || (!isNaN(myAmount+"") && (myAmount+"").toString().indexOf('.') != -1)) && (component.find("InputCurrency").get("v.value")=='000')){
	
			        component.set('v.messageWarningServicesMsg','Debes completar el campo Currency');
                    component.set('v.showWarningServices',true);
		} else {
			component.set("v.info",true);
			component.set('v.showWarningServices',false);
			helper.nuevaProposition(component);
		}
	},
    cancel : function(component, event, helper) {
    	var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
    }
})