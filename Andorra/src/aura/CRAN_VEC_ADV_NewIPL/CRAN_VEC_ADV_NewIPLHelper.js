({  
    doInit : function (component, recoId){
        var action = component.get("c.checkQuoteStatus");
        action.setParams({
            "quoId": recoId,
        });
        action.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state == "SUCCESS"){
                    var returnValue = response.getReturnValue();
                    if(!returnValue.success){
                        var toogleComponent = component.find("outerdiv");
                        $A.util.toggleClass(toogleComponent, "toggle");
                        component.set("v.errorMessage",returnValue.messageError);
                        component.set("v.error",true);
                        component.set("v.successMessage","");
                        component.set("v.success",false);
                        var urlEvent =  $A.get("e.force:closeQuickAction");
                    }else {
                        var toogleComponent = component.find("outerdiv");
                        $A.util.removeClass(toogleComponent, "toggle");
                    }
               }
           });
           $A.enqueueAction(action); 
    },
    
    createIPL : function (component, ipl) {
        var action = component.get("c.saveIPL");
        var quoId = component.get("v.recordId");
        var assetId = component.get("v.Id");
        var noIPLm = component.get("v.noIPLMessage");
        var noValuesSelected = component.get("v.noInput");
        var fQua = component.get("v.extraQuantity");
        var fMav = component.get("v.extraMarket");
        var fPq = component.get("v.extraPercentage");
        
        if(!assetId){
            component.set("v.errorMessage", noIPLm);
            component.set("v.error",true);
        } else if (!fQua && !fMav && !fPq){
            component.set("v.errorMessage", noValuesSelected);
            component.set("v.error",true);
        } else {
            action.setParams({
                "iplToSave": ipl,
                "quoId": quoId,
                "assetId": assetId,
                "fQua" : fQua,
                "fMav" : fMav,
                "fPq" : fPq
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if(component.isValid() && state == "SUCCESS"){
                    var returnValue = response.getReturnValue();
                    if(returnValue.success){
                        component.set("v.errorMessage","");
                        component.set("v.error",false);
                        component.set("v.successMessage",returnValue.messageSuccess);
                        component.set("v.success",true);
                        var urlEvent =  $A.get("e.force:closeQuickAction");
                        setTimeout(function(){
                            urlEvent.fire();
                        }, 1500);
                    }else {
                        component.set("v.errorMessage",returnValue.messageError);
                        component.set("v.error",true);
                        component.set("v.assetId","");
                   }
               }
           });
           $A.enqueueAction(action);         
        }
	 }    
})