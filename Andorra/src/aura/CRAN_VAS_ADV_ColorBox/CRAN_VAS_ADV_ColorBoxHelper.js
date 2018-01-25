({
    processData : function (response, component, event) {
        var state = response.getState();
        
        if (state === "SUCCESS") {
                          
            var values = new Array();
            var mapOfValues = response.getReturnValue();
            var currencyIsoCode = mapOfValues['CurrencyIsoCode'] + " ";
              
            for (key in mapOfValues) {
                
                var color = component.get("v.defaultColor");
                var fieldValue = mapOfValues[key];  
                var numberValue = fieldValue.replace(currencyIsoCode, "").replace(/\./g,"").replace (/,/g, ".");
               
                if (!isNaN(numberValue) && numberValue <0) {
                    color = component.get("v.negativeColor");
                } else if (fieldValue == $A.get("$Label.c.CRAN_VAS_ADV_CF_LBL_Yes")) {
                    color = component.get("v.trueColor");
                } else if (fieldValue == $A.get("$Label.c.CRAN_VAS_ADV_CF_LBL_No")){
                    color = component.get("v.falseColor");
                }
                if (key != 'CurrencyIsoCode')
                	values.push({value:mapOfValues[key],key:key, boxColor: color});
            }
            
            component.set("v.response", values);        
        }
        
    },
    toggleSpinner: function(cmp) {
        var spinner = cmp.find("colorBoxSpinner");
        $A.util.toggleClass(spinner, "slds-hide");         
    }
    
})