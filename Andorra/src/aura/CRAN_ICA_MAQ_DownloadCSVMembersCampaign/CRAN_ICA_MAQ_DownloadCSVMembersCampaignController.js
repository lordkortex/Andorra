({

      getFile : function(component, event, helper) {
		
        
        var action 	= component.get("c.getRecords");
        
        action.setParams({
            "recordId"	:	component.get("v.recordId")
        });
        
        
        action.setCallback(this, function(response) {
           
            		var titleLabel = $A.get("$Label.c.CRAN_ICA_MAQ_ProcesandoSalesCampaign");
                    
            		var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": titleLabel,
                        "message": " "
                    });

                    // Update the UI: close panel, show toast, refresh account page
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
            
            
            		component.find("getFileButton").set("v.disabled", true);
           
        });
        
        $A.enqueueAction(action);        
       
	}  
})