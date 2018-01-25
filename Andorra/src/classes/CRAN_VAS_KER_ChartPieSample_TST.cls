global with sharing class CRAN_VAS_KER_ChartPieSample_TST extends CRAN_VAS_KER_ChartJsPieData_CLS implements CRAN_VAS_KER_IChartJsDataProvider_CLS {
   
    global static String getChartjsData() {
        
        // The component can handle more than one chart per once
        List<CRAN_VAS_KER_ChartJsPieData_CLS> 	charts = new List<CRAN_VAS_KER_ChartJsPieData_CLS>();
        
        // Creating a chart
        CRAN_VAS_KER_ChartJsPieData_CLS 		chartjsData = new CRAN_VAS_KER_ChartJsPieData_CLS();
        chartjsData.chartType = 'doughnut';
        
        // Setting a title for the chart
        ChartOptionTitle 	title 						= new ChartOptionTitle();
                            title.text 					= 'My Chart Sample';
                            title.display 				= true;
        					chartjsData.options.title 	= title;
        
        // Instantiate the dataset
        chartjsData.data.datasets = new List<ChartjsDataset>();        
        
        // Sample Labels
        chartjsData.data.labels = new list<String>	{'Jan','Feb','Mar','Apr','May','Jun','Jul'};
        
        // Creating a dataset to be used in the chart
        ChartjsDataset 	dataset 		= new chartjsDataset();
                        dataset.label 	= 'My First dataset';
                        dataset.data 	= new Integer[] {65, 59, 80, 81, 56, 55, 40}; 
        
        // DoughNut center information
        Integer total = 0;
        
        for (Integer num : dataset.data)
            total+= num;
        
        chartjsData.doughnutInnerText = String.valueOf(total);
            
        // Retrieves random colors based on the amount of values
        List<List<Integer>> rgbas 					= chartjsData.getRandomColor(dataset.data.size(), true);
        					dataset.backgroundColor = new List<String>();
        					dataset.hoverBackgroundColor = new List<String>();
        
        for (Integer i=0; i < dataset.data.size(); i++) {
            String colorString = 'rgba(' + rgbas.get(i).get(0) + ',' + rgbas.get(i).get(1) + ',' + rgbas.get(i).get(2) + ',0.8)';
            dataset.backgroundColor.add(colorString);
            dataset.hoverBackgroundColor.add(colorString);
        }
        
		// Adds the dataset to the list of datasets
        chartjsData.data.datasets.add(dataset);
        
        // Add the report to the list of reports
        charts.add(chartjsData);
        
        // Creating a second chart
        chartjsData = new CRAN_VAS_KER_ChartJsPieData_CLS();
        chartjsData.chartType = 'pie';

        // Instantiate the dataset
        chartjsData.data.datasets = new List<ChartjsDataset>();        
        
        // Sample Labels
        chartjsData.data.labels = new list<String>	{'Oct','Nov','Dec' };
        
        // Creating a dataset to be used in the chart
        dataset 		= new chartjsDataset();
        dataset.label 	= 'My Second dataset';
        dataset.data 	= new Integer[] {85, 29, 45}; 
               
        // Retrieves random colors based on the amount of values
        rgbas 							= chartjsData.getRandomColor(dataset.data.size(), true);
        dataset.backgroundColor 		= new List<String>();
        dataset.hoverBackgroundColor 	= new List<String>();
        
        for (Integer i=0; i < dataset.data.size(); i++) {
            String colorString = 'rgba(' + rgbas.get(i).get(0) + ',' + rgbas.get(i).get(1) + ',' + rgbas.get(i).get(2) + ',0.8)';
            dataset.backgroundColor.add(colorString);
            dataset.hoverBackgroundColor.add(colorString);
        }
        
		// Adds the dataset to the list of datasets
        chartjsData.data.datasets.add(dataset);

        // Add the second report to the list of reports
        charts.add(chartjsData);        
        
        // Return a serialized json object
        return JSON.serialize(charts);
    }
    
}