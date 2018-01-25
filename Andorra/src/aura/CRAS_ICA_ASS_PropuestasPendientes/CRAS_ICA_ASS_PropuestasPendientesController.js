({
    init : function(component, event, helper) {
        var action = component.get("c.getPropuestasPendientes");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length==0){
                    var spinner = component.find("listSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_PP").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                } else {
                    var colors = ['#00a1e0','#16325c','#76ded9','#008080'];
                    
                    var dataPrint = [];
                    var total = 0;
                    
                    for(var i=0; i< dataReceived.length; i++){
                        var pair = {};
                        pair.name = dataReceived[i][0];
                        pair.y = parseInt(dataReceived[i][1].replace(".",""));
                        total += pair.y;
                        dataPrint.push(pair);
                    }
                    
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
                    Highcharts.chart('container_PP', {
                        chart: {
                            type: 'pie'
                        },
                        credits:{
                            enabled: false
                        },
                        colors : colors, 
                        title: {
                            text: ' '
                        },
                        subtitle: {
                            text: total,
                            verticalAlign: 'middle',
                            y: -30,
                            x:0,
                            floating: true,
                            useHTML: true
                        },
                        legend: {
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3
                        },
                        exporting: 
                        { 
                            enabled: true 
                        },
                        tooltip: {
                            borderRadius: 2,
                            shadow:false,
                            shape: "square",
                            formatter: function () {
                                return '<label class="legend_Label">' + this.point.name + ': </label><span><b class="legend_Span">' +
                                    Highcharts.numberFormat(Math.abs(this.point.y), 0) + '</b></span>';
                            },
                            
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
                                        return this.y;
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
                            name: component.get('v.legend1'),
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
    }
})