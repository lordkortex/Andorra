({
	init : function (component, event, helper) {
        //Get Record Types available
        var actionGetRT = component.get("c.getAvailableRecordTypes");
        
        actionGetRT.setParams({
            sObjectApiName: component.get("v.sObjectApiName")
        });
        
        actionGetRT.setCallback(this, function(response) {
            helper.processGetRT(response, component, event, helper)
        });
        
        $A.enqueueAction(actionGetRT);          
    },
    processGetRT : function (response, component, event, helper) {
        var state = response.getState();
        if (state === "SUCCESS") {            
            
            var rtList = new Array();
            var mapOfValues = response.getReturnValue();
            
            var selectRecType 	= component.find("selectedRT"); 

            //Create the result as List<Map<String,String>> 
            //with recordType Id as value
            var key;
            for (key in mapOfValues) {
                var fieldValue = mapOfValues[key];          
                rtList.push({value:mapOfValues[key],key:key});
            }

			selectRecType.set("v.value", rtList[0].value);            
            component.set("v.recordTypesAvailable", rtList); 
        }else{
            console.log("ERROR");
        }        
    },
    createRecord : function (component, event, helper) {
    
		var createRecordEvent 	= $A.get("e.force:createRecord");
        var selectedRecordType 	= component.find("selectedRT").get("v.value");       

        createRecordEvent.setParams({
            "entityApiName": component.get("v.sObjectApiName"),
        	"recordTypeId": selectedRecordType
        });
        createRecordEvent.fire();
    }
})