public with sharing class CRAN_VEC_ADV_DiscardpProp_AUC {
	/**
    * Action para descartar la  Opportunity (Propuesta).
    *
    * @param objId - Id de la Opportunity o quote para generar el pdf con la propuesta y firmar la propuesta.
    * 
    * @return respuesta JSON para gestionar con la Quote que se ha firmado.
    */

	@AuraEnabled
	public static Object discardOpportunity(String objId) {
		try{
			Object errResponse = null;
			Id recordId = objId;
			SObjectType objectType = Id.valueOf(objId).getSObjectType();
			String sObjName = recordId.getSObjectType().getDescribe().getName();

			Opportunity myOpp = queryOpp(recordId, objectType);

			errResponse = callDiscardOpp(myOpp);
			if(errResponse!=null){
				return errResponse;
			}
			
			return new SuccessResponse(myOpp);
		}catch(Exception e){
			System.debug('### ERROR ### closeOpportunity: ' + e);
			System.debug('StackTraceString: ' + e.getStackTraceString());
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Discard);
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
			Opportunity opp  = [SELECT StageName,CRAN_VEC_ADV_T_AvaloqPropId__c,CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :recordId];
			return opp;
		} else if (objectType == Schema.Quote.SObjectType) {
			Opportunity opp  = [SELECT StageName,CRAN_VEC_ADV_T_AvaloqPropId__c,CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM Quote WHERE Id = :recordId)];
			return opp;
		}
		return null;
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

    @AuraEnabled
	public static Object correctOppStatusDiscard(String oppId) {

		Id recordId = oppId;
		SObjectType objectType = Id.valueOf(oppId).getSObjectType();

		Opportunity Opp = queryOpp(recordId, objectType);

		if((opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_OPEN || 
			opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED)){
			return new SuccessResponse(Opp);
		}else{
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Discard);
		}
	}

	/**
    * 
    * Llama al servicio de Avaloq para descartar la Opportunity enviada por parametro.
    *
    * @param  opp - Opportunity sobre la que se esta trabajando
    * 
    * @return 	null - si todo es correcto
    * 			ErrorResponse - Con el error si se produce.
    *
    */
	public static Object callDiscardOpp(Opportunity opp){
		try{
			///////// LLAMADA AL SERVICIO DISCARD /////////
			CRAN_VEC_ADV_RebalpRQ rq = new CRAN_VEC_ADV_RebalpRQ();

			//entrada de parametros//
			rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

			CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
			order.setOrderNr(opp.CRAN_VEC_ADV_T_AvaloqPropId__c);
			rq.setOrder(order);
			//fin entrada de parametros//
			String jsonRequest = JSON.serialize(rq);

			System.debug('jsonRequest' + rq);

			CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_DESCARTAR_OPORTUNIDAD,opp.CRAN_VEC_ADV_P_Bunit__c,jsonRequest);
			System.debug('restClient ' + restClient);

			CRAN_VEC_ADV_RebalpRS results = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpRS.class);

			System.debug('results ' + results);

			if (results != null && results.getErrors() != null) {
				return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors()));
			} else if (results != null && results.getErrors() == null && results.getOrder() != null) {
				opp.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DISCARTED;
				opp.CloseDate = System.today();
				opp.CRAN_VEC_ADV_B_IsService__c = true;
				update opp;
				opp.CRAN_VEC_ADV_B_IsService__c = false;
				update opp;
				return new SuccessResponse(opp);
			} else{
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Discard);
			}
		}catch(Exception e){
			System.debug('### ERROR ### callDiscardOpp: ' + e);
			System.debug('StackTraceString: ' + e.getStackTraceString());
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Discard);
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