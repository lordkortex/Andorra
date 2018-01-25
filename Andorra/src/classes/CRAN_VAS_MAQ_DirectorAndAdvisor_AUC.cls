public with sharing class CRAN_VAS_MAQ_DirectorAndAdvisor_AUC {

    @AuraEnabled
    public static String getSobjectLabel(Id recordId) {
    	
    	List<String> response = new List<String>();
    	
    	response.add(CRAN_VAS_KER_SchemaHelper_CLS.getSObjectLabelPluralById(recordId).toUpperCase());
    	response.add(CRAN_VAS_KER_SchemaHelper_CLS.getRecordNameById(recordId).toUpperCase());
    	response.add(CRAN_VAS_KER_SchemaHelper_CLS.getSObjectApiName(recordId));
        return JSON.serialize(response);
    }
    
}