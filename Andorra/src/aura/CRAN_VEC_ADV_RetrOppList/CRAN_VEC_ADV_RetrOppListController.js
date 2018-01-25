({
    doneRendering: function(component, event, helper) {
        if(!component.get("v.isDoneRendering")){
            component.set("v.isDoneRendering", true);
            helper.Header(component,event, helper);
            helper.refreshPositions(component);
        }
    },
    
    refresh : function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.error",false);
        helper.Header(component,event, helper);
		helper.refreshPositions(component);
    }, 
            
    editRecord : function(component, event, helper) {
		helper.editRecord(component,event, helper);
    }, 
    
    gotoRecord : function(component, event, helper) {
        component.set("v.info",true);
        component.set("v.error",false);
        component.set("v.shownext",false);
		if(component.get("v.nKey") == 'FinServ__FinancialAccount__c'){
            helper.updateRecord(component,event, helper);
        }else{
            helper.gotoRecord(component,event, helper);
        }
    },
    
    gotoList : function(component, event, helper) {
		helper.gotoList(component,event, helper);
    },

    gotoOpp : function(component, event, helper) {
        helper.gotoOpp(component);
    },
    
    goBack : function(component, event, helper) {
		helper.goBack(component,event, helper);
    },

    showSystemError : function(cmp, event) {
        // Handle system error
        console.log(cmp);
        console.log(event);
    },
    
})