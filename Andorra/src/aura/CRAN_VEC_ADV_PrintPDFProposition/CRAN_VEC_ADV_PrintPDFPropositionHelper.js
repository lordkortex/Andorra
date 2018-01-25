({
    cmdPrintPreview : function (component){
        var recoId = component.get("v.recordId");
        var action = component.get("c.printPreview");

        action.setParams({
            "objId": recoId
        });
 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                    var omsID = returnValue.omsID
                    window.open('/apex/CRAN_VEC_ADV_PrintRestPDF?documentType=OMS&documentId='+omsID,'_blank');
                    $A.get("e.force:closeQuickAction").fire();
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