({
    // Load data from Apex Data Provider and draw chart.
    createChart : function(component, event, helper) {

        var action = component.get("c.getChartjsData");
        var self = this;
        
        action.setParams( {"dataProviderName" : component.get("v.apexDataProvider") } );
        
        action.setCallback(this, function(a) {
            
            // Prevents null data from changing default values from Chart.js
            var response = helper.replaceUndefinedOrNull(JSON.parse(a.getReturnValue())); 
				
            // Check if there is not chart to be displayed
            if (response == null || response == "" || response == "[]" || response == "{}"){
                component.set("v.isChartDataEmpty", true);
                return;
            } else {	
                component.set("v.isChartDataEmpty", false);
            }
			console.log('response');
            console.dir(response);
            helper.drawChart(component, response, self);
            
        });
        
        $A.enqueueAction(action);
    }
})