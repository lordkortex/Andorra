/**
* Handles DocuSign's ceremony to a contract
*
* @author Luís Velasco
* @author Zuinglio Lopes Ribeiro Júnior
* @version 1.0
* @version 2.0
*/
public with sharing class CRAN_VAS_KER_ContractSignHndlr extends CRAN_VAS_KER_SignatureHandlerBase {
	
    /**
    * Method that creates a DocuSign envelope and returns a URL to start a ceremony
    * @param objectId sObject Id    
    * @return URL to start a ceremony
    */    
	public override String getSignatureUrl(String objectId) {

        // Starting event log
		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_DocuSignCeremony', CRAN_VAS_KER_ContractSignHndlr.class.getName());  
        String url;

        try {

            CRAN_VAS_KER_DocusignAPIMngr manager = CRAN_VAS_KER_DocusignAPIMngr.getInstance();

    		Contract contract = [SELECT Id, 
    									Status, 
                                 		Account.FinServ__PrimaryContact__c,
    									Account.FinServ__PrimaryContact__r.Name,
    									Account.FinServ__PrimaryContact__r.Email, 
    									Account.FinServ__PrimaryContact__r.MobilePhone,
    									Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_P_Language__c,
                                        Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_T_EBContract__c,
    									CRAN_VAS_KER_T_External_Document_Id__c,
    									CRAN_VAS_KER_DS_Template__c, 
    									CRAN_VAS_KER_Signer2__r.Name, 
    									CRAN_VAS_KER_Signer2__r.Email, 
    									CRAN_VAS_KER_Signer2__r.LanguageLocaleKey,
                                 		CRAN_VAS_KER_Signer2__r.MobilePhone,
    									CRAN_VAS_KER_Signer3__r.Name, 
    									CRAN_VAS_KER_Signer3__r.Email,
    									CRAN_VAS_KER_Signer3__r.LanguageLocaleKey,
                                 		CRAN_VAS_KER_Signer3__r.MobilePhone,
                                        CRAN_VAS_KER_Client_Name__c, 
                                        CRAN_VAS_KER_Person_Id__c, 
                                        CRAN_VAS_KER_Account_Language__c,  
                                        CRAN_VAS_KER_BP__r.CRAN_VEC_ADV_N_Number__c, 
                                        CRAN_VAS_KER_BP__r.AccountNumber,
                                        CRAN_VAS_KER_BP__r.CRAN_VEC_ADV_P_Bunit__c                                   
    							 FROM 	Contract
    							 WHERE 	Id = :objectId];
            
            // Sets an inline template data and its recipients
            CRAN_VAS_KER_DocuSignEnvelope_CLS.InlineTemplate inlineTemplate = new CRAN_VAS_KER_DocuSignEnvelope_CLS.InlineTemplate();
            inlineTemplate.recipients = new CRAN_VAS_KER_DocuSignEnvelope_CLS.Recipients();
            inlineTemplate.recipients.inPersonSigners = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.InPersonSigner>();
            inlineTemplate.recipients.signers = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.Signer>();
            
            // First Signer data (Customer)
            CRAN_VAS_KER_DocuSignEnvelope_CLS.InPersonSigner inPersonSigner = new CRAN_VAS_KER_DocuSignEnvelope_CLS.InPersonSigner();
    		// Non-void ClientUserId sets the embedded recipient as captive, suppressing the email notification
            inPersonSigner.clientUserId = contract.Account.FinServ__PrimaryContact__c; 
            inPersonSigner.hostEmail = UserInfo.getUserEmail();
            inPersonSigner.hostName = UserInfo.getName();
            inPersonSigner.recipientId = '1';
            inPersonSigner.roleName = 'Signer 1';
            inPersonSigner.routingOrder = '1';
            inPersonSigner.signerEmail = contract.Account.FinServ__PrimaryContact__r.Email;
            inPersonSigner.signerName = contract.Account.FinServ__PrimaryContact__r.Name;

            // First Signer Email Notification settings
           	inPersonSigner.emailNotification = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientEmailNotification();
            inPersonSigner.emailNotification.emailSubject = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_ContractSignEmailSubject', 
                                                            contract.Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_P_Language__c);
            inPersonSigner.emailNotification.emailBody = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_ContractSignEmailBody', 
                                                            contract.Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_P_Language__c);
    		inPersonSigner.emailNotification.supportedLanguage = CRAN_VAS_KER_SignatureUtils.getDocusignLanguage(contract.Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_P_Language__c);         
            
            // Fisrt Signer SBS - EU Avanced Signature
            CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider signatureProvider = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider();
            signatureProvider.signatureProviderName = CRAN_VAS_KER_SignatureUtils.SBS_PROVIDER_NAME;
    		signatureProvider.signatureProviderOptions = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProviderOptions();
           	signatureProvider.signatureProviderOptions.sms = CRAN_VAS_KER_SignatureUtils.buildString4Phones(contract.Account.FinServ__PrimaryContact__r.MobilePhone, contract.Account.FinServ__PrimaryContact__r.Name);
            inPersonSigner.recipientSignatureProviders = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider>();
            inPersonSigner.recipientSignatureProviders.add(signatureProvider);
            
            inlineTemplate.recipients.inPersonSigners.add(inPersonSigner);
            
            // Second Signer data
            CRAN_VAS_KER_DocuSignEnvelope_CLS.Signer remoteSigner = new CRAN_VAS_KER_DocuSignEnvelope_CLS.Signer();
            remoteSigner.recipientId = '2';
            remoteSigner.roleName = 'Signer 2';
            remoteSigner.routingOrder = '2';
            remoteSigner.email = contract.CRAN_VAS_KER_Signer2__r.Email;
            remoteSigner.name = contract.CRAN_VAS_KER_Signer2__r.Name; 
            
            // Second Signer SBS - EU Avanced Signature
            signatureProvider = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider();
            signatureProvider.signatureProviderName = CRAN_VAS_KER_SignatureUtils.SBS_PROVIDER_NAME;
    		signatureProvider.signatureProviderOptions = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProviderOptions();
           	signatureProvider.signatureProviderOptions.sms = CRAN_VAS_KER_SignatureUtils.buildString4Phones(contract.CRAN_VAS_KER_Signer2__r.MobilePhone, contract.CRAN_VAS_KER_Signer2__r.Name);
            remoteSigner.recipientSignatureProviders = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider>();
            remoteSigner.recipientSignatureProviders.add(signatureProvider);
            
            // Second Signer Email Notification settings
           	remoteSigner.emailNotification = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientEmailNotification();
            remoteSigner.emailNotification.emailSubject = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_ContractSignEmailSubject', 
                                                            contract.CRAN_VAS_KER_Signer2__r.LanguageLocaleKey);
            remoteSigner.emailNotification.emailBody = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_ContractSignEmailBody', 
                                                            contract.CRAN_VAS_KER_Signer2__r.LanguageLocaleKey);
            remoteSigner.emailNotification.supportedLanguage = CRAN_VAS_KER_SignatureUtils.getDocusignLanguage(contract.CRAN_VAS_KER_Signer2__r.LanguageLocaleKey);
            
            inlineTemplate.recipients.signers.add(remoteSigner);        
            
            // Third Signer data
            remoteSigner = new CRAN_VAS_KER_DocuSignEnvelope_CLS.Signer();
            remoteSigner.recipientId = '3';
            remoteSigner.roleName = 'Signer 3';
            remoteSigner.routingOrder = '2';
            remoteSigner.email = contract.CRAN_VAS_KER_Signer3__r.Email;
            remoteSigner.name = contract.CRAN_VAS_KER_Signer3__r.Name; 
            
            // Third Signer SBS - EU Avanced Signature
            signatureProvider = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider();
            signatureProvider.signatureProviderName = CRAN_VAS_KER_SignatureUtils.SBS_PROVIDER_NAME;
    		signatureProvider.signatureProviderOptions = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProviderOptions();
           	signatureProvider.signatureProviderOptions.sms = CRAN_VAS_KER_SignatureUtils.buildString4Phones(contract.CRAN_VAS_KER_Signer3__r.MobilePhone, contract.CRAN_VAS_KER_Signer3__r.Name);
            remoteSigner.recipientSignatureProviders = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientSignatureProvider>();
            remoteSigner.recipientSignatureProviders.add(signatureProvider);
            
            // Second Signer Email Notification settings
           	remoteSigner.emailNotification = new CRAN_VAS_KER_DocuSignEnvelope_CLS.RecipientEmailNotification();
            remoteSigner.emailNotification.emailSubject = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_ContractSignEmailSubject', 
                                                            contract.CRAN_VAS_KER_Signer3__r.LanguageLocaleKey);
            remoteSigner.emailNotification.emailBody = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_ContractSignEmailBody', 
                                                            contract.CRAN_VAS_KER_Signer3__r.LanguageLocaleKey);
    		remoteSigner.emailNotification.supportedLanguage = CRAN_VAS_KER_SignatureUtils.getDocusignLanguage(contract.CRAN_VAS_KER_Signer3__r.LanguageLocaleKey);        
            
            inlineTemplate.recipients.signers.add(remoteSigner);
            
            // Sets record information so DocuSign attach the signed document to it
            CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField textCustomField = new CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField();
            textCustomField.name = '##SFContract';
            textCustomField.required = 'false';
            textCustomField.show = 'false';
            textCustomField.value = objectId;
            
            // Adds the custom fields information to the Inline Template
            CRAN_VAS_KER_DocuSignEnvelope_CLS.CustomFields customFields = new CRAN_VAS_KER_DocuSignEnvelope_CLS.CustomFields();
            customFields.textCustomFields = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField>();
            customFields.textCustomFields.add(textCustomField);    
            inlineTemplate.customFields = customFields;
            inlineTemplate.sequence = '1';

            // Adds the Inline Template and Server Template to a composite
            CRAN_VAS_KER_DocuSignEnvelope_CLS.CompositeTemplate compositeTemplate = new CRAN_VAS_KER_DocuSignEnvelope_CLS.CompositeTemplate();        
            compositeTemplate.inlineTemplates = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.InlineTemplate>();
            compositeTemplate.inlineTemplates.add(inlineTemplate);
            
            // Sets the DosuSign template Id, which changes based on the recipient language
            CRAN_VAS_KER_DocuSignEnvelope_CLS.ServerTemplate serverTemplate = new CRAN_VAS_KER_DocuSignEnvelope_CLS.ServerTemplate();
            serverTemplate.sequence = '1';
            serverTemplate.templateId = contract.CRAN_VAS_KER_DS_Template__c;
            compositeTemplate.serverTemplates = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.ServerTemplate>();        
            compositeTemplate.serverTemplates.add(serverTemplate);

            // Envelope
            CRAN_VAS_KER_DocuSignEnvelope_CLS envelope = new CRAN_VAS_KER_DocuSignEnvelope_CLS();
            envelope.status = 'sent';
            envelope.emailSubject = 'Contract';

            // Adds the composite template setting to the envelope
            envelope.compositeTemplates = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.CompositeTemplate>();        
            envelope.compositeTemplates.add(compositeTemplate);

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

            CRAN_VAS_KER_ESignature__c customFormEsign;

            try {
                customFormEsign = [ SELECT CRAN_VAS_KER_Core_Id__c 
                                    FROM CRAN_VAS_KER_ESignature__c 
                                    WHERE CRAN_VAS_KER_Signature_Type__c = 'Form' 
                                    AND CRAN_VAS_ADV_HasError__c = FALSE 
                                    AND CRAN_VAS_KER_BP_Id__c =: contract.CRAN_VAS_KER_BP__r.CRAN_VEC_ADV_N_Number__c
                                    AND CRAN_VAS_KER_Person_Id__c =: contract.CRAN_VAS_KER_Person_Id__c
                                    ORDER BY CreatedDate DESC LIMIT 1];
            } catch (Exception ex) {

                String msg = String.format(Label.CRAN_VAS_KER_ContractOrderNumberNotFound, new String[] {
                    contract.CRAN_VAS_KER_BP__r.CRAN_VEC_ADV_N_Number__c,
                    contract.CRAN_VAS_KER_Person_Id__c
                    });

                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(msg, CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel(), 
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10009.name());

                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                        CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10009.name()
                }));                 
            }

            List<CRAN_VAS_KER_ESignature__c> eSignList = new List<CRAN_VAS_KER_ESignature__c>();    
            CRAN_VAS_KER_ESignature__c eSign = new CRAN_VAS_KER_ESignature__c();
            eSign.CRAN_VAS_KER_Start_Date__c = System.now();
            eSign.CRAN_VAS_KER_File_Name__c = 'Envelope ' + envelopeId + '.pdf';
            eSign.CRAN_VAS_KER_Contract__c = objectId;
            eSign.CRAN_VAS_KER_Signature_Id__c = envelopeId;
            eSign.CRAN_VAS_KER_Core_Id__c = customFormEsign.CRAN_VAS_KER_Core_Id__c;
            eSign.CRAN_VAS_KER_Reference_Line__c = objectId + '.1.' + System.now().getTime();
            eSign.CRAN_VAS_KER_Person_Id__c = contract.CRAN_VAS_KER_Person_Id__c;
            eSign.CRAN_VAS_KER_Client_Name__c = contract.CRAN_VAS_KER_Client_Name__c;
            eSign.CRAN_VAS_KER_BP_Id__c = contract.CRAN_VAS_KER_BP__r.CRAN_VEC_ADV_N_Number__c;
            eSign.CRAN_VAS_KER_BU_Id__c = contract.CRAN_VAS_KER_BP__r.CRAN_VEC_ADV_P_Bunit__c;

            if (String.isNotBlank(contract.Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_T_EBContract__c)
                && !contract.Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_T_EBContract__c.contains(';'))
                eSign.CRAN_VAS_KER_T_ContractId__c = contract.Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_T_EBContract__c;

            String metadataXML = CRAN_VAS_KER_SignatureUtils.buildArchivalXMLFromMetadata(contract, eSign);
            eSign.CRAN_VAS_KER_Sent_XML__c = metadataXML;
            eSign.CRAN_VAS_KER_Signature_Type__c = 'Contract';
            eSign.CRAN_VAS_KER_P_DocumentType__c = 'Envelope';
            
            eSignList.add(eSign);
            
            CRAN_VAS_KER_ESignature__c certificate = eSign.clone(false, true, false, false);
            certificate.CRAN_VAS_KER_File_Name__c = 'Certificate ' + envelopeId + '.pdf';
            certificate.CRAN_VAS_KER_Reference_Line__c = objectId + '.2.' + System.now().getTime();
            metadataXML = CRAN_VAS_KER_SignatureUtils.buildArchivalXMLFromMetadata(contract, eSign);      
            certificate.CRAN_VAS_KER_Sent_XML__c = metadataXML;
            certificate.CRAN_VAS_KER_P_DocumentType__c = 'Certificate';

            eSignList.add(certificate);

            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Database.insert(eSignList, false), 
                CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel());        
    												
            if (contract.Status != 'In Approval Process') {
                contract.Status = 'In Approval Process';
     
                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Database.update(contract, false), 
                            CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel());                           
            }

            //If we are signing a new contract we void all non-completed docusign status related objects
    		List<dsfs__Docusign_Status__c> docusignStatuses  = [SELECT 	Id, 
    																	dsfs__Envelope_Status__c 
    															FROM 	dsfs__Docusign_Status__c
    															WHERE 	dsfs__Contract__c =: contract.Id
    															AND 	dsfs__Envelope_Status__c != 'Completed'];
    		
            for (dsfs__Docusign_Status__c dsStat : docusignStatuses) {
                dsStat.dsfs__Envelope_Status__c = 'Voided';
            }
            
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Database.update(docusignStatuses, false), 
                    dsfs__Docusign_Status__c.sObjectType.getDescribe().getLabel());
        } catch (Exception ex) {

            String errorMsg = ex.getMessage();

            if (String.isNotBlank(errorMsg) && !errorMsg.contains('CRAN_ERR_')) {
                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, null, CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10013.name());
                ex.setMessage(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                        CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10013.name()
                }));    
            }

            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_ContractSignHndlr.class.getName()); 
            throw ex;
        }
        
         // Commits the event log
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_ContractSignHndlr.class.getName());                          
        
		return url;
	}
	
}