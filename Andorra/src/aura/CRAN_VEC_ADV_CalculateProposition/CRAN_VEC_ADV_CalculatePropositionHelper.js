({    
    /*doInit :function(component) {
    	component.set("v.error",false);
		var action = component.get("c.calcProp");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "printMode": "none"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                   var urlEvent = $A.get("e.force:navigateToURL");
                   urlEvent.setParams({
                        "url": "/one/one.app#/sObject/" + component.get("v.recordId") + "/view"
                   });
                   urlEvent.fire();
                 } else {
                    component.set("v.info",false);
                	component.set("v.errorMessage",returnValue.messageError);
                	component.set("v.error",true);
                 }
            } else {
                component.set("v.info",false);
                component.set("v.errorMessage",state);
                component.set("v.error",true);
            }
        });
        $A.enqueueAction(action);
	}   */ 


    doInit :function(component) {
        component.set("v.error",false);
        var action = component.get("c.haveRestrictionsDifValDoInit");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "printMode": "none"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                   var urlEvent = $A.get("e.force:navigateToURL");
                   urlEvent.setParams({
                        "url": "/one/one.app#/sObject/" + component.get("v.recordId") + "/view"
                   });
                   urlEvent.fire();
                 } else if(returnValue.difRestriction==true){
                    component.set("v.info",false);
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                    component.set("v.showButtons",true);
                 } else {
                    component.set("v.info",false);
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                 }
            } else {
                component.set("v.info",false);
                component.set("v.errorMessage",state);
                component.set("v.error",true);
            }
        });
        $A.enqueueAction(action);
    },
    
    doCalculate :function(component) {
        component.set("v.error",false);
        var actionCalc = component.get("c.calcProp");
        actionCalc.setParams({
            "recordId": component.get("v.recordId"),
            "printMode": "none"
        });
        actionCalc.setCallback(this, function(response) {
            var state = response.getState();
            
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                   var urlEvent = $A.get("e.force:navigateToURL");
                   urlEvent.setParams({
                        "url": "/one/one.app#/sObject/" + component.get("v.recordId") + "/view"
                   });
                   urlEvent.fire();
                 } else if(returnValue.difRestriction==true){
                    component.set("v.info",false);
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                 } else {
                    component.set("v.info",false);
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                 }
            } else {
                component.set("v.info",false);
                component.set("v.errorMessage",state);
                component.set("v.error",true);
            }
        });
        $A.enqueueAction(actionCalc);
    }

})