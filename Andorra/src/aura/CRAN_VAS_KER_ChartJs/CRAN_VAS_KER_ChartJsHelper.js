({

    // Draw chart using chart.js.
    // If chart instance already exists, it will be destroyed and re-created.
	drawChart : function(component, chartList, context) {

        for (i=0; i < chartList.length; i ++) {
            
            var chartSetup = chartList[i];
            var chartData  = chartSetup.data;

            if (chartData.datasets != null && chartData.datasets.length > 0) {
                
                for (j=0; j < chartData.datasets.length; j++) {
                    
                    // if data is not set, exit.
                    if (chartData.datasets[j].data == null || typeof chartData.datasets[j].data != 'object'){
                        console.error("Chart data is corrupted. Required property 'chartData.datasets[" + j + "].data' not found or data format is incorrect.");
                        return;
                    }
                    
                }                
                
                // Check available Chart Type based on the provided data
                var availableChartTypeList = this.getAvailableChartTypeList(component, chartData);
                component.set("v.availableChartTypeList", availableChartTypeList);
                
                // If chart already exists, we destroy it first and re-create to clean the state.
               // var chart = component.get("v.chart");
                //if (chart != null){
                   //	 chart.destroy();
//                }
          
                // Save chart instance, chart data and chart option so that we can refer them afterward. Ex. Those properties are refered when chart type is changed.
               // component.set("v.chart", chart);
               // component.set("v.chartData", chartData);
               // component.set("v.chartOption", chartOption);
         		
               
               // Create a promise to create the chart container and then create the chart instance 
               this.createChartContainer(i, component, chartSetup).then(
                    $A.getCallback(function(result){
 		                 
                        if (result.chartSetup.hasOwnProperty('doughnutInnerText')) {
                            result.chartSetup.options['elements'] = {
                                center: {
                                    // the longest text that could appear in the center
                                    maxText: '100%',
                                    text: result.chartSetup.doughnutInnerText,
                                    fontColor: '#36A2EB',
                                    fontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
                                    fontStyle: 'normal',
                                    fontSize: 12,
                                    // if a fontSize is NOT specified, we will scale (within the below limits) maxText to take up the maximum space in the center
                                    // if these are not specified either, we default to 1 and 256
                                    minFontSize: 1,
                                    maxFontSize: 256,
                                }
                            };
                        }
                        
                        var ctx = document.getElementById(result.chartId);
                        context['myChart' + result.chartId] = new Chart(ctx,{
                            type: result.chartSetup.chartType,
                            data:result.chartSetup.data,
                            options: result.chartSetup.options
                        }); 
 
                    }),
                    $A.getCallback(function(error){
                        // Something went wrong
                        alert('An error occurred getting the account : ' + error.message);
                    })
                );                 
                
            }
		}
    },
    ////
    // Return available chart types based on the provided chart data.
    getAvailableChartTypeList : function(component, chartData){
        if (chartData.length > 0){
            if (chartData[0].value != null && chartData[0].color != null){
                return [
                    {name:"Pie",label:"Pie"},
                    {name:"Doughnut", label:"Doughnut"},
                    {name:"PolarArea", label:"Polar Area"}
                ];
            }
        }
        if (chartData.datasets != null && chartData.labels != null) {
            return [
                {name:"Line",label:"Line"},
                {name:"Bar", label:"Bar"},
                {name:"Radar", label:"Radar"}
            ];
        }
    },
    ////
    // Return the default color based on the available chart types.
    getDefaultChartTypeByAvailableChartTypeList : function(component, availableChartTypeList){
        return availableChartTypeList[0].name;
    },
    camelize: function (str) {
        return str.replace(/(?:^\w|[A-Z]|\b\w|\s+)/g, function(match, index) {
            if (+match === 0) return ""; // or if (/\s+/.test(match)) for white spaces
            return index == 0 ? match.toLowerCase() : match.toUpperCase();
        });
    },
    createChartContainer: function(counter, component, chartSetup) {
        return new Promise(function(resolve, reject) {
            
            var chartId = "chart" + counter;

            $A.createComponents([
                ["canvas",
                 {
                     "id": chartId,
                     "height": chartSetup.height,
                     "width": chartSetup.width
                 }],
                ["div",
                 {
                     "class" : "slds-float--left"
                 }]
            ], 
            function(components, status, errorMessage) {
  
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var newChart = components[0];
                    var div1 =  components[1];                   
                    div1.set("v.body", newChart);
                    
                    var body = component.get("v.body");
                    body.push(div1);
                    component.set("v.body", body);
                    
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.");
                    reject(Error("Unknown error"));
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    reject(Error("Unknown error"));
                    // Show error message
                }
         	});
            resolve({ chartId : chartId, chartSetup : chartSetup});
        });
    },
    replaceUndefinedOrNull : function (obj) {
        for (var propName in obj) {
            if (obj[propName] === null || obj[propName] === undefined) {
                delete obj[propName];
            } else if (typeof obj === 'object') {
                this.replaceUndefinedOrNull(obj[propName]);
            }
        }
        return obj;
    }
})