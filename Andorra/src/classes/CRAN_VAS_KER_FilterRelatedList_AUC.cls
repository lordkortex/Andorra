public with sharing class CRAN_VAS_KER_FilterRelatedList_AUC {

	/**
    * Get Existing Record Types for the Object objName
    *
    * @param  	objName Name of the object we want to get RecordTypes available
    * @return a map with all recordTypes available, with its names as key and its values as value
    */     
	@AuraEnabled
    public static Map<String,Id> getAvailableRecordTypes(String sObjectApiName) {
        SYSTEM.debug('sObjectApiName ' + sObjectApiName);
        Map<String,Id> oppRecTypes = new Map<String,Id>();
        oppRecTypes = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypesByName(sObjectApiName,true);
        
        return oppRecTypes;
	}
    
    @AuraEnabled
    public static String getSobjectLabel(Id recordId) {
    	
    	List<String> response = new List<String>();
    	
    	response.add(CRAN_VAS_KER_SchemaHelper_CLS.getSObjectLabelPluralById(recordId).toUpperCase());
    	response.add(CRAN_VAS_KER_SchemaHelper_CLS.getRecordNameById(recordId).toUpperCase());
    	response.add(CRAN_VAS_KER_SchemaHelper_CLS.getSObjectApiName(recordId));
        return JSON.serialize(response);
    }    

}