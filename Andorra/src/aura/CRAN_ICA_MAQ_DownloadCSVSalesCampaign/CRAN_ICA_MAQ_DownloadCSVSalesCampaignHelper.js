({
	convertArrayOfObjectsToCSV : function(objectRecords,columnNames) {
		//Le pasamos una lista de objetos y nos devuelve CSV como string
		//El array de columnas poner el nombre de los objetos para que haga el maping

        var csvStringResult, counter, columnNames, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return 'no data';
        }

        columnDivider = ',';
        lineDivider =  '\n';
        
        csvStringResult = '';
        csvStringResult += columnNames.join(columnDivider);
        csvStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
             counter = 0;
             for(var sTempkey in columnNames) {
                	var skey = columnNames[sTempkey] ;  
					if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   	}   
               csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
               counter++;
              } 
             csvStringResult += lineDivider;
          }
       return csvStringResult;       
	},
    
    
    
    
    makeDownload : function(csv) {
		//Hace la descarga del fichero csv
		
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self';  
        hiddenElement.download = 'salesCampaign.csv';  // CSV file Name you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    
    
    hideSpinner  : function(component) {
       var spinner = component.find("mySpinner"); 
       $A.util.addClass(spinner, "slds-hide"); 
    },
    
    
    showSpinner  : function(component) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide"); 
    }
    
    
})