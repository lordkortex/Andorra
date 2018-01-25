({
	Positions : function(component) {
        var txt     = '';
        var rec     = 0;
        var objName = component.get("v.objectName");
        var action  = component.get("c.DataList");
        action.setParams({ 
            "recordId"  : component.get("v.recordId"),
            "nKey"      : component.get("v.nKey"),
            "aFilter"      : component.get("v.aFilter"),
            "objectName": component.get("v.objectName")            
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state=='SUCCESS') {
                var respuesta = response.getReturnValue(); 
                if(!$A.util.isEmpty(respuesta) && !$A.util.isUndefined(respuesta)) {
                    rec = respuesta.length-1;
                	component.set("v.lstData",respuesta);                                        
                    if ( objName=='Quote' ) {
                        txt = $A.get("$Label.c.CRAN_VEC_ADV_IP_Versions");    
                    } else if ( objName=='CRAN_VEC_ADV_IPL_Restriction__c' ) {
                        txt = $A.get("$Label.c.CRAN_VEC_ADV_IP_Restrictions");    
                    } 
                    
            	}                    
            }
            component.set("v.nRecs", rec);
            component.set("v.scroller", ( rec >= 8 ) );
            component.set("v.nHeading", txt + " (" + rec.toString() + ")");
            component.set("v.info", false);

        });
        $A.enqueueAction(action);
    },
   
    gotoRecord : function (component, event, helper) {
            var gotoRec = $A.get("e.force:navigateToSObject");
            var selectedItem = event.currentTarget;
            var subRecordId  = selectedItem.dataset.record;    
            gotoRec.setParams({
                "recordId": subRecordId
            });            
            gotoRec.fire();
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
    
    gotoList : function(component, event, helper) {
        var cmpName    = "";        
        var objectName = component.get("v.objectName");
        var nKey       = component.get("v.nKey");        
        if  ( objectName == "Quote" ) {
            cmpName = "c:CRAN_VEC_ADV_oppQuoteList";
        } else if ( objectName == "CRAN_VEC_ADV_IPL_Restriction__c" ) {
            cmpName = "c:CRAN_VEC_ADV_qteRestrictionList";
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