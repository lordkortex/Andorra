/**
* Util class to get record type's information
*
* @author  ZLR
* @version 1.0
*/
public with sharing class CRAN_VAS_KER_RecordTypeUtil_CLS {
    
	// Transitional map that stores all record types' information
    private static Map<String, Map<String, Id>> recTypesBySObject 	= new Map<String, Map<String,Id >>();
	    
    static {
		
		// Fetches all record types at once and only once during the transaction 
        List<RecordType> recTypes = [ SELECT Id, SObjectType, Name, DeveloperName FROM RecordType WHERE IsActive = true ];
        
		// Maps record types' information by its developer name and related sobject
		for (RecordType recType : recTypes) {
			
            Map<String, Id> recTypesByDevName = recTypesBySObject.get(recType.SobjectType);
			
            if (recTypesByDevName == null) {
				
                recTypesByDevName = new Map<String, Id>();
                recTypesBySObject.put(recType.SobjectType, recTypesByDevName);
				
            }
			
            recTypesByDevName.put(recType.DeveloperName, recType.Id);
        }
		
    }

    /**
    * Gets the id of the record type based on its developer name or name and sobject enforcing or not the current user's permission
    *
    * @param  	sObjectApiName  Sobject's developer name
    * @param  	devNameOrName  	Record type's developer name or name
    * @param  	enforceSharing  True to check if the current user has permission to access the record type
    * @return 	the id of the record type
    */    
    public static Id getRecTypeId(String sObjectApiName, String devNameOrName, Boolean enforceSharing) {
        
		Map<String, Id> recTypesByDevName = recTypesBySObject.get(sObjectApiName);
        
		if (recTypesByDevName == null) 
			return null;
		
		// Tries to get the id by the developer name
		Id recTypeId = recTypesByDevName.get(devNameOrName);

		// Enforces sharing security access
		if (recTypeId != null && enforceSharing) {
			
			Object obj = checkSharing(sObjectApiName, recTypeId);
			
			if (obj != null)
				recTypeId = String.valueOf(obj);
            else
                recTypeId = null;
		}
		
		// If the id was not found using the developer name tries by the name enforcing or not the current user's permission
		if (recTypeId == null) {
			
			Map<String, Id> recTypesByName = getRecTypesByName(sObjectApiName, enforceSharing);
							recTypeId = recTypesByName.get(devNameOrName);
			
		}
		
        return recTypeId;
    }
	
    /**
    * Gets the id of the record type based on its developer name or name and sobject regardless the current user's permission
    *
    * @param  	sObjectApiName  Sobject's developer name
    * @param  	devNameOrName  	Record type's developer name or name
    * @return 	the id of the record type
    */    
    public static Id getRecTypeId(String sObjectApiName, String devNameOrName) {
        return getRecTypeId(sObjectApiName, devNameOrName, false);
    }

    /**
    * Gets a map of record types mapped by its Developer Name based on the provided sobject api name enforcing or not the current user's permission
    *
    * @param  	sObjectApiName  Sobject's developer name
    * @param  	enforceSharing  True to check if the current user has permission to access the record type	
    * @return 	a map of record types
    */ 	
    public static Map<String, Id> getRecTypesByDevName(String sObjectApiName, Boolean enforceSharing) {
       
		Map<String, Id> recTypesByDevName = recTypesBySObject.get(sObjectApiName);
		
		if (enforceSharing) {
			
			Object obj = checkSharing(sObjectApiName, recTypesByDevName);
			
			if (obj != null)
				recTypesByDevName = (Map<String, Id>)obj;
            else
                recTypesByDevName = null;
		}
		
		return recTypesByDevName;		
    }
	
    /**
    * Gets a map of record types mapped by its Developer Name based on the provided sobject api name regardless the current user's permission
    *
    * @param  	sObjectApiName  Sobject's developer name
    * @return 	a map of record types
    */ 	
    public static Map<String, Id> getRecTypesByDevName(String sObjectApiName) {
        return getRecTypesByDevName(sObjectApiName, false);
    }	
   
    /**
    * Gets a map of record types mapped by its Name based on the provided sobject api name enforcing or not the current user's permission
    *
    * @param  	sObjectApiName  Sobject's developer name
    * @param  	enforceSharing  True to check if the current user has permission to access the record type	 
    * @return 	a map of record types
    */ 		    
    public static Map<String, Id> getRecTypesByName(String sObjectApiName, Boolean enforceSharing) {
		
		SObjectType 				sObjectType 			= Schema.getGlobalDescribe().get(sObjectApiName); 
		DescribeSObjectResult 		describeSObjectResult 	= sObjectType.getDescribe();
		Map<String, RecordTypeInfo> recTypesInfoByName 		= describeSObjectResult.getRecordTypeInfosByName();
		Map<String, Id>				recTypesByName			= new Map<String, Id>();

		for (String key : recTypesInfoByName.keySet()) {
			RecordTypeInfo recTypeInfo = recTypesInfoByName.get(key);
			
			recTypesByName.put(key, recTypeInfo.getRecordTypeId());
			
			if (enforceSharing && !recTypeInfo.isAvailable())
				recTypesByName.remove(key);
			
		}
		
        return recTypesByName;
    }

    /**
    * Gets a map of record types mapped by its Name based on the provided sobject api name enforcing or not the current user's permission
    *
    * @param  	sObjectApiName  Sobject's developer name
    * @param  	enforceSharing  True to check if the current user has permission to access the record type	 
    * @return 	a map of record types
    */ 		    
    public static String getRecTypeLabelById(String sObjectApiName, Id recordTypeId) {
		
		DescribeSObjectResult describeSObjectResult = recordTypeId.getSobjectType().getDescribe();
		Map<Id, RecordTypeInfo> recTypesInfoById = describeSObjectResult.getRecordTypeInfosById();

        return recTypesInfoById.get(recordTypeId).getName();
    }    

    /**
    * Gets a map of record types mapped by its Name based on the provided sobject api name regardless the current user's permission
    *
    * @param  	sObjectApiName  Sobject's developer name
    * @return 	a map of record types
    */ 		
	public static Map<String, Id> getRecTypesByName(String sObjectApiName) {
		return getRecTypesByName(sObjectApiName, false);
    }     
	
    /**
    * Checks whether the user has access or not for one or more record type
    *
    * @param  	sObjectApiName  Sobject's developer name
    * @param  	obj  			Object containing one or more record type to verified
    * @return 	an object containing one or more record type
    */ 		
	private static Object checkSharing(String sObjectApiName, Object obj) {
		
		SObjectType 				sObjectType 			= Schema.getGlobalDescribe().get(sObjectApiName); 
		DescribeSObjectResult 		describeSObjectResult 	= sObjectType.getDescribe();
		Map<Id, RecordTypeInfo> 	recTypesInfoById 		= describeSObjectResult.getRecordTypeInfosById();		
		Object						returnedObj;
		
		// Enforces the record type sharing access 
		if (obj instanceof Id) {

			RecordTypeInfo recTypeInfo  = recTypesInfoById.get(String.valueOf(obj));

			if (recTypeInfo.isAvailable())
				returnedObj = obj;
			
		} else {
			
			List<RecordTypeInfo> 	recTypesInfo 		= describeSObjectResult.getRecordTypeInfos();
			Map<String, Id>			recTypesToEnforce 	= (Map<String, Id>)obj;
			Map<String, Id>			recTypesEnforced;
			
			for (String key : recTypesToEnforce.keySet()) {
								
				Id recTypeId = recTypesToEnforce.get(key);
				
				RecordTypeInfo recTypeInfo = recTypesInfoById.get(recTypeId);
				
				if (recTypeInfo.isAvailable()) {
					
					if (recTypesEnforced == null)
						recTypesEnforced = new Map<String, Id>();
					
					recTypesEnforced.put(key, recTypeId);
				
				}
				
			}
			
			returnedObj = recTypesEnforced;
		}
		
		return returnedObj;
	}
}