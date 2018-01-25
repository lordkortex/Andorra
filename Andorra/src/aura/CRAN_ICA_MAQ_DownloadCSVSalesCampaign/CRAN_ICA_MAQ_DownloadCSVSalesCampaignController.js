({

    doInit : function(component, event, helper) {
        //Muestra o noel componente dependiendo de si es SistematicaComercial
    	var action 	= component.get("c.isSistematicaComercialRecordType");
        
        action.setParams({
            "recordId"	:	component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
				component.set("v.isDistintoSistematicaComercial", response.getReturnValue());
            }else if (state === "ERROR") {

            }
        });    
		$A.enqueueAction(action); 
        
    },
    
    getFile : function(component, event, helper) {
		
        
        var action 	= component.get("c.getRecords");
        
        action.setParams({
            "recordId"	:	component.get("v.recordId")
        });
        
        //helper.showSpinner(component);
        
        action.setCallback(this, function(response) {
            /*var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
				
                var dataReceived = JSON.parse(response.getReturnValue());
                var columnNames = ['campaignName','name','bp','status','advisor','ramo','totalOpportunity','amount','idOperacionComercial','accountName','closeDate','recordTypeName'];
                var csv = helper.convertArrayOfObjectsToCSV(dataReceived, columnNames); 
                helper.makeDownload(csv);  
                helper.hideSpinner(component);
                
            }else if (state === "ERROR") {
                helper.hideSpinner(component);
            }*/
            
            		var titleLabel = $A.get("$Label.c.CRAN_ICA_MAQ_ProcesandoSalesCampaign");

                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({ //
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