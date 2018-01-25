({
    afterRender: function (component, helper) {
        this.superAfterRender();
        var modalBody = document.querySelector('.modal-body');
		modalBody.style.position = "relative";
    }
})