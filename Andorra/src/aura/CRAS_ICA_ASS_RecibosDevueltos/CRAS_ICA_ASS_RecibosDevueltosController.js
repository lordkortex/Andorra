({
    init : function(component, event, helper) {
        var action = component.get("c.getRecibosDevueltos");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0){
                    var spinner = component.find("listSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_RD").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                } else {
                    var color1 = "#00a1e0";
                    
                    var categories = [];
                    var series = [];
                    series.push({});
                    series[0].name = component.get('v.legend1');
                    series[0].data = [];   
                    
                    
                    for(var i=0;i<dataReceived.length;i++){
                        var point = {};
                        categories.push(dataReceived[i][0]);
                        var current_value = parseFloat(dataReceived[i][1].replace(/,/g , ""));
                        var current_amount = parseFloat(dataReceived[i][2].replace(/,/g , ""));
                        //current_value = Number(current_value).toLocaleString("es-ES", {minimumFractionDigits: 0})
                        current_amount = Number(current_amount).toLocaleString("es-ES", {minimumFractionDigits: 2})
                        
                        series[0].data.push({y:current_value, name:current_amount});
                    }
                    
                    
                    Highcharts.chart('container_RD', {
                        chart: {
                            type: 'column'
                        },
                        title: {
                            text: ''
                        },
                        subtitle: {
                            text: ''
                        },
                        legend: {
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3
                        },
                        xAxis: {
                            categories: categories,
                            crosshair: true,
                            title: {
                                text: component.get('v.legend4')
                            },
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: component.get('v.legend2')
                            },
                            minTickInterval: 1,
                        },
                        tooltip: {
                            //valueSuffix: ' %'  
                            formatter: function() {
                                var result = '<label class="legend_Label">' + component.get('v.legend2') + ': </label><span><b class="legend_Span">' + this.y + '</b></span>';
                                result += '<br>'
                                result += '<label class="legend_Label">' + component.get('v.legend3') + ': </label><span><b class="legend_Span">' + this.point.name + ' EUR</b></span>';
                                
                                return result;
                            },
                            borderRadius: 2,
                            shadow:false,
                            shape: "square"
                        },
                        plotOptions: {
                            column: {
                                pointPadding: 0.2,
                                borderWidth: 0,
                                events: {
                                    legendItemClick: function(){
                                        return false;
                                    }
                                }
                            },
                            series: {
                                pointPadding:0.0
                            }
                        },
                        series: series,
                        credits: {
                            enabled: false
                        },
                        colors: [color1]
                        
                    });
                    
                    
                }
                
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
    }
})