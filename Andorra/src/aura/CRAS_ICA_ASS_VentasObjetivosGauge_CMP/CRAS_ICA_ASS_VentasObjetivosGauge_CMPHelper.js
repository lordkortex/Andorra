({
    
    drawChart: function(component, event, helper, ventas, objetivo, ventas_format){
                        //gauge
                        
                        Highcharts.chart('container_ventas_objetivos_g', {
                            chart: {
                                plotBackgroundColor: null,
                                plotBorderWidth: 0,
                                plotShadow: false
                            },
                            title: {
                                text: '',
                                align: 'center',
                                verticalAlign: 'top',
                                y: 40
                            },
                            subtitle: {
                                text: ventas_format + ' ' + component.get('v.currencyCode'),
                                verticalAlign: 'middle',
                                y: 40,
                                x: 0,
                                floating: true,
                                useHTML: true
                            },
                            tooltip: {
                                //pointFormat: '{point.x}: <b>{point.y}</b>'
                                pointFormatter : function() {
                                    return '<b>'+ this.y + ' ' + component.get('v.currencyCode') + '</b><br/>'
                                },
                                formatter: function () {
                                    return '<label class="legend_Label">' + this.point.name + ': </label><span><b class="legend_Span">' +
                                        Number(Math.abs(this.point.y)).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' ' + component.get('v.currencyCode') + '</b></span>';
                                },
                                borderRadius: 2,
                                shadow: false,
                                shape: "square"
                                
                            },
                            legend: {
                                symbolHeight: 12,
                                symbolWidth: 12,
                                symbolRadius: 3
                            },
                            plotOptions: {
                                pie: {
                                    dataLabels: {
                                        enabled: false,
                                        distance: -50,
                                        style: {
                                            fontWeight: 'bold',
                                            color: 'white'
                                        }
                                    },
                                    startAngle: -90,
                                    endAngle: 90,
                                    center: ['50%', '75%'],
                                    size: '80%',
                                    borderWidth: 0,
                                    showInLegend: true
                                },
                                
                            },
                            series: [{
                                type: 'pie',
                                name: '',
                                innerSize: '60%',
                                states: {
                                    hover: {
                                        enabled: true,
                                        halo: 0
                                    }
                                },  
                                data: [{
                                    y:ventas,
                                    name:component.get('v.legend1')
                                },{
                                    y: ventas > objetivo ? 0 : Math.round((objetivo-ventas)*100) / 100.00,
                                    name: component.get('v.legend2')
                                }],
                                point: {
                                    events: {
                                        legendItemClick: function () {
                                            return false; // <== returning false will cancel the default action
                                        }
                                    }
                                }                            
                            }],
                            credits: {
                                enabled: false
                            },
                            colors:['#00a1e0','#16325c']
                        });
                        
                        //end gauge
    },
        
    drawHealth : function(component, event, helper) {
        var action = component.get("c.getVentasObjetivos");
        action.setParams({"market":"health"});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0 || (dataReceived[2]==0 && dataReceived[3]==0) ){
                    var spinner = component.find("container_ventas_objetivos_listSpinner_g");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_ventas_objetivos_g").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                    component.set("v.lastUpdate", "");  
                } else {
                    
                    var ventas = parseFloat(dataReceived[2]);
                    var objetivo = parseFloat(dataReceived[3]);
                    var lastUpdate = dataReceived[4];
                    
                    var ventas_format = ventas;
                    
                    if(ventas_format / 1000 > 1)
                    {
                        if(ventas_format / 1000000 > 1)
                        {
                            ventas_format = Math.round((ventas / 1000000) * 10) / 10 + 'M';
                        }
                        else
                        {
                            ventas_format = Math.round((ventas / 1000) * 10) / 10 + 'K';
                        }
                    }
                    
                    //gauge
                    helper.drawChart(component, event, helper, ventas, objetivo, ventas_format);
                   
                    //end gauge
                    if (lastUpdate !== undefined){
                        var lastupdatespt = lastUpdate.split("-");
                        
                        if(lastupdatespt.length>0){
                            lastUpdate = lastupdatespt[2] + '-' + lastupdatespt[1] + '-' + lastupdatespt[0];
                        }
                        component.set("v.lastUpdate", component.get("v.lastUpdateLabel") + " " + lastUpdate);                       
                    }
                } 
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 		
    },
    
    drawLife : function(component, event, helper) {
        var action = component.get("c.getVentasObjetivos");
        action.setParams({"market":"life"});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0 || (dataReceived[2]==0 && dataReceived[3]==0) ){
                    var spinner = component.find("container_ventas_objetivos_listSpinner_g");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_ventas_objetivos_g").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                    component.set("v.lastUpdate", "");
                } else {
                    
                    var ventas = parseFloat(dataReceived[2]);
                    var objetivo = parseFloat(dataReceived[3]);
                    var lastUpdate = dataReceived[4];
                    
                    var ventas_format = ventas;
                    
                    if(ventas_format / 1000 > 1)
                    {
                        if(ventas_format / 1000000 > 1)
                        {
                            ventas_format = Math.round((ventas / 1000000) * 10) / 10 + 'M';
                        }
                        else
                        {
                            ventas_format = Math.round((ventas / 1000) * 10) / 10 + 'K';
                        }
                    }
                    helper.drawChart(component, event, helper, ventas, objetivo, ventas_format);
                    
                    //end gauge
                    //
                    if (lastUpdate !== undefined){
                        var lastupdatespt = lastUpdate.split("-");
                        
                        if(lastupdatespt.length>0){
                            lastUpdate = lastupdatespt[2] + '-' + lastupdatespt[1] + '-' + lastupdatespt[0];
                        }
                        component.set("v.lastUpdate", component.get("v.lastUpdateLabel") + " " + lastUpdate);                      
                    }
                    
                } 
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 		
    },
    
    drawSavings : function(component, event, helper) {
        var action = component.get("c.getVentasObjetivos");
        action.setParams({"market":"savings"});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                
                if(dataReceived.length==0 || (dataReceived[2]==0 && dataReceived[3]==0) ){
                    var spinner = component.find("container_ventas_objetivos_listSpinner_g");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_ventas_objetivos_g").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                } else {
                    
                    var ventas = parseFloat(dataReceived[2]);
                    var objetivo = parseFloat(dataReceived[3]);
                    
                    var ventas_format = ventas;
                    
                    if(ventas_format / 1000 > 1)
                    {
                        if(ventas_format / 1000000 > 1)
                        {
                            ventas_format = Math.round((ventas / 1000000) * 10) / 10 + 'M';
                        }
                        else
                        {
                            ventas_format = Math.round((ventas / 1000) * 10) / 10 + 'K';
                        }
                    }
                    
                    Highcharts.chart('container_ventas_objetivos_g', {
                        chart: {
                            plotBackgroundColor: null,
                            plotBorderWidth: 0,
                            plotShadow: false
                        },
                        title: {
                            text: component.get('v.title1'),
                            align: 'center',
                            verticalAlign: 'top',
                            y: 40
                        },
                        subtitle: {
                            text: ventas_format == 0 ? '0' : ventas_format,
                            verticalAlign: 'middle',
                            y: 40,
                            x: 0,
                            floating: true,
                            useHTML: true
                        },                      
                        tooltip: {
                            //pointFormat: '{point.x}: <b>{point.y}</b>'
                            pointFormatter : function() {
                                return '<b>'+ this.y + ' ' + component.get('v.currencyCode') + '</b><br/>'
                            },
                            formatter: function () {
                                return '<label class="legend_Label">' + this.point.name + ': </label><span><b class="legend_Span">' +
                                    Highcharts.numberFormat(Math.abs(this.point.y), 0) + '</b></span>';
                            },
                            borderRadius: 2,
                            shadow:false,
                            shape: "square"
                        },
                        legend: {
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3
                        },
                        plotOptions: {
                            pie: {
                                dataLabels: {
                                    enabled: false,
                                    distance: -50,
                                    style: {
                                        fontWeight: 'bold',
                                        color: 'white'
                                    }
                                },
                                startAngle: -90,
                                borderWidth: 0,
                                endAngle: 90,
                                center: ['50%', '75%'],
                                size: '80%',
                                showInLegend: true
                            }
                        },
                        series: [{
                            type: 'pie',
                            name: '',
                            innerSize: '60%',
                            states: {
                                hover: {
                                    enabled: true,
                                    halo: 0
                                }
                            },    
                            data: [{
                                y:ventas,
                                name:component.get('v.legend1')
                            },{
                                y: ventas > objetivo ? 0 : Math.round((objetivo-ventas)*100) / 100.00,
                                name: component.get('v.legend2')
                            }],
                             point: {
                                events: {
                                    legendItemClick: function () {
                                        return false; // <== returning false will cancel the default action
                                    }
                                }
							}
                        }],
                        credits: {
                            enabled: false
                        },
                        colors:['#00a1e0','#16325c']
                    });
                    
                    //end gauge
                    //component.set("v.lastUpdate", component.get("v.lastUpdateLabel") + " " + lastUpdate);   
                } 
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 		
    }
})