({
	myAction : function(component, event, helper) {
		
	},
    
        redirectToComponent: function (component, event, helper){
		event.preventDefault();
		var evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
			componentDef : "c:CRAN_VAS_MAQ_ReassignMembers",
			componentAttributes: {
				"recordId" : component.get("v.recordId")
			}
		});
		evt.fire();
	}
})