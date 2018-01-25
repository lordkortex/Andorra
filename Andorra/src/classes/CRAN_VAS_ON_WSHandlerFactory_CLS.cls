/**
* Company         : VASS
* Version         : 1.0 
* Project         : Credit Andorra
* Description     :     
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     22/01/2018		Nacho Hita				
*
******/

public with sharing class CRAN_VAS_ON_WSHandlerFactory_CLS {
	public CRAN_VAS_ON_WSHandlerFactory_CLS () {
   		CRAN_VAS_ON_EventLoggerBase_CLS.getInstance().setLogType(CRAN_VAS_ON_WSHandlerFactory_CLS.class.getName());
   }
   
    public static CRAN_VAS_ON_IWSHandler_CLS createWSHandler(String action) {
        CRAN_VAS_ON_IWSHandler_CLS handler = getWSHandler(action);
        if (handler == null){
            System.debug('Error handler=null in createWSHandler('+action+')');
            //throw new  OwnException(System.Label.MYLABEL + ' ' + action);            
        }
              
        return handler;
    }
    
    /** 
    * Dynamically get the appropiate handler based on the Type of the action.
    *               Handler's name has to follow this format:
    *               <ObjectName>WSHandler, the dispatcher has to be named
    *               Custom<NAME>WSHandler. Take into account that limit for class name size is 40 char!
    * @param strActionId        String Id for the action for which to create the WSHandler
    * @return ISignatureHandler A handler if it exists or null if it doesn't.
    */
    private static CRAN_VAS_ON_IWSHandler_CLS getWSHandler(String strActionId) {
        
        try {
        
            String handlerTypeName = null;
        
            handlerTypeName = 'CRAN_VAS_ON_Custom' + strActionId + 'WSHandler_CLS';
            System.debug('handlerTypeName --->  '+handlerTypeName);
            Type obType = Type.forName(handlerTypeName);
            System.debug('objType:'+obType);
            
            CRAN_VAS_ON_IWSHandler_CLS dispatcher = (obType == null) ? null : (CRAN_VAS_ON_IWSHandler_CLS)obType.newInstance();
            
            return dispatcher;
            
        } catch (Exception e) {
            System.debug('getWSHandler: '+e.getMessage() + '\n' + e.getStackTraceString());
            CRAN_VAS_ON_EventLoggerBase_CLS.getInstance().commitLog(e);  // Logs the Exception in EventLogger__c custom object
            return null;
        }
    }
}