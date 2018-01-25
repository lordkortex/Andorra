({    
    doInit: function(component, event, helper) {  
													
            component.set("v.info", true); 
            helper.helperHeader(component);
            helper.repaintStexForex(component,"true");
														   
										   
		 
    },

    refreshStex : function(component, event, helper) {
        component.set("v.info", true);
        component.set("v.error",false);
        component.set("v.ok",false);
		helper.helperPositionsStex(component,"true");
    }, 

    refreshFxtr : function(component, event, helper) {
        component.set("v.info", true);
        component.set("v.error",false);
        component.set("v.ok",false);
		helper.helperPositionsFxtr(component, "true");
    }, 

    gotoListStex : function(component, event, helper) {
        component.set("v.error",false);
        component.set("v.ok",false);
		helper.helperGotoListStex(component,event, helper);
    },
    
    gotoListFxtr : function(component, event, helper) {
        component.set("v.error",false);
        component.set("v.ok",false);
		helper.helperGotoListFxtr(component,event, helper);
    },

    goBack : function(component, event, helper) {
        component.set("v.ok",false);
		helper.helperGoBack(component,event, helper);
    },
          
	execServiceGet : function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.error",false);
        component.set("v.ok",false);
		helper.helperExecServiceGet(component,"true");
    },

	printPreview : function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.error",false);
        component.set("v.ok",false);
		helper.helperPrintPreview(component);
    },

    execServiceFinal : function(component, event, helper) {
        component.set("v.ok",false);
        // oculto ventana modal
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
        helper.helperExecServiceFinal(component);
    },
    
    execServiceFinalDiscard : function(component, event, helper) {
        component.set("v.ok",false);
        // oculto ventana modal
		component.set("v.info",true);							 
        helper.hidePopupHelper(component, 'modalDiscard', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdropDiscard', 'slds-backdrop--');
        helper.helperExecServiceFinalDiscard(component);
        component.set("v.error",false);
    },

    onCheck : function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.error",false);
        component.set("v.ok",false);
		helper.helperOnCheck(component);
        helper.repaintStexForex(component,"true");
    },  

	confirmService : function(component, event, helper) {
        component.set("v.error",false);
        component.set("v.ok",false);
		component.set("v.info",true);							 
        helper.helperConfirmService(component);
    },  

    checkboxExecStex : function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.error",false);
        component.set("v.ok",false);   
		helper.helperCheckboxExec(component, event, helper, "true","botonExecStex");
    },
    
    checkboxExecFxtr : function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.error",false);
        component.set("v.ok",false);
        helper.helperCheckboxExec(component, event, helper, "true","botonExecFxtr");
    },
    gotoArchive : function(component, event, helper) {
        
        var idOrder_NumOrden = event.getSource().get("v.name");
        var guionIndex = idOrder_NumOrden.indexOf("-");
        var numOrder = idOrder_NumOrden.substring(0, guionIndex);
        var idOrder = idOrder_NumOrden.substring(guionIndex+1, idOrder_NumOrden.length);
        
        component.set("v.info",true);
        component.set("v.error",false); 
        component.set("v.ok",false);       
        helper.helperGotoArchive(component, event, helper, numOrder, idOrder );
    },

    checkOrdersSign : function(component, event, helper){
		component.set("v.info",true);							 
        helper.helpercheckOrdersSign(component);
    },

    checkOrdersDiscard : function(component, event, helper){
		component.set("v.info", true);
        component.set("v.error",false); 							  							
        helper.helpercheckOrdersDiscard(component);
    },

    cancelSing : function(component, event, helper) {
        component.set("v.ok",false);
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
    },

    cancelDiscard : function(component, event, helper) {
        component.set("v.ok",false);
        helper.hidePopupHelper(component, 'modalDiscard', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdropDiscard', 'slds-backdrop--');
    },


    checkboxManualStex: function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.error",false);
        component.set("v.ok",false);
        helper.helperCheckboxManual(component, event, helper, "true","botonManualStex");
    },

    checkboxManualFxtr:function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.error",false);
        component.set("v.ok",false);
        helper.helperCheckboxManual(component, event, helper, "true","botonManualFxtr");
    }

})