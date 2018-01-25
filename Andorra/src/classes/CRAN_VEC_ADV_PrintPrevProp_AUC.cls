public with sharing class CRAN_VEC_ADV_PrintPrevProp_AUC {
	
	private static Quote quo;

    /**
    * Action para el boton de print preview.
    *     *
    * @param objId - Id de la oportunity o quote para generar el pdf con la propuesta. Guardando en la OMS_Id del pdf que se generado.
    * 
    * @return respuesta JSON para gestionar con la Quote que se ha actualizado.
    */

	@AuraEnabled
	public static Object printPreview(String objId) {
		try{
			Object errResponse = null;
			Id recordId = objId;
			SObjectType objectType = Id.valueOf(objId).getSObjectType();
			String sObjName = recordId.getSObjectType().getDescribe().getName();

			Opportunity myOpp = queryOpp(recordId, objectType);
			errResponse = correctOppStatusPreview(myOpp);
			if(errResponse!=null){
				return errResponse;
			}

			errResponse = queryQuote(recordId, sObjName);
			if(errResponse!=null){
				return errResponse;
			}
			errResponse = callOmsPrint();
			return errResponse;
		}catch(Exception e){
			System.debug('### ERROR ### printPreview: ' + e);
			System.debug('StackTraceString: ' + e.getStackTraceString());
			return new ErrorResponse(e);
		}
	}


	/**
    *
    * Guarda sobre la variable de la clase 'opp' la opportunity a partir del objId parado por parametro
    * dependiendo si se envia un Id de Quote o Opportunity
    *
    * @param recordId - Id de la oportunity o quote para generar el pdf con la propuesta y firmar la propuesta.
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
    * Comprueba que es correcta la situación de la Opportunity para realizar el proceso de Print Preview
    *
    * @param  opp - Opportunity para la que se comprueba su status
    * 
    * @return 	null - si todo es correcto
    * 			ErrorResponse - Con el error si se produce.
    */
	public static Object correctOppStatusPreview(Opportunity opp) {
		if(opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED || opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PROPGEN){
			return null;
		}else{
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_PrintPrev);
		}
	}

	/**
    *
    * Guarda sobre la variable de la clase 'quo' la Quote a partir del objId pasado por parametro
    * dependiendo si se envia un Id de Quote o Opportunity.
    *
    * @param recordId - Id de la oportunity o quote para generar el pdf con la propuesta y firmar la propuesta.
    *		 sObjName - Nombre del objeto para distinguir entre Opportunity y Quote
    * 
    * @return devuelve null si todo es correcto y un ErrorResponse si se produce un error.
    *
    */
	private static Object queryQuote(Id recordId, String sObjName) {
		List<Quote> lstQuote;
		if (CRAN_VEC_ADV_Constants_CLS.OPPORTUNITY_OBJ.equals(sObjName)) {
			lstQuote = [SELECT  Id, 
								OpportunityId, 
								CRAN_VEC_ADV_B_Final__c, 
								CRAN_VEC_ADV_P_Bunit__c,
								Opportunity.CRAN_VEC_ADV_T_AvaloqPropId__c
						FROM Quote 
				        WHERE CRAN_VEC_ADV_B_Final__c = true AND OpportunityId = :recordId];
		} else {  //Quote
			//Para fase 1 el print preview no necesita calcular previamiente
			//return CRAN_VEC_ADV_Investment_Proposal_AUC.calcProp(recordId, CRAN_VEC_ADV_Constants_CLS.OPTION_PRINTPREVIEW);
			lstQuote = [SELECT  Id, 
								CRAN_VEC_ADV_P_Bunit__c, 
								Opportunity.CRAN_VEC_ADV_T_AvaloqPropId__c 
						FROM Quote 
						WHERE Id = :recordId];
		}

		if (lstQuote != null && lstQuote.size() > 0) {
			quo = lstQuote[0];
			return null;
		} else {
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_QUOTE);
		}
	}	


	/**
    *
    * Guarda sobre la variable de la clase 'quo' la Quote a partir del objId pasado por parametro
    * dependiendo si se envia un Id de Quote o Opportunity.
    *
    * @param 
    * 
    * @return devuelve null si todo es correcto y un ErrorResponse si se produce un error.
    *
    */

	public static Object callOmsPrint(){
		CRAN_VEC_ADV_OmsPrint_RQ rq = new CRAN_VEC_ADV_OmsPrint_RQ();

		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
		order.setOrderNr(quo.Opportunity.CRAN_VEC_ADV_T_AvaloqPropId__c);
		order.setIsNew(false);
		rq.order = order;
		String jsonRequest = JSON.serialize(rq);
                    
		CRAN_VEC_ADV_RestClient_CLS avaloqClient;
		avaloqClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_PRINT,quo.CRAN_VEC_ADV_P_Bunit__c, jsonRequest);

		CRAN_VEC_ADV_OmsPrint_RS results = (CRAN_VEC_ADV_OmsPrint_RS) JSON.deserialize(avaloqClient.responseBody,CRAN_VEC_ADV_OmsPrint_RS.class);

		if (results != null && results.errors != null) {
			return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors));
		} else if (results != null && results.errors == null && results.omsIdList != null) {
			if(results.omsIdList.size()>0){
				return new SuccessResponse(results.omsIdList[0].id);
			}else{
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
			}
		} else {
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
		}
	}

	@TestVisible
	class SuccessResponse {

		@AuraEnabled public Boolean success {get; set;}
		@AuraEnabled public String omsID {get; set;}

		public SuccessResponse(String omsID) {
			this.success = true;
			this.omsID = omsID;
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