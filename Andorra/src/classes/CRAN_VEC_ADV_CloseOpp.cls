public class CRAN_VEC_ADV_CloseOpp implements Queueable, Database.AllowsCallouts {

    Opportunity opp;
    Id targetId;

	public CRAN_VEC_ADV_CloseOpp(Opportunity opp, Id targetId) {
		this.opp = opp;	
		this.targetId = targetId;	
	}

	public void execute(QueueableContext context) {

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
	        
			CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CLOSE_OPORTUNIDAD,opp.CRAN_VEC_ADV_P_Bunit__c,jsonRequest);

			CRAN_VEC_ADV_RebalpRS results;

			if(restClient.responseBody != null){
				results = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpRS.class);
			}

			System.debug('results ' + results);
	        ///////// FIN LLAMADA AL SERVICIO CLOSE/////////

	        manageResult(results);
	        			
	    } catch (Exception e){
	    	System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
			System.debug('ERROR : ' + e.getTypeName() + '; MENSAJE DEL ERROR : ' + e.getMessage() + '; CAUSA DEL ERROR : ' + e.getCause() + '; ERROR EN LA LINEA : ' + e.getLineNumber() 
				          + 'TRAZA : ' + e.getStackTraceString());
			CRAN_VEC_ADV_ESignatureTriggerUtil.updateOpportunityError(e.getMessage(), null, opp, null);
			if(opp != null && opp.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c != null){
				CRAN_VEC_ADV_ESignatureTriggerUtil.sendNotifications(null , e.getMessage(), true, null, opp.Name, targetId, 
					                                                 opp.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c);
			}			
	    }
   
    }


    public void manageResult(CRAN_VEC_ADV_RebalpRS results){

    	    if (results != null && results.getErrors() != null && results.getOrder() == null) {
				System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
				System.debug('ERROR : ' + CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors()));
				CRAN_VEC_ADV_ESignatureTriggerUtil.updateOpportunityError(null, null, opp, results.getErrors());
				if(opp != null && opp.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c != null){
					CRAN_VEC_ADV_ESignatureTriggerUtil.sendNotifications(null , CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors()), true, null, 
						                                                 opp.Name, targetId, opp.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c);
				}				
			} else if (results != null && results.getErrors() == null && results.getOrder() != null) {
				if (results.getStatus().equals('done') && opp.CRAN_VEC_ADV_T_AvaloqPropId__c == results.getOrder().getOrderNr()) {
	                opp.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE;
	                opp.CloseDate = System.today();
	                opp.CRAN_VEC_ADV_B_IsService__c = true;
	                opp.CRAN_VEC_ADV_HasError__c = false;
	                opp.CRAN_VEC_ADV_ErrorCode__c = null;
	                opp.CRAN_VEC_ADV_ErrorDescription__c = null;
	                update opp;
	                opp.CRAN_VEC_ADV_B_IsService__c = false;
	                update opp;
	                System.debug( ' -------------------- SE HAN ACTUALIZADO LAS OPORTUNIDADES CORRECTAMENTE -------------------- ');
	            } else{
	            	System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
				    System.debug('ERROR : ' + Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
				    CRAN_VEC_ADV_ESignatureTriggerUtil.updateOpportunityError(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close, null, opp, null);
				    if(opp != null && opp.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c != null){
				    	CRAN_VEC_ADV_ESignatureTriggerUtil.sendNotifications(null , Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close, true, null, opp.Name, targetId, 
				    		                                                 opp.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c);
				    }				    				    
	            }            
			} else {
				System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
				System.debug('ERROR : ' + Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close);
				CRAN_VEC_ADV_ESignatureTriggerUtil.updateOpportunityError(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close, null, opp, null);
				if(opp != null && opp.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c != null){
					CRAN_VEC_ADV_ESignatureTriggerUtil.sendNotifications(null , Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Close, true, null, opp.Name, targetId, 
						                                                 opp.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c);
				}				
			}

    }


}