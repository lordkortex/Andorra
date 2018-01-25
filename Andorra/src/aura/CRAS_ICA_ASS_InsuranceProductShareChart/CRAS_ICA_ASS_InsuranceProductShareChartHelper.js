({
    drawProductShareCount : function(component, event, helper) {
        
        var action = component.get("c.getReportPrimeCountProduct");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0){
                    var spinner = component.find("productShareListSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#containerP").html('<div class="no-data-container"><div class="no-data-message">' + component.get('v.nodata1') +'</div></div>');
                } else {
                    
                    var dataPrint = [];
                    var total = 0;
                    var colors = ['#00A1E0','#16325C','#76DED9','#08A69E','#E2CE7D',
                                  '#E69F00','#C23934','#FFB75D','#60B17D','#00716B'];
                    
                    for(var i=0; i< dataReceived.length; i++){
                        var pair = {};
                        pair.name = dataReceived[i][0];
                        pair.y = parseInt(dataReceived[i][2].replace(".",""));
                        total += pair.y;
                        dataPrint.push(pair);
                    }
                    
                    component.set('v.title', component.get("v.title1"));
                    component.set('v.total', total);
                    component.set('v.currency', false);
                    
                    if(total / 1000 > 1)
                    {
                        if(total / 1000000 > 1)
                        {
                            total = Math.round((total / 1000000) * 10) / 10 + 'M';
                        }
                        else
                        {
                            total = Math.round((total / 1000) * 10) / 10 + 'K';
                        }
                        
                    }
                    
                    //draw chart
                    Highcharts.chart('containerP', {
                        chart: {
                            type: 'pie'
                        },
                        credits:{
                            enabled: false
                        },
                        colors:colors,
                        title: {
                            text: ' '
                        },
                        exporting: 
                        { 
                            enabled: true 
                        },
                        legend: {
                            useHTML:true,
                            maxHeight: 45,
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3,
                            navigation: {
                                activeColor: '#16325C',
                                animation: true,
                                arrowSize: 12,
                                inactiveColor: '#CCC',
                                style: {
                                    color: '#868686'
                                }
                            }
                            
                        },
                        subtitle: {
                            text: total,
                            verticalAlign: 'middle',
                            y: -35,
                            floating: true,
                            useHTML: true
                        },
                        tooltip:{
                            borderRadius: 2,
                            shadow:false,
                            shape: "square",
                            formatter: function () {
                                return '<label class="legend_Label">' + this.point.name + ': </label><span><b class="legend_Span">' +
                                    Highcharts.numberFormat(Math.abs(this.point.y), 0) + '</b></span>';
                            }
                        },
                        plotOptions: {
                            pie: {
                                allowPointSelect: true,
                                cursor: 'pointer',
                                innerSize: '60%',
                                showInLegend: true,
                                borderWidth: 0,
                                dataLabels: {
                                    enabled: false,
                                    style: {
                                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                                    }
                                },
                                states: {
                                    hover: {
                                        enabled: true,
                                        halo: 0
                                    }
                                } 
                            }
                        },
                        series: [{
                            name: component.get("v.legend1"),
                            colorByPoint: true,
                            data: dataPrint,
                            point: {
                                events: {
                                    legendItemClick: function () {
                                        return false; // <== returning false will cancel the default action
                                    }
                                }
							}
                        }]
                    });
                }    
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
        
    },
    drawProductShareAmount : function(component, event, helper) {
        
        var action = component.get("c.getReportPrimeCountProduct");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0){
                    var spinner = component.find("productShareListSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#containerP").html('<div class="no-data-container"><div class="no-data-message">' + component.get('v.nodata2') +'</div></div>');
                } else {
                    
                    var dataPrint = [];
                    var total = 0;
                    var colors = ['#00A1E0','#16325C','#76DED9','#08A69E','#E2CE7D',
                                  '#E69F00','#C23934','#FFB75D','#60B17D','#00716B'];
                    
                    for(var i=0; i< dataReceived.length; i++){
                        var pair = {};
                        pair.name = dataReceived[i][0];
                        //pair.y = parseFloat(dataReceived[i][1].replace(".","").replace(",",".").replace(/[^\d.-]/g, ''));
                        pair.y = dataReceived[i][1] == null ? 0 : parseFloat(dataReceived[i][1]);
                        total += pair.y;
                        dataPrint.push(pair);
                    }
                    
                    component.set('v.title', component.get("v.title2"));
                    component.set('v.total', total);
                    component.set('v.currency', true);
                    
                    if(total / 1000 > 1)
                    {
                        if(total / 1000000 > 1)
                        {
                            total = Math.round((total / 1000000) * 10) / 10 + 'M';
                        }
                        else
                        {
                            total = Math.round((total / 1000) * 10) / 10 + 'K';
                        }
                        
                    }
                    
                    //draw chart
                    Highcharts.chart('containerP', {
                        chart: {
                            type: 'pie'
                        },
                        credits:{
                            enabled: false
                        },
                        colors: colors,
                        title: {
                            text: ' '
                        },
                        exporting: 
                        { 
                            enabled: true 
                        },
                        subtitle: {
                            text: total,
                            verticalAlign: 'middle',
                            y: -35,
                            floating: true,
                            useHTML: true
                        },
                        legend: {
                            useHTML:true,
                            maxHeight: 45,
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3,
                            navigation: {
                                activeColor: '#16325C',
                                animation: true,
                                arrowSize: 12,
                                inactiveColor: '#CCC',
                                style: {
                                    color: '#868686'
                                }
                            }
                            
                        },
                        tooltip:{
                            borderRadius: 2,
                            shadow:false,
                            shape: "square",
                            formatter: function () {
                                return '<label class="legend_Label">' + this.point.name + ': </label><span><b class="legend_Span">' +
                                    Highcharts.numberFormat(Math.abs(this.point.y), 0) + ' ' + component.get('v.currencyCode') + '</b></span>';
                            }
                        },
                        plotOptions: {
                            pie: {
                                allowPointSelect: true,
                                cursor: 'pointer',
                                innerSize: '60%',
                                showInLegend: true,
                                borderWidth: 0,
                                dataLabels: {
                                    enabled: false,
                                    style: {
                                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                                    }
                                },
                                states: {
                                    hover: {
                                        enabled: true,
                                        halo: 0
                                    }
                                } 
                            }
                        },
                        series: [{
                            name: component.get('v.currencyCode'),
                            colorByPoint: true,
                            data: dataPrint,
                            point: {
                                events: {
                                    legendItemClick: function () {
                                        return false; // <== returning false will cancel the default action
                                    }
                                }
							}
                        }]
                    });
                    
                }
                
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
        
    },
    drawProductShareInsureds : function(component, event, helper) {
        var action = component.get("c.getReportInsuredsProduct");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0){
                    var spinner = component.find("productShareListSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#containerP").html('<div class="no-data-container"><div class="no-data-message">' + component.get('v.nodata3') +'</div></div>');
                } else {
                    
                    var dataPrint = [];
                    var total = 0;
                    var colors = ['#00A1E0','#16325C','#76DED9','#08A69E','#E2CE7D',
                              '#E69F00','#C23934','#FFB75D','#60B17D','#00716B'];
                    
                    for(var i=0; i< dataReceived.length; i++){
                        var pair = {};
                        pair.name = dataReceived[i][0];
                        pair.y = parseInt(dataReceived[i][1].replace(".",""));
                        total += pair.y;
                        dataPrint.push(pair);
                    }
                    
                    component.set('v.title', component.get("v.title3"));
                    component.set('v.total', total);
                    component.set('v.currency', false);
                    
                    if(total / 1000 > 1)
                    {
                        if(total / 1000000 > 1)
                        {
                            total = Math.round((total / 1000000) * 10) / 10 + 'M';
                        }
                        else
                        {
                            total = Math.round((total / 1000) * 10) / 10 + 'K';
                        }
                        
                    }
                    
                    //draw chart
                    Highcharts.chart('containerP', {
                        chart: {
                            type: 'pie'
                        },
                        credits:{
                            enabled: false
                        },
                        colors:colors,
                        title: {
                            text: ' '
                        },
                        exporting: 
                        { 
                            enabled: true 
                        },
                        legend: {
                            useHTML:true,
                            maxHeight: 45,
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3,
                            navigation: {
                                activeColor: '#16325C',
                                animation: true,
                                arrowSize: 12,
                                inactiveColor: '#CCC',
                                style: {
                                    color: '#868686'
                                }
                            }
                            
                        },
                        subtitle: {
                            text: total,
                            verticalAlign: 'middle',
                            y: -35,
                            floating: true,
                            useHTML: true
                        },
                        tooltip:{
                            borderRadius: 2,
                            shadow:false,
                            shape: "square",
                            formatter: function () {
                                return '<label class="legend_Label">' + this.point.name + ': </label><span><b class="legend_Span">' +
                                    Highcharts.numberFormat(Math.abs(this.point.y), 0) + '</b></span>';
                            }
                        },
                        plotOptions: {
                            pie: {
                                allowPointSelect: true,
                                cursor: 'pointer',
                                innerSize: '60%',
                                showInLegend: true,
                                borderWidth: 0,
                                dataLabels: {
                                    enabled: false,
                                    style: {
                                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                                    }
                                },
                                states: {
                                    hover: {
                                        enabled: true,
                                        halo: 0
                                    }
                                } 
                            }
                        },
                        series: [{
                            name: component.get("v.legend3"),
                            colorByPoint: true,
                            data: dataPrint,
                            point: {
                                events: {
                                    legendItemClick: function () {
                                        return false; // <== returning false will cancel the default action
                                    }
                                }
							}
                        }]
                    });
                    
                }   
                
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
    },
    
})