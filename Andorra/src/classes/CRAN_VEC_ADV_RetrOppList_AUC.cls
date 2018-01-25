/**
 * CRAN_VEC_ADV_RetrOppList_AUC Controlador componente listado de Opportunities
 * Fecha: 01/09/2017
 * 
 * Inicializo el campo CRAN_VEC_ADV_B_ManualConfirm__c de cada orden y lineas 
 * ya no fallan si no existe la security
 * @version 1.3
 *
*/
public class CRAN_VEC_ADV_RetrOppList_AUC {

	/**
    * 
    * Método que carga la información en la lista de propuestas de inversion asociadas a un financial account.
    *
    * @param String objId - Id del Objeto.	     
    *
    * @param String nKey - campo principal por el que se van a filtrar los resultados.	     
    * 
    * @param String aFilter - mas filtros.     
    * 
    * @param String childSObjectName - Nombre del objeto.	     
    * 
    * @param Boolean noExecCall - false se ejecuta el proceso, true no se ejecuta.	     
    *  
    * @return 	SuccessResponseDataInvestment si todo es correcto
    * 			ErrorResponse si va mal.
    *
    */
	@AuraEnabled
	public static Object queryDataInvestment(String objId, String nKey, String aFilter, String childSObjectName, Boolean noExecCall) { 
		try{
           	if (!noExecCall){                                
                CRAN_VEC_ADV_AvaloqSettings__c cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();
                boolean MOCKSERVICES = cs.CRAN_VEC_ADV_B_MockServices__c;
                System.debug('objId: ' + objId);
                System.debug('nKey: ' + nKey);
                Object resp = null;
                Id recordId = objId;
                SObjectType objectType = Id.valueOf(objId).getSObjectType();
                String sObjName = recordId.getSObjectType().getDescribe().getName();
                
                List<FinServ__FinancialAccount__c> lstFAccount = [SELECT 	Id,
                                                                  CRAN_VEC_ADV_P_Bunit__c,
                                                                  CRAN_VEC_DEV_T_ContainerID__c,
                                                                  CRAN_VEC_ADV_P_RefCcy__c,
                                                                  CRAN_ICA_KER_P_Oficina__c,
                                                                  FinServ__PrimaryOwner__c
                                                                  FROM FinServ__FinancialAccount__c 
                                                                  WHERE Id = : recordId];
                
                System.debug('-- lstFAccount -' + lstFAccount);
	                if(!lstFAccount.isEmpty()){
	                    resp = callListOpportunities(lstFAccount,recordId);
	                    if(resp!= null){
	                        if(resp instanceof ErrorResponse){
	                            return new SuccessResponseDataInvestment(CRAN_VEC_ADV_ReportResultsController_AUC.DataList(objId, nKey, aFilter, childSObjectName),(ErrorResponse)resp);
	                        }else{
	                            return new SuccessResponseDataInvestment(CRAN_VEC_ADV_ReportResultsController_AUC.DataList(objId, nKey, aFilter, childSObjectName),(List<ChangedOpportunity>)resp);
	                        }
	                    }
	                }
            	}
		    	return new SuccessResponseDataInvestment(CRAN_VEC_ADV_ReportResultsController_AUC.DataList(objId, nKey, aFilter, childSObjectName));      
		}catch(Exception e){
			System.debug('### ERROR ### queryDataInvestment: ' + e);
			System.debug('StackTraceString: ' + e.getStackTraceString());
			return new ErrorResponse(e);
		}
	}


	/**
    * 
    * Llama al servicio de Avaloq para la lista de Opportunities a partir de Finnacial Account enviado por parametro
    * para mostrarlo en el componente de ResultReport.
    *
    * @param List<FinServ__FinancialAccount__c>lstFA - listado de financial accounts
    *
    * @param Id recordId - Id del financial account sobre el que se esta trabajando
    * 
    * @return 	null - si todo es correcto
    *           List<ChangedOpportunity>lstCO - Todo ha ido bien pero con alertas a mostrar.
    * 			ErrorResponse - Con el error si se produce.
    *
    */
	public static Object callListOpportunities(List<FinServ__FinancialAccount__c> lstFA, Id recordId){
	
			CRAN_VEC_ADV_AvaloqOppInvestProposal__c csAvaloqOIP = CRAN_VEC_ADV_AvaloqOppInvestProposal__c.getInstance();
			
			CRAN_VEC_ADV_RebalpList_RQ rq = new CRAN_VEC_ADV_RebalpList_RQ();
	            
	        ////////// ENTRADA PARAMETROS ////////////
	        rq.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());
	        
	        Datetime dtNow = Datetime.now();
	        Integer numberOfDays = 1;
	        System.debug('csAvaloqOIP: ' + csAvaloqOIP);
	        if(csAvaloqOIP.CRAN_VEC_ADV_N_Days_from__c==null){
	        	throw new CustomInvestmentProposalException(Label.CRAN_VEC_ADV_IP_MSG_Error_CustomSettingNotDefined);
			}else{
				numberOfDays = Integer.valueOf(csAvaloqOIP.CRAN_VEC_ADV_N_Days_from__c);
			}

	        rq.dateFrom = (dtNow-numberOfDays).format(CRAN_VEC_ADV_Constants_CLS.DATE_FORMAT_DDMMYYYY, CRAN_VEC_ADV_Constants_CLS.GMT);
	        rq.dateTo = dtNow.addDays(1).format(CRAN_VEC_ADV_Constants_CLS.DATE_FORMAT_DDMMYYYY, CRAN_VEC_ADV_Constants_CLS.GMT);

	        List<String> lstStatusCodes;
	        if(String.isNotBlank(csAvaloqOIP.CRAN_VEC_ADV_T_Proposal_status_codes__c)){
	        	lstStatusCodes = csAvaloqOIP.CRAN_VEC_ADV_T_Proposal_status_codes__c.split(';');
	        	CRAN_VEC_ADV_StatusList_CLS statusList = new CRAN_VEC_ADV_StatusList_CLS();
	        	statusList.statusId = lstStatusCodes;
	        	rq.statusList = statusList;
	        }
	        
	        CRAN_VEC_ADV_RebalpListObjList objList = new CRAN_VEC_ADV_RebalpListObjList();
	        objList.objType = CRAN_VEC_ADV_Constants_CLS.CONTAINER;

	        List<String> objListString = new List<String>();

	        for(FinServ__FinancialAccount__c fa : lstFA){
	        	objListString.add(CRAN_VEC_ADV_Utils.getIdAvaloq(fa.CRAN_VEC_DEV_T_ContainerID__c));
	        }
	        objList.objId = objListString;
	        rq.objList = objList; 
	        ////////// FIN ENTRADA PARAMETROS ////////////

			String jsonRequest = JSON.serialize(rq);
			System.debug('jsonRequest: ' + jsonRequest);

