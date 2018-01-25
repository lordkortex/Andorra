public with sharing class CRAN_VEC_ADV_PrintContract_AUC {

    //Recuperamos el ReferenceLine para realizar la consulta en Archive
    @AuraEnabled
    public static Object retrieveReferenceLine(String oppId){
	
		try{
			Object errResponse = null;
			Id recordId = oppId;
			SObjectType objectType = Id.valueOf(oppId).getSObjectType();
			String sObjName = recordId.getSObjectType().getDescribe().getName();
            
			Opportunity myOpp = queryOpp(recordId,objectType);
			errResponse = correctOppStatusPrintContract(myOpp);
            
            if(errResponse!=null){
				return errResponse;
			}
            
			List<CRAN_VAS_KER_ESignature__c> listReferenceLine = [SELECT CRAN_VAS_KER_Reference_Line__c,CRAN_VAS_KER_Account__r.CRAN_VEC_ADV_N_Number__c FROM CRAN_VAS_KER_ESignature__c WHERE  CRAN_VAS_KER_Opportunity__c = : oppId AND CRAN_VAS_KER_Reference_Line__c != NULL AND CRAN_VAS_KER_Signature_Type__c = 'Proposal' ORDER BY CRAN_VAS_KER_Start_Date__c DESC LIMIT 1];
			System.debug('listReferenceLine '+listReferenceLine);
			if(listReferenceLine!=null && listReferenceLine.size()>0){        
				if(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c!=null){
				 		return new SuccessInitResponse(listReferenceLine[0].CRAN_VAS_KER_Reference_Line__c,
                                                   listReferenceLine[0].CRAN_VAS_KER_Account__r.CRAN_VEC_ADV_N_Number__c, myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);}
                     else{
                         return new SuccessInitResponse(listReferenceLine[0].CRAN_VAS_KER_Reference_Line__c,
                                                   listReferenceLine[0].CRAN_VAS_KER_Account__r.CRAN_VEC_ADV_N_Number__c, '');}        
         	} else {
              	
                if(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c!=null){
					return new SuccessInitResponse('',myopp.Account.CRAN_VEC_ADV_N_Number__c , myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
            } else {
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Archive);}
		}                
		}catch(Exception e){
			System.debug('### ERROR ### sign: ' + e);
			System.debug('StackTraceString: ' + e.getStackTraceString());
			return new ErrorResponse(e);
		}               
    }



    /**
    * 
    * Comprueba que es correcta la situación de la Opportunity para mostrar el documento firmado
    *
    * @param  opp - Opportunity para la que se comprueba su status
    * 
    * @return 	null - si todo es correcto
    * 			ErrorResponse - Con el error si se produce.
    */
	public static Object correctOppStatusPrintContract(Opportunity opp) {
		if(opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE){
			return null;
		}else{
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Archive);
		}
	}

    
	/**
    *
    * Guarda sobre la variable de la clase 'opp' la opportunity a partir del objId parado por parametro
    * dependiendo si se envia un Id de Quote o Opportunity
    *
    * @param recordId - Id de la oportunity o quote para generar la consulta.
    *		 objectType - Tipo de objeto para distinguir entre Opportunity y Quote
    * 
    * @return respuesta JSON para gestionar con la Quote que se ha firmado.
    *
    */
	private static Opportunity queryOpp(Id recordId, SObjectType objectType) {
		if (objectType == Schema.Opportunity.SObjectType) {
			Opportunity opp  = [SELECT Name,StageName,CRAN_VEC_ADV_T_AvaloqPropId__c,
                                CRAN_VEC_ADV_P_Bunit__c,  Account.CRAN_VEC_ADV_N_Number__c 
                                FROM Opportunity WHERE Id = :recordId];
			return opp;
		} else if (objectType == Schema.Quote.SObjectType) {
			Opportunity opp  = [SELECT StageName,CRAN_VEC_ADV_T_AvaloqPropId__c,CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM Quote WHERE Id = :recordId)];
			return opp;
		}
		return null;
	}    
    
    
    /*--------------------------*/
    /*     Classes Wrapper      */
    /*     ---------------      */
    /*     Para responses       */
    /*--------------------------*/

    @TestVisible
    class SuccessInitResponse{
        @AuraEnabled public Boolean success = true;
        @AuraEnabled public String referenceLine;
        @AuraEnabled public String bp;
        @AuraEnabled public String orderNr;


        public SuccessInitResponse(String referenceLine,String bp,String orderNr){
            this.success = true;
            this.referenceLine = referenceLine;
            this.bp = bp;
            this.orderNr = orderNr;
        }

    }

    /*
    @TestVisible
    class ErrorResponse{
        @AuraEnabled public Boolean success = false;
        @AuraEnabled public String messageError;

        public ErrorResponse(String messageError){
            this.success = false;
            this.messageError = messageError;
            
        }
    }
    */
    
	@TestVisible
	class ErrorResponse {
		@AuraEnabled public Boolean success {get; set;}
		@AuraEnabled public String messageError {get; set;}

		public ErrorResponse(Exception e) {
			this.success = false;
			this.messageError = e.getMessage();
		}

		public ErrorResponse(String str) {
			this.success = false;
			this.messageError = str;
		}
	}    
    
 
    
}