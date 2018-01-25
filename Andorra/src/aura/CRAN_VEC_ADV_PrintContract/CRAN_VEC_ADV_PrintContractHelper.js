({
    printContract : function (component){
        var recordId = component.get("v.recordId");
        var action = component.get("c.retrieveReferenceLine");
        action.setParams({
            "oppId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                    var referenceLine = returnValue.referenceLine;
                    var bp = returnValue.bp == undefined ? '' : returnValue.bp;
                    var orderNr = returnValue.orderNr;
                    window.open('/apex/CRAN_VEC_ADV_PrintRestPDF?documentType=ARCHIVE&referenceLine='+referenceLine+'&archiveBp='+bp+'&orderNr='+orderNr,'_blank');
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