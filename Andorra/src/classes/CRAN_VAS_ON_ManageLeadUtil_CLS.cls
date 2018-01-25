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
* @version  1.0     24/01/2018		Nacho Hita				Class definition and methods	
*
************* */

public class CRAN_VAS_ON_ManageLeadUtil_CLS{
	
	/**
	* Instantiates a new CRA N VA S O N manage lead util CLS.
	*/
	public CRAN_VAS_ON_ManageLeadUtil_CLS(){
    	
    }
    
     /**
	 * @Method:      Creates the lead.
	 *
	 * @param strEmail
	 *            the str email
	 * @param strFirstName
	 *            the str first name
	 * @param strLastName
	 *            the str last name
	 * @param strPrefix
	 *            the str prefix
	 * @param strPhone
	 *            the str phone
	 * @return the lead
	 *
	 * @Description: Method that will create the lead.
	 */
    public static Lead createLead(  string strEmail, string strFirstName, string strLastName, string strPrefix, string strPhone ){
        Lead objLead;
        
        try {
			objLead = new Lead();

            objLead.firstName			=   strFirstName; 
            objLead.lastName            =   strLastName; 
            objLead.email               =   strEmail;
            objLead.Prefix__c			= 	strPrefix;
            objLead.phone               =   strPhone;   
            objLead.Company             =   strFirstName + ' ' + strLastName;   
            
            objLead.recordtypeId		=	CRAN_VAS_ON_ManageObjectUtil_CLS.getMapRecordTypes('Lead').get('General');
            
            insert objLead;
                                
            system.debug('\n Created a new record lead @@@@@  \n' + objLead );                
        }
            
        catch( Exception e ) {
            objLead = null;
        	system.debug ( '-->\n\n CRAN_VAS_ON_ManageLeadUtil_CLS ( createLead ) ' + e );
            throw new CRAN_VAS_ON_Exception(Integer.valueOf(Label.CRAN_VAS_ON_Salesforce_Internal_Error), e.getMessage());
        }  
        
        return objLead;
    }   
  
}