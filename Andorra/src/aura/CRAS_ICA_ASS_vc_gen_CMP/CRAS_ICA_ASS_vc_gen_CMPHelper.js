({
    drawChart :  function(component, event, helper,currency,validArray,cancelledArray,diff,container,xAxisText){
        			var categories = [component.get("v.category1"),component.get("v.category2")];
                    Highcharts.chart('containerCH_' + container, {
                        
                        subtitle: {
                            
                        },
                        exporting: 
                        { 
                            enabled: true 
                        },
                        credits:{
                            enabled: false
                        },
                        yAxis: [{
                            categories: categories,
                            reversed: true,
                            labels: {
                                formatter: function () {
                                    return isNaN(Math.abs(this.value))?0:Math.abs(this.value);
                                },
                            },
                            tickInterval: currency == '' ? 40: 25000,
                            title: {
                                text: xAxisText
                            }
                        }],
                        xAxis: {
                            title: {
                                text: null
                            },
                            labels: {
                                formatter: function () {
                                    return this.value;
                                },
                            },
                            categories: categories
                        },
                        
                        plotOptions: {
                            series: {
                                stacking: 'normal',
                                pointPadding:0.0
                            },
                            column: {
                                pointPadding: 0.2,
                                borderWidth: 0
                        	},

                        },
                        legend: {
                            symbolHeight: 12,
                            symbolWidth: 12,
                            symbolRadius: 3
                        },
                        tooltip: {
                            formatter: function () {
                                return '<label class="legend_Label">' + this.series.name + ' ' + this.point.category + ': </label><span><b class="legend_Span">' +
                                    //Highcharts.numberFormat(Math.abs(this.point.y), 0) + '</b></span>';
                                    Number(Math.abs(this.point.y)).toLocaleString("es-ES", {minimumFractionDigits: 0}) + ' ' + currency +'</b></span>';
                            },
                           borderRadius: 2,
                           shadow:false,
                           shape: "square"  
                        },
                        
                        series: [{
                            name: component.get("v.legend1"),
                            data: validArray,
                            type: 'column',
                            color: '#00a1e0',
                            events: {
                                legendItemClick: function(){
                                    return false;
                                }
                            }
                        }, {
                            name: component.get("v.legend2"),
                            data: cancelledArray,
                            type: 'column',
                            color: '#16325c',
                            events: {
                                legendItemClick: function(){
                                    return false;
                                }
                            }
                        },{
                            name: component.get("v.legend3"),
                            data: diff,
                            type: 'spline',
                            color: '#76ded9',
                            lineWidth: 0,
                            states:{
                                hover:{
                            		enabled:false
                                    }
                            },
                            events: {
                                legendItemClick: function(){
                                    return false;
                                }
                            }
                        }
                                 
                                ],
                        title:{
                            text:' '
                        }     
                    });       
    },
    
	getDataFromApex : function(component, event, helper,grouping,category,container) {		
		var action;
        var currency;
        var xAxisText;
		
        if (grouping == 'Risk'){
		
			if (category == 'polNum'){
				action = component.get("c.getRiskSet");
                currency = '';
                component.set('v.currency', false);
                xAxisText = component.get("v.legend4");
			}
			
			if (category == 'totalAmount'){
				action = component.get("c.getRiskSet");
                currency = component.get('v.currencyCode');
                component.set('v.currency', true);
                xAxisText = currency;
			}

			if (category == 'insNum'){
				action = component.get("c.getRiskInsSet");
                currency = '';
                component.set('v.currency', false);
                xAxisText = component.get("v.legend5");
			}			
            
        } else if (grouping == 'Savings'){
            
			if (category == 'polNum'){
				action = component.get("c.getSavingsSet");
                currency = '';
                component.set('v.currency', false);
                xAxisText = component.get("v.legend4");
			}
			
			if (category == 'totalAmount'){
				action = component.get("c.getSavingsSet");
                currency = component.get('v.currencyCode');
                component.set('v.currency', true);
                xAxisText = currency;
			}
            
        }
        
         action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataReceived = JSON.parse(response.getReturnValue());
                
                if(dataReceived.length == 0){
                    var spinner = component.find("risk_vent_Spinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    $("#containerCH_" + container).html('<div class="no-data-container"><div class="no-data-message">' + component.get("v.nodata1") + '</div></div>');
                } else {
                    
                    var categories = [component.get("v.category1"),component.get("v.category2")];
                    var validArray = [];
                    var cancelledArray = [];
					var diff = [];
                
					if (dataReceived.length == 4){
                        var queryType = dataReceived[0].queryType;
						for(var i=0;i<dataReceived.length;i++){
						
							if (queryType == 'pol'){
								if(category == 'polNum'){
									if(dataReceived[i].status == 'valid'){
										validArray.push(parseInt(dataReceived[i].polCount)*(-1))
									} else if (dataReceived[i].status == 'cancelled'){
										cancelledArray.push(parseInt(dataReceived[i].polCount))
									}
								} else if(category == 'totalAmount'){
									if(dataReceived[i].status == 'valid'){
										validArray.push(parseFloat(dataReceived[i].polAmount)*(-1))
									} else if (dataReceived[i].status == 'cancelled'){
										cancelledArray.push(parseFloat(dataReceived[i].polAmount))
									}							
								}
							} else if (queryType == 'ins'){
								if(dataReceived[i].status == 'valid'){
									validArray.push(parseInt(dataReceived[i].insCount)*(-1))
								} else if (dataReceived[i].status == 'cancelled'){
									cancelledArray.push(parseInt(dataReceived[i].insCount))
								}
							}
						}
						
						for (var j=0; j<validArray.length; j++){
							diff.push(validArray[j]+cancelledArray[j]);
						}
						
					} else {
						//controlar error de salida
					}

                    
					helper.drawChart(component, event, helper,currency,validArray,cancelledArray,diff,container,xAxisText);
				}

			} else {
				console.log("error receiving data from controller");
			}
		});
        
        $A.enqueueAction(action);
	}
    
})