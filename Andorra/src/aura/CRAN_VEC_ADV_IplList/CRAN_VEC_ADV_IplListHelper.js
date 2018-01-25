({
	Positions : function(component) {
        var rec    = 0;
        var action = component.get("c.DataList");
        action.setParams({ 
            "recordId"  : component.get("v.recordId"),
            "nKey"      : component.get("v.nKey"),
            "aFilter"   : component.get("v.aFilter"),
            "objectName": component.get("v.objectName")            
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state=='SUCCESS') {
                var respuesta = response.getReturnValue(); 
                if(!$A.util.isEmpty(respuesta) && !$A.util.isUndefined(respuesta)) {
                    rec = respuesta.length-1;
                	component.set("v.lstPositions",respuesta);                                                           
            	}                    
            }
            component.set("v.nRecs", rec);
            component.set("v.scroller", ( rec >= 8 ) );
            component.set("v.nHeading", $A.get("$Label.c.CRAN_VEC_ADV_IP_Lines") + " (" + rec.toString() + ")");
            component.set("v.info", false);

        });
        $A.enqueueAction(action);
    },

    Header: function(component, event, helper) {
        var action = component.get("c.showHeader");
        action.setParams({ 
            "recordId"  : component.get("v.recordId")         
        });
        console.log('recordId: ' + component.get("v.recordId"));
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

    editRecord : function(component, event, helper) {
        var editRec = $A.get("e.force:editRecord");
        var selectedItem = event.currentTarget;
        var subRecordId  = selectedItem.dataset.record;    
        editRec.setParams({
            "recordId": subRecordId
        });            
        editRec.fire();
    },     
    
    gotoList : function(component, event, helper) {
        var cmpName    = "";        
        var objectName = component.get("v.objectName");
        var nKey       = component.get("v.nKey");        
        if (nKey == "CRAN_VEC_ADV_Investment_Proposition_Line__c.CRAN_VEC_ADV_L_Proposition__c") {
            cmpName = "c:CRAN_VEC_ADV_oppIPLList";  
        } else {
            cmpName = "c:CRAN_VEC_ADV_qteIPLList";
        }                                              
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: cmpName,
            componentAttributes: {
            	"recordId"  : component.get("v.recordId"),
                "objectName": component.get("v.objectName"),
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