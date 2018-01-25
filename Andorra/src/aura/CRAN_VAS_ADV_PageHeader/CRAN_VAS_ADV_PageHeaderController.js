({
    doInit : function(component, event, helper) {
        
		//Get RecordType
        var action = component.get("c.getRecordTypeById"); 
        
        action.setParams({
            recordId:component.get("v.recordId")
        });        
        
        action.setCallback(this, function(response){
            
            helper.processGetRecordTypeById(response, component, event, helper);
     
                //Get Record Data
                var action2 = component.get("c.getRecordById");            
                action2.setParams({
                    recordId:component.get("v.recordId"),
                    myRecordType:component.get("v.myRecordType"),
                    fieldsByRT:component.get("v.fieldsByRT")
                });            
                action2.setCallback(this, function(response){
                    helper.processData(response, component, event, helper);
                });
                
                $A.enqueueAction(action2);
        });
        
        $A.enqueueAction(action);
	}    
})