({
    doInit : function(component, event, helper) {
        helper.doInit(component);
    },
    callAvaloq : function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.showNext",false);
        component.set('v.showErrorServices',false);
        helper.callAvaloq(component);
    },
    cancel : function(component, event, helper) {
        // Close the action panel
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
    },
    changeListToConvert : function(component, event, helper) {
        //cambio radiobuttom seleccionado
        var resultConvert = component.find("r1");
        resultConvert.set("v.value", true);

        var resultClone = component.find("r0");
        resultClone.set("v.value", false);

        //relleno listado de bps a mostrar
        var responsesConver = component.get("v.myListBpConver");
        var optsBp = [];
        if(responsesConver.length==0){
            component.set('v.showErrorBP',true);
        }else{
             for(var i=0;i<responsesConver.length;i++){
                optsBp.push({"class": "optionClass", "label": responsesConver[i].Name, "value": responsesConver[i].Id});
             }
             var InputSelectBP = component.find("InputSelectBP");
             InputSelectBP.set("v.options", optsBp);    
        } 
    },
    changeListToClone : function(component, event, helper) {
        //cambio radiobuttom seleccionado
        var resultConvert = component.find("r1");
        resultConvert.set("v.value", false);

        var resultClone = component.find("r0");
        resultClone.set("v.value", true);

        //relleno listado de bps a mostrar
        var responses = component.get("v.myListBp");
        var optsBp = [];
        if(responses.length==0){
            component.set('v.showErrorBP',true);
        }else{
             for(var i=0;i<responses.length;i++){
                optsBp.push({"class": "optionClass", "label": responses[i].Name, "value": responses[i].Id});
             }
             var InputSelectBP = component.find("InputSelectBP");
             InputSelectBP.set("v.options", optsBp);    
        }        
    }
        
})