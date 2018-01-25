({
	init : function(component, event, helper) {
        var action0 = component.get("c.getUserCurrency");
        
        action0.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
				
			component.set('v.currencyCode',response.getReturnValue());	
            helper.drawHealth(component, event, helper);    
           					
            } else {
                console.log('ACTION 0 Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action0); 
        
	},
    
    selectChangeFunction: function(component, event, helper){
        var selected = parseInt(component.find("selectValue").get("v.value"));
        if (selected > 0){
            if (selected==1){
                helper.drawHealth(component, event, helper);
            } else if (selected==2){
                helper.drawLife(component, event, helper);
            } else if (selected==3){
                helper.drawSavings(component, event, helper);
            } 
        } else {
            $("#container").html("");
        }
    }
    
})