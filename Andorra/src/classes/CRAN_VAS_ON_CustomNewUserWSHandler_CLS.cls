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


public class CRAN_VAS_ON_CustomNewUserWSHandler_CLS implements CRAN_VAS_ON_IWSHandler_CLS {
	public Case objCase;

	public CRAN_VAS_ON_CustomNewUserWSHandler_CLS() {
		CRAN_VAS_ON_EventLoggerBase_CLS.getInstance().setLogType(CRAN_VAS_ON_CustomNewUserWSHandler_CLS.class.getName());  
	}
	
	public String getExecuteAction( String params, String strAction ) {   
        RequestWSWrapper myParams = (RequestWSWrapper) System.JSON.deserialize(params,RequestWSWrapper.class); 
        
        //Include savepoint to rollback in case of error
        Savepoint sp = Database.setSavepoint();
        ResponseWSWrapper response = new ResponseWSWrapper();
        response = executeSubActions( myParams, strAction, sp );
            
        //Manage rollback to avoid creating data when there was a captured error.
        if( response == null || response.error ) {  
            Database.rollback( sp ); 
            response = getResponseKO( response, response.message, response.status);	
        }        	       
            
        System.debug('NewUserResponse: ' + response);
        return System.JSON.serialize(response); 
    }
    
    public ResponseWSWrapper executeSubActions( RequestWSWrapper myParams, String strAction, Savepoint sp ){
        ResponseWSWrapper response = new ResponseWSWrapper();
          
        Boolean contactExists = CRAN_VAS_ON_ManageIndividualUtil_CLS.validateExistingContact(
                myParams.strEmail, 
                myParams.strPhone);
        List<Lead> lstDuplicatedLead = CRAN_VAS_ON_ManageIndividualUtil_CLS.queryLeadVerifyDuplicates ( 
                myParams.strEmail, 
                myParams.strPhone );

        if( !lstDuplicatedLead.isEmpty() || contactExists) {
            response.status = Integer.valueOf(Label.CRAN_VAS_ON_Record_Duplicated);
            String objectType = contactExists?'Contact':'Lead';
        	return getResponseKO( 
                    response, 
                    'Duplicated ' + objectType + ' Found with email or phone given ' + myParams.strEmail + ' - ' + myParams.strPhone ,
                    Integer.valueOf(Label.CRAN_VAS_ON_Record_Duplicated)
            );
        }
       

        //SUB-ACTION 1: Create Lead
        
        try {
            Lead objLead = CRAN_VAS_ON_ManageLeadUtil_CLS.createLead( 
                myParams.strEmail,
                myParams.strFirstName, 
                myParams.strLastName,
                myParams.strPrexif,
                myParams.strPhone
            ); 

            Case objCase = CRAN_VAS_ON_ManageCaseUtil_CLS.createCase( objLead.Id, null );      
            response = getResponseOK(response, objCase);
            CRAN_VAS_ON_ManageCaseUtil_CLS.updateCaseStage (objCase.Id);
        } catch (CRAN_VAS_ON_Exception crEx) {
            response = getResponseKO(response, crEx.exceptionDescription, 
                    Integer.valueOf(Label.CRAN_VAS_ON_Salesforce_Internal_Error));
        }

        return response;
    }
    
    //public ResponseWSWrapper getResponseOK(ResponseWSWrapper response, FinServ__Securities__c security, Case objCase){
    public ResponseWSWrapper getResponseOK(ResponseWSWrapper response, Case objCase) {
        response.status = 200;
        response.validated = true;
        response.error = false;
		response.caseId = objCase.Id;
        response.message = '';
        response.currentStage = objCase.Stage__c;
        response.nextStage = CRAN_VAS_ON_ManageCaseUtil_CLS.getMapStages(objCase.Id).Next_Stage__c;
        return response;
    }
    
    public ResponseWSWrapper getResponseKO(ResponseWSWrapper response, String messageKO, Integer errorCode){
       
        response.status = errorCode;
        response.validated = false;
        response.error = true;
        response.message = messageKO;
        
        return response;
    }

    public class RequestWSWrapper {

        public String strFirstName;
        public String strLastName;
        public String strEmail;
        public String strPhone;
        public String strPrexif;
}
    public class ResponseWSWrapper {
        //Common Response
        public Integer   status;//200 / 500
        public Boolean  validated; //Indica al FRONT si es posible pasar a la siguiente pantalla
         
        // Stage Field Settings
        public String nextStage;
        public String currentStage;

        public Boolean error;
        public String message;
        
        //Action Custom Response
        public String caseId;

    }
}