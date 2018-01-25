/**
* Company         : VASS
* Version         : 1.0 
* Project         :	Credit Andorra
* Description     :  
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0     19-01-2018      Nacho Hita   		    Created of the file
*
*************** Example *****************************************************************************************************************************************
*  CustomNewUserWSHandler: You can call GenericSalesforceWs with the action you prefer, as this ex. :
* 			- URL POST: "https://<salesforceinstance>/services/apexrest/action/NewUser" --> NewUser is the action you want to execute.
* 			- Request parameters: JSON. ex.: {JSON EXAMPLE}
* 			- The response will be diferent depends on your action.
****************************************************************************************************************************************************************/ 


public interface CRAN_VAS_ON_IWSHandler_CLS {
    String getExecuteAction( String params, String strAction );	   
}