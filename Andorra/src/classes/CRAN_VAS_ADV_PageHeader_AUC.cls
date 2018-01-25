public with sharing class CRAN_VAS_ADV_PageHeader_AUC{

    /**
     * Inner class for get String parameters in JSON format,
     * deserialize in order to use them and serialized for 
     * using as the final return String result too
	 */
    public class PageHeaderOptions {
        
        public String fieldName;
        public String iconName;
        public String iconCategory;
        public String value;
        public String label;
        public String fieldType;
        
    }
    
    @AuraEnabled
    public static String getRecordTypeById(String recordId) {       
        Id castedRecordId = Id.valueOf(recordId);
        String objectName = castedRecordId.getSobjectType().getDescribe().getName();
        String query = String.format('SELECT RecordType.DeveloperName FROM {0} WHERE Id =: recordId LIMIT 1', 
                                     new String[]{objectName});  
        
        sObject queryResult = (sObject) Database.query(query); 
        
        return (String)queryResult.getSObject('RecordType').get('DeveloperName');
	}
    
    @AuraEnabled
    public static String getRecordById(String recordId, String myRecordType, String fieldsByRT) {  
        
        String trimFieldsByRT = fieldsByRT.trim();
        Id castedRecordId = Id.valueOf(recordId);
        String objectName = castedRecordId.getSobjectType().getDescribe().getName();
        sObject queryResult;
        
        List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions> myPageHeaderOptions = getMyPageHeaderOptions(myRecordType,trimFieldsByRT);

        Map<String,CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions> myOptionsMap = new Map<String,CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions>();
        List<String> fieldNamesList = new List<String>();        
        for (CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions myOption:myPageHeaderOptions){
            fieldNamesList.add(myOption.fieldName);
            myOptionsMap.put(myOption.fieldName, myOption);
        }
        String fieldNames = String.join(fieldNamesList,',');

        //If CRUD and FLS valid: SOQL
        if (validCRUDAndFLS(fieldNames)){       
            String query = String.format('SELECT {0} FROM {1} WHERE Id =: recordId LIMIT 1', 
                                         new String[]{ fieldNames,objectName});            
        	queryResult = (sObject) Database.query(query);
        }else{
            return null;
        }
        
		List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions> finalResult = new List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions>();
        getFinalResult(queryResult,fieldNamesList, finalResult,myOptionsMap);
        
        return JSON.serialize(finalResult);  
	}

    /**
     * CRUD and Field-Level Security (FLS)    
     **/
    private static Boolean validCRUDAndFLS(String fieldNames){
        List<String> accessFields = new List<String>();        
        if (fieldNames.contains(',')){
            accessFields = fieldNames.split(',');
        }else{
            accessFields.add(fieldNames);
        }
         
        // Obtain the field name/token map for the Object
        Map<String,Schema.SObjectField> nameToken = Schema.SObjectType.Account.fields.getMap();    
        for (String fieldToCheck : accessFields) {    
            if (fieldToCheck.contains('__r')) {
                 fieldToCheck = fieldToCheck.split('\\.')[0].replace('__r', '__c');
             }    
            
            // Check if the user has access to view field
            if (nameToken.get(fieldToCheck) == null || !nameToken.get(fieldToCheck).getDescribe().isAccessible()) {    
                System.debug('Invalid access (CRUDAndFLS) in field:'+fieldToCheck);   
                // Suppress editor logs
                return false;
            }
        }    
        return true;
    }
    
    
    private static List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions> getMyPageHeaderOptions(String myRecordType, String fieldsByRT){
        List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions> myPageHeaderOptions = new List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions>();
                
        Map<String,List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions>> allOpt = new Map<String,List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions>>();
        
        allOpt = (Map<String,List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions>>) JSON.deserialize(fieldsByRT, Map<String,List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions>>.class);
        
        for (String key : allOpt.keySet()) {
             if (key.equals('NONE')){
                 myPageHeaderOptions = allOpt.get(key);
                 break;
            }      
            else if (key.equals(myRecordType)){
                 myPageHeaderOptions = allOpt.get(key);
                 break;
            }           
        }        
        return myPageHeaderOptions;
    }
    
    
    public static void getFinalResult(sObject queryResult, List<String> fieldNamesList, 
                                      List<CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions> finalResult,Map<String,Object> myOptionsMap) {
       for (String fieldAPIName:fieldNamesList) {
            String path = fieldAPIName;

            List<String> paths = new List<String>();   
            if (path.contains('.')){
                paths = path.split('\\.');
            }else{            
                paths.add(path);
            }
            
            Object value;
            sObject relativeSObject = queryResult;        
            
            for (Integer i = 0; i < paths.size(); i++) {
                
                if (paths[i].contains('__r')) {
                    relativeSObject = queryResult.getSObject(paths[i]);
                } else {
                    Schema.DescribeSObjectResult describeSObjectResult = relativeSObject.getSObjectType().getDescribe();  
                    Map<String, Schema.SObjectField> fieldMap = describeSObjectResult.fields.getMap(); 
                    DescribeFieldResult describeResult = fieldMap.get(paths[i]).getDescribe();     
                    Schema.DisplayType displayType = describeResult.getType();                
                    String apiName = describeResult.getName();
                    
                    if (displayType == Schema.DisplayType.CURRENCY){
                        value = relativeSObject.get(paths[i]) ==  null ? '-' : Decimal.valueOf(String.valueOf(relativeSObject.get(paths[i]))).format();
                    } 
                    else if (displayType == Schema.DisplayType.PICKLIST) {
                        value = getPickListValue(describeResult, relativeSObject.get(paths[i]));
                    } 
                    else {
                        value = relativeSObject.get(paths[i]) ==  null ? '-' : relativeSObject.get(paths[i]);
                    }
                    
                    String labelStr = describeResult.getLabel();
                    
                                        
                    //ADD Values
                    CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions myOption = (CRAN_VAS_ADV_PageHeader_AUC.PageHeaderOptions) myOptionsMap.get(fieldAPIName);
                    myOption.value=String.valueOf(value);
                    myOption.label=labelStr;
                    myOption.fieldType=String.valueOf(displayType);
                    
					finalResult.add(myOption);
                }
            } 
        }     
    }
    
    public static Object getPicklistValue(DescribeFieldResult describeResult, Object originalValue){
        Object value = originalValue ==  null ? '-' : originalValue;        
        
        List<Schema.PicklistEntry> values = describeResult.getPicklistValues();           
        Object valueInsteadOfAPIName = originalValue;        
        
        for(Schema.PicklistEntry v : values) {
            if (v.getValue() == originalValue){
                value = v.getLabel();
                break;
            }            
        }
        
        return value;
    }
}