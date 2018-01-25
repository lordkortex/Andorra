public with sharing class CRAN_VAS_KER_SchemaHelper_CLS {

    public static String getSObjectLabelById(Id recordId) {
        return recordId.getSobjectType().getDescribe().getLabel();
    }
   	
   	public static String getSObjectLabelPluralById(Id recordId) {
        return recordId.getSobjectType().getDescribe().getLabelPlural();
    }
    
    public static String getRecordNameById(Id recordId) {    	        
        try {
            String query = 'SELECT Name FROM '+getSObjectApiName(recordId)+' where Id=:recordId';
            sObject record = Database.query(query);

            return (String)record.get('Name');
        } catch(Exception ex) {
            return '';
        }
    }
    
    public static String getSObjectApiName(Id recordId) {
        return recordId.getSobjectType().getDescribe().getName();
    }  
}