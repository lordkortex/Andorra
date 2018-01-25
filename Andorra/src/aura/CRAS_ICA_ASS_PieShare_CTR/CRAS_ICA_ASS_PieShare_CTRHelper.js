({

    drawChart : function(component, event, helper,currency,total,dataPrint,printVal,container){
        //draw chart
        var global_container = 'global_container_' + container;
        return Highcharts.chart(global_container, {
                        chart: {
                            type: 'pie'
                        },
                        credits:{
                            enabled: false
                        },
                        colors : ['#00A1E0','#16325C','#76DED9','#08A69E','#E2CE7D',
                                  '#E69F00','#C23934','#FFB75D','#60B17D','#00716B'],
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
                        tooltip: {
                            borderRadius: 2,
                            shadow:false,
                            shape: "square",
                            formatter: function () {
                                return '<label class="legend_Label">' + this.point.name + ': </label><span><b class="legend_Span">' +
                                    //Highcharts.numberFormat(Math.abs(this.point.y), 0) + ' ' + currency + '</b></span>';
                                    Number(this.point.y).toLocaleString("es-ES", {minimumFractionDigits: currency == '' ? 0:2}) + ' ' + currency + '</b></span>';
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
										if(printVal){
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
										} else {
											return '';
										}
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
    
    getDataFromApex : function(component, event, helper,grouping,category,container) {
   		
		var action;
        var resultPosition;
        var currency;
        var printVal;

        if (grouping == 'Market Share'){
		
			if (category == 'polNum'){
				action = component.get("c.getReportPrimeCountMarket");
                resultPosition = 2; 
                currency = '';
                printVal = true;
                component.set('v.currency', false);
			}
			
			if (category == 'totalAmount'){
				action = component.get("c.getReportPrimeCountMarket");
                resultPosition = 1;
                currency = component.get('v.currencyCode');
                printVal = true;
                component.set('v.currency', true);
			}

			if (category == 'insNum'){
				action = component.get("c.getReportInsuredsMarket");
                resultPosition = 1; 
                currency = '';
                printVal = true;
                component.set('v.currency', false);
			}			
            
        } else if (grouping == 'Product Share'){
            
			if (category == 'polNum'){
				action = component.get("c.getReportPrimeCountProduct");
                resultPosition = 2;
                currency = '';
                printVal = false;
                component.set('v.currency', false);
			}
			
			if (category == 'totalAmount'){
				action = component.get("c.getReportPrimeCountProduct");
                resultPosition = 1;
                currency = component.get('v.currencyCode');
                printVal = false;
                component.set('v.currency', true);
			}

			if (category == 'insNum'){
				action = component.get("c.getReportInsuredsProduct");
                resultPosition = 1;
                currency = '';
                printVal = false;
                component.set('v.currency', false);
			}				
		
        } else if (grouping == 'Saving Product Share') {

			if (category == 'polNum'){
				action = component.get("c.getReportPrimeCountSVProduct");
                resultPosition = 1;
                currency = '';
                printVal = false;
                component.set('v.currency', false);
			}

			if (category == 'insNum'){
				action = component.get("c.getReportInsuredsSVProduct");
                resultPosition = 1;
                currency = '';
                printVal = false;
                component.set('v.currency', false);
			}
        }
        

            action.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state === "SUCCESS") {
                    var dataReceived = JSON.parse(response.getReturnValue());
                    //dataReceived = [];
                    
                    if(dataReceived.length==0){
                        var spinner = component.find("marketShareListSpinner");
                        $A.util.toggleClass(spinner, "slds-hide");
                        $("#global_container_" + container).html('<div class="no-data-container"><div class="no-data-message">' + component.get('v.nodata1') +'</div></div>');
                    } else {
                    	 
                        var dataPrint = [];
                        var total = 0;
                        
                        for(var i=0; i< dataReceived.length; i++){
                            
                            var pair = {};
                            pair.name = dataReceived[i][0];
                            pair.y = resultPosition == 2 ? parseInt(dataReceived[i][resultPosition].replace(".","")) : parseFloat(dataReceived[i][resultPosition]);
                            total += pair.y; 
                            dataPrint.push(pair);
                            
                        }
                        var total_full = Number(total).toLocaleString("es-ES", {minimumFractionDigits: currency=='' ? 0:2});
                        
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
                    
                        
                    helper.drawChart(component, event, helper,currency,total,dataPrint,printVal,container);
                    component.set('v.total', total_full);    
                        
                    }
                } else {
                    console.log('Problem getting ' + ', response state: ' + state);
                }
        });
        $A.enqueueAction(action); 
        

        
    }
})