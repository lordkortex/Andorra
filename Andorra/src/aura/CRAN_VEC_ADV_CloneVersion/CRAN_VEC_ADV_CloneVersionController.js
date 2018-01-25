({
	cloneQuote : function(component, event, helper) {
        component.set("v.error",true);
        var recoId = component.get("v.recordId");
        helper.cloneQuote(component, recoId);
	}
})