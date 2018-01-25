({
	loadMultiSelect : function(component) {
        
		var container = component.find("container").getElement();
        
        var helperContext = this;
        
        $aGoals('[data-aljs="multi-select"]', container).aljsMultiSelect({
            unselectedItems: [],
            selectedItems: [],
            onUnselectItem: function (cmp) {
            	helperContext.refreshRecordTotal(component);
            },
            onSelectItem: function (cmp) {
            	helperContext.refreshRecordTotal(component);
            } 
        });
      
        this.getOffices(component);               
	},
	getOffices: function (component) {
		// Gets events based on the provided values
		var helperContext = this;
        helperContext.toggleSpinner(component);
        var action = component.get("c.getGoalsAssignedToDummy"); 
        
        action.setParams({
            "campaignId"	: component.get("v.recordId"),
            "fieldNames" 	: component.get("v.fieldNames"),
            "vision"		: component.get("v.vision")
        });          
    
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var parsedResponse = JSON.parse(response.getReturnValue());

                var campaignName = parsedResponse[1];
                component.set("v.campaignName",campaignName);
                
				var mapSObjectResponse = parsedResponse[0];

                if (mapSObjectResponse["offices"] !== undefined) {
                	//If the current user is a director, an office must be selected as a first step
                	component.set("v.isDirectorArea", true);
                    helperContext.fetchOffices(component,mapSObjectResponse["offices"]);
                } else if (mapSObjectResponse["users"] !== undefined) {
	                //If the current user is an office director, the response 
	                //contains users and goals
	                component.set("v.isDirectorOffice", true);
                	helperContext.fetchUsers(component,mapSObjectResponse["users"]);
                	helperContext.fetchGoals(component,mapSObjectResponse["goals"]);
                } else if (mapSObjectResponse["goals"]) {
                	//If the current user is an advisor, the response only contains goals
                	component.set("v.isAdvisor", true);
                	component.set("v.showMultiSelect", true);
        			var container 		= component.find("container").getElement();
					$aGoals('#multiSelectDiv', container).show();
                	helperContext.fetchGoals(component,mapSObjectResponse["goals"]);
                }                                                    
            } else if (state === "ERROR") {
                helperContext.printErrors(response.getError());
            }
            
            // Hides the spinner
            helperContext.toggleSpinner(component);
        });
        
        $A.enqueueAction(action); 
	},
	getGoalsUsersByOffice: function (component) {
		
        var container 		= component.find("container").getElement();
		$aGoals('#detailGoalDiv', container).hide();    
		
		var helperContext = this;
		
		helperContext.toggleSpinner(component);	
		
		// Gets events based on the provided values
        var action = component.get("c.getGoalsAssignedToDummyByOffice"); 
        
        var officeSelected = component.find("offices").get("v.value");
        
        action.setParams({
            "campaignId"	: component.get("v.recordId"),
            "officeCode"	: officeSelected,
            "fieldNames" 	: component.get("v.fieldNames"),
            "vision"		: component.get("v.vision")
        });
                
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var parsedResponse = JSON.parse(response.getReturnValue());
                var mapSObjectResponse = parsedResponse[0]; 
                    
                helperContext.fetchUsers(component,mapSObjectResponse["users"]);
                helperContext.fetchGoals(component,mapSObjectResponse["goals"]);                       
            } else if (state === "ERROR") {
                helperContext.printErrors(response.getError());
            }          
            // Hides the spinner
            helperContext.toggleSpinner(component);
        });
        
        $A.enqueueAction(action); 
	},
	
	fetchOffices: function (component, offices) {		
        var values = [];
        var labels = [];

        var officePicklist = offices.picklistFields[0];
        
        var opts =[];
        
        for (var i = 0; i < officePicklist.labels.length; i++) {
        	opts.push({label: officePicklist.labels[i], 
                       value: officePicklist.values[i],
                       selected: i == 0});
        }
        
        if (component.find("offices")!== undefined) {
        	component.find("offices").set("v.options", opts);
        }
	}, 		
	fetchGoals: function (component, goals) {
		
		var helperContext = this;			
		
		/* Fetch goals */
		var selectedItems = [];
		var unselectedItems = [];
	
		
		if (goals !== undefined) {			           

            var recordsGoals = goals.records;
            var fields;
            var labelGoal;
            var idRec;
            var unselectedItems = [];
            
            if (recordsGoals.length < 1) {
            	var toastEvent = $A.get("e.force:showToast");	            
	            
	            toastEvent.setParams({
	                "title": $A.get("$Label.c.CRAN_VAS_MAQ_AG_Title"),
	                "type" : "warning",
	                "message": $A.get("$Label.c.CRAN_VAS_MAQ_AG_NoGoals")
	            });
	                                          
	            toastEvent.fire();
            }
            
            for (var i = 0; i < recordsGoals.length; i++) {
            	fields = recordsGoals[i];
            	labelGoal = '';
            	idRec = '';
            	for (var j=1; j< fields.length; j++) {
            		if ( j> 1 ) {
            			labelGoal += '-';
            		}
            		if (fields[j].value!==undefined && fields[j].value !== null) {
            			labelGoal += fields[j].value;
            		}            		
            		if (fields[0].value!==undefined && fields[0].value !== null) {
            			idRec = fields[0].value;
            		}            		
            	}
            	unselectedItems.push({id: idRec, 
            			label: labelGoal});
            }
            
            component.set("v.numItems",unselectedItems.length);
            component.set("v.numItemsSelected",selectedItems.length);
            
            var container = component.find("container").getElement();          
        
	        $aGoals('[data-aljs="multi-select"]', container).aljsMultiSelect('setUnselectedItems', unselectedItems);
	        $aGoals('[data-aljs="multi-select"]', container).aljsMultiSelect('setSelectedItems', selectedItems);
			
			$aGoals('#ul-unselected li', container).dblclick($A.getCallback(function() {
				component.set("v.goalDetailId",$aGoals(this).attr('id'));
				 helperContext.getGoalDetails(component, helperContext);
			}));
									                      
		} else {
		
			var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "title": $A.get("$Label.c.CRAN_VAS_MAQ_AG_Title"),
                "type" : "warning",
                "message": $A.get("$Label.c.CRAN_VAS_MAQ_AG_NoGoals")
            });
                                          
            toastEvent.fire();
		} 
	},
	
	fetchUsers: function (component, users) {
		
		var helperContext = this;
		
		/* Fetch users */
		if (users !== undefined) {			
            var recordsUsers = users.records;
            var fields;
            var labelUser;
            var idUser;
            var users= [];
            
            users.push({
            	label:"",
            	value:"",
            	selected: true
            });
            
            component.set("v.showUsers",true);
            
            if (recordsUsers.length <1) {
            	
                var toastEvent = $A.get("e.force:showToast");	            
	            
	            toastEvent.setParams({
	                "title": $A.get("$Label.c.CRAN_VAS_MAQ_AG_Title"),
	                "type" : "warning",
	                "message": $A.get("$Label.c.CRAN_VAS_MAQ_AG_NoUsers")
	            });
	                                          
	            toastEvent.fire();
            }
            
            for (var i = 0; i < recordsUsers.length; i++) {
             
            	fields = recordsUsers[i];
            	labelUser = fields[1].value;
            	idUser = fields[0].value;            
            	users.push({label: labelUser,
            			value: idUser,             			
            			selected: false});
            }
            
            if(component.find("users")!== undefined){
            	component.find("users").set("v.options", users);
            }
            
		} else {
			var toastEvent = $A.get("e.force:showToast");	            
	            
            toastEvent.setParams({
                "title": $A.get("$Label.c.CRAN_VAS_MAQ_AG_Title"),
                "type" : "warning",
                "message": $A.get("$Label.c.CRAN_VAS_MAQ_AG_NoUsers")
            });
                                          
            toastEvent.fire();
		}		   
	},
	getGoalDetails: function(component, helperContext) {
	
        $aGoals('.goal-spinner').toggleClass('slds-hide');
        
        var action = component.get("c.getGoalDetailsController");
        
        action.setParams({
            "goalId"	: component.get("v.goalDetailId"),
            "fieldNames" 	: component.get("v.detailFieldNames"),
        });
                 
        action.setCallback(this, function(response) {
             $aGoals('.goal-spinner').toggleClass('slds-hide');
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var parsedResponse = JSON.parse(response.getReturnValue());
                component.set("v.record", parsedResponse.records[0]);
                
                var container 		= component.find("container").getElement();
                $aGoals('#detailGoalDiv', container).show();                  
				
            } else if (state === "ERROR") {
                helperContext.printErrors(response.getError());
            }
            
        });
        
        $A.enqueueAction(action); 	
      
	},
	assignGoalsToAdvisor: function(component) {
		
		var helperContext = this;
        helperContext.toggleSpinner(component);
        
        var container 		= component.find("container").getElement();
        
        var action = component.get("c.assignGoalsToUser");
        var goals = $aGoals('[data-aljs="multi-select"]', container).aljsMultiSelect('getSelectedItems');
        var goalsIds = [];
            
        for (var i = 0; i < goals.length; i++) {
        	goalsIds.push(goals[i].id);
        }
               
        if (component.get("v.selectedUser")!= "") {
            action.setParams({
        		"campaignId": component.get("v.recordId"),
            	"goalsIds"	: goalsIds,
            	"userId" 	: component.get("v.selectedUser")
        	});
        } else {
            action.setParams({
        		"campaignId": component.get("v.recordId"),
            	"goalsIds"	: goalsIds
        	});
        }
                
        action.setCallback(this, function(response) {
            
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            if (state === "SUCCESS") {
                toastEvent.setParams({
                    "title": $A.get("$Label.c.CRAN_VAS_MAQ_SuccessTitle")+"!",
                    "type" : "success",
                    "message": $A.get("$Label.c.CRAN_VAS_MAQ_AG_AssignOK")
                });
            } else {
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": $A.get("$Label.c.CRAN_VAS_MAQ_AG_AssignKO")
                });
                                       
            }            
            
            helperContext.toggleSpinner(component);
            toastEvent.fire();            
            
            if (state === "SUCCESS") {
            	helperContext.refresh(component);
            }
            
        });
        
        $A.enqueueAction(action);
        helperContext.closeModal(component);		
	},	
	printErrors: function(errors) {
        if (errors) {
            var i;
            for (i = 0; i < errors.length; i++) {
                console.log("Error message: " + errors[i].message);
            }
        } else {
            console.log("Unknown error");
        }
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
    refresh: function (component) {
    	var helperContext = this;
		
    	component.set("v.showUsers", false);
    	component.set("v.isDirectorArea", false);
    	component.set("v.showMultiSelect", false);
		
        var container 	= component.find("container").getElement();
        
    	$aGoals('[data-aljs="multi-select"]', container).aljsMultiSelect('setUnselectedItems', []);
		$aGoals('[data-aljs="multi-select"]', container).aljsMultiSelect('setSelectedItems', []);
		
        $aGoals('#multiSelectDiv', container).hide();         

		//helperContext.toggleSpinner(component);
    	helperContext.getOffices(component);
    },
    refreshRecordTotal: function (component) {
    	var container 	= component.find("container").getElement();
    	var unselectedItems = $aGoals('#ul-unselected li', container).length;
    	var selectedItems = $aGoals('#ul-selected li', container).length;
    	component.set("v.numItems",unselectedItems);
    	component.set("v.numItemsSelected",selectedItems);             
    }
})