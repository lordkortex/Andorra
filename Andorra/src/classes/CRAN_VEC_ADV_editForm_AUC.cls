public with sharing class CRAN_VEC_ADV_editForm_AUC {

	/**
    * 
    * Método que obtiene los formularios asociados al contacto principal del Account.
    *
    * @param  String recordId - Id del Account.
    * 
    * @return   respuesta JSON, SuccessResponse(Con los CRAN_VEC_ADV_CustomForm_Response__c asociados y el contacto) si va todo bien 
    *            y ErrorResponse si va mal.
    *
    */
    @AuraEnabled
	public static String getApexResponses(String recordId){
		try{

            Contact myContact = [SELECT AccountId,Name,Id FROM Contact WHERE AccountId = :recordId];
            String myContactId = myContact.Id;

    		List<CRAN_VEC_ADV_CustomForm_Response__c> lstSuitableTestRespond;
            lstSuitableTestRespond = [SELECT Id,Name,CRAN_VEC_ADV_C_Amount__c,CRAN_VEC_ADV_DT_StartDate__c, 
                                        CRAN_VEC_ADV_MD_CustomForm__r.CRAN_VEC_ADV_N_Version__c, CRAN_VEC_ADV_MD_CustomForm__r.CRAN_VEC_ADV_P_Type__c, CRAN_VEC_ADV_MD_CustomForm__r.Name,CRAN_VEC_ADV_P_Acceptance_Status__c,
                                        (SELECT CRAN_VEC_ADV_B_Answered__c,CRAN_VEC_ADV_T_Answer__c,Id,Name,CRAN_VEC_ADV_MD_Question__c,CRAN_VEC_ADV_MD_CustomFormResponse__c 
                                            FROM CRAN_VEC_ADV_Answers__r) 
                                     FROM CRAN_VEC_ADV_CustomForm_Response__c WHERE  CRAN_VEC_ADV_L_Contact__c = :myContactId  AND (CRAN_VEC_ADV_P_Acceptance_Status__c = 'On Hold' OR CRAN_VEC_ADV_P_Acceptance_Status__c = 'Done') ORDER BY CRAN_VEC_ADV_DT_StartDate__c DESC];
            lstSuitableTestRespond.add(0, new CRAN_VEC_ADV_CustomForm_Response__c());

            return JSON.serialize(new SuccessResponse(lstSuitableTestRespond,myContact));
        }catch (Exception e){
            return JSON.serialize(new ErrorResponse(e.getMessage()));
        }

    }

    
    /*--------------------------*/
    /*     Classes Wrapper      */
    /*     ---------------      */
    /*     Para responses       */
    /*--------------------------*/


    class SuccessResponse{
    	public Boolean success = true;
    	public List<CRAN_VEC_ADV_CustomForm_Response__c> suitableTestResponds;
        public Contact contact;

    	public successResponse(List<CRAN_VEC_ADV_CustomForm_Response__c> suitableTestResponds,Contact contact){
    		this.success = true;
    		this.suitableTestResponds = suitableTestResponds;
            this.contact = contact;
    	}
    }

    @TestVisible
    class ErrorResponse{
    	public Boolean success = false;
    	public String messageError;

    	public ErrorResponse(String messageError){
    		this.success = false;
    		this.messageError = messageError;
    		
    	}
    }
}