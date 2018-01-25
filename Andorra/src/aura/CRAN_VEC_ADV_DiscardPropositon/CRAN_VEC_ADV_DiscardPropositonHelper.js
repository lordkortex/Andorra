({  helperCheckStatus : function(component){

        var opId = component.get("v.recordId");    
        var action = component.get("c.correctOppStatusDiscard");  
       action.setParams({
            "oppId": opId
        });      
       action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                
               var returnValue = response.getReturnValue();
                if(returnValue.success){
                    component.set("v.confirm",true);

                }else{
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                    component.set("v.info",false);
                 }

            }
        });
        $A.enqueueAction(action);
    }, 
  
    helperdiscardOpp :function(component) {  
        component.set("v.info",true);
        component.set("v.confirm",false);
        var opId = component.get("v.recordId");     
		var action = component.get("c.discardOpportunity");  
        action.setParams({
            "objId": opId
        });      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                   component.set("v.info",false);
                   var urlEvent = $A.get("e.force:navigateToURL");
                   urlEvent.setParams({
                        "url": "/one/one.app#/sObject/" + opId + "/view"
                   });                  
                   urlEvent.fire();
                 }else{
                	component.set("v.errorMessage",returnValue.messageError);
                	component.set("v.error",true);
                    component.set("v.info",false);
                 }
             }
        });
        $A.enqueueAction(action);
	} 

})