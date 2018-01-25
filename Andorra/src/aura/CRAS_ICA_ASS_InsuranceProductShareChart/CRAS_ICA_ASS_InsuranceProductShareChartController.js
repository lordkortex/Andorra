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
		helper.drawProductShareCount(component, event, helper);
	},
    
    selectPChangeFunction: function(component, event, helper){
        var selected = parseInt(component.find("selectValueP").get("v.value"));
        if (selected > 0){
            if (selected==1){
                helper.drawProductShareCount(component, event, helper);
            } else if (selected==2){
                helper.drawProductShareAmount(component, event, helper);
            } else if (selected==3){
                helper.drawProductShareInsureds(component, event, helper);
            } 
        } else {
            $("#containerP").html("");
        }
    }
})