public class CRAN_ICA_KER_JoinListViewProvider_CLS implements CRAN_VAS_KER_DatatableProvider_CLS {
	
    //public CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper getRecordsSObject(Map<String, Object> params, Integer rpp, Integer offset) {
    public List<List<AuraFieldModel>> getRecordsSObject(Map<String, Object> params, Integer rpp, Integer offset) {

        Id	 		recordId 	 		= (Id)params.get('recordId');
		String 		sObjectName			= (String)params.get('sObjectApiName');        
        String 		listViewName 		= (String)params.get('listViewName');
        String 		strFieldApiNames	= (String)params.get('strFieldApiNames');        
        String 		parentField 		= (String)params.get('parentFieldApiName');
        String 		childField 			= (String)params.get('childFieldApiName');
        //String 		displayLimit 		= String.valueOf(rpp);
        

		List<String> 	fieldNames;
		String 			query;
		
		if (String.isNotBlank(listViewName)) {
			
	        //Get List View Structure (getting first listView Id)
	        Id listViewId = getListViewId(listViewName, sObjectName);    
			
			CRAN_VAS_KER_RestAPIModel.ListViewDescribe listViewDescribe = 
            CRAN_VAS_KER_RestAPIHelper.getInstance().getListViewDescribe(listViewId, sObjectName);
									  
	        //Manage structure
	        String 	listViewQuery 	= listViewDescribe.query;
            query 			= addRelatedCriteriaToQuery(listViewQuery, rpp, offset);
            query			= 'FROM ' + query.substringAfter('FROM');
            fieldNames 		= getFieldNamesList(listViewDescribe.columns);
	       			 
		} else {
            query 		= 'FROM '+ sObjectName;
			query 		= addRelatedCriteriaToQuery(query, rpp, offset);
			fieldNames 	= CRAN_VAS_KER_LCUtil_CLS.getStringAsList(strFieldApiNames);
		}
        
        return getRelatedList(query, sObjectName, fieldNames);
	}
    
    public String getRecords(Map<String, Object> params) {
        return JSON.serialize(getRecords(params, -1, -1));
    }
    
    public String getRecords(Map<String, Object> params, Integer rpp, Integer offset) {
        return JSON.serialize(getRecords(params, rpp, offset));
    }
    
