({
	doInit :function(component) {
        {
        var actionCheckValidation = component.get("c.checkValidation");

        actionCheckValidation.setParams({ 
            "financialAccountId": component.get("v.recordId")
        });

        actionCheckValidation.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = JSON.parse(response.getReturnValue());

                if(returnValue.check){
                    // Recuperación de opciones del picklist method
                    var opts = [];
                    var options = returnValue.optionsMethod;
                    console.log('options: ' + options);
                    for(var i=0;i<options.length;i++){
                        opts.push({"class": "optionClass", "label": options[i].label, "value": options[i].value});
                    }
                    console.log('opts: ' + opts);
                    var inputsel = component.find("InputMethod");
                    inputsel.set("v.options", opts);

                    // Recuperación de opciones del picklist method
                    var opts1 = [];
                    var options1 = returnValue.optionsCurrency;
                    console.log('options: ' + options1);
                    
                    for(var i=0;i<options1.length;i++){
                        if(options1[i].label == 'EUR')
                            opts1.push({"class": "optionClass", "label": options1[i].label, "value": options1[i].value, selected: "true"});
                        else
                            opts1.push({"class": "optionClass", "label": options1[i].label, "value": options1[i].value});
                    }
                    console.log('opts: ' + opts);
                    var inputsel = component.find("InputCurrency");
                    inputsel.set("v.options", opts1);
    
                }else{

                    component.set('v.messageErrorServicesMsg','No es posible hacer la propuesta');
                    component.set('v.showErrorServices',true);
                    component.set('v.showForm',false);

                }
                
            }
            
        });
        $A.enqueueAction(actionCheckValidation);
        }
    },

    nuevaProposition:function(component) {
        var actionNuevaProposition = component.get("c.nuevaProposition");

        actionNuevaProposition.setParams({
            "financialAccountId": component.get("v.recordId"),
            "nameOpportunity": component.get("v.selectedName"), 
            "nameMethod": component.get("v.selectedMethod"), 
            "nameCurrency": component.get("v.selectedCurrency"), 
            "nameAmount": component.find("InputAmount").get("v.value")+"",
        });
        actionNuevaProposition.setCallback(this, function(response) {

            if(component.isValid()){
                var jsonResponse = JSON.parse(response.getReturnValue());
                if(jsonResponse.success && jsonResponse!= null && jsonResponse.obj!=null
                    && jsonResponse.obj.Id!=null){
                    component.set("v.info",false);
       
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/one/one.app#/sObject/"+jsonResponse.obj.Id+"/view"
                    });
                    urlEvent.fire();
                } else{
                    component.set("v.info",false);
                    component.set("v.messageErrorServicesMsg",jsonResponse.messageError);
                    component.set("v.showErrorServices",true);
                }
            }   
        });
        $A.enqueueAction(actionNuevaProposition);
    }
})