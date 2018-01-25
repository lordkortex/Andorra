({
	doInit : function(component, event, helper) {
        var relatedList = component.get("v.RelatedList");
        var recordsPerPage = component.get("v.recordsPerPage");
		
        if (relatedList == 'Insurance Invoices'){
            helper.loadAction(component, helper, "c.getRelListInvoicesFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, helper, "c.getInsuranceInvoicesCount", "v.RecordsCount", "finAccId", component.get("v.recordId"),recordsPerPage);
            component.set("v.IsInvoicesList","true");
        }
        else if (relatedList == 'Insurance Roles'){
            helper.loadAction(component, helper, "c.getRelListRolesFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, helper, "c.getInsuranceRolesCount", "v.RecordsCount", "finAccId", component.get("v.recordId"),recordsPerPage);
            component.set("v.IsRolesList","true");
        }
        else if (relatedList == 'Insurance PolicyHolder'){
            helper.loadAction(component, helper, "c.getRelListPhFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, helper, "c.getInsurancePolicyHolderRoleCount", "v.RecordsCount", "finAccId", component.get("v.recordId"),recordsPerPage);
            component.set("v.IsPolicyHolderRolList","true");
        }
        else if (relatedList == 'Insurance Guarantees'){
            helper.loadAction(component, helper, "c.getRelListGuaranteesFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, helper, "c.getInsuranceGuaranteesCount", "v.RecordsCount", "finAccId", component.get("v.recordId"),recordsPerPage);
            component.set("v.IsGuaranteesList","true");
        }
        else if (relatedList == 'Insurance Products'){
            helper.loadAction(component, helper, "c.getRelListProductsFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, helper, "c.getInsuranceProductsCount", "v.RecordsCount", "finAccId", component.get("v.recordId"),recordsPerPage);
            component.set("v.IsProductsList","true");
        }
        else if (relatedList == 'Claims'){
            helper.loadAction(component, helper, "c.getClaimsListFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, helper, "c.getClaimsCount", "v.RecordsCount", "finAccId", component.get("v.recordId"),recordsPerPage);
            component.set("v.IsClaimsList","true");
            component.set("v.YearMax", new Date().getFullYear() - 2);
        }
        else if (relatedList == 'Insurance And PolicyHolder'){
            helper.loadAction(component, helper, "c.getRelListRolesFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, helper, "c.getInsuranceRolesPHICount", "v.RecordsCount", "finAccId", component.get("v.recordId"),recordsPerPage);
            component.set("v.IsRolesPHI","true");
        }
	},
    loadRecords : function(component, event, helper) {
        var relatedList = component.get("v.RelatedList");
        var recordsCount = 0;
    	recordsCount = component.get("v.RecordsCount");
        var rpp = component.get("v.recordsPerPage");
        var os = (component.get("v.currentPage")-1)*rpp;
       
        var action = '';
        
        if (relatedList == 'Insurance Invoices'){
            action = component.get("c.getInsuranceInvoices");
        }
        else if (relatedList == 'Insurance Roles'){
            action = component.get("c.getInsuranceRoles");
        }
        else if (relatedList == 'Insurance PolicyHolder'){
            action = component.get("c.getInsurancePolicyHolderRole");
        }
        else if (relatedList == 'Insurance Guarantees'){
            action = component.get("c.getInsuranceGuarantees");
        }
        else if (relatedList == 'Insurance Products'){
            action = component.get("c.getInsuranceProducts");
        }
        else if (relatedList == 'Claims'){
            action = component.get("c.getClaims");
        }
        else if (relatedList == 'Insurance And PolicyHolder'){
            action = component.get("c.getInsuranceRolesPHI");
        }

        action.setParams({"finAccId": component.get("v.recordId"),"rpp": rpp,"os": os});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                if (relatedList == 'Insurance Invoices'){
            		component.set("v.InsuranceInvoices", response.getReturnValue());
                    helper.toggleSpinner(component, "invoicesListSpinner");
                }
                else if (relatedList == 'Insurance Roles' || relatedList == 'Insurance PolicyHolder'){
                    component.set("v.InsuranceRoles", response.getReturnValue());
                    helper.toggleSpinner(component, "rolesListSpinner");
                    helper.toggleSpinner(component, "phListSpinner");
                }
                else if (relatedList == 'Insurance Guarantees'){
                    component.set("v.InsuranceGuarantees", response.getReturnValue());
                    helper.toggleSpinner(component, "guaranteesListSpinner");
                    
                }
                else if (relatedList == 'Insurance Products'){
                    component.set("v.InsuranceProducts", response.getReturnValue());
                    helper.toggleSpinner(component, "productsListSpinner");
                }
                else if (relatedList == 'Claims'){
                    component.set("v.ClaimsResultList", response.getReturnValue());
                    helper.toggleSpinner(component, "listClaimsSpinner");
                }
                else if (relatedList == 'Insurance And PolicyHolder'){
                    var lblGuarantees = $A.get("$Label.c.CRAS_ICA_ASS_Guarantee_Title");
                    var result = response.getReturnValue(); 
                    var mapping = [];
                    var resultProces = [];
                    
                    for(var i=0; i < result.length; i++)
                    {
                        result[i].GuranteeTitle = encodeURI(lblGuarantees + ': ' + result[i].FinServ__RelatedContact__r.FirstName + ' ' + result[i].FinServ__RelatedContact__r.LastName);
                        
                        if(mapping[result[i].FinServ__RelatedContact__r.Id] === undefined)
                        {
                            mapping[result[i].FinServ__RelatedContact__r.Id] = result[i];
                        }
                        else
                        {
                            if(mapping[result[i].FinServ__RelatedContact__r.Id].Role !== result[i].Role)
                            {
                                mapping[result[i].FinServ__RelatedContact__r.Id].Role += ', ' + result[i].Role;
                            }
                            
                        }
                    }
                    
                    for(var m in mapping)
                    {
                        resultProces.push(mapping[m]);
                    }
                    
                    
                    component.set("v.RolesPHIList", resultProces); 
                    helper.toggleSpinner(component, "listRolPHISpinner");
                }
                
            } else {
                console.log('Problem getting the Records, response state: ' + state);
            }
        });

        $A.enqueueAction(action);
    },
    
    handlePress : function(cmp,event,helper) {
        var whichOne = event.getSource().getLocalId();
        var newPage = parseInt(whichOne.replace("pagButton",""));
        cmp.set("v.currentPage",newPage);
        cmp.loadRecordsMethod();

    }
    
})