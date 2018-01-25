({
    drawChart: function(component, event, helper, currency, legendString, data, categories, plotLines, plotBands, ventas, objetivo){

        Highcharts.chart('container_ventas_objetivos', {
                                chart: {
                                    type: 'column'
                                },
                                colors : ['#16325c'], 
                                title: {
                                    text: ''
                                },
                                xAxis: {
                                    categories: categories
                                },
                                yAxis: {
                                    min: 0,
                                    max:ventas>objetivo?ventas*1.2:objetivo*1.2,
                                    plotLines: plotLines,
                                    plotBands: plotBands,
                                    title : currency
                                },
                                plotOptions: {
                                    column: {
                                        pointPadding: 0.01,
                                        borderWidth: 0,
                                        events: {
                                            legendItemClick: function(){
                                                return false;
                                            }
                                        }
                                    }
                                },
                                series: [{
                                    name: component.get('v.legend1'),
                                    data: data
                            
                                }],
                                credits: {
                                    enabled: false
                                },
                                legend: {
                                    symbolHeight: 12,
                                    symbolWidth: 12,
                                    symbolRadius: 3,
                                    labelFormatter: function () {
                                        return this.name + ' ' + legendString;
                                    },
                                    useHTML: true
                                    
                                },
                                tooltip:{
                                    formatter: function () {
                                        return '<label class="legend_Label">' + this.point.category + '</label><br/><label class="legend_Label">' + this.series.name + ': </label><span><b class="legend_Span">' +
                                            Number(this.point.y).toLocaleString("es-ES", {minimumFractionDigits: currency==''?0:2}) + ' ' + currency + '</b></span>';
                                    },
                                   borderRadius: 2,
                                   shadow:false,
                                   shape: "square"
                                }
                            });
        },
    
	drawHealth : function(component, event, helper) {
		var action = component.get("c.getVentasObjetivos");
        action.setParams({"market":"health"});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());

                if(dataReceived.length==0){
                    var spinner = component.find("container_ventas_objetivos_listSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_ventas_objetivos").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                    component.set("v.lastUpdate", "");  
                } else {
            
                    var ventas = parseFloat(dataReceived[0]);
                    var objetivo = parseFloat(dataReceived[1]);
                    var lastUpdate = dataReceived[4];
                    
                    var plotLines;
                    var plotBands;
                    var data;
                    var categories;
                    
                    var legendString = '<label class="objetivoActual">' + component.get('v.objetivoActual') + '</label>';
                    
                    if(dataReceived[7] != 'noDoubleBar'){
                        var ventas995 = parseFloat(dataReceived[5]);
                        var objetivo995 = parseFloat(dataReceived[6]);
                        
                        plotLines = [{
                            value: objetivo,
                            color: '#08a69e',
                            width: 0,
                            dashStyle: 'Dot',
                            label: {
                                text: Number(objetivo).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' ' + component.get('v.currencyCode'),
                                rotation: 270,
                                textAlign: 'right',
                                x: 14,
                                y: 5,
                                style: {
                                    color: '#999999',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5
                        },
                        {
                        	value: objetivo995,
                            color: '#76DED9',
                            dashStyle: 'Dot',
                            width: 0,
                            label: {
                                text: Number(objetivo995).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' ' + component.get('v.currencyCode'),
                                align: "right",
                                rotation: 270,
                                textAlign: 'left',
                                x: -6,
                                style: {
                                    color: '#999999',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5
                         }           
                        ];
                        
                        plotBands = [{color: '#eff7f7',
                                        from: 0,
                                        to: objetivo
                                      },
                                      {
                                        color: '#d7efef',
                                        from: 0,
                                        to: objetivo995
                                      }];
                     
                        data = [ventas,ventas995];
                        categories = [component.get('v.comercialBanking'), component.get('v.office995')];
                        
                        
                    } else {
                         plotLines = [{
                            value: objetivo,
                            color: '#08a69e',
                            width: 0,
                            dashStyle: 'Dot',
                            label: {
                                text: Number(objetivo).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' ' + component.get('v.currencyCode'),
                                rotation: 270,
                                textAlign: 'right',
                                x: 14,
                                y: 5,
                                style: {
                                    color: '#999999',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5
                        }        
                        ];
                        
                        plotBands = [{color: '#eff7f7',
                                        from: 0,
                                        to: objetivo
                                      }];
                        
                        data = [ventas];
                        categories = [component.get('v.comercialBanking')];
                    }
                    
                    if(dataReceived[8] != 'noCampaignReal'){
                        
                        legendString += '<label class="objetivoReal">' + component.get('v.objetivoReal') + '</label>';
                        
                        plotLines.push({
                            value: parseFloat(dataReceived[7]),
                            color: '#08A69E',
                            width: 2,
                            label: {
                                text: Number(parseFloat(dataReceived[7])).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' ' + component.get('v.currencyCode'),
                                align: "right",
                                x:-5,
                                style: {
                                    color: '#08A69E',
                                    fontSize: '13',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5                            
                        })
                    }
                    if (lastUpdate !== undefined){
                        var lastupdatespt = lastUpdate.split("-");
                        
                        if(lastupdatespt.length>0){
                            lastUpdate = lastupdatespt[2] + '-' + lastupdatespt[1] + '-' + lastupdatespt[0];
                        }
                        component.set("v.lastUpdate", component.get("v.lastUpdateLabel") + " " + lastUpdate);   
					}
                    helper.drawChart(component, event, helper, component.get('v.currencyCode'), legendString, data, categories, plotLines, plotBands, ventas, objetivo);
                    
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
	
                if(dataReceived.length==0){
                    var spinner = component.find("container_ventas_objetivos_listSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_ventas_objetivos").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                    component.set("v.lastUpdate", '');  
                } else {
            
                    var ventas = parseFloat(dataReceived[0]);
                    var objetivo = parseFloat(dataReceived[1]);
                    var lastUpdate = dataReceived[4];
                    
                    var plotLines;
                    var plotBands;
                    var data;
                    var categories;
                    
                    var legendString = '<label class="objetivoActual">' + component.get('v.objetivoActual') + '</label>';

				if(dataReceived[7] != 'noDoubleBar'){
                        var ventas995 = parseFloat(dataReceived[5]);
                        var objetivo995 = parseFloat(dataReceived[6]);
                        
                        plotLines = [{
                            value: objetivo,
                            color: '#08a69e',
                            dashStyle: 'Dot',
                            width: 0,
                            label: {
                                text: Number(objetivo).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' ' + component.get('v.currencyCode'),
                                rotation: 270,
                                textAlign: 'right',
                                x: 14,
                                y: 5,
                                style: {
                                    color: '#999999',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5
                        },
                        {
                        	value: objetivo995,
                            color: '#76DED9',
                            dashStyle: 'Dot',
                            width: 0,
                            label: {
                                text: Number(objetivo995).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' ' + component.get('v.currencyCode'),
                                align: "right",
                                rotation: 270,
                                textAlign: 'left',
                                x: -6,
                                style: {
                                    color: '#999999',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5
                         }           
                        ];
                    
                    plotBands = [{color: '#eff7f7',
                                  from: 0,
                                  to: objetivo
                                 },
                                 {
                                     color: '#d7efef',
                                     from: 0,
                                     to: objetivo995
                                 }];
                     
                        data = [ventas,ventas995];
                        categories = [component.get('v.comercialBanking'), component.get('v.office995')];
                        
                        
                    } else {
                         plotLines = [{
                            value: objetivo,
                            color: '#08a69e',
                            width: 0,
                            dashStyle: 'Dot',
                            label: {
                                text: Number(objetivo).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' ' + component.get('v.currencyCode'),
                                rotation: 270,
                                textAlign: 'right',
                                x: 14,
                                y: 5,
                                style: {
                                    color: '#999999',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5
                        }        
                        ];
                        
                        plotBands = [{color: '#eff7f7',
                                      from: 0,
                                      to: objetivo
                                     }];
                        
                        data = [ventas];
                        categories = [component.get('v.comercialBanking')];
                    }
                    
                    if(dataReceived[8] != 'noCampaignReal'){
                        
                        legendString += '<label class="objetivoReal">' + component.get('v.objetivoReal') + '</label>';
                        
                        plotLines.push({
                            value: parseFloat(dataReceived[7]),
                            color: '#08a69e',
                            width: 2,
                            label: {
                                text: Number(parseFloat(dataReceived[7])).toLocaleString("es-ES", {minimumFractionDigits: 2}) + ' ' + component.get('v.currencyCode'),
                                align: "right",
                                x:-5,
                                style: {
                                    color: '#08A69E',
                                    fontSize: '13',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5                            
                        });
                    }
                    if (lastUpdate !== undefined){
                        var lastupdatespt = lastUpdate.split("-");
                        if(lastupdatespt.length>0){
                            lastUpdate = lastupdatespt[2] + '-' + lastupdatespt[1] + '-' + lastupdatespt[0];
                        }
                        component.set("v.lastUpdate", component.get("v.lastUpdateLabel") + ": " + lastUpdate);  
                    }
                    
                    helper.drawChart(component, event, helper, component.get('v.currencyCode'), legendString, data, categories, plotLines, plotBands, ventas, objetivo);
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
	
                if(dataReceived.length==0){
                    var spinner = component.find("container_ventas_objetivos_listSpinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#container_ventas_objetivos").html('<div class="no-data-container"><div class="no-data-message">'+ component.get('v.nodata1') +'</div></div>');
                    component.set("v.lastUpdate", "");  
                } else {
            
                    var ventas = parseFloat(dataReceived[0]);
                    var objetivo = parseFloat(dataReceived[1]);
                    var lastUpdate = dataReceived[4];
                    
                    var plotLines;
                    var plotBands;
                    var data;
                    var categories;
                    
                    var legendString = '<label class="objetivoActual">' + component.get('v.objetivoActual') + '</label>';
                    
				if(dataReceived[7] != 'noDoubleBar'){
                        var ventas995 = parseFloat(dataReceived[5]);
                        var objetivo995 = parseFloat(dataReceived[6]);
                        
                        plotLines = [{
                            value: objetivo,
                            color: '#08a69e',
                            dashStyle: 'Dot',
                            width: 0,
                            label: {
                                text: Number(objetivo).toLocaleString("es-ES", {minimumFractionDigits: 0}),
                                rotation: 270,
                                textAlign: 'right',
                                x: 14,
                                y: 5,
                                style: {
                                    color: '#999999',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5
                        },
                        {
                        	value: objetivo995,
                            color: '#76DED9',
                            dashStyle: 'Dot',
                            width: 0,
                            label: {
                                text: Number(objetivo995).toLocaleString("es-ES", {minimumFractionDigits: 0}),
                                align: "right",
                                rotation: 270,
                                textAlign: 'left',
                                x: -6,
                                style: {
                                    color: '#999999',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5
                         }           
                        ];
                     
							plotBands = [{color: '#eff7f7',
                                  from: 0,
                                  to: objetivo
                                 },
                                 {
                                     color: '#d7efef',
                                     from: 0,
                                     to: objetivo995
                                 }];                    
                    
                        data = [ventas,ventas995];
                        categories = [component.get('v.comercialBanking'), component.get('v.office995')];
                        
                        
                    } else {
                         plotLines = [{
                            value: objetivo,
                            color: '#08a69e',
                            dashStyle: 'Dot',
                            width: 0,
                            label: {
                                text: Number(objetivo).toLocaleString("es-ES", {minimumFractionDigits: 0}),
                                rotation: 270,
                                textAlign: 'right',
                                x: 14,
                                y: 5,
                                style: {
                                    color: '#999999',
                                    fontWeight: '500',
                                    fontFamily: 'Salesforce Sans'
                                }
                            },
                            zIndex: 5
                        }        
                        ];
                        
                        plotBands = [{color: '#eff7f7',
                                      from: 0,
                                      to: objetivo
                                     }];
                        
                        data = [ventas];
                        categories = [component.get('v.comercialBanking')];
                    }
                    
                    if (lastUpdate !== undefined){
                        var lastupdatespt = lastUpdate.split("-");
                        
                        if(lastupdatespt.length>0){
                            lastUpdate = lastupdatespt[2] + '-' + lastupdatespt[1] + '-' + lastupdatespt[0];
                        }
                        component.set("v.lastUpdate", component.get("v.lastUpdateLabel") + ": " + lastUpdate);  
                    }
                    helper.drawChart(component, event, helper, '', legendString, data, categories, plotLines, plotBands, ventas, objetivo);
                    
                    
               } 
            } else {
                console.log('Problem getting ' + ', response state: ' + state);
            }
        });
        $A.enqueueAction(action); 		
	},
})