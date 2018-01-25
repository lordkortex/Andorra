({
	toggleSpinner: function (cmp, spinnerId) {
        var spinner = cmp.find(spinnerId);
        $A.util.toggleClass(spinner, "slds-hide");
    }
})