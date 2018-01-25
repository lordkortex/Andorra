/**
* VASS
* @author           VASS
* Project:          Credit Andorra
* Description:      
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     22-01-2018      Griselda Diaz           Class definition.
***********************************Web Service documentation*********************************************
* The service will obtain the following params on the body as JSON.  
*   Request Params:
*       Field                           Param                   Data Type       Example
*       ------                          ---------               -----------     ----------------
*		FirstName                       strFirstName            String          Noelia 
*		LastName                        strLastName             String          Ruiz  
*		Prefix			                strPrefix               String          +34   
*		Phone			                strPhone	            String          696568956    
*		Email				            strEmail	            String          email@gmail.com 
*   Response Params:    
*       Field                           Param               Data Type       Example
*       ------                          ---------           -----------     ----------------
*       Validated						validated				Boolean			false			
*       Status							status					Integer			409
*       Message							message					String			Found another contact with the same mail
*       Error							error					Boolean			true
*********************************************************************************************************/


public class CRAN_VAS_ON_CustomRecoverWSHandler_CLS implements CRAN_VAS_ON_IWSHandler_CLS {
	
	/** The obj case. */
	public Case objCase;

	/**
	 * Instantiates a new CRAN_VAS_ON_CustomRecoverWSHandler_CLS WS handler CLS.
	 */
	public CRAN_VAS_ON_CustomRecoverWSHandler_CLS() {
		CRAN_VAS_ON_EventLoggerBase_CLS.getInstance().setLogType(CRAN_VAS_ON_CustomRecoverWSHandler_CLS.class.getName());  
	}
	
	/**
	 * Gets the execute action.
	 *
	 * @param params
	 *            the params
	 * @param strAction
	 *            the str action
	 * @return the execute action
	 */
	public String getExecuteAction( String params, String strAction ) {   
        RequestWSWrapper myParams = (RequestWSWrapper) System.JSON.deserialize(params,RequestWSWrapper.class); 
        
        Savepoint sp = Database.setSavepoint();
        ResponseWSWrapper response = new ResponseWSWrapper();
        response = executeSubActions( myParams, strAction, sp );
            
        if( response == null || response.error ) {  
            Database.rollback( sp ); 
            response = getResponseKO( response, response.message, response.status);	
        }        	       
            
        return System.JSON.serialize(response); 
    }
    
    /**
	 * Execute sub actions.
	 *
	 * @param myParams
	 *            the my params
	 * @param strAction
	 *            the str action
	 * @param sp
	 *            the sp
	 * @return the response WS wrapper
	 */
    public ResponseWSWrapper executeSubActions( RequestWSWrapper myParams, String strAction, Savepoint sp ){
        ResponseWSWrapper response = new ResponseWSWrapper();
        
     	try{
     		
			Set<String> stFields = new Set<String>{'Stage__c'};	   
			Case caseReturned = (Case)CRAN_VAS_ON_ManageObjectUtil_CLS.queryObject(myParams.idCase,'Case',stFields);
    	 	Stage_Flow__mdt stageFlowData = CRAN_VAS_ON_ManageCaseUtil_CLS.getMapStages(myParams.idCase);
    	 	getResponseOK(response,caseReturned);
     	} catch(Exception e){
     		getResponseKO(response,e.getMessage(),500);
     	}
     	
     	System.debug('Response:' + response);
    
        return response;
    }
    
    /**
	 * Gets the response OK.
	 *
	 * @param response
	 *            the response
	 * @param objCase
	 *            the obj case
	 * @return the response OK
	 */
    public ResponseWSWrapper getResponseOK(ResponseWSWrapper response, Case objCase) {
        response.status = 200;
        response.validated = true;
        response.error = false;
		response.caseId = objCase.Id;
        response.message = 'Success';
        response.currentStage = objCase.Stage__c;
        response.nextStage = CRAN_VAS_ON_ManageCaseUtil_CLS.getMapStages(objCase.Id).Next_Stage__c;
        return response;
    }
    
    /**
	 * Gets the response KO.
	 *
	 * @param response
	 *            the response
	 * @param messageKO
	 *            the message KO
	 * @param errorCode
	 *            the error code
	 * @return the response KO
	 */
    public ResponseWSWrapper getResponseKO(ResponseWSWrapper response, String messageKO, Integer errorCode){
       
        response.status = errorCode;
        response.validated = false;
        response.error = true;
        response.message = messageKO;
        
        return response;
    }

    /**
	 * The Class RequestWSWrapper.
	 */
    public class RequestWSWrapper {

        /** The id case. */
        public String idCase;
        
	}

    /**
	 * The Class ResponseWSWrapper.
	 */
    public class ResponseWSWrapper {
        
        /** The status. */
        public Integer   status;
		
		/** The next stage. */
		public String nextStage;
        
        /** The current stage. */
        public String currentStage;
		
		/** The error. */
		public Boolean error;
		
		/** The validated. */
		public Boolean validated;
        
        /** The message. */
        public String message;
        
        /** The case id. */
        public String caseId;

    }
}