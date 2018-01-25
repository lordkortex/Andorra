({
	initReassignGoals : function (component, event, helper) {
		
		if (window.$reassign == undefined)
            window.$reassign = jQuery.noConflict();
        
        helper.getUsersHelper(component,event);

        var mainContainer = component.find("mainContainer").getElement();
        
        $reassign(mainContainer).on("keyup", ".datatables-search", function () {
            var dataTable = $reassign("[id$="+ this.dataset.tableSufix + "]").DataTable();
            dataTable.search($reassign(this).val()).draw();
        });      
        
        $reassign(mainContainer).on("click", "td:not(.select-checkbox)", function () {
            $reassign(this).siblings(".select-checkbox").trigger("click");
        });
        
        $reassign(mainContainer).on("click", "th.select-checkbox", function () {
        	var $rows 	= $reassign(this).parents("table").DataTable().rows();
        	var $parent = $reassign(this).parent();
        	
        	if ($parent.hasClass("selected")) {
        		$rows.deselect();
        		$parent.removeClass("selected");
        	} else {
        		$rows.select();
        		$parent.addClass("selected");
        	}
        	
        });  
	},
	filterGoalsController : function (component, event, helper) {
		helper.filterGoalsHelper(component,event);
	},
    
    getUsersByOffice : function (component, event, helper) {        
		helper.getUsersByOfficeHelper (component,event);
	},
	
	confirmReassignGoalsToAdvisor : function (component, event, helper) {
		helper.openModal(component);
	},
	reassignGoalsToAdvisor : function (component, event, helper) {
		helper.reassignGoalsToAdvisorHelper (component,event);
	},
	closeModal : function(component, event, helper) {
		helper.closeModal(component);
	},
    refresh : function (component,event,helper) {
        helper.initReassignGoals(component);
    },
    addSelected : function (component, event, helper) {

        $reassign("tr.selected", helper.$dataTable.table().header()).removeClass("selected");
    	
		var rows = helper.$dataTable.rows( { selected : true } ).deselect().data().filter( function ( value, index ) {

				if ( $reassign.inArray( value.DT_RowId , helper.selectedIds ) == -1) {
					helper.selectedIds.push(value.DT_RowId);
					return true;
				} 
				
				return false;
			} );
			
		helper.$dataTableSelected.rows.add(rows).draw();    	
    },
    removeSelected : function (component, event, helper) {

    	$reassign("tr.selected", helper.$dataTableSelected.table().header()).removeClass("selected");        
    	
    	var rowsCounter = helper.$dataTableSelected.rows().count();
    	var rows 		= helper.$dataTableSelected.rows( { selected : true } );

      	if (rowsCounter != rows.count()) {	
	    	var ids = rows.ids();
	    	
	    	for (var i = 0; i < ids.length; i++) {
		    	var index = helper.selectedIds.indexOf(ids[i]);
		    	if (index > -1) {
		    		helper.selectedIds.splice(index, 1);
		    	}
	    	}
	    	
			rows.remove().draw();
  		} else {
  			helper.selectedIds = [];
  			helper.$dataTableSelected.clear().draw();
  		}
	
    }    
})