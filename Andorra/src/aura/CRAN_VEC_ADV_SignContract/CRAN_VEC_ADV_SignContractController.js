({
	doInit : function(component, event, helper) {
		helper.queryAccount(component);
	},
	btnSignContract : function(component, event, helper) {
		helper.signContract(component);
	},
    showSystemError: function(cmp, event) {
        // Handle system error
        component.set("v.errorMessage",returnValue.messageError);
        component.set("v.error",true);
        $A.log(cmp);
        $A.log(event);
    }
})