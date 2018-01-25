({
    doInit : function(component, event, helper) {
        var relatedList = component.get("v.RelatedList");
        var action = '';
        var recordsCount = 0;
        
        if (relatedList == 'FA Insurance PolicyHolder'){
            helper.loadAction(component, "c.getPHRelListRolesFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, "c.getInsuranceRolesPHCount", "v.RecordsCount", "accId", component.get("v.recordId"));
            action = component.get("c.getRolesPHFromAccount");
            component.set("v.IsFAPHRolList","true");
        }
        else if (relatedList == 'FA Insurance Roles'){
            helper.loadAction(component, "c.getRelListRolesFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, "c.getInsuranceRolesCount", "v.RecordsCount", "accId", component.get("v.recordId"));
            action = component.get("c.getRolesFromAccount");
            component.set("v.IsFARolesList","true");
        }
        else if (relatedList == 'Claims'){
            helper.loadAction(component, "c.getRelListClaimsFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, "c.getClaimsCount", "v.RecordsCount", "accId", component.get("v.recordId"));
            action = component.get("c.getClaimsFromAccount");
            component.set("v.IsClaimsList","true");
            component.set("v.YearMax", new Date().getFullYear() - 2);
        }
        else if(relatedList == 'FA Insurance Roles And PolicyHolder')
        {
            helper.loadAction(component, "c.getPHRelListRolesFieldNames", "v.ColumnNames");
            helper.loadActionParam(component, "c.getInsurancePHICount", "v.RecordsCount", "accId", component.get("v.recordId"));
            action = component.get("c.getInsurancePHI");
            component.set("v.IsFAPHIRolList","true");
        }
        
        recordsCount = component.get("v.RecordsCount");
        
        action.setParams({"accId": component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                
                if(relatedList == 'FA Insurance Roles And PolicyHolder')
                {
                    var result = response.getReturnValue(); 
                    var mapping = [];
                    var resultProces = [];
                    
                    for(var i=0; i < result.length; i++)
                    {
                        if(mapping[result[i].FinServ__FinancialAccount__r.Id] === undefined)
                        {
                            mapping[result[i].FinServ__FinancialAccount__r.Id] = result[i];
                        }
                        else
                        {
                            if(mapping[result[i].FinServ__FinancialAccount__r.Id].Role !== result[i].Role)
                            {
                                mapping[result[i].FinServ__FinancialAccount__r.Id].Role += ', ' + result[i].Role;
                            }
                            
                        }
                    }
                    
                    for(var m in mapping)
                    {
                        resultProces.push(mapping[m]);
                    }
                    
                    
                    component.set("v.ResultList", resultProces); 
                }
                else
                {
                    component.set("v.ResultList", response.getReturnValue()); 
                }

                helper.toggleSpinner(component, "listSpinner");
            } else {
                console.log('Problem getting the Records (' + relatedList + '), response state: ' + state);
            }
        });
        
        $A.enqueueAction(action);
    }
})