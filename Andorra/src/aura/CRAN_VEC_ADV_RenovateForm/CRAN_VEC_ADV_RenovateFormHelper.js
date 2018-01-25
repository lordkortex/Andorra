({
	doInit :function(component) {
        var actionInit = component.get("c.initApex");
        actionInit.setParams({
            "accountId": component.get("v.recordId")
        });
        actionInit.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = JSON.parse(response.getReturnValue());
                // Asignación de Contact
                component.set('v.attContact',returnValue.contact);

                // Asignación de BPs para dicho contacto
                var optsBp = [];
                var accountBPs = returnValue.bps;
                optsBp.push({"class": "optionClass", "label": " ", "value": "000"});

                if(accountBPs.length<2){
                    component.set('v.showErrorBP',true);
                }else{

                    for(var i=1;i<accountBPs.length;i++){
                        optsBp.push({"class": "optionClass", "label": accountBPs[i].Name, "value": accountBPs[i].AccountNumber});
                    }
                    var InputSelectBP = component.find("InputSelectBP");
                    InputSelectBP.set("v.options", optsBp);
                }

                if(accountBPs.length<2)
                   component.set("v.step",4);
            }
        });
        $A.enqueueAction(actionInit);
    },

    recuperarCuestionarios:function(component) {
        var actionGetCuestionariosRespond = component.get("c.recuperarCuestionariosRespond");
        actionGetCuestionariosRespond.setParams({
            "bpId": component.find("InputSelectBP").get("v.value")
        });
        actionGetCuestionariosRespond.setCallback(this, function(response) {
            var listForms = [];
            var state = response.getState();
            var InputSelectForm = component.find("InputSelectForm");

            if(component.isValid() && state == "SUCCESS"){
                var returnValue = JSON.parse(response.getReturnValue());
                if(returnValue!=null && returnValue.hasOwnProperty("objList") && 
                    returnValue.objList!= null && returnValue.errors==null){
                    var formsAvaloq = returnValue.objList[0].obj;
                    if(formsAvaloq.length!=0){
                        listForms.push({"class": "optionClass", "label": " " , "value": "000" });
                        for(var i=0;i<formsAvaloq.length;i++){
                            listForms.push({"class": "optionClass", "label": formsAvaloq[i].avqId+' '+formsAvaloq[i].version, "value": formsAvaloq[i].avqId});
                        }
                        InputSelectForm.set("v.options", listForms);
                        component.set("v.info",false);
                    } else{
                        InputSelectForm.set("v.options", listForms);
                        component.set("v.info",false);
                        component.set('v.showErrorBP',true);
                    }

                } else if(returnValue.hasOwnProperty("errors") && returnValue.errors!=null){
                    InputSelectForm.set("v.options", listForms);
                    component.set("v.info",false);
                    component.set('v.messageErrorServicesMsg',returnValue.errors);
                    component.set('v.showErrorServices',true);

                } else if(returnValue.hasOwnProperty("messageError")){
                    InputSelectForm.set("v.options", listForms);
                    component.set("v.info",false);
                    component.set('v.messageErrorServicesMsg',returnValue.messageError);
                    component.set('v.showErrorServices',true);
                } else{
                    InputSelectForm.set("v.options", listForms);
                    component.set("v.info",false);
                    component.set('v.messageErrorServicesMsg','error desconocido');
                    component.set('v.showErrorServices',true);
                }
            }
        });
        $A.enqueueAction(actionGetCuestionariosRespond);
    },

    crearOrdenModificacionCuestionario:function(component) {
        var actioncrearOrdenModificacionFormRespond = component.get("c.crearOrdenModificacionCuestionarioRespond");
        
        actioncrearOrdenModificacionFormRespond.setParams({
            "mybpIdAvaloq": component.get("v.selectedBP"),
            "myIdAccount": component.get("v.recordId"),
            "contactId": component.get("v.attContact.Id"),
            "formValueSelected": component.get("v.idFormSelect")
        });

        actioncrearOrdenModificacionFormRespond.setCallback(this, function(response) {

            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = JSON.parse(response.getReturnValue());
                if(returnValue!=null && returnValue.hasOwnProperty("solService")){
                    component.set("v.info",false);
                    var solService = JSON.parse(returnValue.solService);
                    if(solService.errors==null){
                        if(solService.hasOwnProperty("order")){
                            // Funcionamiento correcto
                            component.set("v.stepDisable","notDisable"); 
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                            "url": "/apex/CRAN_VEC_ADV_CustomForm?id=" + component.get("v.attContact.Id") 
                            + "&BPid=" + component.get("v.selectedBP") 
                            + "&formId=" + returnValue.idForm + "&action=new"
                            });
                            urlEvent.fire();
                        } 
                    } else{
                            component.set('v.messageErrorServicesMsg',solService.errors);
                            component.set('v.showErrorServices',true);
                    }

                }else if(returnValue.hasOwnProperty("messageError")){
                    component.set("v.info",false);
                    component.set('v.messageErrorServicesMsg',returnValue.messageError);
                    component.set('v.showErrorServices',true);

                } else{
                    component.set("v.info",false);
                    component.set('v.messageErrorServicesMsg','error desconocido');
                    component.set('v.showErrorServices',true);
                }           
            }
        });
        $A.enqueueAction(actioncrearOrdenModificacionFormRespond);
    },



    descartarForm:function(component) {
        var actiondescartarOrdenCuestionario = component.get("c.descartarOrdenCuestionarioRespond");
        actiondescartarOrdenCuestionario.setParams({
            "mybpIdAvaloq": component.get("v.selectedBP"),
            "myIdOrdenHold": component.get("v.idOrderHoldToDiscard"),
            "contactId": component.get("v.attContact.Id"),
            "formValueSelected": component.get("v.idFormSelect")
        });
        actiondescartarOrdenCuestionario.setCallback(this, function(response) {

            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = JSON.parse(response.getReturnValue());

                if(returnValue!=null && returnValue.orderList!=null && returnValue.errors==null){

                var urlEvent = $A.get("e.force:navigateToURL");

                urlEvent.setParams({
                        "url": "/apex/CRAN_VEC_ADV_CustomForm?id=" + component.get("v.attContact.Id") 
                        + "&BPid=" + component.get("v.selectedBP") 
                        + "&formId=" + returnValue.idForm + "&action=new"
                        });
                urlEvent.fire();     

                }else{
                    var valWarning = response.getReturnValue();
                    component.set('v.messageErrorServicesMsg',JSON.parse(valWarning).messageError);
                    component.set('v.showErrorServices',true);
                }
            }
        });
        $A.enqueueAction(actiondescartarOrdenCuestionario);
    }
})