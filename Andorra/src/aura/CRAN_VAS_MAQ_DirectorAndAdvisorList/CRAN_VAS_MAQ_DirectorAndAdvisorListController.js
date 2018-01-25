({
	doInit : function(component, event, helper) {
        
        
        // $Label.c.CRAN_VAS_MAQ_CampaignMembers
        // $Label.c.CRAN_VAS_KER_GoalPluralLabel
        // $Label.c.CRAN_VAS_KER_Sales
        var title = component.get("v.cpTitle");
        component.set("v.cpTitle", $A.getReference("$Label.c." + title));        
        
		var params1 = {
            "recordId" 		: component.get("v.recordId"),
            "fieldNames"	: component.get("v.directorFieldNames"),
            "displayType"	: "userRecords",
            "displayLimit"	: ""+component.get("v.directorRowsLimit"),
            "vision"		: component.get("v.vision")
        };
        
        var params2 = {
            "recordId" 		: component.get("v.recordId"),
            "fieldNames"	: component.get("v.advisorFieldNames"),
            "displayType"	: "advisorRecords",
            "displayLimit"	: ""+ component.get("v.advisorRowsLimit"),
            "vision"		: component.get("v.vision")
        };  
        
        var params3 = {
            "recordId" 		: component.get("v.recordId"),
            "fieldNames"	: component.get("v.officeFieldNames"),
            "displayType"	: "officeRecords",
            "displayLimit"	: ""+ component.get("v.officeRowsLimit"),
            "vision"		: component.get("v.vision")
        };  
        
        var recId = component.get("v.recordId");
        
        var action 	= component.get("c.getSobjectLabel");
        
        action.setParams({
            "recordId"	: recId
        }); 
        
        var label;
        var name;
        var apiName;
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
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
 
            $A.createComponents(
                [
                    ["c:CRAN_VAS_KER_DataTables",
                     {
                         "provider"			: component.get("v.directorProvider"),
                         "showTitle"		: false,
                         "iconName"			: component.get("v.iconName"),
                         "params"			: params1,
                         "showPagination"	: false,
                         "lengthChange"		: false,
                         "showPagination"	: false,
                         "showInfo"			: false,
                         "breadCrumb"		: breadCrumb,
                         "cpTitle"			: component.get("v.cpTitle"),
                    	 "showActionButtons": component.get("v.showActionButtons")
                     }],
                    ["c:CRAN_VAS_KER_DataTables",
                     {
                         "provider"			: component.get("v.advisorProvider"),
                         "showTitle"		: false,
                         "iconName"			: component.get("v.iconName"),
                         "params"			: params2,
                         "showPagination"	: false,
                         "lengthChange"		: false,
                         "showPagination"	: false,
                         "showInfo"			: false,
                         "breadCrumb"		: breadCrumb,
                         "cpTitle"			: component.get("v.cpTitle"),
                    	 "showActionButtons": component.get("v.showActionButtons")
                     }],
                    ["c:CRAN_VAS_KER_DataTables",
                     {
                         "provider"			: component.get("v.officeProvider"),
                         "showTitle"		: false,
                         "iconName"			: component.get("v.iconName"),
                         "params"			: params3,
                         "showPagination"	: false,
                         "lengthChange"		: false,
                         "showPagination"	: false,
                         "showInfo"			: false,
                         "breadCrumb"		: breadCrumb,
                         "cpTitle"			: component.get("v.cpTitle"),
                    	 "showActionButtons": component.get("v.showActionButtons")
                     }] 
                ],
                function(newComponents, status, errorMessage) {
                    //Add the new button to the body array
                    if (status === "SUCCESS") {
                        var container	 	= component.find("userContainer");
                        var containerBody	= container.get("v.body");
                        containerBody.push(newComponents[0]);
                        container.set("v.body", containerBody);
                        
                        container	 	= component.find("advisorContainer");
                        containerBody	= container.get("v.body");
                        containerBody.push(newComponents[1]);
                        container.set("v.body", containerBody);
                        
                        container	 	= component.find("officeContainer");
                        containerBody	= container.get("v.body");
                        containerBody.push(newComponents[2]);
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
	}
})