({
	doInit : function(component, event, helper) {
        //Isolating the scope
        if (window.$aGoals == undefined)
        	window.$aGoals = jQuery.noConflict();
        
		if(component.get("v.showComponent")){    
			helper.loadMultiSelect(component);
		}	
	},
	getGoalsUsersByOffice : function (component, event, helper) {
        
        var container 		= component.find("container").getElement();
		$aGoals('#multiSelectDiv', container).hide();                                        
        
        component.set("v.showMultiSelect", false);
		helper.getGoalsUsersByOffice (component);
	},
	getGoalDetails : function (component,event,helper){
		helper.getGoalDetails(component);
	},
	closeModal : function(component, event, helper) {
		helper.closeModal(component);
	},
	confirmAssignGoalsToAdvisor: function(component, event, helper){
		helper.openModal(component);
	},
	assignGoalsToAdvisor: function (component, event, helper){
		helper.assignGoalsToAdvisor(component);
	},
	showGoals: function (component,event,helper){
        
		component.set("v.showMultiSelect", true);
		
        var selectedUser = component.find("users").get("v.value");
		component.set("v.selectedUser", selectedUser);

        var container 		= component.find("container").getElement();
		$aGoals('#multiSelectDiv', container).show();    

	},
	redirectToComponent: function (component, event, helper){
		event.preventDefault();
		var evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
			componentDef : "c:CRAN_VAS_MAQ_AssignGoals",
			componentAttributes: {
				"recordId" : component.get("v.recordId"),
				"showComponent" : true,
				"showButton": false,
				"fieldNames": component.get("v.fieldNames"),
				"detailFieldNames": component.get("v.detailFieldNames"),
                "vision": component.get("v.vision")
			}
		});
		evt.fire();
	}
})