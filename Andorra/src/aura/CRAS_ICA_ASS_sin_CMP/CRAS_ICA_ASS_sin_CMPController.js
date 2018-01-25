({
	init : function(component, event, helper) {
        
        
        var graphType = component.get("v.graphType");
        
        var title1;
        
        var currentyear = '' + new Date().getFullYear();
		
        if (graphType == 'Market'){

            title1 =  $A.get("$Label.c.CRAS_ICA_ASS_ClaimsMarket");
            component.set("v.isMarket","true");
            component.set("v.isProduct","false");
            helper.getDataFromApex(component, event, helper,"Market","currentYear",'1');
        } else if(graphType == 'Product'){

            title1 =  $A.get("$Label.c.CRAS_ICA_ASS_ClaimsProduct");
            component.set("v.isProduct","true");
            component.set("v.isMarket","false");
            helper.getDataFromApex(component, event, helper,"Product","currentYear",'2');
        } 
        
        component.set("v.title1",title1);
        component.set("v.year",currentyear);

	},
    
    select_SNT_ChangeFunction : function(component, event, helper) {
        
        var selected = parseInt(component.find("SNT_selectValue").get("v.value"));
        
        if (selected > 0){
            if (selected==1){
				helper.getDataFromApex(component, event, helper,"Market","currentYear","1");
            } else if (selected==2){
				helper.getDataFromApex(component, event, helper,"Market","allYears","1");
            } else if (selected==3){
				helper.getDataFromApex(component, event, helper,"Product","currentYear","2");
            } else if (selected==4){
				helper.getDataFromApex(component, event, helper,"Product","allYears","2");
            }
         }
    },
})