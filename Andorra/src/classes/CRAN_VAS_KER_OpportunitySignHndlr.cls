/**
* Handles DocuSign's ceremony to an opportunity
*
* @author Luís Velasco
* @author Zuinglio Lopes Ribeiro Júnior
* @version 1.0
* @version 2.0
*/
public class CRAN_VAS_KER_OpportunitySignHndlr extends CRAN_VAS_KER_SignatureHandlerBase {
	
    /** Bus instance to handle calls to Avaloq services */
	private CRAN_VAS_KER_BusHandler bus;

    /**
    * Method that creates a DocuSign envelope and returns a URL to start a ceremony
    * @param objectId sObject Id    
    * @return URL to start a ceremony
    */
	public override String getSignatureUrl(String objectId) {

        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_DocuSignCeremony', CRAN_VAS_KER_OpportunitySignHndlr.class.getName());
        String url;

        try {

            CRAN_VAS_KER_DocusignAPIMngr manager = CRAN_VAS_KER_DocusignAPIMngr.getInstance();
            bus = new CRAN_VAS_KER_BusHandler();

            Opportunity opp     = [ SELECT  Id, 
                                            StageName,
                                            Account.Name, 
                                            Account.Id,
                                            Account.CRAN_VEC_ADV_N_Number__c, // BP ID for Archival
                                            Account.CRAN_VEC_ADV_P_Bunit__c, // BU for Archival                               
                                            Account.CRAN_VEC_ADV_T_BPId__c,
                                            CRAN_VAS_KER_T_External_Document_Id__c,
                                            CRAN_VEC_ADV_T_AvaloqPropId__c,
                                            CRAN_VEC_ADV_L_PersonId__c,
                                            CRAN_VEC_ADV_L_PersonId__r.Name,
                                            CRAN_VEC_ADV_L_PersonId__r.Email,
                                            CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_P_Language__c,
                                            CRAN_VEC_ADV_L_PersonId__r.MobilePhone,
                                            CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_N_NumericSort__c,
                                            CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_T_EBContract__c                             
                                   FROM     Opportunity
                                   WHERE    Id =: objectId];


            // First Signer data (Customer)
            CRAN_VAS_KER_DocuSignEnvelope_CLS.InPersonSigner inPersonSigner = new CRAN_VAS_KER_DocuSignEnvelope_CLS.InPersonSigner();
            // Non-void ClientUserId sets the embedded recipient as captive, suppressing the email notification
            inPersonSigner.clientUserId = opp.CRAN_VEC_ADV_L_PersonId__c;
            inPersonSigner.hostEmail = UserInfo.getUserEmail();
            inPersonSigner.hostName = UserInfo.getName();
            inPersonSigner.recipientId = '1';
            inPersonSigner.roleName = 'Signer 1';
            inPersonSigner.routingOrder = '1';
            inPersonSigner.signerEmail = opp.CRAN_VEC_ADV_L_PersonId__r.Email;
            inPersonSigner.signerName = opp.CRAN_VEC_ADV_L_PersonId__r.Name;

            // First Signer Email Notification settings  
            inPersonSigner.emailNotification = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientEmailNotification();
            inPersonSigner.emailNotification.emailSubject = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_OpportunitySignEmailSubject', 
                                                            opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_P_Language__c);
            inPersonSigner.emailNotification.emailBody = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_OpportunitySignEmailBody', 
                                                            opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_P_Language__c);
            inPersonSigner.emailNotification.supportedLanguage = CRAN_VAS_KER_SignatureUtils.getDocusignLanguage(opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_P_Language__c);        
            
