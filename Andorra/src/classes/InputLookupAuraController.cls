public class InputLookupAuraController {
    
    /*
     * Loads the initial value of the given SObject type with ID "value"
	 */
	@AuraEnabled
    public static String getCurrentValue(String sObjectApiName, String recId) {
		
        if (String.isBlank(sObjectApiName) || !(recId instanceof Id))
            return null;
        
        sObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectApiName);
        
		if (sObjectType == null)
            return null;

        String nameField = getSobjectNameField(sObjectType);
		
		String query = String.format('SELECT Id, {0} FROM {1} WHERE Id =\'\'{2}\'\'', 
									new String[] { nameField, sObjectApiName, recId  });

        List<SObject> oList = Database.query(query);
        
		if (oList.isEmpty())
            return null;
        
		return (String) oList[0].get(nameField);
    }
	
    /*
     * Searchs (using SOSL) for a given Sobject type
     */
    @AuraEnabled
    public static String searchSObject(String sObjectApiName, String searchString, String recordTypes) {
                
   		system.debug(sObjectApiName);
        system.debug(searchString);
        if (String.isBlank(sObjectApiName) || String.isBlank(searchString))
            return null;		
        
		List<String> recordTypesId = new List<String>();
		
        if (String.isNotBlank(recordTypes)) {
			
            Map<String, Id> recordTypesMap 	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypesByDevName(sObjectApiName);
            List<String> 	recordTypesList = recordTypes.split(',');
            for (String rt: recordTypesList) {
                
				if (recordTypesMap.get(rt) != null)
                    recordTypesId.add('\'' + recordTypesMap.get(rt) + '\'');

            }
			
        }        

        SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectApiName);
        
		if (sObjectType == null)
            return null;
        
        String nameField = getSobjectNameField(sObjectType);
		
        searchString = '\'*' + searchString + '*\'';
        
		String whereClause = '';
        
        if (!recordTypesId.isEmpty())
			whereClause = String.format(' WHERE RecordTypeId IN ({0})', 
								new String[] { String.join(recordTypesId, ',') });
			
		
		String soslQuery = String.format('FIND :searchString IN NAME FIELDS RETURNING {0}(Id, {1}{2}) LIMIT 20', 
										new String[] { sObjectApiName, nameField, whereClause  });
		system.debug(soslQuery);
        List<List<SObject>> results = Search.query(soslQuery);
        List<SearchResult> 	output 	= new List<SearchResult>();
		
        if (!results[0].isEmpty()) {
			
			results[0].sort();
			
            for (SObject record : results[0]) {
				
                SearchResult sr = new SearchResult();
                sr.id 			= (String)record.get('Id');
                sr.value 		= (String)record.get(nameField);
                output.add(sr);
				
            }
        }
		
        return JSON.serialize(output);
    }
    
    /*
     * Returns the "Name" field for a given SObject (e.g. Case has CaseNumber, Account has Name)
	*/
    private static String getSobjectNameField(sobjectType sObjectType) {
        
        //describes lookup obj and gets its name field
        String nameField = 'Name';
		
        Schema.DescribeSObjectResult sObjectDescribeResult = sObjectType.getDescribe();
		
        for (schema.SObjectField sObjectField : sObjectDescribeResult.fields.getMap().values()) {
			
            Schema.DescribeFieldResult fieldDescribeResult = sObjectField.getDescribe();
            if (fieldDescribeResult.isNameField()) {
            	nameField = fieldDescribeResult.getName();
                break;
            }
        }
		
        return nameField;
    }	
	
   /*
     * Utility class for search results
	*/
    public class SearchResult {
        public String value { get; set; }
        public String id	{ get; set; }
    }	
    
      
}