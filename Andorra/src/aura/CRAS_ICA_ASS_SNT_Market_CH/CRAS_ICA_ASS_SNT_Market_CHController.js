({
	init : function(component, event, helper) 
    {    
		var currentyear = '' + new Date().getFullYear();
        component.set('v.year', currentyear);
       
		helper.drawYear(component, event, helper);
        
	},
    
    select_SNT_MRK_ChangeFunction: function(component, event, helper){
        var selected = parseInt(component.find("SNT_MKT_selectValue").get("v.value"));
        if (selected > 0){
            if (selected==1){
                helper.drawYear(component, event, helper);
            } else if (selected==2){
                helper.drawAll(component, event, helper);
            }
        } else {
            $("#container_SNT_MRK").html("");
        }
    }
})