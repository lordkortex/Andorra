({
	doInit : function(component, event, helper) {
        
		var relatedList = component.get("v.RelatedList");
		var action = '';
        var recordsCount = 0;
        
        if (relatedList == 'Policies with unpaid invoices'){
            helper.loadAction(component, "c.getHLUnpaidInvLayoutFieldNames", "v.ColumnNames");
            helper.loadAction(component, "c.getFAWithUnpaidInvoicesCount", "v.RecordsCount");
            action = component.get("c.getFAWithUnpaidInvoices");
            component.set("v.IsUnpaidInvoicesList","true");
        }
        else if (relatedList == 'Policies with pending authorization'){
            helper.loadAction(component, "c.getHLPendingStatusLayoutFieldNames", "v.ColumnNames");
            helper.loadAction(component, "c.getFAWithPendingStatusCount", "v.RecordsCount");
            action = component.get("c.getFAWithPendingStatus");
            component.set("v.IsPendingList","true");
        }
        recordsCount = component.get("v.RecordsCount");
        
        action.setParams({"limitList": component.get("v.limitList")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.listFA", response.getReturnValue());
                helper.toggleSpinner(component, "listSpinner");
            } else {
                console.log('Problem getting the Records, response state: ' + state);
            }
        });

        $A.enqueueAction(action);
        helper.loadAction(component, "c.getGlobalSettings", "v.gCS");
	}
})