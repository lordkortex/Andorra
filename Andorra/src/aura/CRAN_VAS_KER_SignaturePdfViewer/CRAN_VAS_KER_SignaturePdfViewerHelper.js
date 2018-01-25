({
	 callApexMethod : function(component) 
	 {
	    var action = component.get("c.getContentDocumentBySignature");
	
	    action.setParams({        
	        orderNr			:   component.get("v.strOrderNr"),
	        BP				: 	component.get("v.strBP"),
	        referenceLine	:	component.get("v.strReferenceLine")
	    });
	
	    action.setCallback(this, function(a) {
	        if (a.getState() === "SUCCESS") {
	            component.set("v.pdfData", a.getReturnValue());
	        } else if (a.getState() === "ERROR") {
	            $A.log("Errors", a.getError());
	        }
	    });
	
	    $A.enqueueAction(action);
	 }  
})