			CRAN_VEC_ADV_RestClient_CLS avaloqClient;
			String bu = lstFA[0].CRAN_VEC_ADV_P_Bunit__c;
	        CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_LIST_OPORTUNIDAD,bu,jsonRequest);
	            
	        CRAN_VEC_ADV_RebalpList_RS results = (CRAN_VEC_ADV_RebalpList_RS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpList_RS.class);            
			
			if (results != null && results.errors != null) {
				return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors));
			} else if (results != null && results.errors == null && results.rebalPropList != null) {
				List<ChangedOpportunity> lstCO = updateDataResponse(results,lstFA[0],bu,recordId);
				if(lstCO.isEmpty()){
					return null; //Todo ha ido bien
				}else{
					return lstCO; //Todo ha ido bien pero con alertas a mostrar
				}
			} else {
				return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
			}
	}


	/**
    * 
    * Actualiza en salesforce los datos de la respuesta del servicio list Opportunities.
    *
    * @param CRAN_VEC_ADV_RebalpList_RS results - Respuesta correcta del servicio.
    *
    * @param FinServ__FinancialAccount__c fa - objeto financial account.
    *
    * @param String bu - Business Unit sobre la que trabajamos.
    *
    * @param Id recordId - Id del financial account que estamos
    * 
    * @return List<ChangedOpportunity> lstChangedOpportunities.
    *
    */
	public static List<ChangedOpportunity> updateDataResponse(CRAN_VEC_ADV_RebalpList_RS results, FinServ__FinancialAccount__c fa, String bu, Id recordId){

		/** Nueva funcionalidad para asignar la oficina de nuevas oportunidades al usuario que las crea */
		String userID = UserInfo.getUserId();
		//mapa que contiene <external Id de opportunity, listado de ordenes de esa opportunity>
		Map<String,List<CRAN_VEC_ADV_RebalpList_RS.OrderItem>> myOrderMap = new Map<String,List<CRAN_VEC_ADV_RebalpList_RS.OrderItem>>();

		List<ChangedOpportunity> lstChangedOpportunities = new List<ChangedOpportunity>();

		List<Opportunity> myOppList = [	SELECT 	Name,
													StageName,
													CRAN_VEC_ADV_T_AvaloqPropId__c,
													CRAN_VEC_ADV_P_Bunit__c,
													Account.CRAN_VEC_ADV_T_BPId__c,
													FinServ__FinancialAccount__r.CRAN_VEC_DEV_T_ContainerID__c,
													CRAN_VEC_ADV_P_InvMethod__c,
													CRAN_VEC_ADV_P_Currency__c,
													CRAN_VEC_ADV_N_InvAmount__c,
													CRAN_VEC_ADV_D_StartDate__c
											FROM Opportunity 
											WHERE 	RecordType.DeveloperName = :CRAN_VEC_ADV_Constants_CLS.CRAN_VEC_ADV_OPP_INVT_PROP AND
													FinServ__FinancialAccount__c = :fa.Id];
											

		if(results.rebalPropList.isEmpty()){ // No devuelve ninguna proposal
			if(myOppList.size()>0)
				 CRAN_VEC_ADV_Utils.deleteSOs(myOppList);
		}else{ //Al menos alguna proposal

			// Consultar todas las Opps recibidas.
			List<String> lstPropOrderNr = new List<String>();
			for(CRAN_VEC_ADV_RebalpList_RS.Proposal myOpp : results.rebalPropList){
				lstPropOrderNr.add(myOpp.propOrderNr);
			}

			
			
			Map<String,Opportunity> mapOpps = new Map<String,Opportunity>();

            for(Opportunity auxOpp : myOppList){
            	mapOpps.put(auxOpp.CRAN_VEC_ADV_T_AvaloqPropId__c, auxOpp);
            }

            List<RecordType> invsPropRecordType = CRAN_VEC_ADV_Constants_CLS.INVSPROP_RECORDTYPE;
            //Create a map between the Record Type SobjectType and Id for easy retrieval
            Map<String,Id> recordTypesMap = new Map<String,Id>();
            for(RecordType rt: invsPropRecordType){
                recordTypesMap.put(rt.SobjectType,rt.Id);
            }

            List<Opportunity> lstOppsToUpsert = new List<Opportunity>();
            Schema.DescribeSObjectResult describeOpp = Opportunity.sObjectType.getDescribe();
			Map<String, Schema.SObjectField> fieldsOppMap = describeOpp.fields.getMap();

			ChangedOpportunity co;
            for(CRAN_VEC_ADV_RebalpList_RS.Proposal proposal : results.rebalPropList){
            	Opportunity opp = mapOpps.get(proposal.propOrderNr);
            	if(opp==null){
            		opp = new Opportunity();
            		opp.RecordTypeId = recordTypesMap.get(CRAN_VEC_ADV_Constants_CLS.OPPORTUNITY_OBJ);
            		opp.CRAN_VEC_ADV_T_AvaloqPropId__c = proposal.propOrderNr;
            		/** Asigamos oficina del user que las crea a las opportunities */
            		opp.CRAN_ICA_KER_P_Oficina__c = fa.CRAN_ICA_KER_P_Oficina__c;
            	}
			
				//guardo map de external <id,order> para luego realizar la inserción
				for(CRAN_VEC_ADV_RebalpList_RS.OrderItem myOrderTemp : proposal.refOrderList){
					List<CRAN_VEC_ADV_RebalpList_RS.OrderItem> listOrderTemp;
					if(opp.CRAN_VEC_ADV_T_AvaloqPropId__c != null){
						if(myOrderMap.get(opp.CRAN_VEC_ADV_T_AvaloqPropId__c)!=null){
							listOrderTemp = myOrderMap.get(opp.CRAN_VEC_ADV_T_AvaloqPropId__c);
						}else{
							listOrderTemp = new List<CRAN_VEC_ADV_RebalpList_RS.OrderItem>();
						}
						listOrderTemp.add(myOrderTemp);
						myOrderMap.put(opp.CRAN_VEC_ADV_T_AvaloqPropId__c,listOrderTemp);
					}
				}							


            	if(opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PEND_SIGN  && proposal.propStatusId==CRAN_VEC_ADV_Constants_CLS.VALUE_50){
            		co = fillAndAuditExistingOpportunityFields(opp,proposal,bu,fieldsOppMap);
            		if(co != null){//Se han realizado cambios en la Opp
            			System.debug('inside if of changes logged : '+co);
            			lstChangedOpportunities.add(co);
            		}
            	}else {
					fillOpportunityFields(opp,proposal,bu,fa, recordId);
            	}
            	opp.CRAN_VEC_ADV_B_isService__c = true;
            	lstOppsToUpsert.add(opp);
			}

			if(!lstOppsToUpsert.isEmpty()){
				System.debug('lstOppsToUpsert: ' + lstOppsToUpsert );
				System.debug('lstOppsToUpsert.size : '+lstOppsToUpsert.size());
				Database.upsert (lstOppsToUpsert);
				for(Opportunity opp : lstOppsToUpsert){
					opp.CRAN_VEC_ADV_B_isService__c = false;
				}
				Database.upsert(lstOppsToUpsert);
			}

            
            //	borro opportunities que no vienen del servicio y sus ordenes
            if(results.rebalPropList!=null && results.rebalPropList.size()>0){            
            	List<String> myListpropOrderNr = new List<String>();
				for(CRAN_VEC_ADV_RebalpList_RS.Proposal myOpp : results.rebalPropList){
					myListpropOrderNr.add(myOpp.propOrderNr);
				}
	
                String strPropOrderNr = '\'' + string.join(myListpropOrderNr,'\',\'') +'\'';
                String strSOQL = 'SELECT Id,FinServ__FinancialAccount__c,CRAN_VEC_ADV_T_AvaloqPropId__c FROM Opportunity WHERE  FinServ__FinancialAccount__c = \'' + fa.Id + '\' AND CRAN_VEC_ADV_T_AvaloqPropId__c NOT IN (' + strPropOrderNr + ')';
                System.debug('strSOQL ---> '+strSOQL);
                List<Opportunity> myListTodelete = Database.query(strSOQL);

                System.debug('myListTodelete---> '+myListTodelete);
                if(myListTodelete !=null && myListTodelete.size()>0)									
                    CRAN_VEC_ADV_Utils.deleteSOs(myListTodelete);
    
                // borro las ordenes
                if(myListTodelete!=null && myListTodelete.size()>0){
                	List<Order> myListOrder = [SELECT Id,OpportunityId FROM Order WHERE OpportunityId IN :myListTodelete];
                    if(myListOrder !=null && myListOrder.size()>0)
                        CRAN_VEC_ADV_Utils.deleteSOs(myListOrder);
                }
                // borro las ordenes            
            }                       

		}
		System.debug('*/*/*/*/*/*/lstChangedOpportunities : '+lstChangedOpportunities);
		
		return lstChangedOpportunities;
	}

	
    /**
    * 
    * Método que convierte un String que represente a una fecha en un Datetime.
    *
    * @param String valueo
    * 
    * @return Datetime stringToDateTime.
    *
    */
	public static Datetime stringToDateTime(String value){
        List<String> lstValueDT = value.split(' ');
        List<String> lstStringD;
        List<String> lstStringT;

        lstStringD = lstValueDT[0].split('-');
        Date d = Date.newinstance(Integer.valueOf(lstStringD[2]),Integer.valueOf(lstStringD[1]),Integer.valueOf(lstStringD[0]));

        Integer miliSeconds = 0;
        lstStringT = lstValueDT[1].split(':');
        Time t =  Time.newInstance(Integer.valueOf(lstStringT[0]), Integer.valueOf(lstStringT[1]), Integer.valueOf(lstStringT[2]), Integer.valueOf(miliSeconds));

        return Datetime.newInstanceGmt(d,t);
    }


	/**
    * 
    * fillAndAuditExistingOpportunityFields
    *
    * @param Opportunity opp - Oportunidad.
    *
    * @param CRAN_VEC_ADV_RebalpList_RS.Proposal prop - propuesta.
    *
    * @param String bu - Business Unit sobre la que trabajamos.
    *
    * @param Map<String, Schema.SObjectField> fieldsOppMap - mapa de campos.
    * 
    * @return ChangedOpportunity ChangedOpportunity.
    *
    */
	public static ChangedOpportunity fillAndAuditExistingOpportunityFields(Opportunity opp, CRAN_VEC_ADV_RebalpList_RS.Proposal prop,String bu, Map<String, Schema.SObjectField> fieldsOppMap){
		ChangedOpportunity co;
		System.debug('------------------fillAndAuditExistingOpportunityFields-----------------');
		system.debug('opp : '+opp);
		system.debug('prop : '+prop);
	
		if(prop.propDesc != null && opp.Name != prop.propDesc){
			addChangedField(co,opp,'Name',opp.Name,prop.propDesc,fieldsOppMap);
			opp.Name = prop.propDesc;
		}

		if(opp.CRAN_VEC_ADV_P_InvMethod__c != prop.propInvMeth){
			co = addChangedField(co,opp,'CRAN_VEC_ADV_P_InvMethod__c',opp.CRAN_VEC_ADV_P_InvMethod__c,prop.propInvMeth,fieldsOppMap);
			opp.CRAN_VEC_ADV_P_InvMethod__c = prop.propInvMeth;
		}

		if(opp.CRAN_VEC_ADV_P_Currency__c != prop.propCurry){
			co = addChangedField(co,opp,'CRAN_VEC_ADV_P_Currency__c',opp.CRAN_VEC_ADV_P_Currency__c,prop.propCurry,fieldsOppMap);
			opp.CRAN_VEC_ADV_P_Currency__c = prop.propCurry;
		}
		
		if(prop.propAmount != null && opp.CRAN_VEC_ADV_N_InvAmount__c != Decimal.valueOf(prop.propAmount)){
			co = addChangedField(co,opp,'CRAN_VEC_ADV_N_InvAmount__c',opp.CRAN_VEC_ADV_N_InvAmount__c,prop.propAmount,fieldsOppMap);
			opp.CRAN_VEC_ADV_N_InvAmount__c = Decimal.valueOf(prop.propAmount);
		}

		if(String.isNotBlank(prop.propDate)){
			List<String> lstValueDT = prop.propDate.split(' ');
			Date newDate = CRAN_VEC_ADV_Utils.stringToDate(lstValueDT[0],CRAN_VEC_ADV_Constants_CLS.DATE_FORMAT_DDMMYYYY);
			if(!opp.CRAN_VEC_ADV_D_StartDate__c.isSameDay(newDate)){
				System.debug('--Fechas not match--');
				co = addChangedField(co,opp,'CRAN_VEC_ADV_D_StartDate__c',opp.CRAN_VEC_ADV_D_StartDate__c,String.valueOf(newDate),fieldsOppMap);
				opp.CRAN_VEC_ADV_D_StartDate__c = newDate;
			}
		}

		//contador de ordenes
		opp = countOrderListOpp(opp,prop);

		System.debug('***********opp : '+ opp);
		System.debug('***********co : '+ co);
		
		return co;
	}


    /**
    * 
    * Rellena los campos para la insercion de Opportunities
    *
    * @param Opportunity opp - Oportunidad.
    *
    * @param CRAN_VEC_ADV_RebalpList_RS.Proposal prop - propuesta.
    *
    * @param String bu - Business Unit sobre la que trabajamos.
    *
    * @param FinServ__FinancialAccount__c fa - financial account del que saca el primary owner.
    * 
    * @param Id recordId - Id del financial account.
    * 
    * @return Void.
    *
    */
	public static void fillOpportunityFields(Opportunity opp,CRAN_VEC_ADV_RebalpList_RS.Proposal prop,String bu,FinServ__FinancialAccount__c fa, Id recordId){
		opp.Name = prop.propDesc;
		opp.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_MAP.get(prop.propStatusId);
		
		opp.CRAN_VEC_ADV_P_Bunit__c = bu;
		opp.AccountId = fa.FinServ__PrimaryOwner__c;

		opp.FinServ__FinancialAccount__c = recordId;
		opp.Name = CRAN_VEC_ADV_Constants_CLS.PROP + CRAN_VEC_ADV_Utils.subStrMaxLongi(prop.propOrderNr,75);
		opp.CRAN_VEC_ADV_P_InvMethod__c = prop.propInvMeth;
		opp.CRAN_VEC_ADV_P_Currency__c = prop.propCurry;
        
        // Los valores del campo CRAN_VEC_ADV_N_OrderList__c sirven para ordenar la lista
        // de propuestas en el componente de la página de Financial Account, según el estado 
        // de la propuesta. Como el valor 51 debe ir delante del 50, le asignamos el valor 49
		if ( Integer.valueOf(prop.propStatusId) == 51 ) {
            opp.CRAN_VEC_ADV_N_OrderList__c = 49;
        } else {
            opp.CRAN_VEC_ADV_N_OrderList__c = Integer.valueOf(prop.propStatusId);
        }
		
		if(prop.propAmount != null)
			opp.CRAN_VEC_ADV_N_InvAmount__c = Decimal.valueOf(prop.propAmount);
		if(prop.propDate != null){
			List<String> lstValueDT = prop.propDate.split(' ');
			opp.CRAN_VEC_ADV_D_StartDate__c = Date.valueOf(CRAN_VEC_ADV_Utils.stringToDate(lstValueDT[0],CRAN_VEC_ADV_Constants_CLS.DATE_FORMAT_DDMMYYYY));
			opp.CloseDate = Date.today().addDays(30);
		}

		opp = countOrderListOpp(opp,prop);
	}


	/**
    * 
    * ChangedOpportunity
    *
    * @param ChangedOpportunity co - ChangedOpportunity.
    *
    * @param Opportunity op - Opportunidad.
    *
    * @param String fieldName - Nombre del campo.
    *
    * @param Object oldValue - Valor antigüo del objeto.
    * 
    * @param String newValue - IdNuevo valor.
    *
    * @param Map<String, Schema.SObjectField> fieldsOppMap - Mapa de los campos antigüos.
    *  
    * @return ChangedOpportunity.
    *
    */
	public static ChangedOpportunity addChangedField(ChangedOpportunity co, Opportunity op, String fieldName, Object oldValue, String newValue, Map<String, Schema.SObjectField> fieldsOppMap){
		if(co == null){
			co = new ChangedOpportunity(op);
			System.debug('***********INITILIAZE CO');
		}
		co.lstChangedFields.add(new FieldChanged(fieldsOppMap.get(fieldName),oldValue,newValue));
		System.debug('***********co : '+ co);
		return co;
	}


	/**
    * Action para el boton de navegación a Opportunity seleccionada en el componente.
    *
    * @param recordId - Id de la Opportunity.
    * 
    * @return respuesta JSON para gestionar posibles errores en la llamada al servicio con la Opportunity.
    */
	@AuraEnabled
	public static Object updateRecordData(Id recordId) {
		 
        List<Opportunity> oppList = [SELECT Id,Name,AccountId,CRAN_VEC_ADV_T_AvaloqPropId__c,CRAN_VEC_ADV_P_Bunit__c,CRAN_VEC_ADV_T_RoleId__c,
        								    CRAN_VEC_ADV_D_QuestionaryExpiryDate__c,CRAN_VEC_ADV_B_Expired__c,CRAN_VEC_ADV_B_isService__c 
        							 FROM Opportunity 
        							 WHERE Id = :recordId];
        String errorDetail;

		try{
			if(oppList!= null && oppList.size()>0){
				CRAN_VEC_ADV_RebalpDetRQ_CLS rqCalc = new CRAN_VEC_ADV_RebalpDetRQ_CLS();
				//entrada de parametros//
				rqCalc.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());

				CRAN_VEC_ADV_Order_CLS myOrder = new CRAN_VEC_ADV_Order_CLS();
				myOrder.setOrderNr(oppList[0].CRAN_VEC_ADV_T_AvaloqPropId__c);
				rqCalc.order = myOrder;

				String jsonRequestCalc = JSON.serialize(rqCalc);
				//peticion post
				CRAN_VEC_ADV_RestClient_CLS restClientCalc = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_DET_OPORTUNIDAD_V2,oppList[0].CRAN_VEC_ADV_P_Bunit__c,jsonRequestCalc);
				System.debug('resp detalle ----------------------------> '+restClientCalc);
				System.debug('responseBody'+restClientCalc.responseBody);

				CRAN_VEC_ADV_DetOrderRS resultsCalc = (CRAN_VEC_ADV_DetOrderRS)JSON.deserialize(restClientCalc.responseBody, CRAN_VEC_ADV_DetOrderRS.class);
				System.debug(resultsCalc);
				///////// FIN LLAMADA AL SERVICIO CALCULAR/////////
				if(resultsCalc.getErrors()== null){
					//borro todos los IPLS y restricciones de quote
					
					List<Quote> deleteQuoteList = [SELECT Id, OpportunityId, Status, CRAN_VEC_ADV_N_LineItems__c, CRAN_VEC_ADV_N_Version__c, CRAN_VEC_ADV_B_Final__c, CRAN_VEC_ADV_B_FinalBK__c, CRAN_VEC_ADV_N_InvAmount__c, CRAN_VEC_ADV_N_InvAmountBK__c, CRAN_VEC_ADV_P_Currency__c, CRAN_VEC_ADV_P_CurrencyBK__c, Name, CRAN_VEC_ADV_P_Quote_ID__c
												   FROM Quote WHERE OpportunityId = :recordId];


					delete deleteQuoteList;

					CRAN_VEC_ADV_Investment_Proposition_Line__c elemenLevel0;
					List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myMap = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
					List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myMapReturn = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();

					List<RecordType> invsPropRecordType = CRAN_VEC_ADV_Constants_CLS.INVSPROP_RECORDTYPE;
					system.debug('Recordtype-------------------------------' + invsPropRecordType);
					Map<String,Id> recordTypesMap = new Map<String,Id>();
					for(RecordType rt: invsPropRecordType){
						recordTypesMap.put(rt.SobjectType,rt.Id);
					}
					// Rescorremos version list
					for(CRAN_VEC_ADV_DetRebalpVersionRS myVersion: resultsCalc.getVersionList()){
						//inserto nivel 0
						elemenLevel0 = new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = CRAN_VEC_ADV_Utils.subStrMaxLongi(myVersion.getNode().getNodeDet().getName(),80),CRAN_VEC_ADV_T_Rating__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(myVersion.getNode().getNodeDet().getRat(),255),CRAN_VEC_ADV_T_NodeId__c = myVersion.getNode().getNodeDet().getNodeId().getValue(),CRAN_VEC_ADV_P_Currency__c =myVersion.getNode().getNodeDet().getCurry(),CRAN_VEC_ADV_N_PortfolioQtty__c = myVersion.getNode().getNodeDet().getSpfQty(),CRAN_VEC_ADV_N_PropQtty__c = myVersion.getNode().getNodeDet().getCpfqty(),CRAN_VEC_ADV_N_PropAccrual__c=myVersion.getNode().getNodeDet().getCpfAccr(),CRAN_VEC_ADV_N_Price__c = myVersion.getNode().getNodeDet().getPrice(),CRAN_VEC_ADV_N_MPF__c=myVersion.getNode().getNodeDet().getMpfPerc(),CRAN_VEC_ADV_N_PercentQtty__c=myVersion.getNode().getNodeDet().getCpfPerc(),CRAN_VEC_ADV_N_PropMktValue__c=myVersion.getNode().getNodeDet().getCpfMktVal(), CRAN_VEC_ADV_P_nodeType__c='node',CRAN_VEC_ADV_T_Remark__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(myVersion.getNode().getNodeDet().getRemark(),255),CRAN_VEC_ADV_P_ChangedField__c='Null',CRAN_VEC_ADV_N_Level__c=0,CRAN_VEC_ADV_N_Secuence__c=1,CRAN_VEC_ADV_T_RestrInfo__c= CRAN_VEC_ADV_Utils.subStrMaxLongi(myVersion.getNode().getNodeDet().getRestrInfo(),255),CRAN_VEC_ADV_T_RestrIcon__c=myVersion.getNode().getNodeDet().getRestrIcon());                
						System.debug('ELEMENTE LEVEL0 ------------------------->'+elemenLevel0);
						CRAN_VEC_ADV_CalcRebalpNodeRS node = myVersion.getNode();
						myMapReturn = CRAN_VEC_ADV_Utils.recorreArbol(node.getNodeList(),1,myMap);                         

						Quote myQuote = new Quote(Name= CRAN_VEC_ADV_Utils.subStrMaxLongi(oppList[0].Name,77)+'_v1',CRAN_VEC_ADV_P_Quote_ID__c=myVersion.getId(),status='Synchronized',CRAN_VEC_ADV_P_Bunit__c=oppList[0].CRAN_VEC_ADV_P_Bunit__c,CRAN_VEC_ADV_N_Version__c=decimal.valueof('1'), OpportunityId=recordId,CRAN_VEC_ADV_D_StartDate__c=Date.today(),CRAN_VEC_ADV_B_OverrideAll__c=false,CRAN_VEC_ADV_B_Final__c=true,CRAN_VEC_ADV_B_FinalBK__c=true, RecordTypeId = recordTypesMap.get('Quote'));
						
						myQuote.CRAN_VEC_ADV_N_InvAmount__c = myVersion.getInvstAmount();
						myQuote.CRAN_VEC_ADV_N_InvAmountBK__c = myVersion.getInvstAmount();
						myQuote.CRAN_VEC_ADV_N_InvAmountBKK__c = myVersion.getInvstAmount();
						
						myQuote.CRAN_VEC_ADV_P_Currency__c = myVersion.getInvstCurry();
						myQuote.CRAN_VEC_ADV_P_CurrencyBK__c = myVersion.getInvstCurry();
						myQuote.CRAN_VEC_ADV_P_CurrencyBKK__c = myVersion.getInvstCurry();

						myQuote.CRAN_VEC_ADV_B_IsService__c = true;
						insert myQuote;
						

						List<CRAN_VEC_ADV_Investment_Proposition_Line__c> finalListLines = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();

						integer mySec = 1;
						//relleno campos que faltan en las lineas antes de insertar
						if(elemenLevel0!=null){
							elemenLevel0.CRAN_VEC_ADV_L_Version__c = myQuote.Id;
							elemenLevel0.CRAN_VEC_ADV_L_Proposition__c = recordId;
							elemenLevel0.RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c');
							elemenLevel0.CRAN_VEC_ADV_N_Secuence__c = mySec;
							elemenLevel0.CRAN_VEC_ADV_B_IsService__c = true;
							finalListLines.add(elemenLevel0);
						}

						for(CRAN_VEC_ADV_Investment_Proposition_Line__c myLine : myMapReturn){
							mySec = mySec+1;
							myLine.CRAN_VEC_ADV_L_Version__c = myQuote.Id;
							myLine.CRAN_VEC_ADV_L_Proposition__c = recordId;
							myLine.RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c');
							myLine.CRAN_VEC_ADV_N_Secuence__c = mySec;
							myLine.CRAN_VEC_ADV_B_IsService__c = true;
							if(myLine.CRAN_VEC_ADV_P_nodeType__c!=null && myLine.CRAN_VEC_ADV_P_nodeType__c==CRAN_VEC_ADV_Constants_CLS.POS){
								if(myLine.CRAN_VEC_ADV_T_Key__c!=null && myLine.CRAN_VEC_ADV_T_Key__c!=CRAN_VEC_ADV_Constants_CLS.EMPTY)
									myLine.CRAN_VEC_ADV_T_Key__c = myQuote.Id+myLine.CRAN_VEC_ADV_T_Key__c;
							}
							finalListLines.add(myLine);
						}
						//Bypass Trigger
						CRAN_VEC_KER_TriggerHandler_CLS.bypass('CRAN_VEC_ADV_IPLTriggerHandler_CLS');

						/////////////////////////////////////////////////////////////
						/////////////////// CRAN_VEC_ADV_L_Assets__r/////////////////
						///////////////////////////////////////////////////////////// 
						//modifico las lineas para que los que son de nodetype pos su 
						//security no existe vacio el campo CRAN_VEC_ADV_L_Assets__r y no falle
						
						List<String> myListTypePos = new List<String>();
						for (CRAN_VEC_ADV_Investment_Proposition_Line__c aux : finalListLines) {
							if(CRAN_VEC_ADV_Constants_CLS.POS.equals(aux.CRAN_VEC_ADV_P_nodeType__c))
								myListTypePos.add(aux.CRAN_VEC_ADV_L_Assets__r.FinServ__SourceSystemId__c);
								
						}

						List<FinServ__Securities__c> mySecuritiesToCheck = [SELECT FinServ__SourceSystemId__c 
																			FROM FinServ__Securities__c
																			WHERE FinServ__SourceSystemId__c IN : myListTypePos];


						Set<String> mySetIdSecurities = new Set<String>();
						for (FinServ__Securities__c aux : mySecuritiesToCheck) {							
								mySetIdSecurities.add(aux.FinServ__SourceSystemId__c);								
						}										

						for (CRAN_VEC_ADV_Investment_Proposition_Line__c aux : finalListLines) {
							if(CRAN_VEC_ADV_Constants_CLS.POS.equals(aux.CRAN_VEC_ADV_P_nodeType__c) && !mySetIdSecurities.contains(aux.CRAN_VEC_ADV_L_Assets__r.FinServ__SourceSystemId__c))
								aux.CRAN_VEC_ADV_L_Assets__r = null;								
						}

						/////////////////////////////////////////////////////////////
						///////////////// FIN DE CRAN_VEC_ADV_L_Assets__r////////////
						///////////////////////////////////////////////////////////// 						

						
						List<CRAN_VEC_ADV_Investment_Proposition_Line__c> lstUpdateService = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
						Database.SaveResult [] cr = CRAN_VEC_ADV_Utils.DBinsertIPL(finalListLines);
				        for (Database.SaveResult r : cr) {
				            if (!r.isSuccess()) {
				                for (Database.Error tmpError : r.getErrors()) {
				                    System.debug('Error: ' + tmpError.getMessage());
				                    if(errorDetail == null)
				                    {
				                    	errorDetail =  'Fields: ' + tmpError.getFields() + '<br/>StatusCode: ' + tmpError.getStatusCode() + '<br/>Message: ' + tmpError.getMessage() + '<br/>';
				                    }else{
				                    	errorDetail +=  'Fields: ' + tmpError.getFields() + '<br/>StatusCode: ' + tmpError.getStatusCode() + '<br/>Message: ' + tmpError.getMessage() + '<br/>';
				                    }
				                }
				            }else{
				            	lstUpdateService.add(new CRAN_VEC_ADV_Investment_Proposition_Line__c(Id = r.Id,CRAN_VEC_ADV_B_IsService__c = false));
				            }
				        }
				        update lstUpdateService;



						// INSERCION DE RESTRICCIONES //
						List<CRAN_VEC_ADV_IPL_Restriction__c> restList = new List<CRAN_VEC_ADV_IPL_Restriction__c>();

						if(myVersion!=null && myVersion.getRestrList()!= null && !myVersion.getRestrList().isEmpty()){
							List<CRAN_VEC_ADV_CalcRebalpRestrictionRS> myListRestriction = myVersion.getRestrList();
							for(CRAN_VEC_ADV_CalcRebalpRestrictionRS elementRestriction : myListRestriction){
								restList.add(new CRAN_VEC_ADV_IPL_Restriction__c(Name = CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getName(),80),CRAN_VEC_ADV_B_isService__c = true,CRAN_VEC_ADV_T_RestrictionId__c= elementRestriction.getId(),CRAN_VEC_ADV_L_Version__c = myQuote.Id, RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_IPL_Restriction__c'), CRAN_VEC_ADV_L_Proposition__c = recordId,CRAN_VEC_ADV_T_RestrictionTypeName__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getTypeName(),255),CRAN_VEC_ADV_T_TopRestriction__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getTopRestr(),255),CRAN_VEC_ADV_T_EvalResult__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getEvalResult(),255),CRAN_VEC_ADV_T_Remark__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getRemark(),255),CRAN_VEC_ADV_T_ViolObject__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getViolObj(),255),CRAN_VEC_ADV_T_ViolClass__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getViolClass(),255),CRAN_VEC_ADV_T_ViolValue__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getViolValue(),255),CRAN_VEC_ADV_T_ValueFrom__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getValueFrom(),255),CRAN_VEC_ADV_T_ValueTo__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getValueTo(),255),CRAN_VEC_ADV_T_Priority__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getPrio(),255),CRAN_VEC_ADV_B_Override__c=elementRestriction.getOverrideRestr(),CRAN_VEC_ADV_B_OverrideBK__c=elementRestriction.getOverrideRestr(),CRAN_VEC_ADV_B_OverrideBKK__c=elementRestriction.getOverrideRestr(),CRAN_VEC_ADV_T_Justification__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getJustif(),255)));
							}
							insert restList;
						}

						// ACTUALIZAMOS isSERVICE a false Restricciones
						for(CRAN_VEC_ADV_IPL_Restriction__c updateRest : restList){
							updateRest.CRAN_VEC_ADV_B_IsService__c = false;
						}
						update restList;

						// ACTUALIZAMOS isSERVICE a false Quote
						myQuote.CRAN_VEC_ADV_B_IsService__c = false;
						update myQuote;


						// INSERCION DE ORDENES //

						if(myVersion!=null && myVersion.refOrderList!= null  && myVersion.refOrderList != null && myVersion.refOrderList.size()>0){
       			            List<Order> listOrders = [SELECT Id,AccountId,CRAN_VEC_ADV_B_ManualConfirm__c,CRAN_VEC_ADV_N_Price__c,Status,CRAN_VEC_ADV_N_xRateType__c,CRAN_VEC_ADV_P_BuyCurry__c,CRAN_VEC_ADV_N_BuyAmount__c,CRAN_VEC_ADV_P_SellCurry__c,CRAN_VEC_ADV_N_SellAmount__c,CRAN_VEC_ADV_N_Limit__c,CRAN_VEC_ADV_T_AssetName__c,CRAN_VEC_ADV_N_Amount__c,CRAN_VEC_ADV_N_Quantity__c,RecordTypeId,EffectiveDate,CRAN_VEC_ADV_B_isService__c,QuoteId,OpportunityId,CRAN_VEC_ADV_T_OrderId__c,CRAN_VEC_ADV_T_HasRestr__c,CRAN_VEC_ADV_T_MetaTypeId__c,CRAN_VEC_ADV_P_MetaType__c,CRAN_VEC_ADV_T_TypeId__c,CRAN_VEC_ADV_P_Type__c,CRAN_VEC_ADV_T_OrderTypeId__c,Type,CRAN_VEC_ADV_T_AvaloqStatusId__c,CRAN_VEC_ADV_T_AvaloqStatus__c,CRAN_VEC_ADV_D_TRXDate__c FROM Order WHERE OpportunityId = : recordId];
       			            List<Quote> myFinalQuote = [SELECT Id FROM Quote WHERE OpportunityId = :recordId AND CRAN_VEC_ADV_B_Final__c=:true];
       			            List<RecordType> myRecordType = CRAN_VEC_ADV_Constants_CLS.ORDER_RECORDTYPE;
				
							//genero maps<CRAN_VEC_ADV_OrderId__c,String> para buscar si ya estan 
                			//las que trae el servicio y realizar update
                			Map<String,Order> myMapOrder = new Map<String,Order>();
                			For(Order orderTemp : listOrders){
                    			myMapOrder.put(orderTemp.CRAN_VEC_ADV_T_OrderId__c, orderTemp);
                			}			

							List<Order> myListOrder = new List<Order>();
                			Order myOrderToUpsert;

                			for(CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_OrderItem_CLS myOrderItem : myVersion.refOrderList)
                			{
								Boolean isNew;
        			            if(myMapOrder.containsKey(myOrderItem.orderNr)){
                    			    isNew = false;
                    			    myOrderToUpsert = myMapOrder.get(myOrderItem.orderNr);                			    
                    			} else {
                    				isNew = true;
                            		myOrderToUpsert = new Order();

                    			}                   			                    	
                    			
                    			//creo o actualizo orders con los datos devueltos de servicio
                    			myOrderToUpsert = completeOrder(myOrderToUpsert, oppList[0], myFinalQuote, recordId, myRecordType[0], myOrderItem,isNew);
                    			myListOrder.add(myOrderToUpsert);                
                			}						

							RootMode rootMode = new rootMode();
			                rootMode.upsertOrders(myListOrder);

			                for(Order orderToUpdate: myListOrder){
			                    orderToUpdate.CRAN_VEC_ADV_B_isService__c = false;
			                }

			                rootMode.updateOrders(myListOrder);

                		}

						// FIN DE ORDENES //

					}

					// actualizo  opportunity 

					if(resultsCalc.getOrder().personId!=null){
						String myPersonId = oppList[0].CRAN_VEC_ADV_P_Bunit__c+'_'+resultsCalc.getOrder().personId;				

						List<Contact> myContac = [SELECT Id FROM Contact WHERE CRAN_VEC_ADV_T_PersonId__c = : myPersonId];

						if(myContac!=null && myContac.size()>0){
							oppList[0].CRAN_VEC_ADV_L_PersonId__c = myContac[0].Id;
						} else oppList[0].CRAN_VEC_ADV_L_PersonId__c = null;
					}

					oppList[0].CRAN_VEC_ADV_T_RoleId__c = resultsCalc.getOrder().rolId;
					if(resultsCalc.getOrder().expiryDate!=null)
						oppList[0].CRAN_VEC_ADV_D_QuestionaryExpiryDate__c = CRAN_VEC_ADV_Utils.stringToDate(resultsCalc.getOrder().expiryDate);
					if(resultsCalc.getOrder().expired!=null)
						oppList[0].CRAN_VEC_ADV_B_Expired__c = Boolean.valueOf(resultsCalc.getOrder().expired);
					oppList[0].CRAN_VEC_ADV_B_isService__c = true;

					//actualizo el estado de la oportunidad
					oppList[0].StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_MAP.get(resultsCalc.getStatusId());

					update oppList[0];

					oppList[0].CRAN_VEC_ADV_B_isService__c = false;
					update oppList[0];					

					//fin actualizo opportunity

				}else{
					if(resultsCalc.getErrors().size()>0)
						return new ErrorResponse(resultsCalc.getErrors()[0].getCode()+' '+resultsCalc.getErrors()[0].getDesc());
					else 
						return new ErrorResponse(CRAN_VEC_ADV_Constants_CLS.EMPTY);
				}
			}else{
				return new SuccessResponse(errorDetail);
			}
		}catch(Exception e){
			System.debug('Exception: ' + e);
			return new ErrorResponse(e);
		}
    	return new SuccessResponse(errorDetail);
    }


    /**
    * Método que actualiza la informacion de todos los campos de un Order pasada como parametro
    *
    * @param Order myOrder - Orden a actulizar.
    * 
    * @param Opportunity myOp - Oportunidad de la que se saca el Account para asociar a la orden.
    * 
    * @param List<Quote> myFinalQuote - Quotes para asociar a la orden.
    * 
    * @param String recordId - Id de la Opportunity a la que se asocia la orden.
    * 
    * @param RecordType myRecordType - RecordType de la orden.
    * 
    * @param CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_OrderItem_CLS myOrderItem - CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_OrderItem_CLS.
    * 
    * @param Boolean isNew - Boolean que indica si es una orden nueva.
    * 
    * @return Order actualizada.
    */
    public static Order completeOrder(Order myOrder,Opportunity myOpp, List<Quote> myFinalQuote,String recordId,RecordType myRecordType,CRAN_VEC_ADV_DetRebalpVersionRS.CRAN_VEC_ADV_OrderItem_CLS myOrderItem,Boolean isNew){
        myOrder.Name = CRAN_VEC_ADV_Utils.subStrMaxLongi(myOrderItem.orderNr,80); //<orderNr>
        myOrder.CRAN_VEC_ADV_T_OrderId__c = myOrderItem.orderNr; //<orderNr>
        if(myOrderItem.hasRestr!=null)
            myOrder.CRAN_VEC_ADV_T_HasRestr__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(myOrderItem.hasRestr,255); //<hasRestr>
		else myOrder.CRAN_VEC_ADV_T_HasRestr__c = null;

        myOrder.CRAN_VEC_ADV_T_MetaTypeId__c = myOrderItem.metaTypeId; //<metaTypeId>
        myOrder.CRAN_VEC_ADV_P_MetaType__c = myOrderItem.metaType; //<metaType>
        myOrder.CRAN_VEC_ADV_T_TypeId__c = myOrderItem.typeId; //typeId
        myOrder.CRAN_VEC_ADV_P_Type__c = myOrderItem.type; // <type>
        myOrder.CRAN_VEC_ADV_T_OrderTypeId__c  = myOrderItem.orderTypeId; // <orderTypeId>
        myOrder.Type = myOrderItem.orderType; // <OrderType>
        myOrder.CRAN_VEC_ADV_T_AvaloqStatusId__c = myOrderItem.orderStatusId; // <orderStatusId>

        myOrder.CRAN_VEC_ADV_N_RealPrice__c = myOrderItem.realPrice; // <realPrice>
        
        if(myOrderItem.orderStatusId != null){
            String myStatusSF = CRAN_VEC_ADV_Constants_CLS.SF_STATUS_ORDER_MAP.get(myOrderItem.orderStatusId);
            if(myStatusSF!=null) myOrder.CRAN_VEC_ADV_P_SFStatus__c = myStatusSF;
            else myOrder.CRAN_VEC_ADV_P_SFStatus__c = CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_INPROCESS_ORDER;
        }

        if(myOrder.CRAN_VEC_ADV_P_SFStatus__c==null && myOrderItem.orderStatusId !=null){
            myOrder.CRAN_VEC_ADV_P_SFStatus__c = CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_INPROCESS_ORDER;
        }

        myOrder.Status = CRAN_VEC_ADV_Constants_CLS.DRAFT;                                        
        myOrder.CRAN_VEC_ADV_T_AvaloqStatus__c = myOrderItem.orderStatus; // <orderStatus>
                      
        if(myOrderItem.orderTrxDate !=null && myOrderItem.orderTrxDate !=CRAN_VEC_ADV_Constants_CLS.EMPTY) 
            myOrder.CRAN_VEC_ADV_D_TRXDate__c = CRAN_VEC_ADV_Utils.stringToDate(myOrderItem.orderTrxDate);

        myOrder.AccountId = myOpp.AccountId;
        myOrder.RecordTypeId = myRecordType.Id;
        myOrder.OpportunityId = recordId;

        myOrder.EffectiveDate = Date.today();
        if(myFinalQuote!=null && myFinalQuote.size()>0)
            myOrder.QuoteId = myFinalQuote[0].Id;
        myOrder.CRAN_VEC_ADV_B_isService__c = true;

		String myInstrGroupId = null;
		String myAssetCatId = null;

        if(myOrderItem.assetItem!=null){
        	myInstrGroupId = myOrderItem.assetItem.instrGroupId;
			myAssetCatId = myOrderItem.assetItem.assetCatId;
	        myOrder.CRAN_VEC_ADV_P_InstrGroup__c = myOrderItem.assetItem.instrGroupId;
	        myOrder.CRAN_VEC_ADV_P_CatActivo__c = myOrderItem.assetItem.assetCatId;
        }

        //chequeo si es una nueva insercion de orden para comprobar si marco o no el manualConfirm
		if(isNew){
			Boolean manualConfirm = CRAN_VEC_ADV_Utils.checkOrderManualConfirm(myOrderItem.metaType,myInstrGroupId,myAssetCatId);
        	myOrder.CRAN_VEC_ADV_B_ManualConfirm__c = manualConfirm;	
        }
     
        //Distingo entre tipo STEX Y FX
        if(myOrderItem.metaType.equals(CRAN_VEC_ADV_Constants_CLS.STEX)){
            myOrder.CRAN_VEC_ADV_N_Price__c = myOrderItem.orderPrcEstim; // <orderPrcEstim>
            myOrder.CRAN_VEC_ADV_N_Limit__c = myOrderItem.orderLimit; // <orderLimit>
            myOrder.CRAN_VEC_ADV_N_Quantity__c = myOrderItem.orderQty; // <orderQty>
            myOrder.CRAN_VEC_ADV_N_Amount__c = myOrderItem.apprxAmount; // <apprxAmount>
            myOrder.CRAN_VEC_ADV_T_AssetName__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(myOrderItem.assetItem.assetName,255); // <assetName>
           
        }else if(myOrderItem.metaType.equals(CRAN_VEC_ADV_Constants_CLS.FXTR)){
            myOrder.CRAN_VEC_ADV_N_SellAmount__c = myOrderItem.sellAmount; // <sellAmount>
            myOrder.CRAN_VEC_ADV_P_SellCurry__c = myOrderItem.sellCurry; // <sellCurry>
            myOrder.CRAN_VEC_ADV_N_BuyAmount__c = myOrderItem.buyAmount; //<buyAmount>
            myOrder.CRAN_VEC_ADV_P_BuyCurry__c = myOrderItem.buyCurry; // <buyCurry>
            myOrder.CRAN_VEC_ADV_N_xRateType__c = myOrderItem.xrateType; // <xrateType> 
            myOrder.CRAN_VEC_ADV_N_Limit__c = myOrderItem.orderLimit; // <xrateType> 
        }

        return myOrder;
    }


    /**
    * 
    * Método para obtener el nombre de la cabecera del componente que simula el related list
    *
    * @param recordId - Id del financial account sobre el que ejecutamos la funcionalidad
    * 
    * @return String a mostrar en la cabecera
    *
    */
    @AuraEnabled
	public static String showHeader(Id recordId) {        
        String sObjName  = recordId.getSObjectType().getDescribe().getName();
        String sObjLabel = recordId.getSObjectType().getDescribe().getLabel();                        
        List<sObject> sObjList = Database.query( 'SELECT Name FROM ' + sObjName + ' WHERE Id = :recordId LIMIT 1' );
        String nHeader = sObjLabel + ' ' + sObjList.get(0).get('Name');
        return nHeader;
    } 


    /**
    * 
    * Método para calcular los distintos tipos de ordenes que se muestran en columnas para una propuesta
    *
    * @param Opportunity opp - Oportunidad.
    * 
    * @param CRAN_VEC_ADV_RebalpList_RS.Proposal prop - Propuesta.
    * 
    * @return Opportunity
    *
    */
    private static Opportunity countOrderListOpp(Opportunity opp,CRAN_VEC_ADV_RebalpList_RS.Proposal prop){
    	//contador de ordenes
		Integer simulated = 0;
		Integer discarded = 0;
		Integer total = 0;
		for(CRAN_VEC_ADV_RebalpList_RS.OrderItem order : prop.refOrderList){
			if(CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_DISCARDED.equals(order.orderStatusId)){
				//orden descartada
				discarded++;
				total++;
			}else if(CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_SIMULATED.equals(order.orderStatusId)){
				//orden simulada
				simulated++;
				total++;
			}else{
				total++;
			}
		}
		opp.CRAN_VEC_ADV_N_SimulatedOrders__c = simulated;
		opp.CRAN_VEC_ADV_N_DiscardedOrders__c = discarded;
		opp.CRAN_VEC_ADV_N_TotalOrders__c = total;
		return opp;
    }

	
	/*---------------------------------------------------------*/
    /*     CLASE PARA HACER ACIONES WITHOUT SHARING METHODS    */
    /*---------------------------------------------------------*/

    
    private without sharing class RootMode{
        public void upsertOrders(List<Order> lstOrders){
            upsert lstOrders;
        }

        public void updateOrders(List<Order> lstOrders){
            update lstOrders;
        }
    }


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
	public class SuccessResponse {

		@AuraEnabled public Boolean success {get; set;}
		@AuraEnabled public SObject obj {get; set;}
		@AuraEnabled public String msj {get; set;}

		public SuccessResponse(Quote vQuo) {
			this.success = true;
			this.obj = vQuo;
		}

		public SuccessResponse(Opportunity vOpp) {
			this.success = true;
			this.obj = vOpp;
		}

		public SuccessResponse(String msj) {
			this.success = true;
			this.msj = msj;
		}
	}


	@TestVisible
	class SuccessResponseDataInvestment {

		@AuraEnabled public Boolean success {get; set;}
		@AuraEnabled public List<List<CRAN_VEC_ADV_FieldData_CLS>> lstDataInvestment {get; set;}
		@AuraEnabled public List<ChangedOpportunity> lstChangedOpportunities{get; set;}
		@AuraEnabled public ErrorResponse error{get; set;}

		public SuccessResponseDataInvestment(List<List<CRAN_VEC_ADV_FieldData_CLS>> lstDataInvestment) {
			this.success = true;
			this.lstDataInvestment = lstDataInvestment;
			this.lstChangedOpportunities = null;
		}

		public SuccessResponseDataInvestment(List<List<CRAN_VEC_ADV_FieldData_CLS>> lstDataInvestment, List<ChangedOpportunity> lstChangedOpportunities) {
			this.success = true;
			this.lstDataInvestment = lstDataInvestment;
			this.lstChangedOpportunities = lstChangedOpportunities;
			this.error = null;
		}

		public SuccessResponseDataInvestment(List<List<CRAN_VEC_ADV_FieldData_CLS>> lstDataInvestment, ErrorResponse error) {
			this.success = true;
			this.lstDataInvestment = lstDataInvestment;
			this.lstChangedOpportunities = null;
			this.error = error;
		}	
	}


	@TestVisible
	public class ErrorResponse {
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


	/*---------------------------*/
    /*   CUSTOM CLASS EXCEPTION  */
    /*---------------------------*/


    public class CustomInvestmentProposalException extends Exception {}

}