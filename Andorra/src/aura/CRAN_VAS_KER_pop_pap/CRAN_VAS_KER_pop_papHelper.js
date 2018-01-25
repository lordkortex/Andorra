({	 
    callApexMethod : function(component) 
    {
    	window.open('/apex/pdfContenido?BP='+component.get("v.strBP") + '&Order=' +  component.get("v.strOrderNr")+'&RF=' + component.get("v.strReferenceLine"));
 	}
    
})