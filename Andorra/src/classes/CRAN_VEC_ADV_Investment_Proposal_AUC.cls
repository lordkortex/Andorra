/**
 * CRAN_VEC_ADV_Investment_Proposal_AUC
 *
 * Fecha: 5/5/2016
 * @author  Iñaki Hernando Urcullu (Cloud Coachers)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_Investment_Proposal_AUC {

	private static Opportunity opp;
	private static Quote quo;


	/*-------------------------*/
    /*   PRIVATE FUCTIONS      */
    /*-------------------------*/

	/**
    *
    * Guarda sobre la variable de la clase 'opp' la opportunity a partir del objId parado por parametro
    * dependiendo si se envia un Id de Quote o Opportunity
    *
    * @param objectType - Tipo del objeto enviado
	*		 recordId - Id del objeto sobre el que estamos trabajando    		 
    * 
    * @return respuesta JSON para gestionar con la Quote que se ha firmado.
    *
    */
    @TestVisible
	private static void queryOpp(SObjectType objectType, Id recordId) {
		if (objectType == Schema.Opportunity.SObjectType) {
			opp  = [SELECT StageName,CRAN_VEC_ADV_T_AvaloqPropId__c,CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :recordId];
		} else if (objectType == Schema.Quote.SObjectType) {
			opp  = [SELECT StageName,CRAN_VEC_ADV_T_AvaloqPropId__c,CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM Quote WHERE Id = :recordId)];
		}
	}



	/**
    * 
    * Llama al servicio de Avaloq para obtener cerrar la Opportunity enviada por parametro.
    *
    * @param 
    * 
    * @return 	null - si todo es correcto
    * 			ErrorResponse - Con el error si se produce.
    *
    */
	/*public static Object callCloseOpp(){
		///////// LLAMADA AL SERVICIO CLOSE /////////
		CRAN_VEC_ADV_RebalpRQ rqClose = new CRAN_VEC_ADV_RebalpRQ();
		
		rqClose.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

		CRAN_VEC_ADV_Order_CLS orderClose = new CRAN_VEC_ADV_Order_CLS();
		orderClose.setOrderNr(opp.CRAN_VEC_ADV_T_AvaloqPropId__c);
		orderClose.setIsNew(false);
		rqClose.setOrder(orderClose);
		//fin entrada de parametros//
		
		String jsonRequestClose = JSON.serialize(rqClose);
		System.debug('jsonRequest' + rqClose);
		CRAN_VEC_ADV_RestClient_CLS restClientClose = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CLOSE_OPORTUNIDAD,opp.CRAN_VEC_ADV_P_Bunit__c,jsonRequestClose);

		System.debug('restClientClose ' + restClientClose);
		CRAN_VEC_ADV_RebalpRS resultsClose = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClientClose.responseBody, CRAN_VEC_ADV_RebalpRS.class);
		System.debug('resultsClose ' + resultsClose);
		
		///////// FIN LLAMADA AL SERVICIO CLOSE/////////
		if (resultsClose == null) {
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
		} else if (resultsClose != null && resultsClose.getErrors() != null) {
			return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsClose.getErrors()));
		} else if (resultsClose != null && resultsClose.getOrder() == null) {
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
		} else if (resultsClose != null && resultsClose.getErrors() == null && resultsClose.getOrder() != null) {
			if (resultsClose.getStatus().equals('done')) {
				opp.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE;
				opp.CRAN_VEC_ADV_B_IsService__c = true;
				update opp;
				opp.CRAN_VEC_ADV_B_IsService__c = false;
				update opp;
				return new SuccessResponse(opp);
			} else{
				return new ErrorResponse(String.format(Label.CRAN_VEC_ADV_IP_MSG_Error_CloseOpp,new List<String>{resultsClose.getStatus()}));
			}
			return null;
		} else{
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
		}
	}*/


	/**
    * 	CODIGO ANTERIOR
    */ 

    /**
    *
    * Realiza el calculo de la prupuesta enviada como parámetro y actualiza los objectos en funcion del tipo de status de la Quote
    *
    * @param recordId2 - d del objeto sobre el que estamos trabajando (Opportunity o Quote)
    * 
    * @return respuesta JSON para gestionar con la Quote que calcualado.
    *
    */
    
	@AuraEnabled
	public static Object calcProp(String recordId2, String printMode) {
		/*
		try {
			List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myMap = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
			List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myMapReturn = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
			CRAN_VEC_ADV_Investment_Proposition_Line__c elemenLevel0;
			Map<String, CRAN_VEC_ADV_Investment_Proposition_Line__c> myMapPos = new Map<String, CRAN_VEC_ADV_Investment_Proposition_Line__c>();

			List<RecordType> invsPropRecordType = [SELECT Id, SobjectType FROM RecordType WHERE Name = 'Investment Proposition' AND isActive = true];
			//Create a map between the Record Type SobjectType and Id for easy retrieval
			System.debug('invsPropRecordType' + invsPropRecordType);

			Map<String, Id> recordTypesMap = new Map<String, Id>();
			for (RecordType rt : invsPropRecordType) {
				recordTypesMap.put(rt.SobjectType, rt.Id);
			}

			List<Quote> myQuoteList = [SELECT Id, OpportunityId, Status, CRAN_VEC_ADV_N_LineItems__c, CRAN_VEC_ADV_N_Version__c, CRAN_VEC_ADV_B_Final__c, CRAN_VEC_ADV_B_FinalBK__c, CRAN_VEC_ADV_N_InvAmount__c, CRAN_VEC_ADV_N_InvAmountBK__c, CRAN_VEC_ADV_P_Currency__c, CRAN_VEC_ADV_P_CurrencyBK__c, Name, CRAN_VEC_ADV_P_Quote_ID__c, CRAN_VEC_ADV_T_OMS_Id__c
			                           FROM Quote WHERE Id = :recordId2];

			if (myQuoteList == null || myQuoteList.size() == 0) {
				System.debug('myQuoteList ' + myQuoteList);
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate);
			}
			Quote myQuote = myQuoteList[0];

			System.debug('sale quote' + myQuote+myQuote.Status);
			// OPPORTUNITY //
			Opportunity myOpp = [SELECT Id, StageName, CloseDate, CRAN_VEC_ADV_F_isNotEdit__c, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Currency__c, CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :myQuote.OpportunityId ];

			System.debug('sale opp');


			//si no cumple la validacion no continua
			if (myOpp.CRAN_VEC_ADV_F_isNotEdit__c && !CRAN_VEC_ADV_Constants_CLS.OPTION_PRINTPREVIEW.equals(printMode)) {
				System.debug('no edita');
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate);
			}

			System.debug('myOpp ' + myOpp);
			String nameCurrency = myOpp.CRAN_VEC_ADV_P_Currency__c;
			String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;

			// IPL //
			List <CRAN_VEC_ADV_Investment_Proposition_Line__c> listOfIPL = [
			            SELECT Id, CRAN_VEC_ADV_N_PropMktValue__c, CRAN_VEC_ADV_N_PropMktValueBK__c, CRAN_VEC_ADV_N_PercentQtty__c, CRAN_VEC_ADV_N_PercentQttyBK__c,
			            CRAN_VEC_ADV_N_PropQtty__c, CRAN_VEC_ADV_N_PropQttyBK__c, CRAN_VEC_ADV_N_MPF__c, CRAN_VEC_ADV_P_ChangedField__c, CRAN_VEC_ADV_FieldChangedbyUser__c,
			            CRAN_VEC_ADV_T_Remark__c, CRAN_VEC_ADV_T_RemarkBK__c, CRAN_VEC_ADV_T_Key__c, CRAN_VEC_ADV_P_nodeType__c, CRAN_VEC_ADV_T_NodeId__c
			            FROM CRAN_VEC_ADV_Investment_Proposition_Line__c
			            WHERE CRAN_VEC_ADV_L_Version__c = :recordId2 AND CRAN_VEC_ADV_P_nodeType__c = 'pos'];

			System.debug('listOfIPL ' + 'tamaño ' + listOfIPL.size() + listOfIPL);

			if (myQuote.status == 'Modified') {
				///////// LLAMADA AL SERVICIO CALCULAR/////////

				CRAN_VEC_ADV_CalcRebalpRQ rqCalcModif = new CRAN_VEC_ADV_CalcRebalpRQ();
				//entrada de parametros//
				rqCalcModif.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));
				CRAN_VEC_ADV_Order_CLS myOrderModif = new CRAN_VEC_ADV_Order_CLS();
				myOrderModif.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
				rqCalcModif.setOrder(myOrderModif);
				rqCalcModif.setPrintMode(printMode);

				List<CRAN_VEC_ADV_CalcRebalpVersion> versionListModif = new List<CRAN_VEC_ADV_CalcRebalpVersion>();
				CRAN_VEC_ADV_CalcRebalpVersion version1Modif = new CRAN_VEC_ADV_CalcRebalpVersion();

				version1Modif.setIsFinal(myQuote.CRAN_VEC_ADV_B_Final__c);
				version1Modif.setId(String.valueOf(myQuote.CRAN_VEC_ADV_N_Version__c));

				version1Modif.setName(myQuote.Name);
				version1Modif.setInvstAmount(double.valueOf(myQuote.CRAN_VEC_ADV_N_InvAmount__c));
				version1Modif.setInvstCurry(myQuote.CRAN_VEC_ADV_P_Currency__c);

				versionListModif.add(version1Modif);
				rqCalcModif.setVersionList(versionListModif);
				//fin entrada de parametros//
				String jsonRequestCalcModif = JSON.serialize(rqCalcModif);

				System.debug('rqCalcModif' + rqCalcModif);
				System.debug('jsonRequestCalcModif' + jsonRequestCalcModif);

				//peticion post
				CRAN_VEC_ADV_RestClient_CLS restClientCalcModif = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR_OPORTUNIDAD, bu, jsonRequestCalcModif);

				System.debug('restClientCalcModif ' + restClientCalcModif);

				CRAN_VEC_ADV_CalcRebalpRS resultsCalcModif = (CRAN_VEC_ADV_CalcRebalpRS)JSON.deserialize(restClientCalcModif.responseBody, CRAN_VEC_ADV_CalcRebalpRS.class);

				System.debug('resultsCalcModif ' + resultsCalcModif);
				///////// FIN LLAMADA AL SERVICIO CALCULAR/////////

				if (resultsCalcModif == null) {
					System.debug('Modified 1');
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate);
				} else if (resultsCalcModif != null && resultsCalcModif.getErrors() != null) {
					System.debug('Modified 2');
					return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsCalcModif.getErrors()));
				} else if (resultsCalcModif != null && (resultsCalcModif.getVersionList() == null || resultsCalcModif.getOrder() == null)) {
					System.debug('Modified 3');
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate);
				} else if (resultsCalcModif != null && resultsCalcModif.getErrors() == null && resultsCalcModif.getVersionList() != null && resultsCalcModif.getOrder() != null) {
					System.debug('Modified 4');

					//borro todos los IPLS y restricciones de quote
					List <CRAN_VEC_ADV_Investment_Proposition_Line__c> lIPL = [ SELECT Id FROM CRAN_VEC_ADV_Investment_Proposition_Line__c
					        WHERE CRAN_VEC_ADV_L_Version__c = :myQuote.Id];
					List <CRAN_VEC_ADV_IPL_Restriction__c> lRestriction = [ SELECT Id FROM CRAN_VEC_ADV_IPL_Restriction__c
					        WHERE CRAN_VEC_ADV_L_Version__c = :myQuote.Id];
					for (CRAN_VEC_ADV_Investment_Proposition_Line__c elementToDelete : lIPL) {
						elementToDelete.CRAN_VEC_ADV_B_IsService__c = true;
					}
					update lIPL;
					delete lIPL;
					delete lRestriction;

					CRAN_VEC_ADV_CalcRebalpVersionRS myVListModif = resultsCalcModif.getVersionList()[0];
					System.debug('myVListModif ' + myVListModif);
					List<CRAN_VEC_ADV_CalcRebalpRestrictionRS> myVRestModif = resultsCalcModif.getVersionList()[0].getRestrList();
					//recorro estructura como new proposition
					//inserto nivel 0
					elemenLevel0 = new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = myVListModif.getNode().getNodeDet().getName(), CRAN_VEC_ADV_N_PropAccrual__c = myVListModif.getNode().getNodeDet().getCpfAccr() , CRAN_VEC_ADV_N_MPF__c = 7.5, CRAN_VEC_ADV_N_PercentQtty__c = myVListModif.getNode().getNodeDet().getCpfPerc(), CRAN_VEC_ADV_N_PropMktValue__c = myVListModif.getNode().getNodeDet().getCpfMktVal(), CRAN_VEC_ADV_P_nodeType__c = 'node', CRAN_VEC_ADV_T_Remark__c = '', CRAN_VEC_ADV_N_PropMktValueBK__c = 837080.27, CRAN_VEC_ADV_N_PercentQttyBK__c = myVListModif.getNode().getNodeDet().getCpfPerc(), CRAN_VEC_ADV_T_RemarkBK__c = '', CRAN_VEC_ADV_P_ChangedField__c = 'Null', CRAN_VEC_ADV_N_Level__c = 0, CRAN_VEC_ADV_N_Secuence__c = 1);

					CRAN_VEC_ADV_CalcRebalpNodeRS nodeModif = myVListModif.getNode();
					myMapReturn = recorreArbol(nodeModif.getNodeList(), 1, myMap);
					System.debug('myMapReturn ' + myMapReturn);

					for (CRAN_VEC_ADV_Investment_Proposition_Line__c temp222 : myMap) {
						System.debug(temp222.Name);
					}

					List<CRAN_VEC_ADV_Investment_Proposition_Line__c> finalListLinesModif = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();

					integer mySecModif = 1;
					//relleno campos que faltan en las lineas antes de insertar
					if (elemenLevel0 != null) {
						elemenLevel0.CRAN_VEC_ADV_L_Version__c = myQuote.Id;
						elemenLevel0.CRAN_VEC_ADV_L_Proposition__c = myOpp.Id;
						elemenLevel0.RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c');
						elemenLevel0.CRAN_VEC_ADV_N_Secuence__c = mySecModif;
						finalListLinesModif.add(elemenLevel0);
					}

					for (CRAN_VEC_ADV_Investment_Proposition_Line__c myLineModif : myMapReturn) {
						mySecModif = mySecModif + 1;
						myLineModif.CRAN_VEC_ADV_L_Version__c = myQuote.Id;
						myLineModif.CRAN_VEC_ADV_L_Proposition__c = myOpp.Id;
						myLineModif.RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c');
						myLineModif.CRAN_VEC_ADV_N_Secuence__c = mySecModif;
						if (myLineModif.CRAN_VEC_ADV_P_nodeType__c != null && myLineModif.CRAN_VEC_ADV_P_nodeType__c == 'pos') {
							if (myLineModif.CRAN_VEC_ADV_T_Key__c != null && myLineModif.CRAN_VEC_ADV_T_Key__c != '')
								myLineModif.CRAN_VEC_ADV_T_Key__c = myQuote.Id + myLineModif.CRAN_VEC_ADV_T_Key__c;
							if (nameCurrency != null && nameCurrency != '')
								myLineModif.CRAN_VEC_ADV_P_Currency__c = nameCurrency;
						}
						//CRAN_VEC_ADV_N_MPF__c
						finalListLinesModif.add(myLineModif);
					}

					System.debug('lista para insertar' + finalListLinesModif + ' de tamaño ' + finalListLinesModif.size());


					for (CRAN_VEC_ADV_Investment_Proposition_Line__c myLine2Modif : finalListLinesModif) {
						System.debug(myLine2Modif.Name + ' ' + myLine2Modif.CRAN_VEC_ADV_N_Secuence__c + ' ' + myLine2Modif.CRAN_VEC_ADV_N_Level__c);
					}

					CRAN_VEC_KER_TriggerHandler_CLS.bypass('CRAN_VEC_ADV_IPLTriggerHandler_CLS');
					System.debug('antes trigger');

					insert finalListLinesModif;
					System.debug('pasa trigger');

					// INSERCION DE RESTRICCIONES //
					List<CRAN_VEC_ADV_IPL_Restriction__c> restListModif = new List<CRAN_VEC_ADV_IPL_Restriction__c>();

					if (myVListModif != null && myVListModif.getRestrList() != null) {

						for (CRAN_VEC_ADV_CalcRebalpRestrictionRS elementRestrictionModif : myVRestModif) {
							restListModif.add(new CRAN_VEC_ADV_IPL_Restriction__c(Name = 'rest: ' + elementRestrictionModif.getName(), CRAN_VEC_ADV_T_RestrictionId__c = elementRestrictionModif.getId(), CRAN_VEC_ADV_L_Version__c = myQuote.Id, RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_IPL_Restriction__c'), CRAN_VEC_ADV_L_Proposition__c = myOpp.Id, CRAN_VEC_ADV_T_RestrictionTypeName__c = elementRestrictionModif.getTypeName(), CRAN_VEC_ADV_T_TopRestriction__c = elementRestrictionModif.getTopRestr(), CRAN_VEC_ADV_T_EvalResult__c = elementRestrictionModif.getEvalResult(), CRAN_VEC_ADV_T_Remark__c = elementRestrictionModif.getRemark(), CRAN_VEC_ADV_T_ViolObject__c = elementRestrictionModif.getViolObj(), CRAN_VEC_ADV_T_ViolClass__c = elementRestrictionModif.getViolClass(), CRAN_VEC_ADV_T_ViolValue__c = elementRestrictionModif.getViolValue(), CRAN_VEC_ADV_T_ValueFrom__c = elementRestrictionModif.getValueFrom(), CRAN_VEC_ADV_T_ValueTo__c = elementRestrictionModif.getValueTo(), CRAN_VEC_ADV_T_Priority__c = elementRestrictionModif.getPrio(), CRAN_VEC_ADV_B_Override__c = elementRestrictionModif.getOverrideRestr(), CRAN_VEC_ADV_B_OverrideBK__c = elementRestrictionModif.getOverrideRestr(),CRAN_VEC_ADV_B_OverrideBKK__c = elementRestrictionModif.getOverrideRestr(), CRAN_VEC_ADV_T_Justification__c = elementRestrictionModif.getJustif()));
						}

						insert restListModif;
					}
					// FIN INSERCION DE RESTRICCIONES //
					System.debug('sale solucion ');
					//fin recorro estructura
					//actualizo quote con los nuevos datos
					System.debug('actualizo quote');

					//myQuote.CRAN_VEC_ADV_B_Final__c = Boolean.valueOf(myVListModif.getIsFinal());
					myQuote.Name = myVListModif.getName();
					myQuote.CRAN_VEC_ADV_N_InvAmount__c = myVListModif.getInvstAmount();
					myQuote.CRAN_VEC_ADV_N_InvAmountBKK__c = myVListModif.getInvstAmount();
					myQuote.CRAN_VEC_ADV_P_Currency__c = myVListModif.getInvstCurry();
					myQuote.CRAN_VEC_ADV_P_CurrencyBKK__c = myVListModif.getInvstCurry();

					System.debug('pasa 1');
					if (myVListModif.getOmsId() != null) {
						myQuote.CRAN_VEC_ADV_T_OMS_Id__c = myVListModif.getOmsId();
					}

					System.debug('pasa 2');
					//actualizo status a Synchronized
					myQuote.Status = 'Synchronized';
					System.debug('quote para actualizar ' + myQuote);


					update myQuote;

					return new SuccessResponse(myQuote);
				}
				return new ErrorResponse(System.Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate);

				//////////////////////////////////////

			} else if (myQuote.Status == 'Synchronized') {

				// SYNCHRONIZED
				System.debug('Entra en Synchronized');
				List <CRAN_VEC_ADV_Investment_Proposition_Line__c> listOfIPLToSend = new List <CRAN_VEC_ADV_Investment_Proposition_Line__c>();
				for (CRAN_VEC_ADV_Investment_Proposition_Line__c elemIpl : listOfIPL) {
					Boolean aux1 = elemIpl.CRAN_VEC_ADV_P_ChangedField__c.equals('CRAN_VEC_ADV_N_PropMktValue__c');//System.debug('aux1 '+aux1);
					Boolean aux2 = elemIpl.CRAN_VEC_ADV_P_ChangedField__c.equals('CRAN_VEC_ADV_N_PercentQtty__c');//System.debug('aux2 '+aux2);
					Boolean aux3 = elemIpl.CRAN_VEC_ADV_P_ChangedField__c.equals('CRAN_VEC_ADV_N_PropQtty__c');//System.debug('aux3 '+aux3);

					if (aux1 || aux2 || aux3 || (elemIpl.CRAN_VEC_ADV_T_Remark__c == null && elemIpl.CRAN_VEC_ADV_T_RemarkBK__c != null)
					        || (elemIpl.CRAN_VEC_ADV_T_Remark__c != null && elemIpl.CRAN_VEC_ADV_T_RemarkBK__c == null) ||
					        (elemIpl.CRAN_VEC_ADV_T_Remark__c != null && elemIpl.CRAN_VEC_ADV_T_RemarkBK__c != null && (!elemIpl.CRAN_VEC_ADV_T_Remark__c.equals(elemIpl.CRAN_VEC_ADV_T_RemarkBK__c))))
						listOfIPLToSend.add(elemIpl);
				}


				System.debug('listOfIPLToSend ' + 'tamaño ' + listOfIPLToSend.size() + listOfIPLToSend);

				// RESTRICTION //
				List<CRAN_VEC_ADV_IPL_Restriction__c> listRestriction = new List<CRAN_VEC_ADV_IPL_Restriction__c>();

				listRestriction = [SELECT Id,  CRAN_VEC_ADV_T_Justification__c, CRAN_VEC_ADV_B_Override__c, CRAN_VEC_ADV_B_OverrideBK__c, CRAN_VEC_ADV_T_RestrictionId__c, CRAN_VEC_ADV_L_Version__c FROM CRAN_VEC_ADV_IPL_Restriction__c
				                   WHERE CRAN_VEC_ADV_L_Version__c = :myQuote.Id ];

				System.debug('listRestriction ' + 'tamaño ' + listRestriction.size() + listRestriction);

				List<CRAN_VEC_ADV_IPL_Restriction__c> listRestrictionToSend = new List<CRAN_VEC_ADV_IPL_Restriction__c>();

				for (CRAN_VEC_ADV_IPL_Restriction__c elemRest : listRestriction) {
					if (elemRest.CRAN_VEC_ADV_B_Override__c != elemRest.CRAN_VEC_ADV_B_OverrideBK__c)
						listRestrictionToSend.add(elemRest);
				}

				System.debug('listRestrictionToSend ' + 'tamaño ' + listRestrictionToSend.size() + listRestrictionToSend);

				///////// LLAMADA AL SERVICIO CALCULAR/////////
				CRAN_VEC_ADV_CalcRebalpRQ rqCalc = new CRAN_VEC_ADV_CalcRebalpRQ();

				//entrada de parametros//
				rqCalc.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

				CRAN_VEC_ADV_Order_CLS myOrder = new CRAN_VEC_ADV_Order_CLS();
				myOrder.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
				rqCalc.setOrder(myOrder);

				rqCalc.setPrintMode(printMode);

				List<CRAN_VEC_ADV_CalcRebalpVersion> versionList = new List<CRAN_VEC_ADV_CalcRebalpVersion>();
				CRAN_VEC_ADV_CalcRebalpVersion version1 = new CRAN_VEC_ADV_CalcRebalpVersion();

				version1.setIsFinal(myQuote.CRAN_VEC_ADV_B_Final__c);
				version1.setId(String.valueOf(myQuote.CRAN_VEC_ADV_N_Version__c));
				version1.setName(myQuote.Name);

				Boolean comprInv = (myQuote.CRAN_VEC_ADV_N_InvAmount__c == null && myQuote.CRAN_VEC_ADV_N_InvAmountBK__c != null) ||
				                   (myQuote.CRAN_VEC_ADV_N_InvAmount__c != null && myQuote.CRAN_VEC_ADV_N_InvAmountBK__c == null) ||
				                   (myQuote.CRAN_VEC_ADV_N_InvAmount__c != null && myQuote.CRAN_VEC_ADV_N_InvAmountBK__c != null && (myQuote.CRAN_VEC_ADV_N_InvAmount__c != myQuote.CRAN_VEC_ADV_N_InvAmountBK__c));

				Boolean comprCur = (myQuote.CRAN_VEC_ADV_P_Currency__c == null && myQuote.CRAN_VEC_ADV_P_CurrencyBK__c != null) ||
				                   (myQuote.CRAN_VEC_ADV_P_Currency__c != null && myQuote.CRAN_VEC_ADV_P_CurrencyBK__c == null) ||
				                   (myQuote.CRAN_VEC_ADV_P_Currency__c != null && myQuote.CRAN_VEC_ADV_P_CurrencyBK__c != null && (!myQuote.CRAN_VEC_ADV_P_Currency__c.equals(myQuote.CRAN_VEC_ADV_P_CurrencyBK__c)));


				if (comprInv || comprCur) {
					version1.setInvstAmount(double.valueOf(myQuote.CRAN_VEC_ADV_N_InvAmount__c));
					version1.setInvstCurry(myQuote.CRAN_VEC_ADV_P_Currency__c);
				}

				System.debug('pasa 1');

				List<CRAN_VEC_ADV_CalcRebalpNodeList> nodeList = new List<CRAN_VEC_ADV_CalcRebalpNodeList>();
				CRAN_VEC_ADV_CalcRebalpNodeList nodeListTemp = new CRAN_VEC_ADV_CalcRebalpNodeList();
				List<CRAN_VEC_ADV_CalcRebalpNode> node = new List<CRAN_VEC_ADV_CalcRebalpNode>();

				System.debug('pasa 2');

				////////////////////////// relleno versions ///////////////////////////
				CRAN_VEC_ADV_CalcRebalpNode node1;

				for (CRAN_VEC_ADV_Investment_Proposition_Line__c tempIPL : listOfIPLToSend) {
					node1 = new CRAN_VEC_ADV_CalcRebalpNode();
					CRAN_VEC_ADV_CalcRebalpNodeId node1Sub = new CRAN_VEC_ADV_CalcRebalpNodeId();

					if (tempIPL.CRAN_VEC_ADV_P_ChangedField__c.equals('CRAN_VEC_ADV_N_PropMktValue__c') &&
					        tempIPL.CRAN_VEC_ADV_N_PropMktValue__c != tempIPL.CRAN_VEC_ADV_N_PropMktValueBK__c)
						node1.setCpfMktVal(String.valueOf(tempIPL.CRAN_VEC_ADV_N_PropMktValue__c));

					if (tempIPL.CRAN_VEC_ADV_P_ChangedField__c.equals('CRAN_VEC_ADV_N_PercentQtty__c') &&
					        tempIPL.CRAN_VEC_ADV_N_PercentQtty__c != tempIPL.CRAN_VEC_ADV_N_PercentQttyBK__c)
						node1.setCpfPerc(String.valueOf(tempIPL.CRAN_VEC_ADV_N_PercentQtty__c));

					if (tempIPL.CRAN_VEC_ADV_P_ChangedField__c.equals('CRAN_VEC_ADV_N_PropQtty__c') &&
					        tempIPL.CRAN_VEC_ADV_N_PropQtty__c != tempIPL.CRAN_VEC_ADV_N_PropQttyBK__c)
						node1.setCpfQty(String.valueOf(tempIPL.CRAN_VEC_ADV_N_PropQtty__c));


					if ((tempIPL.CRAN_VEC_ADV_T_Remark__c != null && tempIPL.CRAN_VEC_ADV_T_RemarkBK__c == null) ||
					        (tempIPL.CRAN_VEC_ADV_T_Remark__c != null && tempIPL.CRAN_VEC_ADV_T_RemarkBK__c != null && (!tempIPL.CRAN_VEC_ADV_T_Remark__c.equals(tempIPL.CRAN_VEC_ADV_T_RemarkBK__c))))
						node1.setRemark(tempIPL.CRAN_VEC_ADV_T_Remark__c);


					System.debug('KEY ' + tempIPL.CRAN_VEC_ADV_T_Key__c);
					if (tempIPL.CRAN_VEC_ADV_T_Key__c != null && tempIPL.CRAN_VEC_ADV_T_Key__c != '')
						node1.setAssetId(CRAN_VEC_ADV_Utils.getIdAvaloq(tempIPL.CRAN_VEC_ADV_T_Key__c));

					if (tempIPL.CRAN_VEC_ADV_P_nodeType__c != null && tempIPL.CRAN_VEC_ADV_P_nodeType__c != '')
						node1Sub.setNodeType(tempIPL.CRAN_VEC_ADV_P_nodeType__c);
					if (tempIPL.CRAN_VEC_ADV_T_NodeId__c != null && tempIPL.CRAN_VEC_ADV_T_NodeId__c != '')
						node1Sub.setValue(tempIPL.CRAN_VEC_ADV_T_NodeId__c);
					node1.setNodeId(node1Sub);
					node.add(node1);
				}
				System.debug('node ' + node);
				/////////////////////////////////////////////////////
				if (node != null && node.size() > 0) {
					System.debug('NODE' + node);
					nodeListTemp.setNode(node);
					nodeList.add(nodeListTemp);
				}
				////////////////////////// relleno restricciones ///////////////////////////
				List<CRAN_VEC_ADV_CalcRebalpRestriction> restrList = new List<CRAN_VEC_ADV_CalcRebalpRestriction>();
				CRAN_VEC_ADV_CalcRebalpRestriction restr1;
				System.debug('pasa 3');

				for (CRAN_VEC_ADV_IPL_Restriction__c tempRest : listRestrictionToSend) {
					restr1 = new CRAN_VEC_ADV_CalcRebalpRestriction();

					if (tempRest.CRAN_VEC_ADV_B_Override__c != tempRest.CRAN_VEC_ADV_B_OverrideBK__c){
						restr1.setOverride(tempRest.CRAN_VEC_ADV_B_Override__c);
						restr1.setJustif(tempRest.CRAN_VEC_ADV_T_Justification__c);
					}

					restrList.add(restr1);
				}
				System.debug('pasa 4');

				/////////////////////////////////////////////////////

				if (restrList.size() > 0 && myQuote.status != 'Modified')
					version1.setRestrList(restrList);

				System.debug('AAAAAAAAAA***** ' + nodeList);
				if (nodeList != null && nodeList.size() > 0) {
					System.debug('entra por aqui' + nodeList.size());
					version1.setNodeList(nodeList);
				}
				//version.add(version1);
				versionList.add(version1);
				rqCalc.setVersionList(versionList);
				//fin entrada de parametros//
				String jsonRequestCalc = JSON.serialize(rqCalc);

				System.debug('rqCalc' + rqCalc);
				System.debug('jsonRequestCalc' + jsonRequestCalc);

				//peticion post
				CRAN_VEC_ADV_RestClient_CLS restClientCalc = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR_OPORTUNIDAD, bu, jsonRequestCalc);

				System.debug('restClientCalc ' + restClientCalc);

				CRAN_VEC_ADV_CalcRebalpRS resultsCalc = (CRAN_VEC_ADV_CalcRebalpRS)JSON.deserialize(restClientCalc.responseBody, CRAN_VEC_ADV_CalcRebalpRS.class);

				System.debug('resultsCalc ' + resultsCalc);
				///////// FIN LLAMADA AL SERVICIO CALCULAR/////////

				if (resultsCalc == null) {
					System.debug('error 1');
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate);
				} else if (resultsCalc != null && resultsCalc.getErrors() != null) {
					System.debug('error 2');
					return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsCalc.getErrors()));
				} else if (resultsCalc != null && (resultsCalc.getVersionList() == null || resultsCalc.getOrder() == null)) {
					System.debug('error 3');
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate);
				} else if (resultsCalc != null && resultsCalc.getErrors() == null && resultsCalc.getVersionList() != null && resultsCalc.getOrder() != null) {
					System.debug('error 4');

					CRAN_VEC_ADV_CalcRebalpVersionRS myVListSyn = resultsCalc.getVersionList()[0];
					List<CRAN_VEC_ADV_CalcRebalpRestrictionRS> myVRestSyn = resultsCalc.getVersionList()[0].getRestrList();

					//recorro estructura como new proposition

					//inserto nivel 0
					elemenLevel0 = new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = myVListSyn.getNode().getNodeDet().getName(), CRAN_VEC_ADV_N_PropAccrual__c = myVListSyn.getNode().getNodeDet().getCpfAccr() , CRAN_VEC_ADV_N_MPF__c = 7.5, CRAN_VEC_ADV_N_PercentQtty__c = myVListSyn.getNode().getNodeDet().getCpfPerc(), CRAN_VEC_ADV_N_PropMktValue__c = myVListSyn.getNode().getNodeDet().getCpfMktVal(), CRAN_VEC_ADV_P_nodeType__c = 'node', CRAN_VEC_ADV_T_Remark__c = '', CRAN_VEC_ADV_N_PropMktValueBK__c = 837080.27, CRAN_VEC_ADV_N_PercentQttyBK__c = myVListSyn.getNode().getNodeDet().getCpfPerc(), CRAN_VEC_ADV_T_RemarkBK__c = '', CRAN_VEC_ADV_P_ChangedField__c = 'Null', CRAN_VEC_ADV_N_Level__c = 0, CRAN_VEC_ADV_N_Secuence__c = 1);

					CRAN_VEC_ADV_CalcRebalpNodeRS nodeSyn = myVListSyn.getNode();
					myMapReturn = recorreArbol(nodeSyn.getNodeList(), 1, myMap);
					System.debug('myMapReturn ' + myMapReturn);

					for (CRAN_VEC_ADV_Investment_Proposition_Line__c temp222 : myMap) {
						System.debug(temp222.Name);
					}

					List<CRAN_VEC_ADV_Investment_Proposition_Line__c> finalListLinesSyn = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();

					integer mySecSyn = 1;
					//relleno campos que faltan en las lineas antes de insertar
					if (elemenLevel0 != null) {
						elemenLevel0.CRAN_VEC_ADV_L_Version__c = myQuote.Id;
						elemenLevel0.CRAN_VEC_ADV_L_Proposition__c = myOpp.Id;
						elemenLevel0.RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c');
						elemenLevel0.CRAN_VEC_ADV_N_Secuence__c = mySecSyn;
						finalListLinesSyn.add(elemenLevel0);
					}

					for (CRAN_VEC_ADV_Investment_Proposition_Line__c myLineSyn : myMapReturn) {
						mySecSyn = mySecSyn + 1;
						myLineSyn.CRAN_VEC_ADV_L_Version__c = myQuote.Id;
						myLineSyn.CRAN_VEC_ADV_L_Proposition__c = myOpp.Id;
						myLineSyn.RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c');
						myLineSyn.CRAN_VEC_ADV_N_Secuence__c = mySecSyn;
						if (myLineSyn.CRAN_VEC_ADV_P_nodeType__c != null && myLineSyn.CRAN_VEC_ADV_P_nodeType__c == 'pos') {
							if (myLineSyn.CRAN_VEC_ADV_T_Key__c != null && myLineSyn.CRAN_VEC_ADV_T_Key__c != '')
								myLineSyn.CRAN_VEC_ADV_T_Key__c = myQuote.Id + myLineSyn.CRAN_VEC_ADV_T_Key__c;
							if (nameCurrency != null && nameCurrency != '')
								myLineSyn.CRAN_VEC_ADV_P_Currency__c = nameCurrency;
						}
						//CRAN_VEC_ADV_N_MPF__c
						finalListLinesSyn.add(myLineSyn);
					}

					System.debug('lista para insertar' + finalListLinesSyn + ' de tamaño ' + finalListLinesSyn.size());


					for (CRAN_VEC_ADV_Investment_Proposition_Line__c myLine2Syn : finalListLinesSyn) {
						System.debug(myLine2Syn.Name + ' ' + myLine2Syn.CRAN_VEC_ADV_N_Secuence__c + ' ' + myLine2Syn.CRAN_VEC_ADV_N_Level__c + ' type' + myLine2Syn.CRAN_VEC_ADV_P_nodeType__c);
					}

					CRAN_VEC_KER_TriggerHandler_CLS.bypass('CRAN_VEC_ADV_IPLTriggerHandler_CLS');


					// IPL //
					List <CRAN_VEC_ADV_Investment_Proposition_Line__c> listOfIPLTemp = [
					            SELECT Id, CRAN_VEC_ADV_N_PropMktValue__c, CRAN_VEC_ADV_N_PropMktValueBK__c, CRAN_VEC_ADV_N_PercentQtty__c, CRAN_VEC_ADV_N_PercentQttyBK__c,
					            CRAN_VEC_ADV_N_PropQtty__c, CRAN_VEC_ADV_N_PropQttyBK__c, CRAN_VEC_ADV_N_MPF__c, CRAN_VEC_ADV_P_ChangedField__c, CRAN_VEC_ADV_FieldChangedbyUser__c,
					            CRAN_VEC_ADV_T_Remark__c, CRAN_VEC_ADV_T_RemarkBK__c, CRAN_VEC_ADV_T_Key__c, CRAN_VEC_ADV_P_nodeType__c, CRAN_VEC_ADV_T_NodeId__c
					            FROM CRAN_VEC_ADV_Investment_Proposition_Line__c
					            WHERE CRAN_VEC_ADV_L_Version__c = :recordId2 order by CRAN_VEC_ADV_N_Secuence__c asc];

					//lista final de IPLS  actualizar
					List<CRAN_VEC_ADV_Investment_Proposition_Line__c> listToUpdate = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
					List<CRAN_VEC_ADV_Investment_Proposition_Line__c> listToUpdateControl = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();

					System.debug('genero un map con valores NodeId->Ipl');
					//genero un map con valores NodeId->Ipl
					for (CRAN_VEC_ADV_Investment_Proposition_Line__c elemenIplTemp : listOfIPLTemp) {
						System.debug('**' + elemenIplTemp);
						if (elemenIplTemp.CRAN_VEC_ADV_P_nodeType__c == 'pos') {
							System.debug('**pos**');
							if (elemenIplTemp.CRAN_VEC_ADV_T_Key__c != null && elemenIplTemp.CRAN_VEC_ADV_T_Key__c != '') {
								System.debug('tiene key');
								myMapPos.put(elemenIplTemp.CRAN_VEC_ADV_T_Key__c, elemenIplTemp);
							}
						} else if (elemenIplTemp.CRAN_VEC_ADV_P_nodeType__c == 'node') {
							System.debug('**node**');
							System.debug('value ' + elemenIplTemp.CRAN_VEC_ADV_T_NodeId__c);
							if (elemenIplTemp.CRAN_VEC_ADV_T_NodeId__c != null && elemenIplTemp.CRAN_VEC_ADV_T_NodeId__c != '') {
								System.debug('tiene key');
								myMapPos.put(elemenIplTemp.CRAN_VEC_ADV_T_NodeId__c, elemenIplTemp);
							}
						}
					}

					System.debug('esta 1');
					System.debug('myMapPos' + myMapPos + 'tamaño ' + myMapPos.size());


					for (CRAN_VEC_ADV_Investment_Proposition_Line__c newLine : finalListLinesSyn) {
						System.debug('esta 2');
						System.debug('///////newLine////// '+newLine.Name);
						System.debug('///////newLine////// '+newLine.CRAN_VEC_ADV_N_Level__c);
						System.debug('///////newLine////// '+newLine.CRAN_VEC_ADV_N_Secuence__c);

						if (newLine.CRAN_VEC_ADV_P_nodeType__c == 'pos') {
							CRAN_VEC_ADV_Investment_Proposition_Line__c aux = myMapPos.get(newLine.CRAN_VEC_ADV_T_Key__c);
							System.debug('aux '+aux);
							if (aux != null) {
								listToUpdateControl.add(aux);
								//actualizo campos
								aux.Name = newLine.Name;
								aux.CRAN_VEC_ADV_T_Remark__c = newLine.CRAN_VEC_ADV_T_Remark__c;
								aux.CRAN_VEC_ADV_T_RemarkBKK__c = newLine.CRAN_VEC_ADV_T_Remark__c;
								aux.CRAN_VEC_ADV_N_PropMktValue__c = newLine.CRAN_VEC_ADV_N_PropMktValue__c;
								aux.CRAN_VEC_ADV_N_PropMktValueBKK__c = newLine.CRAN_VEC_ADV_N_PropMktValue__c;
								aux.CRAN_VEC_ADV_N_PercentQtty__c = newLine.CRAN_VEC_ADV_N_PercentQtty__c;
								aux.CRAN_VEC_ADV_N_PercentQttyBKK__c = newLine.CRAN_VEC_ADV_N_PercentQtty__c;
								aux.CRAN_VEC_ADV_N_PropQtty__c = newLine.CRAN_VEC_ADV_N_PropQtty__c;
								aux.CRAN_VEC_ADV_N_PropQttyBKK__c = newLine.CRAN_VEC_ADV_N_PropQtty__c;
								aux.CRAN_VEC_ADV_N_Price__c = newLine.CRAN_VEC_ADV_N_Price__c;								
								aux.CRAN_VEC_ADV_N_MPF__c = newLine.CRAN_VEC_ADV_N_MPF__c;
								aux.CRAN_VEC_ADV_B_Extl__c = newLine.CRAN_VEC_ADV_B_Extl__c;
								aux.CRAN_VEC_ADV_B_AggrPosition__c = newLine.CRAN_VEC_ADV_B_AggrPosition__c;
								aux.CRAN_VEC_ADV_N_PropAccrual__c = newLine.CRAN_VEC_ADV_N_PropAccrual__c;
								aux.CRAN_VEC_ADV_N_Level__c = newLine.CRAN_VEC_ADV_N_Level__c;
								aux.CRAN_VEC_ADV_N_Secuence__c = newLine.CRAN_VEC_ADV_N_Secuence__c;



								//rellenar resto de campos
								listToUpdate.add(aux);
							} else {
								//no existe esta posicion y la creo
								//listToUpdateControl.add(aux);
								listToUpdate.add(newLine);
							}

						} else if (newLine.CRAN_VEC_ADV_P_nodeType__c == 'node') {
							CRAN_VEC_ADV_Investment_Proposition_Line__c aux1 = myMapPos.get(newLine.CRAN_VEC_ADV_T_NodeId__c);
							if (aux1 != null) {
								listToUpdateControl.add(aux1);
								//actualizo campos
								aux1.Name = newLine.Name;
								aux1.CRAN_VEC_ADV_T_RestrInfo__c = newLine.CRAN_VEC_ADV_T_RestrInfo__c;
								aux1.CRAN_VEC_ADV_T_RestrIcon__c = newLine.CRAN_VEC_ADV_T_RestrIcon__c;
								aux1.CRAN_VEC_ADV_N_PropAccrual__c = newLine.CRAN_VEC_ADV_N_PropAccrual__c;
								aux1.CRAN_VEC_ADV_N_PercentQtty__c = newLine.CRAN_VEC_ADV_N_PercentQtty__c;
								aux1.CRAN_VEC_ADV_N_PropMktValue__c = newLine.CRAN_VEC_ADV_N_PropMktValue__c;
								aux1.CRAN_VEC_ADV_N_MPF__c = newLine.CRAN_VEC_ADV_N_MPF__c;
								aux1.CRAN_VEC_ADV_N_Level__c = newLine.CRAN_VEC_ADV_N_Level__c;
								aux1.CRAN_VEC_ADV_N_Secuence__c = newLine.CRAN_VEC_ADV_N_Secuence__c;

								//rellenar resto de campos
								listToUpdate.add(aux1);
							} else {
								//debe existir

							}
						}

					}

					System.debug('esta 3');
					System.debug(listToUpdate);
					System.debug(listToUpdateControl);


					for (CRAN_VEC_ADV_Investment_Proposition_Line__c auxxx2 : listToUpdateControl) {
						auxxx2.CRAN_VEC_ADV_B_IsService__c = true;
					}

					System.debug('a');
					update listToUpdateControl;
					System.debug('b');

					upsert listToUpdate;
					System.debug('c');

					for (CRAN_VEC_ADV_Investment_Proposition_Line__c auxxx : listToUpdateControl) {
						auxxx.CRAN_VEC_ADV_B_IsService__c = false;
					}
					System.debug('d');
					update listToUpdateControl;


					System.debug('esta 4');


					//Boolean haveChangesInRest = haveRestrictionsDifferentsVal(recordId2);
					//System.debug('haveRestrictionsDifferentsVal ' + haveChangesInRest);
					
						//elimino restricciones antiguas
						List<CRAN_VEC_ADV_IPL_Restriction__c> myRestrictionToDelete = [SELECT Id  FROM CRAN_VEC_ADV_IPL_Restriction__c WHERE CRAN_VEC_ADV_L_Version__c = :recordId2 ];
						delete myRestrictionToDelete;
						System.debug('restricciones borradas');
						//inserto las nuevas

						List<CRAN_VEC_ADV_IPL_Restriction__c> restList = new List<CRAN_VEC_ADV_IPL_Restriction__c>();

						if (myVRestSyn != null) {
							for (CRAN_VEC_ADV_CalcRebalpRestrictionRS elementRestriction : myVRestSyn) {
								restList.add(new CRAN_VEC_ADV_IPL_Restriction__c(Name = 'rest: ' + elementRestriction.getName(), CRAN_VEC_ADV_T_RestrictionId__c = elementRestriction.getId(), CRAN_VEC_ADV_L_Version__c = myQuote.Id, RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_IPL_Restriction__c'), CRAN_VEC_ADV_L_Proposition__c = myOpp.Id, CRAN_VEC_ADV_T_RestrictionTypeName__c = elementRestriction.getTypeName(), CRAN_VEC_ADV_T_TopRestriction__c = elementRestriction.getTopRestr(), CRAN_VEC_ADV_T_EvalResult__c = elementRestriction.getEvalResult(), CRAN_VEC_ADV_T_Remark__c = elementRestriction.getRemark(), CRAN_VEC_ADV_T_ViolObject__c = elementRestriction.getViolObj(), CRAN_VEC_ADV_T_ViolClass__c = elementRestriction.getViolClass(), CRAN_VEC_ADV_T_ViolValue__c = elementRestriction.getViolValue(), CRAN_VEC_ADV_T_ValueFrom__c = elementRestriction.getValueFrom(), CRAN_VEC_ADV_T_ValueTo__c = elementRestriction.getValueTo(), CRAN_VEC_ADV_T_Priority__c = elementRestriction.getPrio(), CRAN_VEC_ADV_B_Override__c = elementRestriction.getOverrideRestr(), CRAN_VEC_ADV_B_OverrideBK__c = elementRestriction.getOverrideRestr(),CRAN_VEC_ADV_B_OverrideBKK__c = elementRestriction.getOverrideRestr(), CRAN_VEC_ADV_T_Justification__c = elementRestriction.getJustif()));
							}

							insert restList;
						}
					
					//actualizo quote
					//myQuote.CRAN_VEC_ADV_B_Final__c = Boolean.valueOf(myVListSyn.getIsFinal());
					myQuote.Name = myVListSyn.getName();
					myQuote.CRAN_VEC_ADV_N_InvAmount__c = myVListSyn.getInvstAmount();
					myQuote.CRAN_VEC_ADV_N_InvAmountBKK__c = myVListSyn.getInvstAmount();
					myQuote.CRAN_VEC_ADV_P_Currency__c = myVListSyn.getInvstCurry();
					myQuote.CRAN_VEC_ADV_P_CurrencyBKK__c = myVListSyn.getInvstCurry();

					if (myVListSyn.getOmsId() != null) {
						myQuote.CRAN_VEC_ADV_T_OMS_Id__c = myVListSyn.getOmsId();
					}

					//actualizo status a Synchronized
					myQuote.Status = 'Synchronized';
					System.debug('quote para actualizar ' + myQuote);
					update myQuote;

					return new SuccessResponse(myQuote);

				}
				// SYNCHRONIZED
			}
			
		} catch (Exception e) {
			return new ErrorResponse(e.getMessage());
		}
		*/
		return new ErrorResponse(System.Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate);
	}

	/*@AuraEnabled
	public static Boolean haveRestrictionsDifferentsVal(String idMyquote) {
		Boolean result = false;
		List<CRAN_VEC_ADV_IPL_Restriction__c> temp = [SELECT Id, Name, CRAN_VEC_ADV_B_OverrideBK__c, CRAN_VEC_ADV_L_Version__c, CRAN_VEC_ADV_B_Override__c, CRAN_VEC_ADV_T_JustificationBK__c, CRAN_VEC_ADV_T_Justification__c FROM CRAN_VEC_ADV_IPL_Restriction__c WHERE CRAN_VEC_ADV_L_Version__c = :idMyquote ];

		for (CRAN_VEC_ADV_IPL_Restriction__c elemRest : temp) {
			if ((elemRest.CRAN_VEC_ADV_T_Justification__c == null && elemRest.CRAN_VEC_ADV_T_JustificationBK__c != null) ||
			        (elemRest.CRAN_VEC_ADV_T_Justification__c != null && elemRest.CRAN_VEC_ADV_T_JustificationBK__c == null) ||
			        (elemRest.CRAN_VEC_ADV_T_Justification__c != null && elemRest.CRAN_VEC_ADV_T_JustificationBK__c != null && (!elemRest.CRAN_VEC_ADV_T_Justification__c.equals(elemRest.CRAN_VEC_ADV_T_JustificationBK__c))) ||
			        elemRest.CRAN_VEC_ADV_B_Override__c != elemRest.CRAN_VEC_ADV_B_OverrideBK__c)
				result = true;
		}

		return result;

	}*/

	/**
    * 
    *
    * @param 
    * 
    * @return
    */
	@AuraEnabled
	public static Object haveRestrictionsDifValDoInit(String recordId2, String printMode) {
		Boolean result = false;
		/*
		List<CRAN_VEC_ADV_IPL_Restriction__c> temp = [SELECT Id, Name, CRAN_VEC_ADV_B_OverrideBK__c, CRAN_VEC_ADV_L_Version__c, CRAN_VEC_ADV_B_Override__c, CRAN_VEC_ADV_T_Justification__c FROM CRAN_VEC_ADV_IPL_Restriction__c WHERE CRAN_VEC_ADV_L_Version__c = :recordId2 ];

		for (CRAN_VEC_ADV_IPL_Restriction__c elemRest : temp) {
			if (elemRest.CRAN_VEC_ADV_B_Override__c != elemRest.CRAN_VEC_ADV_B_OverrideBK__c)
				result = true;
		}

		System.debug('result ' + result);

		if (result) {
			return new ErrorResponse(Label.CRAN_VEC_ADV_WarningRest, true);
		} else {
			return CRAN_VEC_ADV_Investment_Proposal_AUC.calcProp(recordId2, printMode);
		}
		//return JSON.serialize(new ErrorResponse(e.getMessage()))
		*/
		return result;
	}



	/**
    * 
    *
    * @param 
    * 
    * @return 
    */
	/*@AuraEnabled
	public static Object printPreviewOpp(Opportunity myOpp) {
		Quote myQuote = bringFinalQuote(myOpp.Id);
		if ( myQuote != null && myOpp.StageName == 'advOpen' ) {
			myQuote.CRAN_VEC_ADV_T_Internal_Status__c = 'Printed';
			update myQuote;
			return new SuccessResponse(myOpp);
		} else {
			return new ErrorResponse(System.Label.CRAN_VEC_ADV_IP_MSG_ERR_B_PrintPrev);
		}
	}*/
	/**
    * 
    *
    * @param 
    * 
    * @return 
    */
	private static Quote bringFinalQuote (String oppId) {
		return [SELECT Id FROM Quote WHERE OpportunityId = :oppId AND CRAN_VEC_ADV_B_Final__c = True LIMIT 1];
	}
	
	/*@AuraEnabled
	public static Object acceptOpp(String recordId) {

	try{
			System.debug('before '+System.Now());
			System.debug('acceptOpp');
			Opportunity myOpp = [SELECT Id, StageName,CRAN_VEC_ADV_T_AvaloqPropId__c,CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id =:recordId ];
			System.debug('myOpp '+ myOpp);
			Quote myQuote = bringFinalQuote(recordId);
			System.debug('myQuote '+ myQuote);

			Boolean signBoolean = false;
			Boolean detBoolean = false;
			Boolean closeDoneBoolean = false;
			Boolean closeDiscardBoolean = false;
			String solStatus = '';
			Opportunity myOpportunityTemp;


					try{

						System.debug('pasa 1');
						if ( myQuote != null && myOpp.StageName == 'advToSign' ) {
							System.debug('pasa 2');

								///////// LLAMADA AL SERVICIO SIGN /////////
								CRAN_VEC_ADV_RebalpRQ rq = new CRAN_VEC_ADV_RebalpRQ();

								//entrada de parametros//
								rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

								CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
								order.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
								rq.setOrder(order);
								//fin entrada de parametros//
								String jsonRequest = JSON.serialize(rq);

								String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;

								System.debug('jsonRequest' + rq);

								CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_FIRMA_OPORTUNIDAD,jsonRequest,bu,CRAN_VEC_ADV_Constants_CLS.GET);

			            		System.debug('restClient '+restClient);

			            		CRAN_VEC_ADV_RebalpRS results = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpRS.class);

			            		System.debug('results '+results);

								///////// FIN LLAMADA AL SERVICIO SIGN /////////

								if(results ==null){
										return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept));
			            		}else if(results !=null && results.getErrors() != null){
			                			return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors())));

			            		}else if(results!=null && results.getOrder()==null){
			                			return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept));
			            		} else if(results!=null && results.getErrors()==null && results.getOrder()!=null && results.getStatus().equals('rdy_trx_gen')){

			            					//confirmo que la propuesta se acepta
			            					signBoolean = true;
			            					///////// LLAMADA AL SERVICIO DET /////////
											CRAN_VEC_ADV_RebalpRQ rqDet = new CRAN_VEC_ADV_RebalpRQ();

											//entrada de parametros//
											rqDet.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

											CRAN_VEC_ADV_Order_CLS orderDet = new CRAN_VEC_ADV_Order_CLS();
											orderDet.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
											orderDet.setIsNew(false);
											rqDet.setOrder(orderDet);
											//fin entrada de parametros//
											String jsonRequestDet = JSON.serialize(rqDet);
											System.debug('jsonRequest' + rqDet);

											System.debug('before ** '+System.Now());
											Integer start = System.Now().millisecond();
											while(System.Now().millisecond()< start+999){ }
											System.debug('after **'+System.Now());

											CRAN_VEC_ADV_RestClient_CLS restClientDet = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_DET_OPORTUNIDAD,jsonRequestDet,bu,CRAN_VEC_ADV_Constants_CLS.GET);

							           		System.debug('restClientDet '+restClientDet);
							            	CRAN_VEC_ADV_RebalpRS resultsDet = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClientDet.responseBody, CRAN_VEC_ADV_RebalpRS.class);
							            	System.debug('resultsDet '+resultsDet);
											///////// FIN LLAMADA AL SERVICIO DET/////////
											if(resultsDet ==null){
													myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
													update myOpportunityTemp;
													return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Det));
							            	}else if(resultsDet !=null && resultsDet.getErrors() != null){
														myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
														update myOpportunityTemp;
							                			return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsDet.getErrors())));
							            	}else if(resultsDet!=null && resultsDet.getOrder()==null){
														myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
														update myOpportunityTemp;
							               				return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Det));
							           		//} else if(resultsDet!=null && resultsDet.getErrors()==null && resultsDet.getOrder()!=null && resultsDet.getStatus().equals('rdy_trx_gen')){
							           		} else if(resultsDet!=null && resultsDet.getErrors()==null && resultsDet.getOrder()!=null && resultsDet.getStatus().equals('trx_gend')){

												           		//confirmo que la propuesta se acepta
								            					detBoolean = true;
								            					///////// LLAMADA AL SERVICIO CLOSE /////////
																CRAN_VEC_ADV_RebalpRQ rqClose = new CRAN_VEC_ADV_RebalpRQ();

																//entrada de parametros//
																rqClose.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

																CRAN_VEC_ADV_Order_CLS orderClose = new CRAN_VEC_ADV_Order_CLS();
																orderClose.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
																orderClose.setIsNew(false);
																rqClose.setOrder(orderClose);
																//fin entrada de parametros//
																String jsonRequestClose = JSON.serialize(rqClose);
																System.debug('jsonRequest' + rqClose);
																CRAN_VEC_ADV_RestClient_CLS restClientClose = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CLOSE_OPORTUNIDAD,jsonRequestClose,bu,CRAN_VEC_ADV_Constants_CLS.GET);

												           		System.debug('restClientClose '+restClientClose);
												            	CRAN_VEC_ADV_RebalpRS resultsClose = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClientClose.responseBody, CRAN_VEC_ADV_RebalpRS.class);
												            	System.debug('resultsClose '+resultsClose);
												            	System.debug('after  '+System.Now());
																///////// FIN LLAMADA AL SERVICIO CLOSE/////////
																if(resultsClose ==null){
																			myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
																			update myOpportunityTemp;
																			return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close));
												            	}else if(resultsClose !=null && resultsClose.getErrors() != null){
																			myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
																			update myOpportunityTemp;
												                			return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsClose.getErrors())));
												            	}else if(resultsClose!=null && resultsClose.getOrder()==null){
																			myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
																			update myOpportunityTemp;
												               				return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close));
												           		} else if(resultsClose!=null && resultsClose.getErrors()==null && resultsClose.getOrder()!=null && ( resultsClose.getStatus().equals('done')|| resultsClose.getStatus().equals('discd'))){
												           					if(resultsClose.getStatus().equals('done'))
																					closeDoneBoolean = true;
																			else if(resultsClose.getStatus().equals('discd'))
																					closeDiscardBoolean = true;
												           		} else {
																		myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
																		update myOpportunityTemp;
																		return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close));
												           		}

											} else{
													myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
													update myOpportunityTemp;
			            							return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close));
			            					}

								} else {
										myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
										update myOpportunityTemp;
										return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept));
								}


								myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
								update myOpportunityTemp;

								return JSON.serialize(new SuccessResponse(myOpp));

								//return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept));
						} else {
								myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
								update myOpportunityTemp;
								return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept));
						}

					}catch(DMLException dmlE){
						//actualizo ultimo estado antes de salir para estar Sf al mismo nivel que los servicios
						myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
						update myOpportunityTemp;

			            return JSON.serialize(new ErrorResponse(dmlE.getMessage()));
			        }
			        catch(Exception e){
			        	//actualizo ultimo estado antes de salir para estar Sf al mismo nivel que los servicios
						myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
						update myOpportunityTemp;

			            return JSON.serialize(new ErrorResponse(e.getMessage()));
			        }


	    }catch(Exception e){
	        return JSON.serialize(new ErrorResponse(e.getMessage()));
	    }

		/* ANTES DE SERVICIOS
		Opportunity myOpp = [SELECT Id, StageName FROM Opportunity WHERE Id =:recordId ];
		Quote myQuote = bringFinalQuote(recordId);
		if ( myQuote != null && myOpp.StageName == 'advToSign' ) {
			myOpp.StageName = 'advAccepted';
			update myOpp;
			return new SuccessResponse(myOpp);
		} else {
			return new ErrorResponse(System.Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept);
		}*/
	/*}*/

	/**
    * 
    *
    * @param 
    * 
    * @return 
    */
	@AuraEnabled
	public static Object acceptOppOnlyServiceSign(String recordId2) {
		/*try {
			System.debug('acceptOpp');
			Opportunity myOpp = [SELECT Id, StageName, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :recordId2 ];
			System.debug('myOpp ' + myOpp);
			Quote myQuote = bringFinalQuote(recordId2);
			System.debug('myQuote ' + myQuote);

			Boolean signBoolean = false;
			Boolean detBoolean = false;
			Boolean closeDoneBoolean = false;
			Boolean closeDiscardBoolean = false;
			String solStatus = '';
			Opportunity myOpportunityTemp;

			if ( myQuote != null && myOpp.StageName == 'advToSign' ) {
				System.debug('pasa 2');

				///////// LLAMADA AL SERVICIO SIGN /////////
				CRAN_VEC_ADV_RebalpRQ rq = new CRAN_VEC_ADV_RebalpRQ();

				//entrada de parametros//
				rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));
				CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
				order.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
				rq.setOrder(order);
				//fin entrada de parametros//
				String jsonRequest = JSON.serialize(rq);
				String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;
				System.debug('jsonRequest' + rq);
				CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_FIRMA_OPORTUNIDAD,bu,jsonRequest);
				System.debug('restClient ' + restClient);
				CRAN_VEC_ADV_RebalpRS results = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpRS.class);
				System.debug('results ' + results);
				///////// FIN LLAMADA AL SERVICIO SIGN /////////

				if (results == null) {
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept);
				} else if (results != null && results.getErrors() != null) {
					return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors()));
				} else if (results != null && results.getOrder() == null) {
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept);
				} else if (results != null && results.getErrors() == null && results.getOrder() != null) {
					myOpp.StageName = 'advAccepted';
					myOpp.CRAN_VEC_ADV_B_IsService__c = true;
					update myOpp;

					myOpp.CRAN_VEC_ADV_B_IsService__c = false;
					update myOpp;
					System.debug('actualizo opportunity a ADVACCEPTED');
					return new SuccessResponse(myOpp);
				}
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept);
			} else {
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept);
			}

		} catch (Exception e) {
			return new ErrorResponse(e);
		}*/
		return null;
	}

	// REVIASR PORQUE SE DEBERIA BORRAR, se deja para utilizar la llamada al servicio de detalle.
	/*
	@AuraEnabled
	public static Object closeAcceptOrRegen(String recordId2) {

		try {
			System.debug('closeAcceptOrRegen');
			Opportunity myOpp = [SELECT Id, StageName, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :recordId2 ];
			System.debug('myOpp ' + myOpp);
			Quote myQuote = bringFinalQuote(recordId2);
			System.debug('myQuote ' + myQuote);

			String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;

			System.debug('pasa 1');
			if ( myQuote != null && (myOpp.StageName == 'advSimulated')) {
				System.debug('pasa 2');
				
				///////// LLAMADA AL SERVICIO DET /////////
				CRAN_VEC_ADV_RebalpRQ rqDet = new CRAN_VEC_ADV_RebalpRQ();

				//entrada de parametros//
				rqDet.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

				CRAN_VEC_ADV_Order_CLS orderDet = new CRAN_VEC_ADV_Order_CLS();
				orderDet.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
				orderDet.setIsNew(false);
				rqDet.setOrder(orderDet);
				//fin entrada de parametros//
				String jsonRequestDet = JSON.serialize(rqDet);
				System.debug('jsonRequest' + rqDet);

				CRAN_VEC_ADV_RestClient_CLS restClientDet = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_DET_OPORTUNIDAD,bu,jsonRequestDet);

				System.debug('restClientDet ' + restClientDet);
				CRAN_VEC_ADV_RebalpRS resultsDet = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClientDet.responseBody, CRAN_VEC_ADV_RebalpRS.class);
				System.debug('resultsDet ' + resultsDet);
				///////// FIN LLAMADA AL SERVICIO DET/////////
				
				if (resultsDet == null) {
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Det);
				} else if (resultsDet != null && resultsDet.getErrors() != null) {
					return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsDet.getErrors()));
				} else if (resultsDet != null && resultsDet.getOrder() == null) {
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Det);
				} else if (resultsDet != null && resultsDet.getErrors() == null && resultsDet.getOrder() != null && resultsDet.getStatus().equals('trx_gend')) {

					///////// LLAMADA AL SERVICIO CLOSE /////////
					CRAN_VEC_ADV_RebalpRQ rqClose = new CRAN_VEC_ADV_RebalpRQ();

					//entrada de parametros//
					rqClose.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

					CRAN_VEC_ADV_Order_CLS orderClose = new CRAN_VEC_ADV_Order_CLS();
					orderClose.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
					orderClose.setIsNew(false);
					rqClose.setOrder(orderClose);
					//fin entrada de parametros//
					String jsonRequestClose = JSON.serialize(rqClose);
					System.debug('jsonRequest' + rqClose);
					CRAN_VEC_ADV_RestClient_CLS restClientClose = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CLOSE_OPORTUNIDAD,bu,jsonRequestClose);

					System.debug('restClientClose ' + restClientClose);
					CRAN_VEC_ADV_RebalpRS resultsClose = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClientClose.responseBody, CRAN_VEC_ADV_RebalpRS.class);
					System.debug('resultsClose ' + resultsClose);
					System.debug('after  ' + System.Now());
					///////// FIN LLAMADA AL SERVICIO CLOSE/////////

					if (resultsClose == null) {
						return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
					} else if (resultsClose != null && resultsClose.getErrors() != null) {
						return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsClose.getErrors()));
					} else if (resultsClose != null && resultsClose.getOrder() == null) {
						return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
					} else if (resultsClose != null && resultsClose.getErrors() == null && resultsClose.getOrder() != null && ( resultsClose.getStatus().equals('done'))) {
						if (resultsClose.getStatus().equals('done')) {
							myOpp.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE;
							myOpp.CRAN_VEC_ADV_B_IsService__c = true;
							update myOpp;
							myOpp.CRAN_VEC_ADV_B_IsService__c = false;
							update myOpp;
							System.debug('actualiza done');
							return new SuccessResponse(myOpp);
						} else
							return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
					} else
						return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
				} else
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Det);
			} else
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
		} catch (Exception e) {
			return new ErrorResponse(e.getMessage());
		}
	}
	*/

	/*private static Opportunity actualizaEstado (Opportunity myOpp, Boolean signBoolean, Boolean detBoolean, Boolean closeDoneBoolean, Boolean closeDiscardBoolean) {
		String solStatus = setStatus(signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
		if (!solStatus.equals('')) {
			myOpp.StageName = solStatus;
		}
		return myOpp;
	}

	private static String setStatus (Boolean signBoolean, Boolean detBoolean, Boolean closeDoneBoolean, Boolean closeDiscardBoolean) {
		System.debug('setStatus');
		String solStatus = '';

		if (closeDoneBoolean)
			solStatus = 'done';
		else if (closeDiscardBoolean)
			solStatus = 'simulada';
		else if (signBoolean)
			solStatus = 'advAccepted';
		System.debug(solStatus);

		return solStatus;
	}*/


	/**
    * 
    *
    * @param 
    * 
    * @return 
    */
	@AuraEnabled
	public static Object simulOpp(String recordId2) {
		Opportunity myOpp = [SELECT Id, StageName, CloseDate FROM Opportunity WHERE Id = :recordId2 ];
		Quote myQuote = bringFinalQuote(recordId2);
		if ( myQuote != null && myOpp.StageName == 'advAccepted' ) {
			myOpp.StageName = 'advSimulated';
			myOpp.CloseDate = System.today();
			myOpp.CRAN_VEC_ADV_B_IsService__c = true;
			update myOpp;

			myOpp.CRAN_VEC_ADV_B_IsService__c = false;
			update myOpp;
			return new SuccessResponse(myOpp);
		} else {
			return new ErrorResponse(System.Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate);
		}
	}

    /* Método para obtener el nombre de la cabecera del componente que simula el related list*/
    @AuraEnabled
	public static String showHeader(Id recordId) {        
        String sObjName  = recordId.getSObjectType().getDescribe().getName();
        String sObjLabel = recordId.getSObjectType().getDescribe().getLabel();                        
        List<sObject> sObjList = Database.query( 'SELECT Name FROM ' + sObjName + ' WHERE Id = :recordId LIMIT 1' );
        String nHeader = sObjLabel + ' ' + sObjList.get(0).get('Name');
        return nHeader;
    } 

        
    
	/*@AuraEnabled
	public static Object trxOpp(String recordId2){


		try{

			System.debug('trxOpp');
			Opportunity myOpp = [SELECT Id, StageName,CRAN_VEC_ADV_T_AvaloqPropId__c,CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id =:recordId2 ];
			System.debug('myOpp '+ myOpp);
			Quote myQuote = bringFinalQuote(recordId2);
			System.debug('myQuote '+ myQuote);

			Boolean signBoolean = false;
			Boolean detBoolean = false;
			Boolean closeDoneBoolean = false;
			Boolean closeDiscardBoolean = false;
			String solStatus = '';
			Opportunity myOpportunityTemp;

					try{

						System.debug('pasa 1');
						if ( myQuote != null && myOpp.StageName == 'advErrSim' ) {
							System.debug('pasa 2');

								///////// LLAMADA AL SERVICIO REGEN /////////
								CRAN_VEC_ADV_RebalpRQ rq = new CRAN_VEC_ADV_RebalpRQ();

								//entrada de parametros//
								rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

								CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
								order.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
								rq.setOrder(order);
								//fin entrada de parametros//
								String jsonRequest = JSON.serialize(rq);

								String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;

								System.debug('jsonRequest' + rq);

								CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_REGEN_OPORTUNIDAD,jsonRequest,bu,CRAN_VEC_ADV_Constants_CLS.GET);

			            		System.debug('restClient '+restClient);

			            		CRAN_VEC_ADV_RebalpRS results = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpRS.class);

			            		System.debug('results '+results);

								///////// FIN LLAMADA AL SERVICIO REGEN /////////

								if(results ==null){
										return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate));
			            		}else if(results !=null && results.getErrors() != null){
			                			return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors())));

			            		}else if(results!=null && results.getOrder()==null){
			                			return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate));
			            		} else if(results!=null && results.getErrors()==null && results.getOrder()!=null && results.getStatus().equals('rdy_trx_gen')){

			            					//confirmo que la propuesta se acepta
			            					signBoolean = true;
			            					///////// LLAMADA AL SERVICIO DET /////////
											CRAN_VEC_ADV_RebalpRQ rqDet = new CRAN_VEC_ADV_RebalpRQ();

											//entrada de parametros//
											rqDet.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

											CRAN_VEC_ADV_Order_CLS orderDet = new CRAN_VEC_ADV_Order_CLS();
											orderDet.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
											orderDet.setIsNew(false);
											rqDet.setOrder(orderDet);
											//fin entrada de parametros//
											String jsonRequestDet = JSON.serialize(rqDet);
											System.debug('jsonRequest' + rqDet);
											CRAN_VEC_ADV_RestClient_CLS restClientDet = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_DET_OPORTUNIDAD,jsonRequestDet,bu,CRAN_VEC_ADV_Constants_CLS.GET);

							           		System.debug('restClientDet '+restClientDet);
							            	CRAN_VEC_ADV_RebalpRS resultsDet = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClientDet.responseBody, CRAN_VEC_ADV_RebalpRS.class);
							            	System.debug('resultsDet '+resultsDet);
											///////// FIN LLAMADA AL SERVICIO DET/////////
											if(resultsDet ==null){
														myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
														update myOpportunityTemp;
														return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Det));
							            	}else if(resultsDet !=null && resultsDet.getErrors() != null){
														myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
														update myOpportunityTemp;
							                			return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsDet.getErrors())));
							            	}else if(resultsDet!=null && resultsDet.getOrder()==null){
														myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
														update myOpportunityTemp;
							               				return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Det));
							           		} else if(resultsDet!=null && resultsDet.getErrors()==null && resultsDet.getOrder()!=null && resultsDet.getStatus().equals('rdy_trx_gen')){

												           		//confirmo que la propuesta se acepta
								            					detBoolean = true;
								            					///////// LLAMADA AL SERVICIO CLOSE /////////
																CRAN_VEC_ADV_RebalpRQ rqClose = new CRAN_VEC_ADV_RebalpRQ();

																//entrada de parametros//
																rqClose.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

																CRAN_VEC_ADV_Order_CLS orderClose = new CRAN_VEC_ADV_Order_CLS();
																orderClose.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
																orderClose.setIsNew(false);
																rqClose.setOrder(orderClose);
																//fin entrada de parametros//
																String jsonRequestClose = JSON.serialize(rqClose);
																System.debug('jsonRequest' + rqClose);
																CRAN_VEC_ADV_RestClient_CLS restClientClose = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CLOSE_OPORTUNIDAD,jsonRequestClose,bu,CRAN_VEC_ADV_Constants_CLS.GET);

												           		System.debug('restClientClose '+restClientClose);
												            	CRAN_VEC_ADV_RebalpRS resultsClose = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClientClose.responseBody, CRAN_VEC_ADV_RebalpRS.class);
												            	System.debug('resultsClose '+resultsClose);
																///////// FIN LLAMADA AL SERVICIO CLOSE/////////
																if(resultsClose ==null){
																			myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
																			update myOpportunityTemp;
																			return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close));
												            	}else if(resultsClose !=null && resultsClose.getErrors() != null){
																			myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
																			update myOpportunityTemp;
												                			return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsClose.getErrors())));
												            	}else if(resultsClose!=null && resultsClose.getOrder()==null){
																			myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
																			update myOpportunityTemp;
												               				return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close));
												           		} else if(resultsClose!=null && resultsClose.getErrors()==null && resultsClose.getOrder()!=null && ( resultsClose.getStatus().equals('done')|| resultsClose.getStatus().equals('discd'))){
												           					if(resultsClose.getStatus().equals('done'))
																					closeDoneBoolean = true;
																			else if(resultsClose.getStatus().equals('discd'))
																					closeDiscardBoolean = true;
												           		} else {
																		myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
																		update myOpportunityTemp;
																		return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close));
												           		}





											} else{
													myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
													update myOpportunityTemp;
			            							return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close));
			            					}

								} else {
										myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
										update myOpportunityTemp;

										return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate));
								}


								myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
								update myOpportunityTemp;

								return JSON.serialize(new SuccessResponse(myOpp));

								//return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Accept));
						} else {
								myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
								update myOpportunityTemp;
								return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate));
						}

					}catch(Exception e){

			        	//actualizo ultimo estado antes de salir para estar Sf al mismo nivel que los servicios
						myOpportunityTemp = actualizaEstado(myOpp,signBoolean, detBoolean, closeDoneBoolean, closeDiscardBoolean);
						update myOpportunityTemp;

			            return JSON.serialize(new ErrorResponse(e.getMessage()));
			        }


	    }catch(DMLException dmlE){
	        return JSON.serialize(new ErrorResponse(dmlE.getMessage()));
	    }catch(Exception e){
	        return JSON.serialize(new ErrorResponse(e.getMessage()));
	    }

		/*try{
			System.debug('trxOpp');
			Opportunity myOpp = [SELECT Id, StageName,CRAN_VEC_ADV_P_Bunit__c,CRAN_VEC_ADV_T_AvaloqPropId__c FROM Opportunity WHERE Id =:recordId2 ];
			Quote myQuote = bringFinalQuote(recordId2);

			if ( myQuote != null && myOpp.StageName == 'advErrSim' ) {
				///////// LLAMADA AL SERVICIO SIGN /////////
				CRAN_VEC_ADV_RebalpRQ rq = new CRAN_VEC_ADV_RebalpRQ();

				//entrada de parametros//
				rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

				CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
				order.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
				order.setIsNew(false);
				rq.setOrder(order);
				//fin entrada de parametros//
				String jsonRequest = JSON.serialize(rq);
				String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;
				System.debug('jsonRequest' + rq);
				CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_REGEN_OPORTUNIDAD,jsonRequest,bu,CRAN_VEC_ADV_Constants_CLS.GET);

	       		System.debug('restClient '+restClient);
	        	CRAN_VEC_ADV_RebalpRS results = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpRS.class);
	        	System.debug('results '+results);
				///////// FIN LLAMADA AL SERVICIO SIGN /////////
				if(results ==null){
							return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate));
	        	}else if(results !=null && results.getErrors() != null){
	            			return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors())));
	        	}else if(results!=null && results.getOrder()==null){
	           				return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate));
	       		} else if(results!=null && results.getErrors()==null && results.getOrder()!=null){
							myOpp.StageName = 'advAccepted';
							update myOpp;
							return JSON.serialize(new SuccessResponse(myOpp));
	       		} else{
	       					return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate));
	       		}
			} else {
						return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate));
			}

		}catch(Exception e){
	        return JSON.serialize(new ErrorResponse(e.getMessage()));
	    }*/

	/*Version sin servicios*/
	/*Opportunity myOpp = [SELECT Id, StageName FROM Opportunity WHERE Id =:recordId2 ];
	Quote myQuote = bringFinalQuote(recordId2);
	if ( myQuote != null && myOpp.StageName == 'advErrSim' ) {
		myOpp.StageName = 'advAccepted';
		update myOpp;
		return new SuccessResponse(myOpp);
	}else {
		return new ErrorResponse(System.Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate);
	}*/


	/*}*/


	/**
    * 
    *
    * @param 
    * 
    * @return 
    */
	@AuraEnabled
	public static Object trxOppOnlyRegen(String recordId2) {

		try {

			System.debug('trxOpp');
			Opportunity myOpp = [SELECT Id, StageName, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :recordId2 ];
			System.debug('myOpp ' + myOpp);
			Quote myQuote = bringFinalQuote(recordId2);
			System.debug('myQuote ' + myQuote);

			System.debug('pasa 1');
			if ( myQuote != null && myOpp.StageName == 'advErrSim' ) {
				System.debug('pasa 2');

				///////// LLAMADA AL SERVICIO REGEN /////////
				CRAN_VEC_ADV_RebalpRQ rq = new CRAN_VEC_ADV_RebalpRQ();

				//entrada de parametros//
				rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

				CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
				order.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
				rq.setOrder(order);
				//fin entrada de parametros//
				String jsonRequest = JSON.serialize(rq);
				String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;
				System.debug('jsonRequest' + rq);

				CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_REGEN_OPORTUNIDAD,bu,jsonRequest);
				System.debug('restClient ' + restClient);
				CRAN_VEC_ADV_RebalpRS results = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpRS.class);
				System.debug('results ' + results);

				///////// FIN LLAMADA AL SERVICIO REGEN /////////

				if (results != null && results.getErrors() != null) {
					return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors()));
				} else if (results != null && results.getErrors() == null && results.getOrder() != null && results.getStatus().equals('rdy_trx_gen')) {
					myOpp.StageName = 'advAccepted';
					myOpp.CRAN_VEC_ADV_B_IsService__c = true;
					update myOpp;

					myOpp.CRAN_VEC_ADV_B_IsService__c = false;
					update myOpp;
					System.debug('acutaliza opportunity a advAccepted');
					return new SuccessResponse(myOpp);
				} else {
					return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate);
				}
			}
			return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Simulate);
		} catch (Exception e) {
			return new ErrorResponse(e);
		}

	}


	/*---------------------------*/
    /*   CUSTOM CLASS EXCEPTION  */
    /*---------------------------*/

    public class CustomInvestmentProposalException extends Exception {}

   /*--------------------------*/
	/*     Classes Wrapper      */
	/*     ---------------      */
	/*     Para responses       */
	/*--------------------------*/

	@TestVisible
	class ChangedOpportunity {

		@AuraEnabled public Id idSF {get; set;}
		@AuraEnabled public String sfName {get; set;}
		@AuraEnabled public String sfOrderNr {get; set;}
		@AuraEnabled public List<FieldChanged> lstchangedFields {get; set;}

		public ChangedOpportunity(Opportunity opp) {
			this.idSf = opp.Id;
			this.sfName = opp.Name;
			this.sfOrderNr = opp.CRAN_VEC_ADV_T_AvaloqPropId__c;
			this.lstchangedFields = new List<FieldChanged>();
		}
	}

	@TestVisible
	class FieldChanged {
		@AuraEnabled public String fieldName {get; set;}
		@AuraEnabled public String labelName {get; set;}
		@AuraEnabled public String oldValue {get; set;}
		@AuraEnabled public String newValue {get; set;}

		public FieldChanged(Schema.SObjectField sobjectField, Object oldValue, String newValue) {
			this.fieldName = sobjectField.getDescribe().Label;
			this.labelName = sobjectField.getDescribe().Name;
			this.oldValue = String.valueOf(oldValue);
			this.newValue = newValue;
		}
	}

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
		@AuraEnabled public Integer lineNumber {get; set;}
		@AuraEnabled public String messageError {get; set;}
		@AuraEnabled public String typeError {get; set;}
		@AuraEnabled public String stackTrace {get; set;}
		@AuraEnabled public Boolean difRestriction {get; set;}

		public ErrorResponse(Exception e) {
			this.success = false;
			this.lineNumber = e.getLineNumber();
			this.typeError = e.getTypeName();
			this.messageError = e.getMessage();
			this.stackTrace = e.getStackTraceString();
			this.difRestriction = false;
		}

		public ErrorResponse(String str) {
			this.success = false;
			this.messageError = str;
		}

		public ErrorResponse(String str, Boolean difRestriction) {
			this.success = false;
			this.messageError = str;
			this.difRestriction = true;
		}

	}
}