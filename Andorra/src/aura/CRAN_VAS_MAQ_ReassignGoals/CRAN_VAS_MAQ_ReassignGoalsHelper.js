({
	selectedIds 		: [],
	$dataTable			: "undefined",
	$dataTableSelected	: "undefined",
	getUsersHelper : function (component, event) {
		var action = component.get("c.getOfficesAndUsers");
		var helper = this;

		action.setCallback(this, function(response) {

			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {

				var mapSObjectResponse = JSON.parse(response.getReturnValue());               
				var offices = null; 
				var users = null;

				if(mapSObjectResponse != null){
					offices = mapSObjectResponse["offices"];					
					helper.fetchOffices(component,offices);

				} else {
					helper.printErrors(response.getError());
				}                                  
			} else if (state === "ERROR") {
				helper.printErrors(response.getError());
			}                                               
		});
		$A.enqueueAction(action);
	},
	filterGoalsHelper : function(component,event) {

		var helper = this;

		if ($A.util.isEmpty(component.get("v.user"))) {			
			this.showToast($A.get("$Label.c.CRAN_VAS_MAQ_RG_FilterTitle")+"!","warning",$A.get("$Label.c.CRAN_VAS_MAQ_RG_UserRequired"));
			return;
		}

		if ($A.util.isEmpty(component.get("v.startDate")) || $A.util.isEmpty(component.get("v.closeDate"))) {
			this.showToast($A.get("$Label.c.CRAN_VAS_MAQ_RG_FilterTitle")+"!","warning",$A.get("$Label.c.CRAN_VAS_MAQ_RG_DatesRequired"));
			return;
		}

		helper.toggleSpinner(component);	        

		var action = component.get("c.getFilteredData");		
		action.setParams(
				{
					"filters": {
						"bp"			: component.get("v.bp"),
						"client"		: component.get("v.client"),
						"campaign"		: component.get("v.campaign"),
						"user"			: component.get("v.user"),
						"startDate"		: component.get("v.startDate"),
						"closeDate"		: component.get("v.closeDate"),
                        "office_bp"		: component.find("offices_filter").get("v.value")
					},
					"strFieldApiNames"	: component.get("v.strFieldApiNames")
				}
		);
		
		action.setCallback(this, function(response) {

			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
        
				helper.fetchGoals(component, helper, JSON.parse(response.getReturnValue())); 

			} else if (state === "ERROR") {
				helper.printErrors(response.getError(), true);
			}  
			//Hides the spinner
			helper.toggleSpinner(component);                                              
		});
		$A.enqueueAction(action);
	},	
	fetchGoals: function (component, helper, sObject) {

        var tableContainer 			= component.find("tableContainer").getElement();         
        var tableContainerSelected 	= component.find("tableContainerSelected").getElement();
        var mainContainer 			= component.find("mainContainer").getElement();     
        
        helper.selectedIds = [];
        
        if (helper.$dataTableSelected != "undefined" ||  helper.$dataTable != "undefined") {
        	helper.$dataTableSelected.clear().draw();
	        helper.$dataTable.clear().draw();
	        $reassign(component.find("mainContainer").getElement()).addClass("slds-hide");
	        $reassign(component.find("userSelection").getElement()).addClass("slds-hide");      	
        }

            if (sObject != null && sObject.records.length > 0 ) {
    
                var columnDefs	= [];                 
                var records 	= [];
            
                for (var i = 0; i < sObject.records.length; i++) {
                    
                    var record 			= {};
                    var sObjectRecord 	= sObject.records[i];
                    
                    $reassign.extend( record, {"DT_RowId" : sObjectRecord[0].value } );                     
                    
                    for (var j = 1; j < sObjectRecord.length; j++) {

                        if (i == 0) {
                        
                            columnDefs.push({ 	"title"		: "<div class=\"slds-grid\"><div class=\"slds-truncate\">" + sObjectRecord[j].label + "</div></div>",
                                                "targets"	: j,
                                                "data"		: sObjectRecord[j].apiName 
                                            });
                                            
                            columnDefs.push({"title"			: "",
                                             "orderable"		: false,
                                             "width"			: "20px",
                                             "targets"			: 0 ,
                                             "className"		: "select-checkbox",
                                             "defaultContent"	:  "",
                                             "searchable" 		: false});                                                
                        }
                        
                        var newObj = {};
                        
                        if (sObjectRecord[j].apiName == "Name" || sObjectRecord[j].fieldType == "REFERENCE") {
                            var recordId;
                            if (sObjectRecord[j].apiName == "Name") {
                                recordId = record.DT_RowId;
                            } else {                            
                                recordId = sObjectRecord[j].recId;
                            }
                            var anchor = "<div class=\"slds-grid\"><div class=\"slds-truncate\"><a href=\"/one/one.app#/sObject/" + recordId +"/view\">" +
                                sObjectRecord[j].value + "</a></div></div>";                                
                            newObj[sObjectRecord[j].apiName] = anchor;
                            
                        } else if (sObjectRecord[j].fieldType == "BOOLEAN" ) {
                            
                            var checkBoxClass = sObjectRecord[j].value === 'true' ? "checked" : "unchecked";
                            var checkBoxImg   = "<div class=\"slds-grid\"><div class=\"slds-truncate\"><span class=\"uiImage uiOutputCheckbox\" data-aura-class=\"uiImage uiOutputCheckbox\"><img src=\"/auraFW/resources/aura/s.gif\" class=\""+ checkBoxClass + "\" /></span></div></div>";
                            newObj[sObjectRecord[j].apiName] = checkBoxImg; 
                            
                        } else {
                            newObj[sObjectRecord[j].apiName] = "<div class=\"slds-grid\"><div class=\"slds-truncate\">" + sObjectRecord[j].value + "</div></div>";
                        }
                        $reassign.extend( record, newObj );
                    }                    
                    
                    records.push(record);
                }                
            

            $reassign(mainContainer).removeClass("slds-hide");
            $reassign(component.find("userSelection").getElement()).removeClass("slds-hide");            
            
            if (helper.$dataTableSelected == "undefined")
            	helper.$dataTable = $reassign('[id$=_datatable]', tableContainer).DataTable(helper.tableSetup(columnDefs, records));
            else
            	helper.$dataTable.rows.add(records).draw();
            	
            if (helper.$dataTableSelected == "undefined")
            	helper.$dataTableSelected = $reassign('[id$=_datatableSelected]', tableContainerSelected).DataTable(helper.tableSetup(columnDefs, null));
            
            // Apply Lightning style to the table header
            $reassign("thead tr", mainContainer).addClass("slds-text-title--caps");


		} else {		

			var toastEvent = $A.get("e.force:showToast");	            

			toastEvent.setParams({
				"title": $A.get("$Label.c.CRAN_VAS_MAQ_RG_FilterTitle"),
				"type" : "warning",
				"message": $A.get("$Label.c.CRAN_VAS_MAQ_RG_NoGoals")
			});

			toastEvent.fire();
		}
	},
	fetchOffices: function (component, offices) {		
		
		var values = [];
		var labels = [];

		var officePicklist = offices.picklistFields[0];

		var opts =[];
		
		opts.push({
			label:"",
			value:"",
			selected: true
		});		

		for (var i = 0; i < officePicklist.labels.length; i++) {
			opts.push({label: officePicklist.labels[i], 
				value: officePicklist.values[i]});
		}

		if (!$A.util.isEmpty(component.find("offices"))) {
			component.find("offices").set("v.options", opts);
            component.find("offices_filter").set("v.options", opts);
		}
	},
	getUsersByOfficeHelper: function (component,event) {

		var officeSelected = component.find("offices").get("v.value");

		var action = component.get("c.getOfficesAndUsers");
		var helper = this;

		action.setParams({
            "officeSelected"	: officeSelected,
        });
		action.setCallback(this, function(response) {

			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {

				var mapSObjectResponse = JSON.parse(response.getReturnValue());               
				var users = undefined;

				if (mapSObjectResponse != null) {
					users = mapSObjectResponse["users"];					
					helper.fetchUsers(component,users);

				} else {
					helper.printErrors(response.getError());
				}                                  
			} else if (state === "ERROR") {
				helper.printErrors(response.getError());
			}                                               
		});
		$A.enqueueAction(action);
	},
	fetchUsers: function (component, users) {
		if (users === undefined) {
            this.showToast($A.get("$Label.c.CRAN_VAS_MAQ_RG_Title")+"!","warning",$A.get("$Label.c.CRAN_VAS_MAQ_AG_NoUsers"));
		}

		var recordsUsers = users.records;
		var fields;
		var labelUser;
		var idUser;
		var usersOffice= [];

		component.set("v.showUsers",true);

		if (recordsUsers.length < 1) {
            this.showToast($A.get("$Label.c.CRAN_VAS_MAQ_RG_Title")+"!","warning",$A.get("$Label.c.CRAN_VAS_MAQ_AG_NoUsers"));
		}     

		for (var i = 0; i < recordsUsers.length; i++) {
			fields = recordsUsers[i];
			labelUser = fields[1].value;
			idUser = fields[0].value;            
			usersOffice.push({label: labelUser,
				value: idUser,             			
				selected: false});
		}

		if (!$A.util.isEmpty(component.find("users"))) {
			component.find("users").set("v.options", usersOffice);
		}
	
	},
	reassignGoalsToAdvisorHelper: function(component,event) {
		
		var helper 			= this;
		var selectedUser 	= component.find("users").get("v.value"); 
		
		if ($A.util.isEmpty(selectedUser) || $A.util.isEmpty(helper.selectedIds)) {
			
            this.showToast($A.get("$Label.c.CRAN_VAS_MAQ_RG_FilterTitle")+"!","warning",$A.get("$Label.c.CRAN_VAS_MAQ_RG_NoGoalsSelected"));
			return;
		}		
		
        helper.toggleSpinner(component);

        var action = component.get("c.reassignGoalsToUser");
               
        action.setParams({
        	"goalsIds"	: helper.selectedIds,
        	"userId" 	: component.find("users").get("v.value")
    	});
                   
        action.setCallback(this, function(response) {

            var state = response.getState();
            
            if (state === "SUCCESS") {
                this.showToast($A.get("$Label.c.CRAN_VAS_MAQ_SuccessTitle")+"!","success",$A.get("$Label.c.CRAN_VAS_MAQ_AG_AssignOK"));
                helper.filterGoalsHelper(component, event);

            } else {
                this.showToast($A.get("$Label.c.CRAN_VAS_MAQ_ErrorTitle")+"!","error",$A.get("$Label.c.CRAN_VAS_MAQ_AG_AssignKO"));
            }            
            helper.toggleSpinner(component);   

        });
        
        $A.enqueueAction(action);
        helper.closeModal(component);		
	},		
	printErrors: function(errors,showToast) {
		var msg = $A.get("$Label.c.CRAN_VAS_KER_UnknownError");

        if (errors) {
            msg = '';
            for (var i = 0; i < errors.length; i++) {
                msg += errors[i].message + "\n";
                console.log("Error message: " + errors[i].message);
            }
        } else {
            console.log("Unknown error");
        }
        if(showToast !== undefined && showToast){
        	this.showToast($A.get("$Label.c.CRAN_VAS_MAQ_ErrorTitle"), "error", msg);    
        }        
	},
    showToast : function(title, type, message) {

        var toastEvent = $A.get("e.force:showToast");               

        toastEvent.setParams({
            "title": title,
            "type" : type,
            "message": message
        });

        toastEvent.fire();
    },
	// Displays or hides the spinner
	toggleSpinner: function (component) {
		var spinner = component.find("assignGoalsSpinner");
		$A.util.toggleClass(spinner, "slds-hide");
	},
	closeModal : function(component) {
		//find modal using aura id
		var modal = component.find("confirmDialog");
		var modalBackdrop = component.find("confirmDialog-Back");

		// Now add and remove class
		$A.util.removeClass(modal, 'slds-fade-in-open');
		$A.util.removeClass(modalBackdrop, 'slds-fade-in-open');
	},
	openModal : function(component) {
		//find modal using aura id
		var modal = component.find("confirmDialog");
		var modalBackdrop = component.find("confirmDialog-Back");

		// Now add and remove class
		$A.util.addClass(modal, 'slds-fade-in-open');
		$A.util.addClass(modalBackdrop, 'slds-fade-in-open');
	}, 
    tableSetup : function (columnDefs, records) {
    	return {
    					data			: records,
                        deferRender		: true,
                        destroy			: true,
                        columnDefs		: columnDefs,
                        pageLength		: 10,
                        paging			: true,
                        ordering		: true,
                        order			: [[1, 'asc']],
                        searching		: true,
                        lengthChange	: false,
                        info			: false,
                        select: {
                            style:    'multi',
                            selector: 'td:first-child',
                            info:	  false
                        },                        
                        dom				: 'lrtip',
                        language: {
                        	emptyTable: $A.get("$Label.c.CRAN_VAS_KER_NoRecordsToDisplay"),
                            paginate: {
                                next: $A.get("$Label.c.CRAN_VAS_KER_Next"),
                                previous : $A.get("$Label.c.CRAN_VAS_KER_Previous")
                            },
                            zeroRecords: $A.get("$Label.c.CRAN_VAS_KER_NoResults"),
                            info: $A.get("$Label.c.CRAN_VAS_KER_Showing") + " _PAGE_ " + $A.get("$Label.c.CRAN_VAS_KER_Of") + " _PAGES_"
                        }
                    };
    }
})