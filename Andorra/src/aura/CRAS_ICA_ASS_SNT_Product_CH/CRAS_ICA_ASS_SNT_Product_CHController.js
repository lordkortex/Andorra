({
	init : function(component, event, helper) 
    {        
		helper.drawYear(component, event, helper);
	},
    
    select_SNT_PROD_ChangeFunction: function(component, event, helper){
        var selected = parseInt(component.find("SNT_PROD_selectValue").get("v.value"));
        if (selected > 0){
            if (selected==1){
                helper.drawYear(component, event, helper);
            } else if (selected==2){
                helper.drawAll(component, event, helper);
            }
        } else {
            $("#container_PROD_MRK").html("");
        }
    }
})