/**
* Company         : VASS
* Version         : 1.0 
* @author 		  : Marta Barriuso
* Project         :	Credit Andorra
* Description     : Generic Salesforce WS, in order to be consumed by any FRONT-END.
* 				  	Create a new action creating it APEX class: 
* 				  		- The class name must be Custom<actionName>WSHandler: 
* 				  		- It must implements IWSHandler Interface
* 						- Create RequestWSWrapper/ResponseWSWrapper inner class with Request and Response structure for the action.		  
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0     19-01-2018      Nacho Hita				Created of the file
*
**********************************************************************************************************************************************/ 

@RestResource(urlMapping='/action/*')
global with sharing class CRAN_VAS_ON_GenericSalesforceWS_CLS {
	
    @HttpPost
    global static void executeAction() {
        RestRequest req = RestContext.request!=null?RestContext.request:new RestRequest();
        RestResponse res = RestContext.response!=null?RestContext.response:new RestResponse();
        
        String action = req.requestURI.substringAfter('action/');
        System.debug('CRAN_VAS_ON_WSHandlerFactory_CLS -- action:'+action+'\n--> bod '+req.requestBody.toString());
        
        // REQUEST - Obtain JSON from the request body and remove the white spaces.
        String strJSONReq = req.requestBody != null ? req.requestBody.toString().trim() : '';
        
        
        // EXECUTE ACTION - Invoke he appropriate class depending on the action received
        CRAN_VAS_ON_IWSHandler_CLS handler = CRAN_VAS_ON_WSHandlerFactory_CLS.createWSHandler(action);
        System.debug('handler ---> ' + handler);
        String response = handler.getExecuteAction( strJSONReq, action ); 
        
        // RESPONSE - Put the JSON in the response body.
        res.addHeader( 'Content-Type', 'application/json' );
		// Fill the statusCode in the HTTP header
        res.responseBody = Blob.valueOf(response);
		System.debug('GenericSalesforceWS Response: ' + response);
    }
}