({
	init : function(component, event, helper) {
        var action = component.get("c.getUserCurrency");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
				
			component.set('v.currencyCode',response.getReturnValue());	
           					
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
		helper.drawMarketShareCount(component, event, helper);
	},
    
    selectChangeFunction: function(component, event, helper){
        var selected = parseInt(component.find("selectValue").get("v.value"));
        if (selected > 0){
            if (selected==1){
                helper.drawMarketShareCount(component, event, helper);
            } else if (selected==2){
                helper.drawMarketShareAmount(component, event, helper);
            } else if (selected==3){
                helper.drawMarketShareInsureds(component, event, helper);
            } 
        } else {
            $("#container").html("");
        }
    }
})