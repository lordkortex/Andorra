global with sharing class CRAN_VAS_KER_ChartJs_AUC {
    @AuraEnabled
    global static string getChartjsData(string dataProviderName){
        CRAN_VAS_KER_IChartJsDataProvider_CLS dp;
        dp = (CRAN_VAS_KER_IChartjsDataProvider_CLS)type.forName(dataProviderName).newInstance();
        return dp.getChartjsData();
    }
}