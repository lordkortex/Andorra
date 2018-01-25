({
    doInit : function(component) {
        var actionInit = component.get("c.initApex");
        actionInit.setParams({
            "accountId": component.get("v.recordId")
        });
        actionInit.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = JSON.parse(response.getReturnValue());
                // Recuperación de opciones del picklist
                if(returnValue.success){
                        var opts = [];
                        var options = returnValue.options;

                        if(options.length==0){
                            component.set('v.showErrorBP',true);
                        }else{
                            for(var i=0;i<options.length;i++){
                                opts.push({"class": "optionClass", "label": options[i].label, "value": options[i].value});
                            }
                            var inputsel = component.find("InputSelectDynamic");
                            component.set('v.myListForms',returnValue.options);
                            inputsel.set("v.options", opts);
                        }

                        // Asignación de Contact
                        component.set('v.attContact',returnValue.contact);

                        //RELLENO BPS PARA CLONAR//
                        // Asignación de BPs para dicho contacto
                        var optsBp = [];
                        var accountBPs = returnValue.bps;
                        if(accountBPs.length==0){
                            component.set('v.showErrorBP',true);
                        }else{
                            for(var i=0;i<accountBPs.length;i++){
                                optsBp.push({"class": "optionClass", "label": accountBPs[i].Name, "value": accountBPs[i].Id});
                            }
                            var InputSelectBP = component.find("InputSelectBP");
                            component.set('v.myListBp',returnValue.bps);
                            InputSelectBP.set("v.options", optsBp);    
                        }

                        //FIN RELLENO BPS PARA CLONAR//

                        //RELLENO LISTADO DE BPS CONVERT//
                        var optsBpConver = [];
                        component.set('v.myListBpConver',returnValue.bpsConvert);    
                        //FIN RELLENO LISTADO DE BPS CONVERT//
                } else{
                            var valError = response.getReturnValue();
                            component.set('v.messageErrorServicesMsg',JSON.parse(valError).messageError);
                            component.set('v.showError',true);
                            component.set('v.showErrorServices',true);
                            component.set("v.showNext",false);
                            component.set("v.info",false);
                }
            }
        });
        $A.enqueueAction(actionInit);
    },
    callAvaloq : function(component){

        var changedToAdv = true;
        if(component.find("r0").get("v.value")==true)
           changedToAdv = false;

        var actionCallAvaloq = component.get("c.callApexAvaloqNewForm");
        actionCallAvaloq.setParams({
            "bpId": component.get("v.selectedBP"),
            "contactId": component.get("v.attContact.Id"),
            "formTemplateId": component.get("v.selectedForm"),
            "changedToAdv":changedToAdv
        });
        actionCallAvaloq.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var jsonResponse = JSON.parse(response.getReturnValue());
                if(jsonResponse!=null && jsonResponse.responseId!=null && jsonResponse.bpId!=null){
                    component.set("v.info",false);
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/apex/CRAN_VEC_ADV_CustomForm?id=" + component.get("v.attContact.Id") 
                        + "&BPid=" + component.get("v.selectedBP") 
                        + "&formId=" + jsonResponse.responseId + "&action=new"
                    });
                    urlEvent.fire();    
                }else{
                    var valError = response.getReturnValue();
                    component.set('v.messageErrorServicesMsg',JSON.parse(valError).messageError);
                    component.set('v.showError',true);
                    component.set('v.showErrorServices',true);
                    component.set("v.showNext",true);
                    component.set("v.info",false);
                }

            }
            component.set("v.info",false);
        });
        $A.enqueueAction(actionCallAvaloq);
    }

})