/**
* Handles DocuSign's ceremony to an order
*
* @author Luís Velasco
* @author Zuinglio Lopes Ribeiro Júnior
* @version 1.0
* @version 2.0
*/
public with sharing class CRAN_VAS_KER_OrderSignHndlr extends CRAN_VAS_KER_SignatureHandlerBase  {
 
    /** OMS Id to retrieve the merged PDF */
	private String omsID;

    /** List containing orders of an opportunity */
	private List<Order> orderList;

    /**
    * Method that creates a DocuSign envelope and returns a URL to start a ceremony
    * @param objectId sObject Id    
    * @return URL to start a ceremony
    */
    public override String getSignatureUrl(String objectId) {
        
        // Starting event log
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_DocuSignCeremony', CRAN_VAS_KER_OrderSignHndlr.class.getName());
        String url;

        try {

            CRAN_VAS_KER_DocusignAPIMngr manager = CRAN_VAS_KER_DocusignAPIMngr.getInstance();
            CRAN_VAS_KER_BusHandler bus = new CRAN_VAS_KER_BusHandler();
     
            Opportunity opp     = [ SELECT  Id, 
                                            StageName,
                                            Account.Name, 
                                            Account.Id,
                                            Account.CRAN_VEC_ADV_N_Number__c, // BP ID for Archival
                                            Account.CRAN_VEC_ADV_P_Bunit__c, // BU for Archival                               
                                            Account.CRAN_VEC_ADV_T_BPId__c,
                                            CRAN_VAS_KER_T_External_Document_Id__c,
                                            CRAN_VEC_ADV_T_AvaloqPropId__c,
                                            CRAN_VEC_ADV_P_Bunit__c,
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
            inPersonSigner.emailNotification.emailSubject = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_OrderSignEmailSubject', 
                                                            opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_P_Language__c);
            inPersonSigner.emailNotification.emailBody = CRAN_VAS_KER_SignatureUtils.getTranslatedLabel('CRAN_VAS_KER_OrderSignEmailBody', 
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
            textCustomField.name = '##SFOpportunity';
            textCustomField.required = 'false';
            textCustomField.show = 'false';
            textCustomField.value = opp.Id;
            
            // Adds the custom fields information to the Inline Template
            envelope.customFields = new CRAN_VAS_KER_DocuSignEnvelope_CLS.CustomFields();
            envelope.customFields.textCustomFields = new List<CRAN_VAS_KER_DocuSignEnvelope_CLS.TextCustomField>();          
            envelope.customFields.textCustomFields.add(textCustomField);

            // Retrieves and set the base64 document that will be signed      
            if (omsId == null) {

                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Label.CRAN_VAS_KER_SignatureExceptionDocId, CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel(), 
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10011.name());

                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                        CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10011.name()
                }));                                     
            }

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
                                                    inPersonSigner.clientUserId, inPersonSigner.recipientId, opp.Id);
            
            List<CRAN_VAS_KER_ESignature__c> eSignList = new List<CRAN_VAS_KER_ESignature__c>();

            for (Order order : orderList) { 
             
                CRAN_VAS_KER_MetadataResponse metadata = bus.getArchivalMetadata(order.CRAN_VEC_ADV_T_OrderId__c);
                
                metadata.orderList.order.metadaTypeId   = order.CRAN_VEC_ADV_P_MetaType__c;              
                metadata.orderList.order.metadaTypeName = order.CRAN_VEC_ADV_P_MetaType__c == 'STEX'?'Stock exchange SF': 'FX trade SF' ; 
    		
                CRAN_VAS_KER_ESignature__c eSign        = new CRAN_VAS_KER_ESignature__c();
                eSign.CRAN_VAS_KER_Start_Date__c        = System.now();
                eSign.CRAN_VAS_KER_File_Name__c         = 'Envelope ' + envelopeId + '.pdf';
                eSign.CRAN_VAS_KER_Order__c             = order.Id;
                eSign.CRAN_VAS_KER_Opportunity__c       = objectId;
                eSign.CRAN_VAS_KER_Signature_Id__c      = envelopeId;
                eSign.CRAN_VAS_KER_Core_Id__c           = order.CRAN_VEC_ADV_T_OrderId__c;
                eSign.CRAN_VAS_KER_Reference_Line__c    = order.Id + '.1.' + System.now().getTime();
                eSign.CRAN_VAS_KER_Person_Id__c         = opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_N_NumericSort__c;
                eSign.CRAN_VAS_KER_Client_Name__c       = opp.CRAN_VEC_ADV_L_PersonId__r.Name;
                eSign.CRAN_VAS_KER_BP_Id__c             = opp.Account.CRAN_VEC_ADV_N_Number__c;
                eSign.CRAN_VAS_KER_BU_Id__c             = opp.Account.CRAN_VEC_ADV_P_Bunit__c;

                if (String.isNotBlank(opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_T_EBContract__c)
                && !opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_T_EBContract__c.contains(';'))
                    eSign.CRAN_VAS_KER_T_ContractId__c = opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_T_EBContract__c;

                eSign.CRAN_VAS_KER_Sent_XML__c          = CRAN_VAS_KER_SignatureUtils.buildArchivalXMLFromMetadata(metadata, eSign);
                eSign.CRAN_VAS_KER_Signature_Type__c    = 'Order';
                eSign.CRAN_VAS_KER_P_DocumentType__c = 'Envelope';
                
                eSignList.add(eSign);
                
                CRAN_VAS_KER_ESignature__c certificate      = eSign.clone(false, true, false, false);
                certificate.CRAN_VAS_KER_File_Name__c       = 'Certificate ' + envelopeId + '.pdf';
                certificate.CRAN_VAS_KER_Reference_Line__c  = order.Id + '.2.' + System.now().getTime();
                certificate.CRAN_VAS_KER_Sent_XML__c        = CRAN_VAS_KER_SignatureUtils.buildArchivalXMLFromMetadata(metadata, certificate);
                certificate.CRAN_VAS_KER_P_DocumentType__c = 'Certificate';

                eSignList.add(certificate);
            }
            
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

            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_OrderSignHndlr.class.getName());
            throw ex;
        }   

        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_OrderSignHndlr.class.getName());   

        return url;

    }
    
    /**
    * Method that retrieves an OMS Id for a merged PDF
    * @param orderList list of order 
    * @param bUnit business unit
    * @return OMS Id
    */    
    public String getDocumentId(List<Order> orderList, String bUnit) {          
        
		this.orderList = orderList;
		
        if (orderList != null && orderList.size() > 0) {
            
            CRAN_VEC_ADV_OmsPrintList_RQ rq = new CRAN_VEC_ADV_OmsPrintList_RQ();
            rq.orderList = new List<CRAN_VEC_ADV_OrderPrintList_CLS>();
            
            for (Order order : orderList) {
                CRAN_VEC_ADV_OrderPrintList_CLS orderCls = new CRAN_VEC_ADV_OrderPrintList_CLS();
                orderCls.orderNr = order.CRAN_VEC_ADV_T_OrderId__c;
                rq.orderList.add(orderCls);
            }
            
            String omsPrintjsonRequest = JSON.serialize(rq);
            
            CRAN_VEC_ADV_RestClient_CLS avaloqClient;
            avaloqClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_LIST_PRINT, bUnit, omsPrintjsonRequest);
            
            CRAN_VEC_ADV_OmsPrintList_RS results = (CRAN_VEC_ADV_OmsPrintList_RS) JSON.deserialize(avaloqClient.responseBody, CRAN_VEC_ADV_OmsPrintList_RS.class);
            
            if (results == null) {
                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Label.CRAN_VEC_ADV_IP_MSG_Error, CRAN_VEC_ADV_MergeOMS_RQ.class.getName(), 
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name());

                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                        CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name()
                })); 
            } else if (results != null && results.errors != null) {
                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors), CRAN_VEC_ADV_MergeOMS_RQ.class.getName(), 
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name());

                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                        CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name()
                }));                 
            } else if (results != null && results.errors == null && results.omsIdList != null) {
                
                CRAN_VEC_ADV_MergeOMS_RQ mergeRequest = new CRAN_VEC_ADV_MergeOMS_RQ();
                
                if (results.omsIdList.size() > 0) {
                    //LLAMADA A MERGEADO DE LISTAS
                    String mergeIds = '';
                    for (CRAN_VEC_ADV_OmsPrintList_RS.oms printOMS : results.omsIdList) {
                        if (mergeIds.equals('')) {
                            mergeIds = printOMS.omsId;
                        } else {
                            mergeIds = mergeIds + ';' + printOMS.omsId;
                        }
                    }
                    omsID = mergeIds;
                    return mergeIds;
                } else {
                    CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Label.CRAN_VEC_ADV_IP_MSG_Error, CRAN_VEC_ADV_MergeOMS_RQ.class.getName(), 
                        CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name());

                    throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                            CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name()
                    }));                        
                }
            } else {
                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Label.CRAN_VEC_ADV_IP_MSG_Error, CRAN_VEC_ADV_MergeOMS_RQ.class.getName(), 
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name());

                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                        CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name()
                })); 
            }
        } else {
            return null;
        }
        
    }
    
    /**
    * Method that retrieves a base64 PDF string
    * @param documentId OMS Id
    * @return base64 merged pdf
    */     
    private String getBase64Document(String documentId) {           

        List<String> omsIdList = documentId.split(';');
        
        CRAN_VEC_ADV_MergeOMS_RQ mergeRequest = new CRAN_VEC_ADV_MergeOMS_RQ();
        //LLAMADA A MERGEADO DE LISTAS
        mergeRequest.omsList = new List<CRAN_VEC_ADV_MergeOMS_RQ.Oms>();
        
        for (String printOMS : omsIdList) {
            CRAN_VEC_ADV_MergeOMS_RQ.Oms tmp = new CRAN_VEC_ADV_MergeOMS_RQ.Oms();
            tmp.omsId = printOMS;
            mergeRequest.omsList.add(tmp);
        }
        
        String mergeOmsjsonRequest = JSON.serialize(mergeRequest);
        
        String resultCallout = CRAN_VEC_ADV_PrintRestPDF_CTR.printPDFcallOut(CRAN_VEC_ADV_Constants_CLS.SERVICE_MERGE_PDF, mergeOmsjsonRequest);

        if (resultCallout == null) {
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Label.CRAN_VEC_ADV_IP_MSG_Error, CRAN_VEC_ADV_MergeOMS_RQ.class.getName(), 
                CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name());

            throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10012.name()
            }));            
        }
        
        return resultCallout;
        
    }
    
}