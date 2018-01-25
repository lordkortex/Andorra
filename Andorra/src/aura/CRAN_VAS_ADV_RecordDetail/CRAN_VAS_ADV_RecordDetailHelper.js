({
    processData : function (response, component, event) {
        var state = response.getState();
        if (state === "SUCCESS") {            
            console.log("SUCCESS");
            var returnedAccount = response.getReturnValue();
            component.set("v.myAccount", response.getReturnValue());            
        }else{
            console.log("ERROR");
        }
        
    }
    
})