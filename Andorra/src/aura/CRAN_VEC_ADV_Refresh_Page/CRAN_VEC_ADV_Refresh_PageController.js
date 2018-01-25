({
	doInit : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
            "url": "/one/one.app#/sObject/" + component.get("v.recordId") + "/view"
        });
        urlEvent.fire();
	},

})