            // Fisrt Signer SBS - EU Avanced Signature
            CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider signatureProvider = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider();
            signatureProvider.signatureProviderName = CRAN_VAS_KER_SignatureUtils.SBS_PROVIDER_NAME;
            signatureProvider.signatureProviderOptions = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProviderOptions();
            signatureProvider.signatureProviderOptions.sms = CRAN_VAS_KER_SignatureUtils.buildString4Phones(opp.CRAN_VEC_ADV_L_PersonId__r.MobilePhone, opp.CRAN_VEC_ADV_L_PersonId__r.Name);
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
            // Add the signer tab
            inPersonSigner.tabs.signHereTabs.add(signHereTab);
            
            // Add the date tab
            CRAN_VAS_KER_DocuSignEnvelope_CLS.SignHere dateSignedTab = new CRAN_VAS_KER_DocuSignEnvelope_CLS.SignHere();
            dateSignedTab.anchorIgnoreIfNotPresent = 'false';
            dateSignedTab.anchorString = '\\d1\\';
            dateSignedTab.anchorUnits = 'inches';
            dateSignedTab.anchorXOffset = '0';
            dateSignedTab.anchorYOffset = '0';
            inPersonSigner.tabs.dateSignedTabs = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.SignHere>();        
            inPersonSigner.tabs.dateSignedTabs.add(dateSignedTab);
            
            // Add the full name tab
            CRAN_VAS_KER_DocuSignEnvelope_CLS.SignHere fullNameTab = new CRAN_VAS_KER_DocuSignEnvelope_CLS.SignHere();        
            fullNameTab.anchorIgnoreIfNotPresent = 'false';
            fullNameTab.anchorString = '\\n1\\';
            fullNameTab.anchorUnits = 'inches';
            fullNameTab.anchorXOffset = '0';
            fullNameTab.anchorYOffset = '0';
            inPersonSigner.tabs.fullNameTabs = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.SignHere>();
            inPersonSigner.tabs.fullNameTabs.add(fullNameTab);
                            
            // Envelope
            CRAN_VAS_KER_DocuSignEnvelope_CLS envelope = new CRAN_VAS_KER_DocuSignEnvelope_CLS();
            envelope.status = 'sent';

            // Adds the InPersonSigner to the envelope
            envelope.recipients = new CRAN_VAS_KER_DocuSignEnvelope_CLS.Recipients();
            envelope.recipients.inPersonSigners = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.InPersonSigner>();        
            envelope.recipients.inPersonSigners.add(inPersonSigner);

            // Sets record information so DocuSign attach the signed document to it
            CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField textCustomField = new CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField();
            textCustomField.name = '##SFOpportunity';
            textCustomField.required = 'false';
            textCustomField.show = 'false';
            textCustomField.value = objectId;
            
            // Adds the custom fields information to the Inline Template
            envelope.customFields = new CRAN_VAS_KER_DocuSignEnvelope_CLS.CustomFields();
            envelope.customFields.textCustomFields = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField>();        
            envelope.customFields.textCustomFields.add(textCustomField);

    		// Update medium for OMS to generate the doc from the correct templates
    		updateMedium(objectId);

            // Retrieves and set the base64 document that will be signed
    		String omsId = getDocumentId(opp.CRAN_VEC_ADV_T_AvaloqPropId__c);		

