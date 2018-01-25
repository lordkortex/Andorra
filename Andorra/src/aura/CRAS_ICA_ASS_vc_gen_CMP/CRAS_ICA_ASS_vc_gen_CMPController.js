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
        
        //set userid
        var action2 = component.get("c.getUserId");
        action2.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.userId", response.getReturnValue());
             }
         });
       	$A.enqueueAction(action2);
        
        var productType = component.get("v.productType");
        var title1='';
        
        if (productType == 'Risk'){
            title1 =  $A.get("$Label.c.CRAS_ICA_ASS_RiskSalesNumPol");
            component.set("v.isRisk","true");
            helper.getDataFromApex(component, event, helper,"Risk","polNum",'1');
        } else if(productType == 'Savings'){
            title1 =  $A.get("$Label.c.CRAS_ICA_ASS_SavingsSalesNumPol");
            component.set("v.isSavings","true");
            helper.getDataFromApex(component, event, helper,"Savings","polNum",'2');
        }
        
        component.set("v.title1",title1);    
	},
    
    selectChangeCHFunction: function(component, event, helper) {
        var selected = parseInt(component.find("selectValueCH").get("v.value"));
        if (selected > 0){
            if (selected==1){
				helper.getDataFromApex(component, event, helper,"Risk","polNum",'1');
            } else if (selected==2){
				helper.getDataFromApex(component, event, helper,"Risk","totalAmount",'1');
            } else if (selected==3){
				helper.getDataFromApex(component, event, helper,"Risk","insNum",'1');
            } else if (selected==4){
				helper.getDataFromApex(component, event, helper,"Savings","polNum",'2');
            } else if (selected==5){
				helper.getDataFromApex(component, event, helper,"Savings","totalAmount",'2');
            } 
        } else {
            //$("#container").html("");
        }		
	}
})