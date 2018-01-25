({
	doInit : function(component, event, helper) {
        helper.loadFieldNames(component);
        helper.loadPolicyHolder(component);
        
		var action = component.get("c.getFinAccountData");
        action.setParams({"finAccId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.Fin_Account_Data", response.getReturnValue());
                
                var statusText = component.get("v.Fin_Account_Data.FinServ__FinancialAccount__r.FinServ__Status__c");
                var numUnpaidInvoices = parseInt(component.get("v.Fin_Account_Data.FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c"));

                var isValid = false;
                var isCanceled = false;
                var isReduced = false;
                var isHeld = false;       
                var isNew = false;       
                var isInvoiceValid = true;
                
                if (statusText == 'Valid' || statusText == 'Vigente'){
                    isValid = true;
                }
                if (statusText == 'Cancelled' || statusText == 'Anulada'){
                    isCanceled = true;
                }
                if (statusText == 'Reduced' || statusText == 'Reducida'){
                    isReduced = true;
                }
                if (statusText == 'Held' || statusText == 'Retenida'){
                    isHeld = true;
                }
                if (statusText == 'Pending Authorization' || statusText == 'Aprobación pendiente'){
                    isNew = true;
                }
                if (numUnpaidInvoices > 0){
                    isInvoiceValid = false;
                }
                
                component.set("v.IsValid", isValid);
                component.set("v.IsCanceled", isCanceled);
                component.set("v.IsReduced", isReduced);
                component.set("v.IsHeld", isHeld);
                component.set("v.IsNew", isNew);
                component.set("v.IsInvoiceValid", isInvoiceValid);
                
                helper.toggleSpinner(component, "loadCLSpinner");
                
            } else {
                console.log('Problem getting the Compact Layout, response state: ' + state);
                helper.toggleSpinner(component, "loadCLSpinner");
            }
        });

        $A.enqueueAction(action);
	}
    
    
})