            envelope.documents = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.Document>();
            CRAN_VAS_KER_DocuSignEnvelope_CLS.Document document = new CRAN_VAS_KER_DocuSignEnvelope_CLS.Document();
            document.documentBase64 = getBase64Document(omsId);
            document.documentId = '1';
            document.fileExtension = 'pdf';
            document.name = System.Label.CRAN_VAS_KER_OpportunitySignFileName;
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
    												inPersonSigner.clientUserId, inPersonSigner.recipientId, objectId);
    		
            List<CRAN_VAS_KER_ESignature__c> eSignList = new List<CRAN_VAS_KER_ESignature__c>();		

    		CRAN_VAS_KER_MetadataResponse metadata = bus.getArchivalMetadata(opp.CRAN_VEC_ADV_T_AvaloqPropId__c);
            metadata.orderList.order.metadaTypeName = 'Rebalancer investment proposition SF'; 
            metadata.orderList.order.metadaTypeId= 'REBALP';

    		CRAN_VAS_KER_ESignature__c eSign = new CRAN_VAS_KER_ESignature__c();
    		eSign.CRAN_VAS_KER_Start_Date__c = System.now();
    		eSign.CRAN_VAS_KER_File_Name__c = 'Envelope ' + envelopeId + '.pdf';
    		eSign.CRAN_VAS_KER_Opportunity__c = objectId;
    		eSign.CRAN_VAS_KER_Signature_Id__c = envelopeId;
    		eSign.CRAN_VAS_KER_Document_Id__c = omsId;
    		eSign.CRAN_VAS_KER_Core_Id__c = opp.CRAN_VEC_ADV_T_AvaloqPropId__c;
    		eSign.CRAN_VAS_KER_Reference_Line__c = objectId + '.1.' + System.now().getTime();
    		eSign.CRAN_VAS_KER_Person_Id__c = opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_N_NumericSort__c;
    		eSign.CRAN_VAS_KER_Client_Name__c = opp.CRAN_VEC_ADV_L_PersonId__r.Name;
    		eSign.CRAN_VAS_KER_BP_Id__c = opp.Account.CRAN_VEC_ADV_N_Number__c;
    		eSign.CRAN_VAS_KER_BU_Id__c = opp.Account.CRAN_VEC_ADV_P_Bunit__c;

            if (String.isNotBlank(opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_T_EBContract__c)
                && !opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_T_EBContract__c.contains(';'))
                eSign.CRAN_VAS_KER_T_ContractId__c = opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_T_EBContract__c;

    		String metadataXML = CRAN_VAS_KER_SignatureUtils.buildArchivalXMLFromMetadata(metadata, eSign);
    		eSign.CRAN_VAS_KER_Sent_XML__c = metadataXML;
    		eSign.CRAN_VAS_KER_Signature_Type__c = 'Proposal';
            eSign.CRAN_VAS_KER_P_DocumentType__c = 'Envelope';
    		
    		eSignList.add(eSign);
    		
    		CRAN_VAS_KER_ESignature__c certificate = eSign.clone(false, true, false, false);
    		certificate.CRAN_VAS_KER_File_Name__c = 'Certificate ' + envelopeId + '.pdf';
    		certificate.CRAN_VAS_KER_Reference_Line__c = objectId + '.2.' + System.now().getTime();
    		metadataXML = CRAN_VAS_KER_SignatureUtils.buildArchivalXMLFromMetadata(metadata, certificate);		
    		certificate.CRAN_VAS_KER_Sent_XML__c = metadataXML;
            certificate.CRAN_VAS_KER_P_DocumentType__c = 'Certificate';

    		eSignList.add(certificate);

            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Database.insert(eSignList, false), 
                CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel());

    		opp.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PEND_SIGN;

    		opp.CRAN_VEC_ADV_B_IsService__c = true;

            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Database.update(opp, false), 
                Opportunity.sObjectType.getDescribe().getLabel());        

    		opp.CRAN_VEC_ADV_B_IsService__c = false;

            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Database.update(opp, false), 
                Opportunity.sObjectType.getDescribe().getLabel());

        } catch (Exception ex) {

            String errorMsg = ex.getMessage();
			system.debug('errorMsg ' + errorMsg);
            if (String.isNotBlank(errorMsg) && !errorMsg.contains('CRAN_ERR_')) {
                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, null, CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10013.name());
                ex.setMessage(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                        CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10013.name()
                }));    
            }

            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_OpportunitySignHndlr.class.getName());
            throw ex;       
        }

        // Commits the event log
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_OpportunitySignHndlr.class.getName());                  

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
	
    /**
    * Updates medium for an opportunity
    * @param id avaloq Id for investment proposal
    */     
	private void updateMedium(String id) {
		CRAN_VAS_KER_BusHandler.setAvaloqMediumToSalesforce(id);
	}
    
}