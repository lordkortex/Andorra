/**
 * CRAN_VEC_ADV_ViewForm_AUC
 *
 * Fecha Modificacion: 13/11/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.2
 * Fix query recuperacion ReferenceLine añadido CRAN_VAS_KER_P_DocumentType__c = 'Envelope'
 *
*/
public with sharing class CRAN_VEC_ADV_ViewForm_AUC {

    @AuraEnabled
    public static String initApex(String accountId){
        Contact c = retrieveIdContact(accountId);
        List<Account> lstBPs = getBPs(c.Id);
        SuccessInitResponse responseSuccess = new SuccessInitResponse(c,lstBPs);
        return JSON.serialize(responseSuccess);
    }

    //Modificacion  para recuperar solamente los formularios firmados en Salesforce relacionados con el Account/Contact seleccionado
    @AuraEnabled
    public static Object recuperarCuestionariosDone(String accountId){

        try{
            Contact c = retrieveIdContact(accountId);
            System.debug('recuperarCuestionariosDone contactID: ' + c.Id);
            List<CRAN_VEC_ADV_CustomForm_Response__c> lstFormResponses = [SELECT Id,Name,CRAN_VEC_ADV_P_Acceptance_Status__c,CRAN_VEC_ADV_T_Avaloq_External_Id__c,
                                                                                CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber,CRAN_VEC_ADV_L_Business_Partner__r.CRAN_VEC_ADV_N_Number__c,CRAN_VEC_ADV_DT_StartDate__c
                                                                                ,CRAN_VEC_ADV_MD_CustomForm__r.CRAN_VEC_ADV_T_ExternalID__c
                                                                            FROM CRAN_VEC_ADV_CustomForm_Response__c 
                                                                            WHERE CRAN_VEC_ADV_P_Acceptance_Status__c = 'Signed' AND CRAN_VEC_ADV_L_Contact__c =:c.ID
                                                                            ORDER BY Name DESC, CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber ASC];

            if(lstFormResponses != null && lstFormResponses.size()>0){
                return new SuccessInitResponse(lstFormResponses);
            }else{
                //NO HAY FORMULARIOS FIRMADOS PARA EL BP SELECCIONADO
                return new ErrorResponse(Label.CRAN_VEC_ADV_CF_MSG_NOFORMS);
            }
        }catch(Exception e){
            return new ErrorResponse(e.getMessage());
        }
    }

    private static List<Account> getBPs(String contactId){
        try{
            List<FinServ__FinancialAccountRole__c> lstFAR = CRAN_VEC_ADV_Utils.getRelatedBpsFromContactID(contactId);
            List<Account> lstAccounts = new List<Account>();
            Map<String,Account> mapAccounts = new  Map<String,Account>();

            lstAccounts.add(new Account());

            for(FinServ__FinancialAccountRole__c far : lstFAR){
                mapAccounts.put(far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id, new Account(Id=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id,AccountNumber=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c,Name=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.AccountNumber+' - '+far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name));
            }

             for(Account accountTemp : mapAccounts.values()){
                lstAccounts.add(accountTemp);
            }

            return lstAccounts;
        }catch (Exception e){
            return null;
        }
    }


    private static Contact retrieveIdContact(String accountId){
        try{
            Contact myContact = [SELECT Id,CRAN_VEC_ADV_P_PersonType__c FROM Contact WHERE AccountId = :accountId];
            return myContact;
        }catch (Exception e){
            return null;
        }
    }

    /**
     * retrieveReferenceLine
     *
     * Fecha Modificacion: 22/06/2017
     * @author  Julian Gonzalez Garcia (Vector ITC)
     * @version 1.0
     *
    */

    //Recuperamos el ReferenceLine para realizar la consulta en Archive
    @AuraEnabled
    public static Object retrieveReferenceLine(String formId){
        List<CRAN_VAS_KER_ESignature__c> listReferenceLine = [SELECT CRAN_VAS_KER_Reference_Line__c,CRAN_VAS_KER_Account__r.CRAN_VEC_ADV_N_Number__c 
                                                              			FROM CRAN_VAS_KER_ESignature__c 
                                                              			WHERE CRAN_VAS_KER_Core_Id__c = : formId AND CRAN_VAS_KER_P_DocumentType__c = 'Envelope' 
                                                              				AND CRAN_VAS_KER_Reference_Line__c != NULL ORDER BY CRAN_VAS_KER_Start_Date__c DESC LIMIT 1];
        if(listReferenceLine!=null && listReferenceLine.size()>0){        
                return new SuccessInitResponse(listReferenceLine[0].CRAN_VAS_KER_Reference_Line__c,listReferenceLine[0].CRAN_VAS_KER_Account__r.CRAN_VEC_ADV_N_Number__c );
        } else {
            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Archive);
        }
    }

    /*--------------------------*/
    /*     Classes Wrapper      */
    /*     ---------------      */
    /*     Para responses       */
    /*--------------------------*/

    class SuccessInitResponse{
        @AuraEnabled public Boolean success = true;
        @AuraEnabled public List<Account> bps;
        @AuraEnabled public Contact contact;
        @AuraEnabled public List<CRAN_VEC_ADV_CustomForm_Response__c> lstFormResponses;
        @AuraEnabled public String referenceLine;
        @AuraEnabled public String bp;

        public SuccessInitResponse(Contact c,List<Account> bps){
            this.success = true;
            this.contact = c;
            this.bps = bps;
        }

        public SuccessInitResponse( List<CRAN_VEC_ADV_CustomForm_Response__c> lstFormResponses){
            this.success = true;
            this.lstFormResponses = lstFormResponses;
        }

        public SuccessInitResponse(String referenceLine,String bp){
            this.success = true;
            this.referenceLine = referenceLine;
            this.bp = bp;
        }

    }

    @TestVisible
    class ErrorResponse{
        @AuraEnabled public Boolean success = false;
        @AuraEnabled public String messageError;

        public ErrorResponse(String messageError){
            this.success = false;
            this.messageError = messageError;
            
        }
    } 
}