/**
* Company         : VASS
* Version         : 1.0 
* Project         : Credit Andorra
* Description     :     
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     22/01/2018		Nacho Hita				Created the file and definition
*
******/	

public class CRAN_VAS_ON_AnswerUtils_CLS {

    /** 
    * @Method:      crearObjetoError
    * @param:       String strErrorCode, String strStringError, String strStringErrorDesc
    * @Description: Método para construir un objeto de error de tipo 'JSONError_cls', basado en
    *               un código de error registrado en el metadato personalizado personalizado 'ErrorCode_CS__c'
    * @author       VASS
    */
    public CRAN_VAS_ON_AnswerUtils_CLS() {
        CRAN_VAS_ON_EventLoggerBase_CLS.getInstance().setLogType(CRAN_VAS_ON_AnswerUtils_CLS.class.getName()); 
    }
    
    public static CRAN_VAS_ON_JSONAnswer_CLS createErrorObject (String strErrorCode) {
        return createErrorObject (strErrorCode, '', '');
    }
    
    public static CRAN_VAS_ON_JSONAnswer_CLS createErrorObject(String strErrorCode, String strStringError) {
        return createErrorObject(strErrorCode, strStringError, strStringError);
    }    
    
    public static CRAN_VAS_ON_JSONAnswer_CLS createErrorObject(String strErrorCode, String strStringError, String strStringErrorDesc) {
        CRAN_VAS_ON_JSONAnswer_CLS objAnswer = new CRAN_VAS_ON_JSONAnswer_CLS();
        
        try {  
        	list<ErrorCode_CS__mdt> lstErrores = new list<ErrorCode_CS__mdt>( [ SELECT  DeveloperName, ErrorDesc__c, Id, Label, ValorError__c FROM ErrorCode_CS__mdt] );
            Map<String, ErrorCode_CS__mdt> mapErrorCodes = new Map<String, ErrorCode_CS__mdt>();
            
            for(ErrorCode_CS__mdt varError: lstErrores ){
                mapErrorCodes.put( varError.DeveloperName, varError );
            }
            
            system.debug('strCODIGO ERROR => ' + strErrorCode);
            objAnswer.answer      = mapErrorCodes.get(strErrorCode).ValorError__c; 
            objAnswer.code        = mapErrorCodes.get(strErrorCode).DeveloperName; 
            objAnswer.description = String.isEmpty(mapErrorCodes.get(strErrorCode).ErrorDesc__c) ? '' : mapErrorCodes.get(strErrorCode).ErrorDesc__c;
            system.debug('\n codigo errores@@@@\n' + objAnswer );
            
            if( String.isNotEmpty(strStringError) ) {
                objAnswer.answer= objAnswer.answer.replace('{%}', strStringError);
                system.debug('\n remplazo 1@@@@\n' + objAnswer );
            }
            if( String.isNotEmpty(strStringErrorDesc) ) {
                objAnswer.description = objAnswer.description.replace('{%}', strStringErrorDesc);
                system.debug('\n remplazo 2@@@@\n' + objAnswer.description ); 
            }
              
        } 
        catch(Exception e) {
            objAnswer.answer       	= 	'Tipo de error "' + strStringError + '" no registrado en configuración personalizada';
            objAnswer.code      	= 	'9999';
            objAnswer.description 	= 	e.getMessage() + '\n' + e.getStackTraceString();
            
            CRAN_VAS_ON_EventLoggerBase_CLS.getInstance().commitLog(e);  // Logs the Exception in EventLogger__c custom object
        } 
        
        System.debug('DEBUG CONTROL_ERRORES. objAnswer:' + objAnswer);

        return objAnswer; 
    }

}