public class CRAN_VEC_ADV_CloseOpp_AUC {


	/**
    * Action para CERRAR la Opportunity (Propuesta).
    *
    * @param objId - Id de la Opportunity que se va a cerrar.
    * 
    * @return respuesta JSON para gestionar con la Opportunity.
    */

	@AuraEnabled
	public static Object closeOpportunity(String objId) {

		try{
			Object errResponse = null;
			Id recordId = objId;
			SObjectType objectType = Id.valueOf(objId).getSObjectType();
			String sObjName = recordId.getSObjectType().getDescribe().getName();

			Opportunity myOpp = queryOpp(recordId);
			errResponse = correctOppStatusClose(myOpp);
			if(errResponse!=null){
				return errResponse;
			}

			errResponse = callCloseOpp(myOpp);
			return errResponse;

		}catch(Exception e){
			System.debug('### ERROR ### closeOpportunity: ' + e);
			System.debug('StackTraceString: ' + e.getStackTraceString());
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
		}        
	}

	/**
    *
    * Guarda sobre la variable de la clase 'opp' la opportunity a partir del objId pasado por parametro
    *
    * @param recordId   - Id de la oportunity o quote para generar la consulta.
    * 
    * @return respuesta JSON para gestionar con la Quote que se ha firmado.
    *
    */
	private static Opportunity queryOpp(Id recordId) {
        Opportunity opp  = [SELECT StageName,CRAN_VEC_ADV_T_AvaloqPropId__c,CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :recordId];
        return opp;
	}

    
	/**
    * 
    * Comprueba que es correcta la situación de la Opportunity para poder descartar la Opportunity
    *
    * @param  opp - Opportunity para la que se comprueba su status
    * 
    * @return 	null - si todo es correcto
    * 			ErrorResponse - Con el error si se produce.
    */
	public static Object correctOppStatusClose(Opportunity opp) {
		if ( opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PEND_SIGN ){
            // Se permite el cierre con el estado OPP_STAGENAME_PEND_SIGN porque,
            // por el momento, no está integrado con DocuSign.
			return null;
		}else{
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
		}
	}

	/**
    * 
    * Llama al servicio de Avaloq para cerrar la Opportunity enviada por parametro.
    *
    * @param  opp - Opportunity sobre la que se está trabajando
    * 
    * @return 	null          - si todo es correcto
    * 			ErrorResponse - Con el error si se produce.
    *
    */
	public static Object callCloseOpp(Opportunity opp){
		try {
			///////// LLAMADA AL SERVICIO CLOSE /////////		
			CRAN_VEC_ADV_RebalpRQ rq = new CRAN_VEC_ADV_RebalpRQ();

			//entrada de parametros//
			rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));
			CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
			order.setOrderNr(opp.CRAN_VEC_ADV_T_AvaloqPropId__c);
			rq.setOrder(order);
			//fin entrada de parametros//

			String jsonRequest = JSON.serialize(rq);
			System.debug('jsonRequest' + rq);
			
			CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CLOSE_OPORTUNIDAD,opp.CRAN_VEC_ADV_P_Bunit__c,jsonRequest);
			System.debug('restClient ' + restClient);

			CRAN_VEC_ADV_RebalpRS results = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpRS.class);
			System.debug('results ' + results);
			///////// FIN LLAMADA AL SERVICIO CLOSE/////////
			
			if (results == null) {
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
			} else if (results != null && results.getErrors() != null) {
				return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors()));
			} else if (results != null && results.getOrder() == null) {
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
			} else if (results != null && results.getErrors() == null && results.getOrder() != null) {
				if (results.getStatus().equalsIgnoreCase(CRAN_VEC_ADV_Constants_CLS.DONE)) {
					opp.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE;
					opp.CloseDate = System.today();
					opp.CRAN_VEC_ADV_B_IsService__c = true;
					update opp;
					opp.CRAN_VEC_ADV_B_IsService__c = false;
					update opp;
					return new SuccessResponse(opp);
				} else{
					return new ErrorResponse(String.format(Label.CRAN_VEC_ADV_IP_MSG_Error_CloseOpp,new List<String>{results.getStatus()}));
				}            
			} else {
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
			}
		}catch(Exception ex){
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
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
		@AuraEnabled public SObject obj {get; set;}

		public SuccessResponse(Quote vQuo) {
			this.success = true;
			this.obj = vQuo;
		}

		public SuccessResponse(Opportunity vOpp) {
			this.success = true;
			this.obj = vOpp;
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