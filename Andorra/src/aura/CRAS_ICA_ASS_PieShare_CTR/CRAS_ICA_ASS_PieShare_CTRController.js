({
	init : function(component, event, helper) {
        
        //set currency
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

        //SETEAR TIPO DE GRÁFICO
        var graphType = component.get("v.graphType");
        
        var title1;
		
        if (graphType == 'Market Share'){
            title1 =  $A.get("$Label.c.CRAS_ICA_ASS_MarketNumPol");
            component.set("v.isMarketShare","true");
            helper.getDataFromApex(component, event, helper,"Market Share","polNum",'1');
        } else if(graphType == 'Product Share'){
            title1 =  $A.get("$Label.c.CRAS_ICA_ASS_ProductNumPol");
            component.set("v.isProductShare","true");
            helper.getDataFromApex(component, event, helper,"Product Share","polNum",'2');
        } else if(graphType == 'Saving Product Share'){
            title1 =  $A.get("$Label.c.CRAS_ICA_ASS_SavingsProductNumPol");
            component.set("v.isSVProductShare","true");
            helper.getDataFromApex(component, event, helper,"Saving Product Share","polNum",'3');
        }
        
        component.set("v.title1",title1);
        
	},
    
    selectChangeFunction : function(component, event, helper) {

        var selected = parseInt(component.find("selectValue").get("v.value"));

        if (selected > 0){
            if (selected==1){
				helper.getDataFromApex(component, event, helper,"Market Share","polNum",'1');
            } else if (selected==2){
				helper.getDataFromApex(component, event, helper,"Market Share","totalAmount",'1');
            } else if (selected==3){
				helper.getDataFromApex(component, event, helper,"Market Share","insNum",'1');
            } else if (selected==4){
				helper.getDataFromApex(component, event, helper,"Product Share","polNum",'2');
            } else if (selected==5){
				helper.getDataFromApex(component, event, helper,"Product Share","totalAmount",'2');
            } else if (selected==6){
				helper.getDataFromApex(component, event, helper,"Product Share","insNum",'2');
            } else if (selected==7){
				helper.getDataFromApex(component, event, helper,"Saving Product Share","polNum",'3');
            } else if (selected==8){
				helper.getDataFromApex(component, event, helper,"Saving Product Share","insNum",'3');
            } 
            
        } else {
            //$("#container").html("");
        }
        
	} 
})