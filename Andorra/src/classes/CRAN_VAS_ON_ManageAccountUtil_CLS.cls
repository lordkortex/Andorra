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
* @version  1.0     22/01/2018		Nacho Hita				Class definition and methods	
*
****************************************************************************************************************************************************************/ 

public class CRAN_VAS_ON_ManageAccountUtil_CLS {
	
	/**
    * @Method:      CRAN_VAS_ON_ManageAccountUtil_CLS
    * @Paramerers:  none
    * @Description: Default Constructor within paremeters.
    */  
	public CRAN_VAS_ON_ManageAccountUtil_CLS()
    {
    }
    
    /**
    * @Method:      createContact
    * @Paramerers:  boolean, string, string, string, string, string
    * @Description: Method that will create the contact based on the paremeters of the function
    */  
    public static Contact createContact( boolean IsInsert, string strEmail, string strFirstName, string strLastName, string strPrefix, string strPhone )
    {
    	Contact objAcc;
    	try {
			objAcc = new Contact();

            objAcc.firstName			=   strFirstName; 
            objAcc.lastName             =   strLastName; 
            objAcc.email                =   strEmail;
            objAcc.Prefix__c			= 	strPrefix;
            objAcc.phone                =   strPhone;   
            
            objAcc.recordtypeId			=	CRAN_VAS_ON_ManageObjectUtil_CLS.getMapRecordTypes('Contact').get('IndustriesIndividual');
            if(IsInsert)
                insert objAcc;
                                
            system.debug('\n Created a new record individual @@@@@  \n' + objAcc );                
            update objAcc;  
        }
            
        catch( exception e ) {
            objAcc = null;
        	system.debug ( '-->\n\n CRAN_VAS_ON_ManageAccountUtil_CLS ( createAccount ) ' + e );
        }    

       return objAcc;
	}	
}