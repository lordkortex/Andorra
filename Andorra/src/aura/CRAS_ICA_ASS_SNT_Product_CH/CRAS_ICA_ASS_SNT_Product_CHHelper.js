({
	drawAll : function(component, event, helper) {
		var action = component.get("c.getSntByMarket");
        action.setParams({"groupType":"product","byYear":"false"});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
	
                if(dataReceived.length==0){
                    var spinner = component.find("SNT_PROD_ListSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_PROD_MRK").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                } else {
            
                    var categories = [];
                    var series = [];
                    series.push({});
                    series[0].name = component.get('v.legend1');
                    series[0].data = [];
                    
                    var color1 = "#0fe088";
                    var color2 = "#ffe368";
                    var color3 = "#e03535";
                    
                    for(var i=0;i<dataReceived.length;i++){
                        categories.push(dataReceived[i][0]);
                        
                        //DETERMINAR COLOR
                        //var current_value = parseFloat(dataReceived[i][1].replace(".","").replace(",",".").replace(/[^\d.-]/g, ''));
                        var current_value = parseFloat(dataReceived[i][1]);
                        var bmk_green = parseFloat(dataReceived[i][2]);
                        var bmk_yellow = parseFloat(dataReceived[i][3]);
                        var current_color;
                        
                        if(current_value <= bmk_green){
                            current_color = color1;
                        } else if (current_value <= bmk_yellow){
                            current_color = color2;
                        } else {
                            current_color = color3;
                        }
                        
                        series[0].data.push({y:current_value, color: current_color, name: bmk_green + "__" + bmk_yellow});
                    }
                    
    
                    Highcharts.chart('container_SNT_PROD', {
                        chart: {
                            type: 'bar',
                        },
                        title: {
                            text: ' ',
                            useHTML: true
                        },
                        exporting: 
                        { 
                            enabled: true 
                        },
                        legend:{
                            enabled:false,
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3
                        },
                        xAxis: {
                            categories: categories,
                            title: {
                                text: null
                            }
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: component.get('v.legend1'),
                            },
                            labels: {
                                overflow: 'justify',
                                format: "{value}" + " %"
                            }
                        },
                        tooltip: {
                            //valueSuffix: ' %'  
                            formatter: function() {
                                
                                var bmk_array = this.point.name.split("__");
                                bmk_array[0] = Number(bmk_array[0]).toLocaleString("es-ES", {minimumFractionDigits: 0});
								bmk_array[1] = Number(bmk_array[1]).toLocaleString("es-ES", {minimumFractionDigits: 0});	
                                
                                var result = '<label class="legend_Label">' + component.get('v.legend1') + ': </label><span><b class="legend_Span">' + this.y + ' %</b></span>';
                                result += '<br>'
                                result += '<label class="legend_Label">' + component.get('v.legend2') + ': </label><span><b class="legend_Span">' + component.get('v.lowerThan') + ' ' + bmk_array[0] + ' %</b></span>';
                                result += '<br>'
                                result += '<label class="legend_Label">' + component.get('v.legend3') + ': </label><span><b class="legend_Span">' + component.get('v.between') + ' ' + bmk_array[0] + '-' + bmk_array[1] + ' %</b></span>';
                                result += '<br>'
                                result += '<label class="legend_Label">' + component.get('v.legend4') + ': </label><span><b class="legend_Span">' + component.get('v.greaterThan') + ' ' + bmk_array[1] + ' %</b></span>';
                                
                            	return result;
                        	},
                               borderRadius: 2,
                               shadow:false,
                               shape: "square"
                        },
                        plotOptions: {
                            bar: {
                                dataLabels: {
                                    enabled: true,
                                    formatter:function(){ 
                                        return Number(this.y).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' %';
                                    }
                                }
                            },
                            series: {
                                colorByPoint: true
                            }
                        },
                        
                        credits: {
                            enabled: false
                        },
                        series: series,
                        categories: categories
                    });
                }
                
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
	},
    
    drawYear : function(component, event, helper) {
		var action = component.get("c.getSntByMarket");
        action.setParams({"groupType":"product","byYear":"true"});
        var currentyear = '' + new Date().getFullYear();
        component.set('v.year', currentyear);
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
	
                if(dataReceived.length==0){
                    var spinner = component.find("SNT_PROD_ListSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_SNT_PROD").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                } else {
            
                    var categories = [];
                    var series = [];
                    series.push({});
                    series[0].name = component.get('v.legend1');
                    series[0].data = [];
                    
                    var color1 = "#0fe088";
                    var color2 = "#ffe368";
                    var color3 = "#e03535";
                    
                    for(var i=0;i<dataReceived.length;i++){
                        categories.push(dataReceived[i][0]);
                        
                        //DETERMINAR COLOR
                        //var current_value = parseFloat(dataReceived[i][1].replace(".","").replace(",",".").replace(/[^\d.-]/g, ''));
                        var current_value = parseFloat(dataReceived[i][1]);
                        var bmk_green = parseFloat(dataReceived[i][2]);
                        var bmk_yellow = parseFloat(dataReceived[i][3]);
                        var current_color;
                        
                        if(current_value <= bmk_green){
                            current_color = color1;
                        } else if (current_value <= bmk_yellow){
                            current_color = color2;
                        } else {
                            current_color = color3;
                        }
                        
                        series[0].data.push({y:current_value, color: current_color, name: bmk_green + "__" + bmk_yellow});
                    }
                    
    
                    Highcharts.chart('container_SNT_PROD', {
                        chart: {
                            type: 'bar',
                        },
                        title: {
                            text: ' ',
                            useHTML: true
                        },
                        exporting: 
                        { 
                            enabled: true 
                        },
                        legend:{
                            enabled:false,
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3 
                        },
                        xAxis: {
                            categories: categories,
                            title: {
                                text: null
                            }
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: component.get('v.legend1'),
                            },
                            labels: {
                                overflow: 'justify',
                                format: "{value}" + " %"
                            }
                        },
                        tooltip: {
                            //valueSuffix: ' %'  
                            formatter: function() {
                                
                                var bmk_array = this.point.name.split("__");
                                bmk_array[0] = Number(bmk_array[0]).toLocaleString("es-ES", {minimumFractionDigits: 0});
								bmk_array[1] = Number(bmk_array[1]).toLocaleString("es-ES", {minimumFractionDigits: 0});	
                                
                                var result = '<label class="legend_Label">' + component.get('v.legend1') + ': </label><span><b class="legend_Span">' + Number(this.y).toLocaleString("es-ES", {minimumFractionDigits: 0}); + ' %</b></span>';
                                result += '<br>'
                                result += '<label class="legend_Label">' + component.get('v.legend2') + ': </label><span><b class="legend_Span">' + component.get('v.lowerThan') + ' ' + bmk_array[0] + ' %</b></span>';
                                result += '<br>'
                                result += '<label class="legend_Label">' + component.get('v.legend3') + ': </label><span><b class="legend_Span">' + component.get('v.between') + ' ' + bmk_array[0] + '-' + bmk_array[1] + ' %</b></span>';
                                result += '<br>'
                                result += '<label class="legend_Label">' + component.get('v.legend4') + ': </label><span><b class="legend_Span">' + component.get('v.greaterThan') + ' ' + bmk_array[1] + ' %</b></span>';
                                
                            	return result;
                        	},
                               borderRadius: 2,
                               shadow:false,
                               shape: "square"
                        },
                        plotOptions: {
                            bar: {
                                dataLabels: {
                                    enabled: true,
                                    formatter:function(){ 
                                        return Number(this.y).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' %';
                                    }
                                }	
                            },
                            series: {
                                colorByPoint: true
                            }
                        },
                        
                        credits: {
                            enabled: false
                        },
                        series: series,
                        categories: categories
                    });
                }
                
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
	}
})