@isTest
private class CRAN_VAS_KER_ChartJs_TST {
	
    @isTest static void testPieSampleData() {
       
        String jsonReturn = CRAN_VAS_KER_ChartJs_AUC.getChartJsData('CRAN_VAS_KER_ChartPieSample_TST');
        
        try {
            
            List<CRAN_VAS_KER_ChartJsPieData_CLS> charts = (List<CRAN_VAS_KER_ChartJsPieData_CLS>)JSON.deserialize(jsonReturn, List<CRAN_VAS_KER_ChartJsPieData_CLS>.class);
            
            // There must be two charts to render
            system.assert(charts.size() == 2);
            
            // Assess that the data is not null
            for (CRAN_VAS_KER_ChartJsPieData_CLS chart : charts) {
                system.assert(chart.data.datasets != null);
            }
        } catch (Exception ex) { 
            system.assert(false);
        }
    }
    
    @isTest static void testInvalidProvider() {
       
        try {
            // An invalid provider must throw an exception
            CRAN_VAS_KER_ChartJs_AUC.getChartJsData('INVALID_PROVIDER');
        } catch (Exception ex) {
            system.assert(ex.getTypeName() == 'System.NullPointerException');
        }
    }    
    
}