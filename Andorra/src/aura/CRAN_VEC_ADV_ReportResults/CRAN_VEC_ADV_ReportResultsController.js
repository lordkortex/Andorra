({  
    doInit: function(component, event, helper) {
        helper.Header(component,event, helper);
        helper.Positions(component);
    }, 
    
    refresh : function(component, event, helper) {
        component.set("v.info", true);
        component.set("v.error",false);        		
        helper.Positions(component);
    }, 
            
    editRecord : function(component, event, helper) {
		helper.editRecord(component,event, helper);
    }, 
    
    gotoRecord : function(component, event, helper) {
        helper.gotoRecord(component,event, helper);
    },
    
    gotoList : function(component, event, helper) {
        component.set("v.error",false);     
		helper.gotoList(component,event, helper);
    },
    
    goBack : function(component, event, helper) {
		helper.goBack(component,event, helper);
    },
    
})