public with sharing class CRAN_VAS_KER_Datatable_AUC {

    @AuraEnabled
	public static Object getRecords(String dataProviderName, Map<String, Object> params) {
            
        CRAN_VAS_KER_DatatableProvider_CLS dp;
        dp = (CRAN_VAS_KER_DatatableProvider_CLS)type.forName(dataProviderName).newInstance();
        return dp.getRecords(params);        
        
	}

    @AuraEnabled
	public static void deleteRecord(Id recordId) {     
		Database.delete(recordId);
	}      
}