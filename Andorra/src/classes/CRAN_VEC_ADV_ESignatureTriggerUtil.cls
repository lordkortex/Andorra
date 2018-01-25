/**
 * CRAN_VEC_ADV_ESignature Trigger Util Class
 *
 * Fecha: 13/06/2017
 * @author  Javier Touchard Vicente (Vector ITC)
 * @version 1.3
 * Add OrgWideEmailAddress
 *
*/
public without sharing class CRAN_VEC_ADV_ESignatureTriggerUtil {

	/**
    * 
    * Método que gestiona los objetos relacionados con el Electronic Signature.
    * Si el objeto relacionado es una oportunidad y si el Electronic Signature ha cambiado de un estado In Progress a un estado
    * Sent to Archive y es del tipo 'proposal se llama a un método auxiliar para que pase la oportunidad a un estado advDone. Si 
    * el del tipo 'order' llamara al servicio OrderConfirm para confirmar las ordenes asociadas a la oportunidad. Si el ESignature
    * va asociado a un form y cambia de estado a sent to archive se pasa el CRAN_VEC_ADV_CustomForm_Response__c a signed.
    *
    * @param List<CRAN_VAS_KER_ESignature__c> listNew - Lista de los ESignature modificados.
    *
    * @param List<CRAN_VAS_KER_ESignature__c> listOld - Lista de los ESignature antes de modificar.
    * 
    * @return void
    *
    */
	public static void gestionObjetosRelacionados(List<CRAN_VAS_KER_ESignature__c> listNew, List<CRAN_VAS_KER_ESignature__c> listOld){

		System.debug('------ENTRA A GESTIONOBJETOSRELACIONADOS------');

		Set<Id> setIdsOpportunity = new set<id>();
		Map<Id, Id> mapObIdTargetId = new Map<Id, Id>();
		Set<Id> setOrdersIds = new Set<Id>();
		List<Order> orderList =  new List<Order>();
		Map<Id, String> mapOrderReferenceLine = new Map<Id, String>(); 
		Set<String> setIdsForm = new Set<String>();

		for(Integer i = 0; i < listNew.size(); i++){
			if(listNew[i].CRAN_VAS_KER_File_Name__c.contains('Envelope')){

				if(listNew[i].CRAN_VAS_KER_Opportunity__c != null && listNew[i].CRAN_VAS_KER_Signature_Type__c == 'Proposal' 
					&& listOld[i].CRAN_VAS_KER_Status__c == 'In Progress' && listNew[i].CRAN_VAS_KER_Status__c == 'Sent to Archive'){
					setIdsOpportunity.add(listNew[i].CRAN_VAS_KER_Opportunity__c);
					mapObIdTargetId.put(listNew[i].CRAN_VAS_KER_Opportunity__c, listNew[i].OwnerId);
				}

				if(listNew[i].CRAN_VAS_KER_Order__c != null && listNew[i].CRAN_VAS_KER_Signature_Type__c == 'Order' 
					&& listOld[i].CRAN_VAS_KER_Status__c == 'In Progress' && listNew[i].CRAN_VAS_KER_Status__c == 'Sent to Archive'){
					setOrdersIds.add(listNew[i].CRAN_VAS_KER_Order__c);
					mapOrderReferenceLine.put(listNew[i].CRAN_VAS_KER_Order__c, listNew[i].CRAN_VAS_KER_Reference_Line__c);
					mapObIdTargetId.put(listNew[i].CRAN_VAS_KER_Order__c, listNew[i].OwnerId);
				}

				if(ListNew[i].CRAN_VAS_KER_Core_Id__c != null && listNew[i].CRAN_VAS_KER_Signature_Type__c == 'Form' 
					&& listOld[i].CRAN_VAS_KER_Status__c == 'In Progress' && listNew[i].CRAN_VAS_KER_Status__c == 'Sent to Archive'){
					setIdsForm.add(listNew[i].CRAN_VAS_KER_Core_Id__c);
				}

			}
			
		}

		if(!setIdsOpportunity.isEmpty()){
			Set<Id> oppIdsCall = new Set<Id>();
			for(Id idOpp : setIdsOpportunity){
				oppIdsCall.add(idOpp);
				if(oppIdsCall.size() == 10){
					closeOpps(oppIdsCall, mapObIdTargetId);					
					oppIdsCall.clear();
				}
			}

			if(oppIdsCall.size() > 0){
					closeOpps(oppIdsCall, mapObIdTargetId);				
			}
		}

		if(!setOrdersIds.isEmpty()){
			orderList = ObtainOrders(setOrdersIds);	
			if(!orderList.isEmpty()){
				updateOrder(orderList, mapOrderReferenceLine);
			    setOrderConfirm(orderList, mapObIdTargetId);
			}
		}

		if(!setIdsForm.isEmpty()){
			List<CRAN_VEC_ADV_CustomForm_Response__c>  myListResponse = [SELECT Id FROM CRAN_VEC_ADV_CustomForm_Response__c WHERE 
																			CRAN_VEC_ADV_T_Avaloq_External_Id__c  IN: setIdsForm];
																			
			if(myListResponse!=null && myListResponse.size()>0){
				for(CRAN_VEC_ADV_CustomForm_Response__c temp : myListResponse){
					temp.CRAN_VEC_ADV_P_Acceptance_Status__c = CRAN_VEC_ADV_Constants_CLS.SIGNED;					
				}
				CRAN_VEC_ADV_Utils.updateSOs(myListResponse);
			}
		}		

	}



	/**
    * 
    * Método que encola el servicio 'SERVICE_CLOSE_OPORTUNIDAD'. Recupera las oportunidades asociadas a los Ids 
    * que le entra por por parámetro y que además tiene el record type = 'Investment Proposition' y 
    * posteriormente llama al servicio.
    *
    * @param  set<Id> - Ids de las oportunidades a cerrar.
    *
    * @param  Map<Id, Id> mapObIdTargetId - Mapa que relaciona las oportunidades con el gestor de la oportunidad.
    * 
    * @return void
    *
    */	
	public static void closeOpps(set<Id> OppIds, Map<Id, Id> mapObIdTargetId){

		List<Opportunity> listOportunidades = [SELECT Id, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c, Name, FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c 
		                                        FROM Opportunity 
		                                        WHERE Id IN: OppIds 
		                                        AND RecordType.DeveloperName = :CRAN_VEC_ADV_Constants_CLS.CRAN_VEC_ADV_OPP_INVT_PROP];


		if(!listOportunidades.isEmpty()){
			for(Opportunity opp : listOportunidades){
				ID jobToMoveId = System.enqueueJob(new CRAN_VEC_ADV_CloseOpp(opp, mapObIdTargetId.get(opp.Id)));
			}
		}
	}	


	/**
    * 
    * Método auxiliar que guarda los errores en la oportunidad.
    *
    * @param  String errorMessage - Mensaje del error.
    *
    * @param  String errorCode - Código del error.
    *
    * @param  Opportunity opp - Oportunidad a actualizar.
    * 
    * @return void
    *
    */
	public static void updateOpportunityError(String errorMessage, String errorCode, Opportunity opp, List<CRAN_VEC_ADV_ProcessSTError_CLS > errors){

		String errorMessages;
		String errorCodes;

		if(errorMessage != null){
			errorMessages = errorMessage;
		}

		if(errorCode != null){
			errorCodes =  errorCode;
		}

		if(errors != NULL && errors.size() > 0){

			errorMessages = '';
			errorCodes = '';

			for(CRAN_VEC_ADV_ProcessSTError_CLS error : errors){
				errorMessages = errorMessages + error.getDesc() + ';';
				errorCodes = errorCodes + error.getCode() + ';';
			}
		}

		opp.CRAN_VEC_ADV_B_IsService__c = true;
		opp.CRAN_VEC_ADV_HasError__c = true;
	    opp.CRAN_VEC_ADV_ErrorCode__c = errorCodes;
	    opp.CRAN_VEC_ADV_ErrorDescription__c = errorMessages;
	    opp.CRAN_VEC_ADV_ErrorDatetime__c = System.today();
	    update opp;
	    opp.CRAN_VEC_ADV_B_IsService__c = false;
	    update opp;

	}



	/**
    * 
    * Método que encola el servicio 'SERVICE_ORDER_CONFIRM'.
    *
    * @param  List<Order> - Órdenes a confirmar.
    *
    * @param  Map<Id, Id> mapObIdTargetId - Mapa que relaciona las ordenes con el gestor de la oportunidad.
    * 
    * @return void
    *
    */ 	
	public static void setOrderConfirm(List<Order> orderList, Map<Id, Id> mapObIdTargetId) {

		if(!orderList.isEmpty()){
			ID jobToMoveId = System.enqueueJob(new CRAN_VEC_ADV_OrderConfirm(orderList, mapObIdTargetId));
		}

	}

	
	/**
    * 
    * Método auxiliar que actualiza las ordenes.
    *
    * @param  List<Order> listOrders - Órdenes a actualizar.
    *
    * @param  Map<Id, String> mapOrderReferenceLine - referenceLine.
    * 
    * @return void
    *
    */
	public static void updateOrder(List<Order> listOrders, Map<Id, String> mapOrderReferenceLine){		

		if(!listOrders.isEmpty() && mapOrderReferenceLine!=null){

			for(Order order : listOrders){
				order.CRAN_VEC_ADV_B_Signed__c  = true;
				order.CRAN_VEC_ADV_ReferenceLine__c = mapOrderReferenceLine.get(order.Id);	
			}

			update listOrders;

	    }
    }


    /**
    * 
    * Método auxiliar que guarda los errores en la orden.
    *
    * @param  String errorMessage - Mensaje del error.
    *
    * @param  Map<String, Order> - Mapa de órdenes a actualizar.
    * 
    * @param  Boolean concatenarErrores - Booleano que indica si hay que concatenar los errores.
    * 
    * @return void
    *
    */
	public static void updateOrderError(String errorMessage, Map<String, Order> mapOrders, Boolean concatenarErrores){

		List<Order> listaOrdenes = new List<Order>();

		if(mapOrders != null && !mapOrders.isEmpty()){
			String errorMessages;

			if(errorMessage != null){
				errorMessages = errorMessage;
			}

			
			for(String clave : mapOrders.keySet()){
				if(errorMessage == null){
                    mapOrders.get(clave).CRAN_VEC_ADV_HasError__c = false;
                    mapOrders.get(clave).CRAN_VEC_ADV_ErrorDatetime__c = null;
					mapOrders.get(clave).CRAN_VEC_ADV_ErrorDescription__c = '';
					mapOrders.get(clave).CRAN_VEC_ADV_B_ExecuteToConfirm__c = false;
					mapOrders.get(clave).CRAN_VEC_ADV_B_Execute__c = false;
				}else{
					mapOrders.get(clave).CRAN_VEC_ADV_HasError__c = true;
					mapOrders.get(clave).CRAN_VEC_ADV_ErrorDatetime__c = System.today();
					if(concatenarErrores){
						mapOrders.get(clave).CRAN_VEC_ADV_ErrorDescription__c += errorMessages + ' ';
					}else{
						mapOrders.get(clave).CRAN_VEC_ADV_ErrorDescription__c = errorMessages + ' ';
					}					
				}			        
		        listaOrdenes.add(mapOrders.get(clave));
			}
		}

		update listaOrdenes;

	}


	/**
    * 
    * Método auxiliar que guarda los errores en la orden(Colas).
    *
    * @param  String errorMessage - Mensaje del error.
    * 
    * @param  Map<String, Order> mapOrders - Mapa de órdenes a actualizar.
    * 
    * @param  Map<String, Order> mapOrdersOk - Mapa de órdenes a actualizar.
    * 
    * @param  Boolean concatenarErrores - Booleano que indica si hay que concatenar los errores.
    *
    * @return void
    *
    */
	public static void updateOrderErrorJob(String errorMessage, Map<String, Order> mapOrders, Map<String, Order> mapOrdersOk, Boolean concatenarErrores){

		List<Order> listaOrdenes = new List<Order>();

		if(mapOrders != null && !mapOrders.isEmpty()){			
			for(String clave : mapOrders.keySet()){
                mapOrders.get(clave).CRAN_VEC_ADV_HasError__c = true;
				mapOrders.get(clave).CRAN_VEC_ADV_ErrorDatetime__c = System.today();
				if(concatenarErrores){
					mapOrders.get(clave).CRAN_VEC_ADV_ErrorDescription__c += errorMessage + ' ';
				}else{
					mapOrders.get(clave).CRAN_VEC_ADV_ErrorDescription__c = errorMessage + ' ';
				}										        
		        listaOrdenes.add(mapOrders.get(clave));
			}			    		    
		}

		if(mapOrdersOk != null && !mapOrdersOk.isEmpty()){			
			for(String clave : mapOrdersOk.keySet()){
				mapOrdersOk.get(clave).CRAN_VEC_ADV_HasError__c = false;
                mapOrdersOk.get(clave).CRAN_VEC_ADV_ErrorDatetime__c = null;
				mapOrdersOk.get(clave).CRAN_VEC_ADV_ErrorDescription__c = '';
				mapOrdersOk.get(clave).CRAN_VEC_ADV_B_ExecuteToConfirm__c = false;
				mapOrdersOk.get(clave).CRAN_VEC_ADV_B_Execute__c = false;						        
		        listaOrdenes.add(mapOrdersOk.get(clave));
			}			    		    
		}
		update listaOrdenes;
	}


	/**
    * 
    * Método auxiliar para mandar una notificación cuando el servicio devuelve errores.
    *
    * @param  List<String> objectIds - Lista de ids de ordenes que se han confirmado correctamente.
    *
    * @param  String errors - Mensaje del error.
    *
    * @param  Boolean isProposal - True se trata de una opportunity, False se trata de ordenes.
    *
    * @param  List<CRAN_VEC_ADV_ProcessSTError_CLS> errorsObs - Lista de objetos CRAN_VEC_ADV_ProcessSTError_CLS que devuelve el servicio orderConfirm cuando alguna orden no se ha confirmado correctamente.
    *
    * @param  String opName - Nombre de la Oportunidad.
    *
    * @param  Id targetId - Id de la persona a la que se manda el mensaje.
    * 
    * @param  String fAFullName - Nombre completo del financial Account.
    * 
    * @return void
    *
    */
	public static void sendNotifications(List<String> objectIds,  String errors, Boolean isProposal, List<CRAN_VEC_ADV_ProcessSTError_CLS> errorsObs, String opName, Id targetId, String fAFullName){
		
		System.debug('------ENTRA A SENDNOTIFICATION------ objectIds: ' + objectIds + ', errors: ' + errors + ', isProposal: ' + isProposal + ', errorsObs:' 
			          + errorsObs + ', opName: ' + opName + ', targetId: ' + targetId + ', fAFullName: ' + fAFullName);

        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Interface_Email'];
        
		String subject = '';
        String plainBody = '';
        String htmlValue = '';
        List<Messaging.SingleEmailMessage>messages;
        List<EmailTemplate>templates;
        Boolean sendMessage = false;

        if (isProposal) {

        	if (UserInfo.getLanguage().equalsIgnoreCase('es')) {
        		templates = [SELECT Id, DeveloperName, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'CRAN_VEC_ADV_CloseOpportunityErrorHtml_es'];
        	} else {
        		templates = [SELECT Id, DeveloperName, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'CRAN_VEC_ADV_CloseOpportunityErrorHtml'];
        	}

        	if(templates != null && !templates.isEmpty()){
				messages = new List<Messaging.SingleEmailMessage>();
				subject = templates[0].Subject;
	            plainBody = templates[0].Body;
	            htmlValue = templates[0].HtmlValue;            
	            plainBody = plainBody.replace('{!Opportunity.Name}', opName); 
	            htmlValue = htmlValue.replace('{!Opportunity.Name}', opName);          
	            plainBody = plainBody.replace('{Error}', errors);
	            htmlValue = htmlValue.replace('{Error}', errors);
	            plainBody = plainBody.replace('{!FAFullName}', fAFullName);
	            htmlValue = htmlValue.replace('{!FAFullName}', fAFullName);
	            subject = subject.replace('{!Opportunity.Name}', opName);
	            sendMessage = true;
	        }

        } else {

        	if (UserInfo.getLanguage().equalsIgnoreCase('es')) {
        		templates = [SELECT Id, DeveloperName, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'CRAN_VEC_ADV_OrderConfirmErrorHTML_es'];
        	} else {
        		templates = [SELECT Id, DeveloperName, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'CRAN_VEC_ADV_OrderConfirmErrorHTML'];
        	}

			if(templates != null && !templates.isEmpty()){
				messages = new List<Messaging.SingleEmailMessage>();
				subject = templates[0].Subject;
	            plainBody = templates[0].Body;
	            htmlValue = templates[0].HtmlValue;
	            htmlValue = htmlValue.replace('{opName}', opName);
	            plainBody = plainBody.replace('{opName}', opName);
	            htmlValue = htmlValue.replace('{!FAFullName}', fAFullName);
	            plainBody = plainBody.replace('{!FAFullName}', fAFullName);

	            if(objectIds == null){
	            	plainBody = plainBody.replace('{!Order.Name}', Label.CRAN_VEC_ADV_NoOrderConfirmedCorrectly);
	            	htmlValue = htmlValue.replace('{!Order.Name}', '<LI> ' + Label.CRAN_VEC_ADV_NoOrderConfirmedCorrectly);

	            }else{
	            	String orderHtml = '';
	            	String orderPT = '';
	            	for(String orOk : objectIds){
	            		orderHtml += '<LI> ' + orOk;
	            		orderPT += orOk + ' ,';
	            	}
	            	orderPT = orderPT.substringBeforeLast(',') + '.';
	            	plainBody = plainBody.replace('{!Order.Name}', orderPT);
	            	htmlValue = htmlValue.replace('{!Order.Name}', orderHtml);
	            }

	            if(errorsObs != null){
	            	String errorsSL = '';
		            for(CRAN_VEC_ADV_ProcessSTError_CLS error : errorsObs){
		            	errorsSL += '<LI> ' + error.getCode() + ' - ' + error.getDesc();
		            }	            
		            plainBody = plainBody.replace('{!Order.CRAN_VEC_ADV_ErrorDescription__c}', errors);
		            htmlValue = htmlValue.replace('{!Order.CRAN_VEC_ADV_ErrorDescription__c}', errorsSL);	            	
	            }else{
	            	plainBody = plainBody.replace('{!Order.CRAN_VEC_ADV_ErrorDescription__c}', errors);
		            htmlValue = htmlValue.replace('{!Order.CRAN_VEC_ADV_ErrorDescription__c}', '<LI> ' + errors);
	            }

	            sendMessage = true;
	        }
        }

        if (sendMessage) {
            
			// If there is not org wide email address, throws an exception
            if (owea.isEmpty())
                throw new EmailHelperException('Org-Wide Address display name Interface_Email has not been found.');
            
	        Messaging.SingleEmailMessage message = New Messaging.SingleEmailMessage();
		    message.setTargetobjectId(targetId);
		    message.setsubject(subject);
		    message.setPlainTextBody(plainBody);
            message.setOrgWideEmailAddressId(owea[0].Id);
		    if(htmlValue != ''){
		    	message.setHtmlBody(htmlValue);
		    }		    
		    message.setSaveAsActivity(false);                   
		    messages.add(message);
		    System.debug('mensaje: ' + message);
	            
	        Messaging.SendEmailResult[] resultsError = Messaging.sendEmail(messages, false);
	        for(Messaging.SendEmailResult ser:resultsError){
	            if(!ser.isSuccess()){
	                System.debug('Error sending Mail.');
	                for( Messaging.SendEmailError err:ser.getErrors()){
	                    System.debug('Message: ' + err.getMessage());
	                    System.debug('Code: ' + err.getStatusCode());
	                    System.debug('TargetObjectId: ' + err.getTargetObjectId());
	                }
	            }
	        }
	        
	        sendMessage = false;   	
        }
		
	}


	
    /**
    * 
    * Método auxiliar que recupera las ordenes asociadas a la oportunidad.
    *
    * @param  Id oppId - Id de la oportunidad a la que están asociadas las órdenes.
    * 
    * @return List<Order>
    *
    */
	public static List<Order> ObtainOrders(Set<Id> setOrderIds){
		return [SELECT Id,	CRAN_VEC_ADV_T_OrderId__c, Opportunity.Name, Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c, 
		               OpportunityId, CRAN_VEC_ADV_B_ManualConfirm__c, CRAN_VEC_ADV_ErrorDescription__c
		         FROM Order 
		         WHERE Id =: setOrderIds
		          AND CRAN_VEC_ADV_F_WaitSign__c = true AND CRAN_VEC_ADV_B_ExecuteToConfirm__c = true 
		          AND RecordType.DeveloperName = :CRAN_VEC_ADV_Constants_CLS.CRAN_VEC_ADV_ORDER_INVT_PROP
		        ];
    }
    
    private class EmailHelperException extends Exception {}


}