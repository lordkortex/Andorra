({
    recuperarCuestionariosDone:function(component) {
        var actionGetCuestionariosDone = component.get("c.recuperarCuestionariosDone");
        actionGetCuestionariosDone.setParams({
            "accountId": component.get("v.recordId")
        });
        actionGetCuestionariosDone.setCallback(this, function(response) {
            var InputSelectForm = component.find("InputViewSelectForm");
            var state = response.getState();
            var listForms = [];
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.lstFormResponses != null){
                        listForms.push({"class": "optionClass", "label": " " , "value": "000" });
                        for(var i=0;i<returnValue.lstFormResponses.length;i++){
                                var response = returnValue.lstFormResponses[i];
                                listForms.push({"class": "optionClass", "label": response.Name+ ' -- BP ' +response.CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber, "value": response.CRAN_VEC_ADV_T_Avaloq_External_Id__c});
                        }
                        component.set("v.info",false);
                        InputSelectForm.set("v.options", listForms);
                }else{
                    component.set("v.info",false);
                    component.set('v.errorMessage',returnValue.messageError);
                     component.set("v.error",true);
                    InputSelectForm.set("v.options", listForms);
                }
            }
        });
        $A.enqueueAction(actionGetCuestionariosDone);
    },

    printPdf : function(component) {
        var action = component.get("c.retrieveReferenceLine");
        action.setParams({
            "formId": component.get("v.idFormSelect")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                    var referenceLine = returnValue.referenceLine;
                    var bp = returnValue.bp;
                    component.set("v.info",false);
                    window.open('/apex/CRAN_VEC_ADV_PrintRestPDF?documentType=ARCHIVE&referenceLine='+referenceLine,'_blank');
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                       "url": "/one/one.app#/sObject/"+component.get("v.recordId")+"/view"
                    });
                    urlEvent.fire();
                }else {
                    component.set("v.info",false);
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                }
           }
       });
       $A.enqueueAction(action);
    }
})