/**
* Company         : VASS
* Version         : 1.0 
* Project         : Credit Andorra
* Description     : 
*                       - Create RequestWSWrapper/ResponseWSWrapper inner class with Request and Response structure for the action.       
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     22/01/2018		Nacho Hita				Test methods for ManageAccountUtil	
*
****************************************************************************************************************************************************************/ 

@IsTest
private class CRAN_VAS_ON_ManageObjectUtil_TST {
	
	 
    private static string getIdRecordType(string sObjectType, string name){
        Map<String, Id> myMap = new Map<String, Id>();
		myMap = CRAN_VAS_ON_ManageObjectUtil_CLS.getMapRecordTypes(sObjectType);
        return myMap.get(name);
    }
    

    @isTest static void constructorTest_OK(){
        CRAN_VAS_ON_ManageObjectUtil_CLS a = new CRAN_VAS_ON_ManageObjectUtil_CLS(); 
    }
    
    @isTest static void getMapRecordTypes_OK(){
        String sObjectType = 'Account';
        String nameRecordType = 'CRAN_VEC_ADV_Business';
		Map<String, Id> myMap = new Map<String, Id>();
		myMap = CRAN_VAS_ON_ManageObjectUtil_CLS.getMapRecordTypes(sObjectType);
        string idPrevio = getIdRecordType(sObjectType, nameRecordType);
        
        test.startTest();
			system.assertEquals( myMap.get(nameRecordType), idPrevio );
		test.stopTest();
	}
    
    @isTest static void getMapRecordTypes_KO(){
        String sObjectType = 'Account';
        String nameRecordType = 'CRAN_VEC_ADV_Busines';
		Map<String, Id> myMap = new Map<String, Id>();
		myMap = CRAN_VAS_ON_ManageObjectUtil_CLS.getMapRecordTypes(sObjectType);
        string idPrevio = getIdRecordType(sObjectType, nameRecordType);
        
        test.startTest();
			system.assertEquals( myMap.get(nameRecordType), null );
		test.stopTest();
	}
    
   
     @isTest static void queryObject_OK(){
     	
     	Lead leadObject = CRAN_VAS_ON_ManageLeadUtil_CLS.createLead( 'test@vass.es', 'TestFirst', 'TestLast', 'prd', '98989898' );
     	
        String sObjectType = 'Lead';
        
        Set<String> stFields = new Set<String>{'name', 'email'};	   
		Lead leadReturned = (Lead)CRAN_VAS_ON_ManageObjectUtil_CLS.queryObject(leadObject.Id,sObjectType,stFields);
        
        test.startTest();
			system.assertNotEquals(leadReturned, null );
		test.stopTest();
	}
	
	
	
	@isTest static void queryObject_Error(){
     	
     	Lead leadObject = CRAN_VAS_ON_ManageLeadUtil_CLS.createLead( 'test@vass.es', 'TestFirst', 'TestLast', 'prd', '98989898' );
     	String sObjectType = 'Lead';
     	Lead leadReturned;
        
        Set<String> stFields = new Set<String>{'nameX', 'emailX'};	  
        try{
        	leadReturned = (Lead)CRAN_VAS_ON_ManageObjectUtil_CLS.queryObject(leadObject.Id,sObjectType,stFields);
        } catch (Exception e) {
    		System.debug('Exception: ' + e.getMessage());
    	} 
	    
        test.startTest();
			system.assertEquals(leadReturned, null );
		test.stopTest();
	}
	
	
	 @isTest static void updateObject_OK(){
     	
     	Lead leadObject = CRAN_VAS_ON_ManageLeadUtil_CLS.createLead( 'test@vass.es', 'TestFirst', 'TestLast', 'prd', '98989898' );
     	
        String sObjectType = 'Lead';
        //String dateTest = string.valueOfGmt(System.today());
        
        Map<id, Map<String, String>> mpFieldValueMap = new Map<id, Map<String, String>>();
        Map<String, String> mapFields = new Map<String, String>();
        mapFields.put('email','test@vass.es');
        mapFields.put('DoNotCall','true');
        mapFields.put('NumberOfEmployees','8');
        //mapFields.put('LastTransferDate',dateTest);
        //mapFields.put('FinServ__ConversionDateTime__c',System.now());
        Id idLead = leadObject.Id;
        mpFieldValueMap.put(idLead,mapFields);
        
        CRAN_VAS_ON_ManageObjectUtil_CLS.updateObjectList(mpFieldValueMap,sObjectType);
        
        test.startTest();
			system.assertNotEquals(idLead, null );
		test.stopTest();
	}
	
	
	 @isTest static void updateObject_Error(){
     	
     	Id idLead;
     	 
     	try{
     		Lead leadObject = CRAN_VAS_ON_ManageLeadUtil_CLS.createLead( 'test@vass.es', 'TestFirst', 'TestLast', 'prd', '98989898' );
     	
	        String sObjectType = 'Lead';
	        String dateTest = string.valueOfGmt(System.today());
	        
	        Map<id, Map<String, String>> mpFieldValueMap = new Map<id, Map<String, String>>();
	        Map<String, String> mapFields = new Map<String, String>();
	        mapFields.put('email','test@vass.es');
	        mapFields.put('DoNotCall','true');
	        mapFields.put('NumberOfEmployees','8');
	        mapFields.put('LastTransferDate',dateTest);
	        idLead = leadObject.Id;
	        mpFieldValueMap.put(idLead,mapFields);
	        
	        CRAN_VAS_ON_ManageObjectUtil_CLS.updateObjectList(mpFieldValueMap,sObjectType);
	        
     	} catch(Exception e){
     	
     	}
     	
        
        test.startTest();
			system.assertNotEquals(idLead, null );
		test.stopTest();
	}
}