({
	doInit : function(component, event, helper) {
	

        var action 	= component.get("c.getSobjectLabel");
        var recId 	= component.get("v.recordId");
		
        action.setParams({
            "recordId"	: recId
        }); 
        		
        action.setCallback(this, function(response) {
            
            var state = response.getState();
			var label;
			var name;
			var apiName;            
			
            if (component.isValid() && state === "SUCCESS") { 
            	var parsedResponse = JSON.parse(response.getReturnValue());       
                label = parsedResponse[0];
                name = parsedResponse[1];
                apiName = parsedResponse[2];
            } else if (state === "ERROR") {
                label = "SOBJECT";
                name = "";
                apiName = "";
            }
            
            var breadCrumb = {
                "id" 	: recId,
                "label" : label,
                "name"	: name,
                "apiName": apiName
            }

			var params = {
				"recordId" 				: recId,
				"displayLimit"			: ""+component.get("v.displayLimit"),
				"sObjectApiName"		: component.get("v.sObjectApiName"),
				"listViewName"			: component.get("v.listView"),
				"strFieldApiNames"		: component.get("v.strFieldApiNames"),
				"parentFieldApiName"	: component.get("v.parentFieldApiName"),      
				"childFieldApiName"		: component.get("v.childFieldApiName"),                        
		   };
				
		  $A.createComponent(
				  "c:CRAN_VAS_KER_DataTables",
					{
						"provider"			: "CRAN_VAS_KER_FilterListViewProvider_CLS",
						"showTitle"			: false,
						"iconName"			: component.get("v.iconName"),
						"params"			: params,
						"showPagination"	: false,
						"searching"			: true,
						"lengthChange"		: false,
						"showPagination"	: false,
						"showInfo"			: false,
						"showActionButtons" : component.get("v.showTableActionButtons"),
						"breadCrumb"		: breadCrumb,
						"cpTitle"			: component.get("v.title")
					},
				function(newComponent, status, errorMessage) {
					//Add the new button to the body array
					if (status === "SUCCESS") {
						
						var container	 	= component.find("filterListViewContainer");
						var containerBody	= container.get("v.body");
						
						containerBody.push(newComponent);
						container.set("v.body", containerBody);
				
					} else if (status === "INCOMPLETE") {
						console.log("No response from server or client is offline.")
						// Show offline error
					} else if (status === "ERROR") {
							console.log("Error: " + errorMessage);
							// Show error message
					}
				}
			);	  
            
        });
        
        $A.enqueueAction(action);

	
		helper.init(component,event,helper); 
	},
    createRecord : function (component, event, helper) {
        helper.createRecord(component, event, helper);
    },
    openNewModal : function(component, event, helper) {
        //find modal using aura id
        var modal = component.find("newDialog");
        var modalBackdrop = component.find("newDialog-Back");

        // Now add and remove class
        $A.util.addClass(modal, 'slds-fade-in-open');
        $A.util.addClass(modalBackdrop, 'slds-fade-in-open');
    },
    closeNewModal : function(component, event, helper) {
       //find modal using aura id
        var modal = component.find("newDialog");
        var modalBackdrop = component.find("newDialog-Back");
        
        // Now add and remove class
        $A.util.removeClass(modal, 'slds-fade-in-open');
        $A.util.removeClass(modalBackdrop, 'slds-fade-in-open'); 
    },
    updateDatatablesInfo : function(component, event) {

    	var resultSizeEl 	= component.find("resultSize").getElement();
    	var info 			= event.getParam("info");
    	var showNewButton	= component.get("v.showNewButton");

    	if (info != undefined)
    		resultSizeEl.innerHTML = info.resultSize;
        
    	if (showNewButton && info.isCreateable) {

    		$A.createComponent(
			    "lightning:button",
			    {
				    "label": $A.get("$Label.FinServ.Button_Label_New"),
				    "onclick": component.getReference("c.openNewModal")
			    },
			    function(newButton) {
					var newButtonContainer 	= component.find("newButtonContainer");
					var containerBody		= newButtonContainer.get("v.body");
					containerBody.push(newButton);
					newButtonContainer.set("v.body", containerBody);					
			
			});
		}
    	
    }
})