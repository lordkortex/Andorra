({
	doInit : function(component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        var param;
        var val;
        var isLV = false;
        for (var i = 0; i < sURLVariables.length; i++) {
            param = sURLVariables[i].split('='); 

            if (param[0] === 'obj') { 
                val = param[1] === undefined ? 'Not found' : param[1];
                component.set("v.object", val);
            }
            else if (param[0] === 't' && !isLV) { 
                val = param[1] === undefined ? 'Not found' : param[1];
                component.set("v.title", val);
            }
            else if (param[0] === 'lv') { 
                val = param[1] === undefined ? 'Not found' : param[1];
                component.set("v.listView", val);
                component.set("v.title", val);
                isLV = true;
            }
            else if (param[0] === 'rpp') { 
                val = param[1] === undefined ? 'Not found' : param[1];
                component.set("v.recordsPerPage", val);
            }
            else if (param[0] === 'pr') { 
                val = param[1] === undefined ? 'Not found' : param[1];
                component.set("v.provider", val);
            }
            else if (param[0] === 'recordId') { 
                val = param[1] === undefined ? 'Not found' : param[1];
                component.set("v.recordId", val);
            }
        }

        var recordsPerPage = component.get("v.recordsPerPage");
        var object = component.get("v.object");
        var listView = component.get("v.listView");
        var currentPage = component.get("v.currentPage");
        var pr = component.get("v.provider");
        var recordId = component.get("v.recordId");
        
        if (object && (listView || pr)){
        	helper.loadActionParam(component, helper, "c.getRecordsCount", "v.RecordsCount", "", "", recordsPerPage, [object, listView, pr, recordId]);
        }
	},
    doLoadRecords : function(component, event, helper) {
		
        var action = component.get("c.getRecords");
        var object = component.get("v.object");
        var listView = component.get("v.listView");
        var rpp = component.get("v.recordsPerPage");
        var pr = component.get("v.provider");
        var recordId = component.get("v.recordId");
        var os = Math.round( (component.get("v.currentPage")-1)*rpp);
        
        if (object && (listView || pr)){
            action.setParams({"objName"	: object,
                              "listViewName": listView,
                              "rpp"		: rpp,
                              "offset"	: os,
                              "selectProvider": pr,
                              "recordId": recordId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state === "SUCCESS") {
                    var result = response.getReturnValue(); 
                    
                    /*
                    for(var i=0; i < result.length; i++)
                    {
                        console.log(result[i]);
                    }*/
                    
                    component.set("v.ResultList", result);
                    helper.toggleSpinner(component, "spinner");
                } else {
                    console.log(response.getError()[0]);
                    console.log(response.getError()[0].message);
                    console.log('Problem getting the Records, response state: ' + state);
                }
            });
    
            $A.enqueueAction(action);
        }
    },
    
    handlePress : function(cmp,event,helper) {
        var whichOne = event.getSource().getLocalId();
        var newPage = parseInt(whichOne.replace("pagButton",""));
        cmp.set("v.currentPage",newPage);
        cmp.doLoadRecordsMethod();
    }
})