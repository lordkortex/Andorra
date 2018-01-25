/*************************************************************************************
Company         : VASS
Version         : 1.0 
Created Date    : 23 Ene 2018
Function        : Business logic for manage individual

Modification Log :
-------------------------------------------------------------------------------------
* Developer                   Date                   Description
* -----------------------------------------------------------------------------------
* Griselda Diaz          	2018/01/23	             Original Version
 
*************************************************************************************/

public class CRAN_VAS_ON_ManageIndividualUtil_CLS {
	
	/*
    * @Method:      createIndividual
    * @param:       boolean isInsert
    * @author       VASS 2018/01/23
    * @Description  create individual record 
    */  
    
    public CRAN_VAS_ON_ManageIndividualUtil_CLS() {
     	CRAN_VAS_ON_EventLoggerBase_CLS.getInstance().setLogType(CRAN_VAS_ON_ManageIndividualUtil_CLS.class.getName());
    }
    
    ///*
    //* @Method:      queryLead
    //* @Description  verify if another Lead was created with the same email address
    //* @Date         24/01/2018
    //*/
    public static List<Lead> queryLeadVerifyDuplicates( String strEmail, String strPhone) {
        List<Lead> lstLead = new List<Lead>([
            SELECT Email, 
                (SELECT Id, Status,Stage__c FROM CasesLead__r) 
            FROM Lead 
            WHERE Email =: strEmail 
            OR Phone =: strPhone 
        ]);
        return lstLead;              
    }


    ///*
    //* @Method:      queryContact
    //* @Description  verify if another Contact exist with email or phone given
    //* @Date         24/01/2018
    //*/
    public static Boolean validateExistingContact( String strEmail, String strPhone) {
        Boolean contactExists = false;
        
        List<Contact> lstContact = new List<Contact>([
            SELECT Email, CRAN_VEC_ADV_T_BizEmail__c, Phone, OtherPhone, AssistantPhone, HomePhone, MobilePhone 
            FROM Contact  
        ]);

        for(Contact contact: lstContact) {
            if(contact.Email == strEmail ||
                contact.CRAN_VEC_ADV_T_BizEmail__c == strEmail ||
                contact.Phone == strPhone ||
                contact.OtherPhone == strPhone ||
                contact.AssistantPhone == strPhone ||
                contact.HomePhone == strPhone ||
                contact.MobilePhone == strPhone) {
                
                    contactExists = true;
            } 

        }
        return contactExists;              
    }
}