({
    
    drawChart : function(component, event, helper,currency,total,dataPrint){
        //draw chart     
        return Highcharts.chart('container', {
                        chart: {
                            type: 'pie'
                        },
                        credits:{
                            enabled: false
                        },
                        colors : ['#00a1e0','#16325c','#76ded9'], 
                        title: {
                            text: ' '
                        },
                        subtitle: {
                            text: total,
                            verticalAlign: 'middle',
                            y: -25,
                            floating: true,
                            useHTML: true
                        },
                        exporting: 
                        { 
                            enabled: true 
                        },
                        legend: {
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3
                        },
                        tooltip: {
                            borderRadius: 2,
                            shadow:false,
                            shape: "square",
                            formatter: function () {
                                return '<label class="legend_Label">' + this.point.name + ': </label><span><b class="legend_Span">' +
                                    Highcharts.numberFormat(Math.abs(this.point.y), 0) + ' ' + currency + '</b></span>';
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
                                    enabled: true,
                                    formatter:function() 
                                    {
                                        var val = this.y
                                        if(val / 1000 > 1)
                                        {
                                            if(val / 1000000 > 1)
                                            {
                                                val = Math.round(val / 1000000) + 'M';
                                            }
                                            else
                                            {
                                                val = Math.round(val / 1000)+ 'K';
                                            }
                                            
                                        }
                                        return val;
                                    },
                                    distance: -30 ,
                                    style: {"color": "#ffffff", 
                                            "fontSize": "13px", 
                                            "fontWeight": "normal", 
                                            "textOutline": "0px #FFFFFF" 
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
                            name: currency,
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
        
    },
    
    drawMarketShareCount : function(component, event, helper) {
        
        var action = component.get("c.getReportPrimeCountMarket");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0){
                    var spinner = component.find("marketShareListSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container").html('<div class="no-data-container"><div class="no-data-message">' + component.get('v.nodata1') +'</div></div>');
                } else {
                    
                    var dataPrint = [];
                    var total = 0;
                    
                    for(var i=0; i< dataReceived.length; i++){
                        var pair = {};
                        pair.name = dataReceived[i][0];
                        pair.y = parseInt(dataReceived[i][2].replace(".",""));
                        total += pair.y;
                        dataPrint.push(pair);
                    }
                    
                    component.set('v.total', total);
                    component.set('v.currency', false);
                    component.set('v.title', component.get("v.title1"));
                    
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
                    var chart = helper.drawChart(component, event, helper,'',total,dataPrint);
                    
                }
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
        
    },
    drawMarketShareAmount : function(component, event, helper) {
        
        var action = component.get("c.getReportPrimeCountMarket");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0){
                    var spinner = component.find("marketShareListSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container").html('<div class="no-data-container"><div class="no-data-message">' + component.get('v.nodata2') +'</div></div>');
                } else {
                    
                    var dataPrint = [];
                    var total = 0;
                    
                    for(var i=0; i< dataReceived.length; i++){
                        var pair = {};
                        pair.name = dataReceived[i][0];
                        pair.y = dataReceived[i][1] == null ? 0 : parseFloat(dataReceived[i][1]);
                        total += pair.y;
                        dataPrint.push(pair);
                    }
                    
                    component.set('v.total', total);
                    component.set('v.currency', true);
                    component.set('v.title', component.get("v.title2"));
                    
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
                    var chart = helper.drawChart(component, event, helper,component.get('v.currencyCode'),total,dataPrint);
                    
                }
                
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
        
    },
    drawMarketShareInsureds : function(component, event, helper) {
        var action = component.get("c.getReportInsuredsMarket");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0){
                    var spinner = component.find("marketShareListSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container").html('<div class="no-data-container"><div class="no-data-message">' + component.get('v.nodata3') +'</div></div>');
                } else {
                    
                    var dataPrint = [];
                    var total = 0;
                    
                    for(var i=0; i< dataReceived.length; i++){
                        var pair = {};
                        pair.name = dataReceived[i][0];
                        pair.y = parseInt(dataReceived[i][1].replace(".",""));
                        total += pair.y;
                        dataPrint.push(pair);
                    }
                    
                    component.set('v.total', total);
                    component.set('v.currency', false);
                    component.set('v.title', component.get("v.title3"));
                    
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
                    var chart = helper.drawChart(component, event, helper,'',total,dataPrint);
                    
                }
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
    },
    
})