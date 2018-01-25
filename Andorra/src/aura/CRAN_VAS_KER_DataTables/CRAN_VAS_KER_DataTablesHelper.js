({
    ignoreRefresh : true,
    $dataTable    : {},
    initDatatable : function(component) {

        // Gets events based on the provided values
        var action 			= component.get("c.getRecords");
        var helper 			= this;
        var params 			= component.get("v.params");
        var provider 		= component.get("v.provider") + params["displayType"] + component.get("v.cpTitle");
        var tableContainer 	= component.find("tableContainer").getElement();         
		var showActions		= component.get("v.showActionButtons");
        
        if (params["displayType"] != undefined
           && (params["displayLimit"] != undefined && params["displayLimit"] != "")) {
            var $subTitle = $lDatatable("#subTitle", tableContainer);
            if (params["displayType"] == "userRecords") {
                $subTitle.text($A.get("$Label.c.CRAN_VAS_KER_My")+' '+component.get("v.cpTitle"));
            } else if (params["displayType"] == "officeRecords"){
                $subTitle.text($A.get("$Label.c.CRAN_VAS_KER_Office")+' '+component.get("v.cpTitle"));
            } else {
                $subTitle.text($A.get("$Label.c.CRAN_VAS_KER_Advisor")+' '+component.get("v.cpTitle"));
            }

            $subTitle.show();
        }
        
        
        action.setParams({
            "dataProviderName"	: component.get("v.provider"),
            "params" 			: params
        });
        
        
		var breadCrumb = component.get("v.breadCrumb");        

		
		component.set("v.breadCrumbApiName", breadCrumb["apiName"]);
		component.set("v.breadCrumbLabel", breadCrumb["label"]);
		component.set("v.breadCrumbName", breadCrumb["name"]);
		component.set("v.breadCrumbId", breadCrumb["id"]);

        // Shows the spinner
        helper.toggleSpinner(component);
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
                        	          
            if (component.isValid() && state === "SUCCESS") {
                
                debugger;
                if (helper.$dataTable[provider] != undefined)
                    helper.$dataTable[provider].clear().draw();	

                var sObject = JSON.parse(response.getReturnValue());               
                if (sObject != null && sObject.records.length > 0 ) {
         
                    var columnDefs	= [];                 
                    var records 	= [];

                    component.set("v.sObjectName", sObject.apiName);
	                var evtDatatables = component.getEvent("evtDatatablesInfo");
                        evtDatatables.setParam("info", { 	resultSize 	: sObject.records.length, 
                                                            isCreateable: sObject.isCreateable,
                                                            isDeletable	: sObject.isDeletable,
                                                            isUpdateable: sObject.isUpdateable});                    
                    evtDatatables.fire();
                    
                    for (var i = 0; i < sObject.records.length; i++) {
                        
                        var record 			= {};
                        var sObjectRecord 	= sObject.records[i];
                        
                        $lDatatable.extend( record, {"DT_RowId" : sObjectRecord[0].value } ); 
                                                     
                        for (var j = 1; j < sObjectRecord.length; j++) {

                            if (i == 0) {
                                var columnDef = { 	"title"		: "<div class=\"slds-grid\"><div class=\"slds-truncate\">" + sObjectRecord[j].label + "</div></div>",
                                                 	"targets"	: j-1 ,
                                                 	"data"		: sObjectRecord[j].apiName
                                                };
                                
                                columnDefs.push(columnDef);
                            }
                            
                            var newObj = {};
                       	
                            if (sObjectRecord[j].apiName == "Name" || sObjectRecord[j].fieldType == "REFERENCE") {
                                var recordId;
                                if (sObjectRecord[j].apiName == "Name") {
                                   recordId = record.DT_RowId;
                                } else {                            
									recordId = sObjectRecord[j].recId;
                                }
                                var anchor = 	"<div class=\"slds-grid\"><div class=\"slds-truncate\"><a href=\"/one/one.app#/sObject/" + recordId +"/view\">" +
                                    sObjectRecord[j].value + "</a></div></div>";                                
                                newObj[sObjectRecord[j].apiName] = anchor;
                                
                            } else if (sObjectRecord[j].fieldType == "BOOLEAN" ) {
                                var checkBoxClass = sObjectRecord[j].value === 'true' ? "checked" : "unchecked";
                                var checkBoxImg   = "<div class=\"slds-grid\"><div class=\"slds-truncate\"><span class=\"uiImage uiOutputCheckbox\" data-aura-class=\"uiImage uiOutputCheckbox\"><img src=\"/auraFW/resources/aura/s.gif\" class=\""+ checkBoxClass + "\" /></span></div></div>";
                                newObj[sObjectRecord[j].apiName] = checkBoxImg;        
                            } else {
                                newObj[sObjectRecord[j].apiName] = "<div class=\"slds-grid\"><div class=\"slds-truncate\">" + sObjectRecord[j].value + "</div></div>";
                            }
                            $lDatatable.extend( record, newObj );
                        }

                        if (i == 0 && showActions && (sObject.isUpdateable || sObject.isDeletable)) {
                            
                            var $buttomTemplate  = $lDatatable(helper.getButtonsTemplate());
     
                            if (!sObject.isUpdateable) {
                                $buttomTemplate.remove("li.edit");
                            }
                            
                            if (!sObject.isDeletable) {
                                $buttomTemplate.remove("li.delete");
                            }                           
                            
                            columnDefs.push({"title": "",
                                             "orderable": false,
                                             "targets": sObjectRecord.length-1 , 
                                             "data": null,
                                             "width": "20px",
                                             "defaultContent":  $buttomTemplate.html()});
     
                        }
                        
                        records.push(record);
                    }                
					
                    helper.$dataTable[provider] = $lDatatable('[id$=_datatable]', tableContainer).DataTable(helper.tableSetup(columnDefs, 
                                                                                                                              records,
                                                                                                                              component));
                    $lDatatable("tr", helper.$dataTable[provider].table().header()).addClass("slds-text-title--caps");                     
                    
                    if (sObject.limitReached) {
                        var dataTableFilter = component.find("dataTableFilter");
                        var dataTableFilterExplanation = component.find("dataTableFilterExplanation");
                        helper.showToast('', 'warning',  $A.get("$Label.c.CRAN_VAS_KER_LimitFilter"));
                        $A.util.removeClass(dataTableFilterExplanation, 'slds-hide');
                        $A.util.removeClass(dataTableFilter, 'slds-hide');
                    }
                    
                    $lDatatable('.table-wrapper', tableContainer).show();
                    $lDatatable('.no-records-to-display', tableContainer).hide();   
                } else {
                    if ((params["displayType"] != undefined && params["displayType"] != "userRecords")
                        && (params["displayLimit"] != undefined && params["displayLimit"] != "")) {
                        $lDatatable("#subTitle",  tableContainer).hide();
                        $lDatatable('.table-wrapper', tableContainer).hide();
                    } else if (helper.$dataTable[provider] == undefined) {
                        $lDatatable('.table-wrapper', tableContainer).hide();
                        $lDatatable('.no-records-to-display', tableContainer).show();
                    }
                }
                
            } else if (state === "ERROR") {
                console.log ('error');
                helper.printErrors(response.getError(),true);
            }
            
            helper.ignoreRefresh = true;
            // Hides the spinner
            helper.toggleSpinner(component);
        });
        
        $A.enqueueAction(action);         

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
        this.ignoreRefresh = true;        

        toastEvent.setParams({
            "title": title,
            "type" : type,
            "message": message
        });

        toastEvent.fire();
    },
    getButtonsTemplate : function() {
        return 	"<div>" + 
        			"<div class=\"slds-align--absolute-center slds-dropdown-trigger slds-dropdown-trigger--click datatable-buttons-container\">" +  
                    "  <button class=\"slds-button slds-button--icon-border-filled slds-button--icon-x-small datatable-button\" aria-haspopup=\"true\" title=\"Show More\">" +  
                    "    <svg class=\"slds-button__icon datatable-svg-button-icon\" width=\"52\" height=\"52\" viewBox=\"0 0 52 52\">" +  
                    "      <use xlink:href=\"/resource/slds221/utility-sprite/svg/symbols.svg#down\"></use>" +  
                    "    </svg>" +  
                    "    <span class=\"slds-assistive-text\">Show More</span>" +  
                    "  </button>" +  
                    "  <div class=\"slds-dropdown slds-dropdown--left slds-dropdown--actions datatable-button-actions\">" +  
                    "    <ul class=\"slds-dropdown__list\" role=\"menu\">" +  
                    "      <li class=\"slds-dropdown__item edit\" role=\"presentation\">" +  
                    "        <a href=\"#\" data-button-type=\"edit\" role=\"menuitem\" tabindex=\"0\">" +  
                    "         Edit" +  
                    "        </a>" +  
                    "      </li>" +  
                    "      <li class=\"slds-dropdown__item delete\" role=\"presentation\">" +  
                    "        <a href=\"#\" data-button-type=\"delete\" data-modal=\"deleteDialog\" role=\"menuitem\" tabindex=\"-1\">" +  
                    "         Delete" +  
                    "        </a>" +  
                    "      </li>" +  
                    "    </ul>" +  
                    "  </div>" +  
                    "</div>" +
        		"</div>";
    },
    editRecord : function(event) {

        var editRecordEvent = $A.get("e.force:editRecord");
        //var recordID = event.currentTarget.dataset.recordid;
        var recordID = $lDatatable(event.target).closest("tr").prop("id");
        
        editRecordEvent.setParams({
            "recordId": recordID
        });
        editRecordEvent.fire();        
    },
    createRecord : function (component) {
		var createRecordEvent = $A.get("e.force:createRecord");

        createRecordEvent.setParams({
            "entityApiName": component.get("v.sobjectName"),
        	"recordTypeId": null
        });
        createRecordEvent.fire();
    }, 
    deleteRecordHelper: function(component, event, helper) {
        var action = component.get("c.deleteRecord");
        action.setParams({
            recordId: $lDatatable("#recIdToDelete").val()
        });
        
        action.setCallback(this, function(response) {    
            
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                toastEvent.setParams({
                    "title": $A.get("$Label.c.CRAN_VAS_MAQ_SuccessTitle")+"!",
                    "type" : "success",
                    "message": $A.get("$Label.c.CRAN_VAS_KER_CF_LBL_DeletedOK")
                });
                helper.ignoreRefresh = false;              
            } else {
                
                helper.printErrors(response.getError());
                
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": $A.get("$Label.c.CRAN_VAS_KER_CF_LBL_DeletedKO")
                });                       
            }            
            
            toastEvent.fire();
            
			           
        });
        
        $A.enqueueAction(action);
        helper.closeModal("deleteDialog");
        
    },    
    openModal : function(event) {
		var helper = this;
        // Now add and remove class
        $lDatatable("#" + $lDatatable(event.target).data("modal")).addClass("slds-fade-in-open");
        $lDatatable("#dialogBack").addClass("slds-fade-in-open");
        var recordID 		= $lDatatable(event.target).closest("tr").prop("id");
        $lDatatable("#recIdToDelete").val(recordID);        
    },
    closeModal : function(elementSelector) {
		var helper = this;        
        // Now add and remove class
       	$lDatatable("#recIdToDelete").val("");
        $lDatatable("#" + elementSelector).removeClass("slds-fade-in-open");
        $lDatatable("#dialogBack").removeClass("slds-fade-in-open");
    },
	// Displays or hides the spinner
    toggleSpinner: function (component) {
        var spinner = component.find("datatablespinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }, 
    tableSetup : function (columnDefs, records, component) {
    	return {
            data			: records,
            deferRender		: true,
            destroy			: true,
            columnDefs		: columnDefs,
            pageLength		: component.get("v.tablePageLength"),
            paging			: component.get("v.showPagination"),
            ordering		: component.get("v.ordering"),
            searching		: component.get("v.searching") && component.get("v.showPagination"),
            lengthChange	: component.get("v.lengthChange"),
            info			: component.get("v.showInfo"),
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