({
    doInit : function(component, event, helper) {

        
        if (window.$lDatatable == undefined)
            window.$lDatatable = jQuery.noConflict();
        
		if (component.get("v.searching") && component.get("v.showPagination")) {
           
            $lDatatable("#searchContainer").removeClass("slds-hide");
            
            var tablePageHeaderContainer = component.find("datatablePageHeader").getElement();
            
            $lDatatable(tablePageHeaderContainer).on("keyup", "#dataTableSearch", function () {
                var dataTable = $lDatatable("[id$=_datatable]", tableContainer).DataTable();
                dataTable.search($lDatatable(this).val()).draw();
            });                
        } 
        helper.initDatatable(component);
        
        var tableContainer 	= component.find("tableContainer").getElement(); 
        $lDatatable(tableContainer).on("click", "[data-button-type=delete]", function (e) {
            e.preventDefault();
            helper.openModal(e);
        });  
        
        $lDatatable(tableContainer).on("click", "[data-button-type=edit]", function (e) {          
            e.preventDefault();
            helper.editRecord(e);
        });        
        
        $lDatatable(tableContainer).on("click", ".datatable-button, .datatable-svg-button-icon", function () {
            $lDatatable(this).parent().toggleClass("slds-is-open");
        });                
        
        var clickFunc = function(e) {
            var $el = $lDatatable(e.target);
            if ($el.hasClass("datatable-svg-button-icon")) {
                $el = $el.parent();
            }
            if (!$el.hasClass("datatable-button-actions")
                && !$el.hasClass("datatable-button"))
                $lDatatable(".datatable-buttons-container", tableContainer).removeClass("slds-is-open");
        };
        
        $lDatatable(document).off("click", clickFunc).on("click", clickFunc);          

    },
    deleteRecordController: function (component, event, helper) {
        helper.deleteRecordHelper(component, event, helper);
    },
    createRecord : function (component, event, helper) {
        helper.createRecord(component);
    },
    closeModal : function(component, event, helper) {
        helper.closeModal("deleteDialog");
    },    
    viewAll: function (component, event, helper) {
        
        event.preventDefault();
        
        var params = component.get("v.params");
        params.displayLimit = '';
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CRAN_VAS_KER_DataTables",
            componentAttributes: {
                "provider"			: component.get("v.provider"),
                "params"			: component.get("v.params"),
                "iconName"			: component.get("v.iconName"),
                "searching"			: component.get("v.searching"),
                "breadCrumb"		: component.get("v.breadCrumb"),
                "showActionButtons"	: component.get("v.showActionButtons"),
                "cpTitle"			: component.get("v.cpTitle")
            }
        });
        evt.fire();
    },
    refreshBtn : function (component,event,helper) {
    	helper.initDatatable(component);
    },
    refresh : function (component,event,helper) {
        if (!helper.ignoreRefresh)
        	helper.initDatatable(component);
    },
    filterResults : function (component,event,helper) {

        var params = component.get("v.params");
        params['ownerId'] = component.get("v.user");
        
        component.set("v.params", params);

		helper.initDatatable(component);        
    }   
})