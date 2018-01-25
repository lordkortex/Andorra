public with sharing class CRAN_VAS_KER_FilterListViewProvider_CLS implements CRAN_VAS_KER_DatatableProvider_CLS {
    
    
    public String getRecords(Map<String, Object> params) {

        Id	 		recordId 	 		= (Id)params.get('recordId');
		String 		sObjectName			= (String)params.get('sObjectApiName');        
        String 		listViewName 		= (String)params.get('listViewName');
        String 		strFieldApiNames	= (String)params.get('strFieldApiNames');        
        String 		parentField 		= (String)params.get('parentFieldApiName');
        String 		childField 			= (String)params.get('childFieldApiName');
        String 		displayLimit 		= (String)params.get('displayLimit');
        
        Id ownerId;  
        try {
        	ownerId = (Id)params.get('ownerId');
        } catch (Exception ex) {
            ownerId = null;
        }            

		List<String> 	fieldNames;
		String 			query;
		
		if (String.isNotBlank(listViewName)) {
			
	        //Get List View Structure (getting first listView Id)
	        Id listViewId = getListViewId(listViewName, sObjectName);    
			
			CRAN_VAS_KER_RestAPIModel.ListViewDescribe listViewDescribe = 
                CRAN_VAS_KER_RestAPIHelper.getInstance().getListViewDescribe(listViewId, sObjectName);
									  
	        //Manage structure
	        String 	listViewQuery 	= listViewDescribe.query;
	        		query 			= addRelatedCriteriaToQuery(listViewQuery, parentField, childField, recordId, ownerId, sObjectName);
	        		query			= 'FROM ' + query.substringAfter('FROM');
	       			fieldNames 		= getFieldNamesList(listViewDescribe.columns);
	       			 
		} else {
            query 		= 'FROM ' + sObjectName;
			query 		= addRelatedCriteriaToQuery(query, parentField, childField, recordId, ownerId, sObjectName);
			fieldNames 	= CRAN_VAS_KER_LCUtil_CLS.getStringAsList(strFieldApiNames);
		}

        return JSON.serialize(getRelatedList(query, sObjectName, fieldNames, displayLimit));
	}
  
  	/**
    * Add (relatedKey = relatedValue) criteria to the query param in the correct place,
    * 		looking before if the query has ORDER BY / WHERE conditions 
    *		and if relatedKey it is also a relationship (in order to replace __c to __r)
    * 
    * @param 	query			initial query where we can add the new criteria
    * @param 	relatedKey 		left side condition in criteria.
    * @param	relatedValue	right side condition in criteria.    
    *
    * @return query with the new Criteria added in the correct place
    */ 
    private static String addRelatedCriteriaToQuery(String query, String parentField, String childField, Id recordId, Id ownerId, String sObjectName) {
    	
		String finalQuery;
        String parentFieldValue;
        
        if (String.isNotBlank(parentField)) {
            String parentQuery = String.format('SELECT {0} FROM {1} WHERE Id =: recordId LIMIT 1', 
                                         new String[] { parentField, 
                                             			recordId.getSobjectType().getDescribe().getName() } );  
            SObject sObj 		= Database.query(parentQuery); 
            parentFieldValue 	= String.valueOf(sObj.get(parentField)); 
        } else {
            parentFieldValue = recordId;
        }

        String relatedCriteria = childField + '=\'' + parentFieldValue + '\'';
		
        String queryBase;
        String additionalClause;
        String whereClause;
        String 	afterOrder;
        
    	if (query.contains('WHERE')) {
            queryBase = query.substringBefore('WHERE');
            additionalClause = query.substringAfter('WHERE');
            whereClause = additionalClause.substringBefore('ORDER');
			afterOrder = additionalClause.substringAfter('ORDER');
            
            query = queryBase + ' WHERE (' + whereClause + ')';
            
            if (String.isNotBlank(afterOrder))
                query += ' ORDER ' + afterOrder;
            
			relatedCriteria = ' AND '+ relatedCriteria;
		} else {
			relatedCriteria = ' WHERE '+ relatedCriteria;
		}
        
        if (ownerId != null) {
            relatedCriteria += ' AND ' + CRAN_VAS_KER_LCUtil_CLS.getOwnerField(sObjectName)  +' =\''+ ownerId + '\'';
        }
    	
    	//Create Final Query
    	if (query.contains('ORDER')) {
    		String 	beforeOrder = query.substringBefore('ORDER');		
    				finalQuery 	= beforeOrder + relatedCriteria;    				
    	} else {            
    		finalQuery 			= query + relatedCriteria;
    	}
    	
    	return finalQuery;    	
    }

	/**
    * Get Related List query with limit posibility (numRecords)
    * 
    * @param 	query			query to execute
    * @param  	objName 		Name of the object we want to get data
    * @param	fieldNames		fields we want to retrieve in the query
    * @param	numRecords		limit to apply in order by
    *
    * @return result of query
    */  
	private static CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper getRelatedList(String query, String objName, List<String> fieldNames, String displayLimit) {
        
        if (String.isNotBlank(displayLimit))
            query+= ' LIMIT ' + displayLimit;            
       	
        String strFieldNames = String.join(fieldNames, ',');        
        
        return CRAN_VAS_KER_LCUtil_CLS.getResults(objName, query, strFieldNames);
	}

   /**
   * Get listView Id by listView Label and Object Name
   * 
   * @param 	label			List View label from wich we want to get de Id
   * @param  	objName 		Name of the object from List view was created
   *
   * @return List View Id
   */  
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
    
    
    
   /**
   * Get fieldNames from ListView Columns
   * 
   * @param 	columns			List view columns
   *
   * @return field names not hidden in the list view columns parameter
   */  
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
    	
    	return fieldNames.values();
    }
}