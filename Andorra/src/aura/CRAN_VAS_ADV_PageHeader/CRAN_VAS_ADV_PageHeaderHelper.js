({
    processGetRecordTypeById : function (response, component, event) {
        var state = response.getState();
        if (state === "SUCCESS") {            
            var returnedRecordType = response.getReturnValue();
            component.set("v.myRecordType", returnedRecordType);            
        }
        
    },
    processData : function (response, component, event) {
        var state = response.getState();
        if (state === "SUCCESS") { 
            var listOfValues = response.getReturnValue();
            var response = JSON.parse(listOfValues);            
            component.set("v.response", response);                         
        }else{
            console.log("PageHeader not found");
        }        
    }
    
})