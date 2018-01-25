({
	refreshPositions : function(component) {
        var action = component.get("c.queryDataInvestment");
        action.setParams({
            "objId"  : component.get("v.recordId"),
            "nKey"      : component.get("v.nKey"),
            "aFilter"      : component.get("v.aFilter"),
            "childSObjectName": component.get("v.childSObjectName"),
            "noExecCall": component.get("v.viewAll")
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state=='SUCCESS') {
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                    var rec  = returnValue.lstDataInvestment.length-1;
                    component.set("v.scroller",(rec>=8));
                    component.set("v.lstPositions",returnValue.lstDataInvestment);
                    component.set("v.nRecs",rec);
                    console.log('returnValue: ' + returnValue);
                    if(returnValue.error){
                        component.set("v.info",false);
                        component.set("v.errorMessage",returnValue.error.messageError);
                        component.set("v.errorResponse",returnValue.error);
                        component.set("v.severityMessage",'error');
                        component.set("v.error",true);
                    }else if(returnValue.lstChangedOpportunities != null && returnValue.lstChangedOpportunities.length>0){
                        var array = returnValue.lstChangedOpportunities;
                        var messageInfo = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_Changed_To_Sign_Opps");
                        var secLabel = $A.get("$Label.c.CRAN_VEC_ADV_IP_FieldChanged");
                        for(var i = 0; i < array.length; i++){
                            messageInfo += '<br/>&nbsp;&nbsp;&nbsp;&nbsp;---> <b>' + array[i].sfName+'</b>';
                            messageInfo += '&nbsp;'+secLabel;
                            var arrayF = array[i].lstchangedFields;
                            for(var u = 0; u < arrayF.length; u++){
                                messageInfo += ' <b>'+arrayF[u].fieldName+'</b>,&nbsp;';
                            }
                            messageInfo = messageInfo.slice(0,-7);
                        }
                        component.set("v.info",false);
                        component.set("v.errorMessage",messageInfo);
                        component.set("v.severityMessage",'info');
                        component.set("v.error",true);
                    }else{
                        component.set("v.info",false);
                        component.set("v.errorMessage","");
                        component.set("v.severityMessage",'info');
                        component.set("v.error",false);
                    }
                }else {
                    component.set("v.info",false);
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.errorResponse",returnValue);
                    component.set("v.severityMessage",'error');
                    component.set("v.error",true);
                }                    
            } 
            component.set("v.info", false);
        });
        $A.enqueueAction(action);
    },
    
    /*
    Para los registros de tipo Opportunity antes de redireccionar al objeto salesforce es necesario actualizar los objetos hijos dependientes
    */
    updateRecord : function (component, event, helper) {
        var selectedItem = event.currentTarget;
        var subRecordId  = selectedItem.dataset.record;  
        var action = component.get("c.updateRecordData");
        action.setParams({ 
            "recordId"  : subRecordId          
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state=='SUCCESS') {
                var respuesta = response.getReturnValue();
                if(respuesta.success && respuesta.msj == null){
                    //Si la respuesta es correcta navegamos a la oportunidad con los datos actualizados
                    this.gotoRecordId(subRecordId);
                    component.set("v.info",false);
                }else if(respuesta.success && respuesta.msj != null){
                    component.set("v.selectedOpp",subRecordId);
                    component.set("v.info",false);
                    component.set("v.errorMessage",respuesta.msj);
                    component.set("v.errorResponse",respuesta);
                    component.set("v.severityMessage",'error');
                    component.set("v.shownext",true); 
                    component.set("v.error",true);
                }else{
                    component.set("v.info",false);
                    component.set("v.errorMessage",respuesta.messageError);
                    component.set("v.errorResponse",respuesta);
                    component.set("v.severityMessage",'error');
                    component.set("v.error",true);   
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    gotoRecord : function (component, event, helper) {
        var gotoRec      = $A.get("e.force:navigateToSObject");
        var selectedItem = event.currentTarget;
        var subRecordId  = selectedItem.dataset.record;  
        gotoRec.setParams({
            "recordId": subRecordId
        });            
        gotoRec.fire();
    },

    gotoOpp : function (component) {
        var gotoRec      = $A.get("e.force:navigateToSObject");
        var subRecordId  = component.get("v.selectedOpp");  
        gotoRec.setParams({
            "recordId": subRecordId
        });            
        gotoRec.fire();
    },

    Header: function(component, event, helper) {
        var action = component.get("c.showHeader");
        action.setParams({ 
            "recordId"  : component.get("v.recordId")         
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state=='SUCCESS') {
                var respuesta = response.getReturnValue(); 
                if(!$A.util.isEmpty(respuesta) && !$A.util.isUndefined(respuesta)) {
                	component.set("v.nHeader",respuesta);
            	}                    
            }                
        });
        $A.enqueueAction(action);
    },
    
    gotoRecordId : function (recordId) {
        var gotoRec = $A.get("e.force:navigateToSObject");
        gotoRec.setParams({
            "recordId" : recordId
        });
        gotoRec.fire();
    },

    gotoList : function(component, event, helper) {       
        var evt     = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:CRAN_VEC_ADV_RetrOppList",
            componentAttributes: {                   
            	"recordId"  : component.get("v.recordId"),
                "objectName": component.get("v.childSObjectName"),
                "nKey"      : component.get("v.nKey"),
                "aFilter"   : component.get("v.aFilter"),                
                "viewAll"   : true
            }
        });
        evt.fire();
    },
    
    goBack : function(component, event, helper) {        
        var gotoUrl  = '/one/one.app#/sObject/' + component.get("v.recordId") + '/view?';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": gotoUrl
        });
        urlEvent.fire();
    },   
})