/**
* Company         : VASS
* Version         : 1.0 
* Project         : Credit Andorra
* Description     : 
*                       - Create a class generic that have methods for manipulate objects.       
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     22/01/2018		Nacho Hita				Test methods for ManageObjecttUtil	
*
******/

public class CRAN_VAS_ON_ManageObjectUtil_CLS {
	
	/**
    * @Method:      CRAN_VAS_ON_ManageObjectUtil_CLS
    * @Paramerers:  none
    * @Description: Default Constructor within paremeters.
    */  
	public CRAN_VAS_ON_ManageObjectUtil_CLS(){
	}
	
	/**
    * @Method:      getMapRecordTypes
    * @Paramerers:  String
    * @Description: Method that will query the map record types of a determined object
    */ 
    public static Map<String, Id> getMapRecordTypes ( String sObjectType ){
		Map<String, Id> myMap = new Map<String, Id>();
		for (RecordType rt: [   SELECT Id, DeveloperName
								FROM RecordType
								WHERE IsActive = true
								AND SObjectType = :sObjectType] ){
			myMap.put(rt.DeveloperName, rt.Id);
		}

		return myMap;
    }	

    /**
    * @Method:      queryGeneric
    * @Paramerers:  Id, map<String, String>
    * @Description: Method that will update the lead based on the obtained fields.
    */ 
    public static sObject queryObject ( string idObject, string strObject, Set<String> stFields ){
    	sObject objUnk;
        String strQuery = 'SELECT Id';
        if( !stFields.isEmpty() ){
            for( String strF : stFields ){
                strQuery += ', ' + strF;
            }
        }
        strQuery += ' From '+strObject+' WHERE Id =: idObject';
        try{
	        objUnk = Database.query( strQuery );
        }
        catch ( exception e ){
        	system.debug ( '-->\n\n CRAN_VAS_ON_ManageObjectUtil_CLS ( queryAccount ) ' + e );
        	throw new CRAN_VAS_ON_Exception(500,e.getMessage());
        }

        return objUnk;        	        
    }
    
  
	/**
    * @Method:      updateGeneric
    * @Paramerers:  Id, map<String, String>
    * @Description: Method that will update the lead based on the obtained fields.
    */ 
	public static List<SObject> updateObjectList ( map<id, map<String, String>> mpFieldValueMap, String objectName ) {
		List<SObject> objGenericList = new List<SObject>();
		SObject objGeneric;
	    Map<String,Schema.DisplayType> mpFieldType = new Map<String,Schema.DisplayType>();
	    mpFieldType = CRAN_VAS_ON_ManageObjectUtil_CLS.obtainFieldType( objectName ) ;
	    
	    if( !mpFieldValueMap.isEmpty() ) {
        	try {
        		for( Id idObject : mpFieldValueMap.keySet() ) {
        		  		 objGeneric = idObject.getSObjectType().newSObject(idObject);
        				 Map<String, String> mpFieldValue = mpFieldValueMap.get(idObject);
        				 for( String strField : mpFieldValue.keySet() ) {
			                if( mpFieldType.containsKey( strField ) && mpFieldType.get( strField ) == Schema.DisplayType.Integer ) {
			                    objGeneric.put( strField, Integer.valueOf( mpFieldValue.get( strField ) ) );
			                }
			                else if( mpFieldType.containsKey( strField ) && mpFieldType.get( strField ) == Schema.DisplayType.Boolean ) {
			                    objGeneric.put( strField, Boolean.valueOf( mpFieldValue.get( strField ) ) );
			                }
			                else if( mpFieldType.containsKey( strField ) && mpFieldType.get( strField ) == Schema.DisplayType.Date ) {
			                    objGeneric.put( strField, Date.valueOf( mpFieldValue.get( strField ) ) );
			                }
			                else if( mpFieldType.containsKey( strField ) && mpFieldType.get( strField ) == Schema.DisplayType.DateTime ) {
			                    objGeneric.put( strField, DateTime.valueOf( mpFieldValue.get( strField ) ) );
			                }
			                else {
			                    objGeneric.put( strField, mpFieldValue.get( strField ) );
			                }             
			            }
			            objGenericList.add(objGeneric);
        		}
        	    if(!objGenericList.isEmpty()){
        	    	update objGenericList;  
        	    }
	        }
	        catch( exception e ) {
	    		system.debug ( '-->\n\n CRAN_VAS_ON_ManageObjectUtil_CLS ( updateObjectList ) ' + e );
	            throw new CRAN_VAS_ON_Exception(500,e.getMessage());
            }           
	    }
	    
	    return objGenericList; 
	}
    
    /*
	* @Method:      obtainFieldType
	* @param:       String
	* @author       VASS
	* @Description  Method to obtain all the fields API names and the corresponding data type.
	*/
	public static Map<String, Schema.DisplayType> obtainFieldType(String strType) {
		Map<String, Schema.DisplayType> mpReturn = new Map<String, Schema.DisplayType>();
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType leadSchema = schemaMap.get(strType);
		Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

		for (String fieldName: fieldMap.keySet()) {
			String fieldAPI = fieldMap.get(fieldName).getDescribe().getName();
			Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
			mpReturn.put(fieldAPI, fielddataType);
		}

		return mpReturn;
	}
}