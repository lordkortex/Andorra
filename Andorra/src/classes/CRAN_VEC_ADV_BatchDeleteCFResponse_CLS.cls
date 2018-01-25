global class CRAN_VEC_ADV_BatchDeleteCFResponse_CLS implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

	String query;
	String idTemplate;
	Map<String,List<CRAN_VEC_ADV_CustomForm_Response__c>> myMap;
	List<CRAN_VEC_ADV_deleteError> lstErrors = new List<CRAN_VEC_ADV_deleteError>();

	global CRAN_VEC_ADV_BatchDeleteCFResponse_CLS(String idTemplate) {
		this.idTemplate = idTemplate;
		query = 'SELECT Id,CRAN_VEC_ADV_T_Bu_Id__c,CRAN_VEC_ADV_T_Avaloq_External_Id__c FROM CRAN_VEC_ADV_CustomForm_Response__c WHERE CRAN_VEC_ADV_P_Acceptance_Status__c = \'On Hold\' and CRAN_VEC_ADV_MD_CustomForm__c= \''+idTemplate+'\'  ALL ROWS';
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<CRAN_VEC_ADV_CustomForm_Response__c> scope) {

		try{

				myMap = new Map<String,List<CRAN_VEC_ADV_CustomForm_Response__c>>();

				for (CRAN_VEC_ADV_CustomForm_Response__c a : scope){
		            String buAvaloq = a.CRAN_VEC_ADV_T_Bu_Id__c;
		            String idExternal = a.CRAN_VEC_ADV_T_Avaloq_External_Id__c;

		            if(buAvaloq!='' && idExternal != '' && buAvaloq != null  && idExternal != null){
			            if(!myMap.containsKey(buAvaloq)){
			           		List<CRAN_VEC_ADV_CustomForm_Response__c> listTemp = new List<CRAN_VEC_ADV_CustomForm_Response__c>();
			           		listTemp.add(a);
			           		myMap.put(buAvaloq,listTemp);
			            }
			           	else{
				           		List<CRAN_VEC_ADV_CustomForm_Response__c> myList = myMap.get(buAvaloq);
				           		myList.add(a);
			           	}
		           	}
		        }

		        /////////////////////////////////////////////////
		    	////////////////BORRADO EN AVALOQ////////////////
		    	/////////////////////////////////////////////////

		        for (String keyMapBU : myMap.keySet()){
		        	List<CRAN_VEC_ADV_CustomForm_Response__c> listIdBU = myMap.get(keyMapBU);
		        	
					List<CRAN_VEC_ADV_Order_CLS> orderList = new List<CRAN_VEC_ADV_Order_CLS>();

		        	for (CRAN_VEC_ADV_CustomForm_Response__c idDiscard : listIdBU){
			        		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
			        		order.setIsNew(false);
			        		order.setOrderNr(idDiscard.CRAN_VEC_ADV_T_Avaloq_External_Id__c);
			        		orderList.add(order);
		        	}
		        	CRAN_VEC_ADV_DiscardCustomFormRQ_CLS rq = new CRAN_VEC_ADV_DiscardCustomFormRQ_CLS();
		        	////////////// ENTRADA PARAMETROS /////////////
		        	rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));
		        	rq.setOrderList(orderList);
		        	////////////// FIN ENTRADA PARAMETROS /////////////

					//LLamar servicio avaloq con los response a descartar
					String jsonRequest = JSON.serialize(rq);
				
					CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_DESCARTAR_ORDEN,keyMapBU,jsonRequest);

					CRAN_VEC_ADV_DiscardCustomFormRS_CLS rs = (CRAN_VEC_ADV_DiscardCustomFormRS_CLS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_DiscardCustomFormRS_CLS.class);

					//guardo errores de la llamada al servicio si existen
					if(rs != null && rs.getErrors()!=null){
						for (CRAN_VEC_ADV_ProcessSTError_CLS errorElement : rs.getErrors()){
							CRAN_VEC_ADV_deleteError serviceErrors = new CRAN_VEC_ADV_deleteError(); 
							serviceErrors.setErrorMessageSF('Error al llamar al servicio '+errorElement.getCode()+' '+errorElement.getDesc());
							lstErrors.add(serviceErrors);
						}
					}								
		    	}

    	}catch(Exception e){

  			String errorMessageServ = 'Error deteted executing batch delete'+e.getMessage();
    		sendEmailError('maguado@vectoritcgroup.com',errorMessageServ,'');
    	}	

	}



		global void finish(Database.BatchableContext BC) {
			// Generar mail y enviar.
			String errorMessageService = '';

			for(CRAN_VEC_ADV_deleteError error : lstErrors)
				errorMessageService = error.getErrorMessageSF()+' '+errorMessageService;
			errorMessageService = errorMessageService+'';						

			if(errorMessageService!=''){
				List<User> myUser =  [SELECT Alias,Email,Id,ProfileId FROM User where alias = :'cando'];
				if(myUser!=null && myUser.size()>0)
					sendEmailError(myUser[0].Email,errorMessageService,'');
			}

		}


		@TestVisible
		class CRAN_VEC_ADV_deleteError {
			public ID idSalesforce;
			public String idAvaloqOrder;
			public String errorMessageAvaloq;
			public String errorMessageSF;
		
			public ID getIdSalesforce(){
				return idSalesforce;
			}

			public void setIdSalesforce(ID idSalesforce){
				this.idSalesforce = idSalesforce;
			}

			public String getIdAvaloqOrder(){
				return idAvaloqOrder;
			}

			public void setIdAvaloqOrder(String idAvaloqOrder){
				this.idAvaloqOrder = idAvaloqOrder;
			}			

			public String getErrorMessageAvaloqr(){
				return errorMessageAvaloq;
			}

			public void setErrorMessageAvaloq(String errorMessageAvaloq){
				this.errorMessageAvaloq = errorMessageAvaloq;
			}		

			public String getErrorMessageSF(){
				return errorMessageSF;
			}

			public void setErrorMessageSF(String errorMessageSF){
				this.errorMessageSF = errorMessageSF;
			}	

		}

		private static void sendEmailError(String email, String errorMessage, String templateId) {

			String htmlBody = 'Error: {!errorMessage}';
			String plainBody = 'Error: {!errorMessage}';
			List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

			List<EmailTemplate> emailTemplates = [select Id, Subject, HtmlValue, Body from EmailTemplate where Id = : templateId];
			if (emailTemplates.size() > 0) {
				htmlBody = emailTemplates[0].HtmlValue;
				plainBody = emailTemplates[0].Body;
			}

			htmlBody = htmlBody.replace('{!errorMessage}', errorMessage);
			plainBody = plainBody.replace('{!errorMessage}', errorMessage);

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

			List<String> sendTo = new List<String>();
			sendTo.add(email);
			mail.setToAddresses(sendTo);
			mail.setSenderDisplayName('Integration Avaloq - Salesforce');
			mail.setSubject('Error AvaloqCreateFiles_SCH - ' + Datetime.now().format('yyyy-MM-dd HH:mm:ss'));

			mail.setHtmlBody(htmlBody);
			mail.setPlainTextBody(plainBody);

			mails.add(mail);
			Messaging.SendEmailResult[] resultsError = Messaging.sendEmail(mails,false);
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
		}

	}