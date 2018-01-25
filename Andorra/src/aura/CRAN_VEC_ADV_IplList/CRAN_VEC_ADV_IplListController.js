({  
    doneRendering: function(component, event, helper) {
        if(!component.get("v.isDoneRendering")){
            component.set("v.isDoneRendering", true);
            helper.Header(component,event, helper);
            helper.Positions(component);
            component.set("v.info", false);
        }        
    },
    
    refresh : function(component, event, helper) {
        component.set("v.info", true);
        component.set("v.error",false);        
		helper.Positions(component);
    }, 
            
    editRecord : function(component, event, helper) {
		helper.editRecord(component,event, helper);
    }, 
        
    gotoList : function(component, event, helper) {
        component.set("v.error",false);        
		helper.gotoList(component,event, helper);
    },
    
    goBack : function(component, event, helper) {
		helper.goBack(component,event, helper);
    },
    
})