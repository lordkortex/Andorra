({
	cloneQuote : function (component, recoId){
        var action = component.get("c.saveIPL");
        action.setParams({
            "quoId": recoId,
        });
	}
})