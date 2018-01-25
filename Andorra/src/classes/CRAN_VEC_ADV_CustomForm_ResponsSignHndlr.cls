/**
* Handles DocuSign's ceremony to a custom form
*
* @author Luís Velasco
* @author Zuinglio Lopes Ribeiro Júnior
* @version 1.0
* @version 2.0
*/
public with sharing class CRAN_VEC_ADV_CustomForm_ResponsSignHndlr extends CRAN_VAS_KER_SignatureHandlerBase {
	
    /** Bus instance to handle calls to Avaloq services */	
	private CRAN_VAS_KER_BusHandler bus;
	
    /**
    * Method that creates a DocuSign envelope and returns a URL to start a ceremony
    * @param objectId sObject Id    
    * @return URL to start a ceremony
    */	
	public override String getSignatureUrl(String objectId) {

        // Starting event log
		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_DocuSignCeremony', CRAN_VEC_ADV_CustomForm_ResponsSignHndlr.class.getName());
		String url;

		try {

			CRAN_VAS_KER_DocusignAPIMngr manager = CRAN_VAS_KER_DocusignAPIMngr.getInstance();
			bus = new CRAN_VAS_KER_BusHandler();
			
			CRAN_VEC_ADV_CustomForm_Response__c customForm = [SELECT Id,																 
			 														 CRAN_VEC_ADV_L_Business_Partner__c,
																	 CRAN_VEC_ADV_L_Business_Partner__r.CRAN_VEC_ADV_N_Number__c, // BP ID for Archival
																	 CRAN_VEC_ADV_L_Business_Partner__r.CRAN_VEC_ADV_P_Bunit__c, // BU for Archival
																	 CRAN_VEC_ADV_L_Contact__c,																 
																	 CRAN_VEC_ADV_L_Contact__r.Name, // Client's name
																	 CRAN_VEC_ADV_L_Contact__r.Email, // Client's E-mail
																	 CRAN_VEC_ADV_L_Contact__r.AccountId, // Client's Account Id																 
																	 CRAN_VEC_ADV_L_Contact__r.MobilePhone,
																	 CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_N_NumericSort__c, // Person Id for Archival	
																	 CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_P_Language__c,
																	 CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_T_EBContract__c,
																	 CRAN_VEC_ADV_T_Avaloq_External_Id__c  //Número de orden 
							   								  FROM CRAN_VEC_ADV_CustomForm_Response__c
							   								  WHERE Id = :objectId];

			if (customForm.CRAN_VEC_ADV_T_Avaloq_External_Id__c == null) {

	            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Label.CRAN_VAS_KER_CustomFormAvaloqIdNull, CRAN_VEC_ADV_CustomForm_Response__c.sObjectType.getDescribe().getLabel(), 
	                CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10010.name());

	            throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
	                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10010.name()
	            })); 

			}						   								  

	       // First Signer data (Customer)
	        CRAN_VAS_KER_DocuSignEnvelope_CLS.InPersonSigner inPersonSigner = new CRAN_VAS_KER_DocuSignEnvelope_CLS.InPersonSigner();
	        // Non-void ClientUserId sets the embedded recipient as captive, suppressing the email notification
	        inPersonSigner.clientUserId = customForm.CRAN_VEC_ADV_L_Contact__c;
	        inPersonSigner.hostEmail = UserInfo.getUserEmail();
	        inPersonSigner.hostName = UserInfo.getName();
	        inPersonSigner.recipientId = '1';
	        inPersonSigner.roleName = 'Signer 1';
	        inPersonSigner.routingOrder = '1';
	        inPersonSigner.signerEmail = customForm.CRAN_VEC_ADV_L_Contact__r.Email;
	        inPersonSigner.signerName = customForm.CRAN_VEC_ADV_L_Contact__r.Name;

	        // First Signer Email Notification settings    
	        inPersonSigner.emailNotification = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientEmailNotification();
	        inPersonSigner.emailNotification.emailSubject = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_AccountSignEmailSubject', 
                                                            customForm.CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_P_Language__c);
	        inPersonSigner.emailNotification.emailBody = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_AccountSignEmailBody', 
                                                            customForm.CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_P_Language__c);
	        inPersonSigner.emailNotification.supportedLanguage = CRAN_VAS_KER_SignatureUtils.getDocusignLanguage(customForm.CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_P_Language__c);        
	        
	        // Fisrt Signer SBS - EU Avanced Signature
	        CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider signatureProvider = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider();
	        signatureProvider.signatureProviderName = CRAN_VAS_KER_SignatureUtils.SBS_PROVIDER_NAME;
	        signatureProvider.signatureProviderOptions = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProviderOptions();
	        signatureProvider.signatureProviderOptions.sms = CRAN_VAS_KER_SignatureUtils.buildString4Phones(customForm.CRAN_VEC_ADV_L_Contact__r.MobilePhone, customForm.CRAN_VEC_ADV_L_Contact__r.Name);
			inPersonSigner.recipientSignatureProviders = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider>();        
	        inPersonSigner.recipientSignatureProviders.add(signatureProvider);

	        // Adds a tab that indicates to DocuSign where the recipient must sign
	        inPersonSigner.tabs = new CRAN_VAS_KER_DocuSignEnvelope_CLS.Tabs();
	        CRAN_VAS_KER_DocuSignEnvelope_CLS.SignHere signHereTab = new CRAN_VAS_KER_DocuSignEnvelope_CLS.SignHere();
	        signHereTab.anchorIgnoreIfNotPresent = 'false';
	        signHereTab.anchorString = '\\s1\\';
	        signHereTab.anchorUnits = 'inches';
	        signHereTab.anchorXOffset = '0';
	        signHereTab.anchorYOffset = '0';
	        inPersonSigner.tabs.signHereTabs = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.SignHere>();
	        inPersonSigner.tabs.signHereTabs.add(signHereTab);

	        // Envelope
	        CRAN_VAS_KER_DocuSignEnvelope_CLS envelope = new CRAN_VAS_KER_DocuSignEnvelope_CLS();
	        envelope.status = 'sent';

	        // Adds the InPersonSigner to the envelope
	        envelope.recipients = new CRAN_VAS_KER_DocuSignEnvelope_CLS.Recipients();
	        envelope.recipients.inPersonSigners = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.InPersonSigner>();         
	        envelope.recipients.inPersonSigners.add(inPersonSigner);

	        // Sets record information so DocuSign attach the signed document to it
	        CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField textCustomField = new CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField();
	        textCustomField.name = '##SFAccount';
	        textCustomField.required = 'false';
	        textCustomField.show = 'false';
	        textCustomField.value = customForm.CRAN_VEC_ADV_L_Business_Partner__c;
	        
	        // Adds the custom fields information to the Inline Template
	        envelope.customFields = new CRAN_VAS_KER_DocuSignEnvelope_CLS.CustomFields();
	        envelope.customFields.textCustomFields = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField>();          
	        envelope.customFields.textCustomFields.add(textCustomField);

	        // Retrieves and set the base64 document that will be signed
			String omsId = getDocumentId(customForm.CRAN_VEC_ADV_T_Avaloq_External_Id__c);

	        envelope.documents = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.Document>();
	        CRAN_VAS_KER_DocuSignEnvelope_CLS.Document document = new CRAN_VAS_KER_DocuSignEnvelope_CLS.Document();
	        document.documentBase64 = getBase64Document(omsId);
	        document.documentId = '1';
	        document.fileExtension = 'pdf';
	        document.name = System.Label.CRAN_VAS_KER_AccountSignFileName + customForm.CRAN_VEC_ADV_T_Avaloq_External_Id__c + '.pdf';
	        envelope.documents.add(document);

	        // Sets envelope Event Notification that defines in which stages DocuSign will trigger an update to SFDC
	        envelope.eventNotification = new CRAN_VAS_KER_DocuSignEnvelope_CLS.EventNotification();
	        envelope.eventNotification.recipientEvents = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientEvent>();
	        envelope.eventNotification.envelopeEvents = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.EnvelopeEvent>();        
	        
	        for (String eventStatus : CRAN_VAS_KER_SignatureUtils.DOCUSIGN_EVENTS) {
	            
	            CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientEvent recipientEvent = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientEvent();
	            recipientEvent.recipientEventStatusCode = eventStatus;
	            
	            envelope.eventNotification.recipientEvents.add(recipientEvent);
	            
	            CRAN_VAS_KER_DocuSignEnvelope_CLS.EnvelopeEvent envelopeEvent = new CRAN_VAS_KER_DocuSignEnvelope_CLS.EnvelopeEvent();
	            envelopeEvent.envelopeEventStatusCode = eventStatus;
	            
	            envelope.eventNotification.envelopeEvents.add(envelopeEvent);            
	        }

			manager.userLogin();
	        
			String envelopeId = manager.createEnvelope(envelope);
			
			url = manager.getUrlForEnvelope(envelopeId, inPersonSigner.hostName, inPersonSigner.hostEmail, 
													inPersonSigner.clientUserId, inPersonSigner.recipientId, customForm.CRAN_VEC_ADV_L_Business_Partner__c);
			
			List<CRAN_VAS_KER_ESignature__c> eSignList = new List<CRAN_VAS_KER_ESignature__c>();		
			
			CRAN_VAS_KER_MetadataResponse metadata = bus.getArchivalMetadata(customForm.CRAN_VEC_ADV_T_Avaloq_External_Id__c);
			metadata.orderList.order.metadaTypeName = 'Questionnaire SF'; 
	        metadata.orderList.order.metadaTypeId= 'QUESTR'; 					

			CRAN_VAS_KER_ESignature__c eSign = new CRAN_VAS_KER_ESignature__c();
			eSign.CRAN_VAS_KER_Start_Date__c = System.now();
			eSign.CRAN_VAS_KER_File_Name__c = 'Envelope ' + envelopeId + '.pdf';
			eSign.CRAN_VAS_KER_Account__c = customForm.CRAN_VEC_ADV_L_Business_Partner__c;
			eSign.CRAN_VAS_KER_Client__c = customForm.CRAN_VEC_ADV_L_Contact__r.AccountId;
			eSign.CRAN_VAS_KER_Signature_Id__c = envelopeId;
			eSign.CRAN_VAS_KER_Document_Id__c = omsId;
			eSign.CRAN_VAS_KER_Core_Id__c = customForm.CRAN_VEC_ADV_T_Avaloq_External_Id__c;
			eSign.CRAN_VAS_KER_Reference_Line__c = customForm.CRAN_VEC_ADV_L_Business_Partner__c + '.1.' + System.now().getTime();
			eSign.CRAN_VAS_KER_Person_Id__c = customForm.CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_N_NumericSort__c;
			eSign.CRAN_VAS_KER_Client_Name__c = customForm.CRAN_VEC_ADV_L_Contact__r.Name;
			eSign.CRAN_VAS_KER_BP_Id__c = customForm.CRAN_VEC_ADV_L_Business_Partner__r.CRAN_VEC_ADV_N_Number__c;
			eSign.CRAN_VAS_KER_BU_Id__c = customForm.CRAN_VEC_ADV_L_Business_Partner__r.CRAN_VEC_ADV_P_Bunit__c;

	        if (String.isNotBlank(customForm.CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_T_EBContract__c)
	            && !customForm.CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_T_EBContract__c.contains(';'))
	            eSign.CRAN_VAS_KER_T_ContractId__c = customForm.CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_T_EBContract__c;

			String metadataXML = CRAN_VAS_KER_SignatureUtils.buildArchivalXMLFromMetadata(metadata, eSign);
			eSign.CRAN_VAS_KER_Sent_XML__c = metadataXML;
			eSign.CRAN_VAS_KER_Signature_Type__c = 'Form';
			eSign.CRAN_VAS_KER_P_DocumentType__c = 'Envelope';
			
			eSignList.add(eSign);
			
			CRAN_VAS_KER_ESignature__c certificate = eSign.clone(false, true, false, false);
			certificate.CRAN_VAS_KER_File_Name__c = 'Certificate ' + envelopeId + '.pdf';
			certificate.CRAN_VAS_KER_Reference_Line__c = customForm.CRAN_VEC_ADV_L_Business_Partner__c + '.2.' + System.now().getTime();
			metadataXML = CRAN_VAS_KER_SignatureUtils.buildArchivalXMLFromMetadata(metadata, certificate);		
			certificate.CRAN_VAS_KER_Sent_XML__c = metadataXML;	
			certificate.CRAN_VAS_KER_P_DocumentType__c = 'Certificate';

			eSignList.add(certificate);

	        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Database.insert(eSignList, false), 
	            CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel());

	    } catch (Exception ex) {

            String errorMsg = ex.getMessage();

            if (String.isNotBlank(errorMsg) && !errorMsg.contains('CRAN_ERR_')) {
                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, null, CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10013.name());
                ex.setMessage(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                        CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10013.name()
                }));    
            }

	    	CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VEC_ADV_CustomForm_ResponsSignHndlr.class.getName());
	    	throw ex;
	    }   

		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VEC_ADV_CustomForm_ResponsSignHndlr.class.getName());                 		

		return url;
	}
	
    /**
    * Method that retrieves an OMS Id for a merged PDF
    * @param bUnit business unit
    * @return OMS Id
    */      	
	private String getDocumentId(String id) {			
		return bus.printOMSDoc(id);
	}
	
    /**
    * Method that retrieves a base64 PDF string
    * @param documentId OMS Id
    * @return base64 pdf
    */     	
	private String getBase64Document(String id) {			
		return bus.getBase64DocumentFromService(id);
	}
}