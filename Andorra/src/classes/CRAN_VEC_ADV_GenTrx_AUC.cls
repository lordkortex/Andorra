public with sharing class CRAN_VEC_ADV_GenTrx_AUC {

	/**
    * 
    * Método que llama al servicio SERVICE_GEN_TRX para generar las transacciones y actualiza la propuesta.
    *
    * @param  String recordId - Id de la propuesta.
    * 
    * @return   SuccessResponse si va todo bien.
    *           ErrorResponse si va mal.
    *
    */
	@AuraEnabled
	public static Object genTRX(String recordId){
        try {
			Opportunity myOpp = [SELECT Id,StageName,CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c 
									   FROM Opportunity WHERE Id = : recordId];
			
			System.debug('myOpp '+myOpp);									   
			if(myOpp !=null){

				if(!CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PROPGEN.equals(myOpp.StageName)){
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_GenTrx);
				}

				CRAN_VEC_ADV_GenTrxRQ_CLS rq = new CRAN_VEC_ADV_GenTrxRQ_CLS();

				////////// ENTRADA PARAMETROS ////////////
		        rq.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());
		        CRAN_VEC_ADV_Order_CLS myOrder = new CRAN_VEC_ADV_Order_CLS();
		        myOrder.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
		        rq.order = myOrder;
		        ////////// FIM ENTRADA PARAMETROS ////////
		        
		        String jsonRequest = JSON.serialize(rq);
				System.debug('jsonRequest: ' + jsonRequest);

				CRAN_VEC_ADV_RestClient_CLS avaloqClient;
				String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;
		        CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_GEN_TRX,bu,jsonRequest);

		        CRAN_VEC_ADV_GenTrxRS_CLS results = (CRAN_VEC_ADV_GenTrxRS_CLS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_GenTrxRS_CLS.class);            
		        System.debug('results '+results);

				if (results != null && results.errors != null) {
					return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors));
				} else if (results != null && results.errors == null && results.order != null && results.status != null && results.statusId != null) {

						Object resultServDetail = CRAN_VEC_ADV_RetrOppList_AUC.updateRecordData(recordId);
						
						if(resultServDetail instanceof CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponse){
							CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponse tempSuccess = (CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponse)resultServDetail;
							System.debug(tempSuccess);
							return new SuccessResponse(Label.CRAN_VEC_ADV_IP_GenTrx+' '+results.status);
						} else if(resultServDetail instanceof CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse) {
							CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse tempError = (CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse)resultServDetail;
							return new ErrorResponse( CRAN_VEC_ADV_Constants_CLS.SERVICE_DET_OPORTUNIDAD_V2+'. '+tempError.messageError);
						}

						return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_GenTrx);

				} else {
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_GenTrx);
				}
			} else return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_GenTrx);

		} catch (Exception e) {
            return new ErrorResponse(e);
        }
				
	}

	
    /**
    * 
    * Método que llama al servicio SERVICE_UPDATE_MEDIUM para actualizar el Medium.
    *
    * @param  String recordId - Id la propuesta.
    * 
    * @return   SuccessResponse si va todo bien.
    *           ErrorResponse si va mal.
    *
    */
	@AuraEnabled
	public static Object updateMedium(String recordId){
		System.debug('updateMedium');
        try {
			Opportunity myOpp = [SELECT Id,StageName,CRAN_VEC_ADV_F_ValidPerson__c,CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c 
									   FROM Opportunity WHERE Id = : recordId];
			
			System.debug('myOpp '+myOpp);
			if(!myOpp.CRAN_VEC_ADV_F_ValidPerson__c){
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_NoContactToFirm);
			}									   

			if(myOpp != null){

				CRAN_VEC_ADV_GenTrxRQ_CLS rq = new CRAN_VEC_ADV_GenTrxRQ_CLS();

				////////// ENTRADA PARAMETROS ////////////
		        rq.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());
		        CRAN_VEC_ADV_Order_CLS myOrder = new CRAN_VEC_ADV_Order_CLS();
		        myOrder.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
		        rq.order = myOrder;
		        ////////// FIM ENTRADA PARAMETROS ////////

		        String jsonRequest = JSON.serialize(rq);
				System.debug('jsonRequest: ' + jsonRequest);

				CRAN_VEC_ADV_RestClient_CLS avaloqClient;
				String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;
		        CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_UPDATE_MEDIUM,bu,jsonRequest);
		        System.debug('restClient '+restClient);		        
		        CRAN_VEC_ADV_UpdateMediumRS_CLS results = (CRAN_VEC_ADV_UpdateMediumRS_CLS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_UpdateMediumRS_CLS.class);            
		        System.debug('results '+results);

				if (results != null && results.errors != null) {
					return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors));
				} else if (results != null && results.errors == null && results.order != null) {
					return new SuccessResponse(CRAN_VEC_ADV_Constants_CLS.MEDIUMUPDATED);
				} else {
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_GenTrx);
				}

			} else return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_GenTrx);

		} catch (Exception e) {
            return new ErrorResponse(e);
        }
				
	}

    /*--------------------------*/
	/*     Classes Wrapper      */
	/*     ---------------      */
	/*     Para responses       */
	/*--------------------------*/

	@TestVisible
	class SuccessResponse {

		@AuraEnabled public Boolean success {get; set;}
		@AuraEnabled public String msj {get; set;}

		public SuccessResponse(String msj) {
			this.success = true;
			this.msj = msj;
		}
	}

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