({
	init : function(component, event, helper) {
		helper.drawSVProductShareCount(component, event, helper);
	},
    
    selectPSVChangeFunction: function(component, event, helper){
        var selected = parseInt(component.find("selectValuePSV").get("v.value"));
        if (selected > 0){
            if (selected==1){
                helper.drawSVProductShareCount(component, event, helper);
            } else if (selected==2){
                helper.drawSVProductShareInsureds(component, event, helper);
            }
        } else {
            $("#containerPSV").html("");
        }
    }
})