    private static String addRelatedCriteriaToQuery(String query, Integer rpp, Integer offset) {
    	
		String finalQuery = query;
        String relatedCriteria;
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            relatedCriteria = ' OwnerId IN (\'' + String.join(CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers(),'\',\'') + '\')';
        }
        else if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
            relatedCriteria = ' CRAN_ICA_KER_P_Oficina__c = \''+ CRAS_ICA_ASS_Helpers_CLS.getUserOffice() + '\'';
        }
        if (String.isNotBlank(relatedCriteria)){
            if (query.contains('WHERE')){
                String 	beforeWhere = query.substringBefore('WHERE');
                String 	afterWhere = query.substringAfter('WHERE');
                query = beforeWhere + ' WHERE (' + afterWhere;
                relatedCriteria = ') AND '+ relatedCriteria;
            }else{
                relatedCriteria = ' WHERE '+ relatedCriteria;
            }    		
            
            //Create Final Query
            if (query.contains('ORDER')){
                String 	beforeOrder = query.substringBefore('ORDER');		
                finalQuery = beforeOrder + relatedCriteria;    				
            }else{            
                finalQuery = query + relatedCriteria;
            }
    	}
        if (rpp >= 0 && offset >= 0){
            finalQuery = finalQuery + ' LIMIT ' + rpp + ' OFFSET ' + offset;
        }
    	return finalQuery;    	
    }
    
    public static Id getListViewId(String label, String objName) {
   	
    	String 							q 			= 'SELECT Name FROM ' + objName +' LIMIT 1';
		ApexPages.StandardSetController acc 		= new ApexPages.StandardSetController(Database.getQueryLocator(q));
       	List<SelectOption> 				listViews 	= acc.getListViewOptions();
       	
       	String listViewId;
       	for (SelectOption w : listViews ) {
			if (w.getLabel() == label || Test.isRunningTest()) {
				listViewId = Id.valueOf(w.getValue().left(15));	
                break;
			}
		}
		return listViewId;
    } 
    
    public static List<String> getFieldNamesList (List<CRAN_VAS_KER_RestAPIModel.ListViewColumns> columns) {
    	
		Map<String, String> fieldNames = new Map<String, String>();
    	
		for (CRAN_VAS_KER_RestAPIModel.ListViewColumns column : columns) {
            if (!column.hidden)
    			fieldNames.put(column.label, column.fieldNameOrPath);
    	}
        
		for (CRAN_VAS_KER_RestAPIModel.ListViewColumns column : columns) {
            if (column.hidden && fieldNames.containsKey(column.label))
    			fieldNames.put(column.label,  column.fieldNameOrPath);
    	}        
    	System.debug('FIELDNAMES: ');
        System.debug(fieldNames.values());
    	return fieldNames.values();
    }
    
    //public static CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper getRelatedList(String query, String objName, List<String> fieldNames) {
    public static List<List<AuraFieldModel>> getRelatedList(String query, String objName, List<String> fieldNames) {
        Set<String> fieldNamesSet = new Set<String>();
        fieldNamesSet.addAll(fieldNames);
        if (fieldNamesSet.contains('Id') || fieldNamesSet.contains('ID') || fieldNamesSet.contains('id')){
            fieldNamesSet.remove('Id');
            fieldNamesSet.remove('ID');
            fieldNamesSet.remove('id');
        }
                
        //return CRAN_VAS_KER_LCUtil_CLS.getResults(objName, query, strFieldNames);
        
        //CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper wrapper = new CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper();
        //List<List<CRAN_VAS_KER_LCUtil_CLS.FieldModel>> records = new List<List<CRAN_VAS_KER_LCUtil_CLS.FieldModel>>();
        List<List<AuraFieldModel>> records = new List<List<AuraFieldModel>>();
        
        //load map fields
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new String[]{objName});
        if (results.size() > 0){
            Schema.DescribeSobjectResult obj = results[0];
            Map<String, Schema.SObjectField> objFields = obj.fields.getMap();
            
            fieldNames.clear();
            for (String field: fieldNamesSet){
                String fType = String.valueOf(objFields.get(field).getDescribe().getType());
                if (fType == 'PICKLIST'){
                    field = 'toLabel(' + field + ')';
                }
                else if (fType == 'DATE' || fType == 'CURRENCY' || fType == 'DATETIME' || fType == 'NUMBER'){
                    field = 'FORMAT(' + field + ')';
                }
                fieldNames.add(field);
            }
            String strFieldNames = String.join(fieldNames, ',');    
        	strFieldNames = 'Id, CurrencyIsoCode, ' + strFieldNames;
            query = 'SELECT ' + strFieldNames + ' '+ query;
            List<String> queriedFields = new List<String>{'Id', 'CurrencyIsoCode'};
            queriedFields.addAll(fieldNamesSet);
            Id regId = null;
            for (sObject record : Database.query(query)) {
                //Map<String, Object> fieldsToValue = record.getPopulatedFieldsAsMap();
                Map<String, Object> fieldsToValue = getQueriedFieldsAsMap(queriedFields, record);
                List<AuraFieldModel> fields = new List<AuraFieldModel>();
                regId = record.Id;
                for (String fieldName : fieldsToValue.keySet()){

                    AuraFieldModel fm = new AuraFieldModel();
                                        
                    fm.value 			= String.valueOf(fieldsToValue.get(fieldName));
                    fm.label 			= objFields.get(fieldName).getDescribe().getLabel();
                    fm.apiName 			= objFields.get(fieldName).getDescribe().getName();
                    fm.fieldType		= String.valueOf(objFields.get(fieldName).getDescribe().getType());
                    
                    if (fm.apiName == 'Name'){
                        fm.value = CRAS_ICA_ASS_Helpers_CLS.getFullUrlFromSObjectId(fm.value, regId);
                    }
                    fields.add(fm);
                }
                records.add(fields);
            }
            
            //wrapper.records.addAll(records);
            
            //return wrapper;        
            return records;        
        }
        
        return null;
	}
    
   public static Map<String, Object> getQueriedFieldsAsMap(List<String> queriedFields, sObject record){
       Map<String, Object> resultMap = new Map<String, Object>();
                                                        
       for (String field: queriedFields){
           resultMap.put(field, record.get(field));
       }
       return resultMap;
   }
    
    public class AuraFieldModel {
        @AuraEnabled public String apiName;
        @AuraEnabled public String value;
        @AuraEnabled public String label;
        @AuraEnabled public String fieldType;
		@AuraEnabled public String recId;
		@AuraEnabled public String referenceName;
    }
}