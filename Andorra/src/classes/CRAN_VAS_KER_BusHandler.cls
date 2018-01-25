/**
* Class that handles all callouts to ICA services
* @author Luis Velasco
* @author Zuinglio Lopes Ribeiro Júnior
* @version 2.0
*/
public with sharing class CRAN_VAS_KER_BusHandler {

    /** Public constructor */
    public CRAN_VAS_KER_BusHandler() {
        // Instantiates Event log
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_General', CRAN_VAS_KER_BusHandler.class.getName());        
    }
    
    /**
    * Sends a request to OMS service passing an order number to generate the PDF
    * @param avaloqOrderNr order number to generate the PDF file
    * @return OMS Id to retrieve the PDF
    */    
    public String printOMSDoc(String avaloqOrderNr) {
        
        String omsId = '';
        HttpResponse res;
        CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
        
        try {

            String origin = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().Origin__c;
            String enviro = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().AvaloqEnvironment__c;

            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeFieldName('order');
            gen.writeStartObject();
            gen.writeStringField('orderNr', avaloqOrderNr);
            gen.writeBooleanField('isNew', false);
            gen.writeEndObject();
            gen.writeEndObject();
            
            String escapedContent = gen.getAsString();  
            
            gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeStringField('service', 'SfOmsPrint');
            gen.writeStringField('content', escapedContent);
            gen.writeStringField('codAppOrigin', origin);
            gen.writeStringField('codEnv', enviro);
            gen.writeEndObject();
            gen.close();         

            String endPoint = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().PrintOMSEndPoint__c;
            restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint);
            res = restCallOut.sendSSLJSONRequestWithEncryption(gen.getAsString());
            
            // Any status code different from 200 will be considered an exception
            if (res.getStatusCode() != 200) {
                throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_SignatureExceptionDocId);
            } else {
                
                Map<String, Object> untypedRes 	= (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                CRAN_VEC_ADV_OmsPrint_RS omsResponse = (CRAN_VEC_ADV_OmsPrint_RS) JSON.deserialize((String) untypedRes.get('content'), CRAN_VEC_ADV_OmsPrint_RS.class);		
                
                // If there is no results or if there is reported errors, throws an exception
                if (omsResponse == null) {
                    throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_SignatureExceptionDocId);
                } else if (omsResponse.errors != null) {
                    throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_SignatureExceptionDocId + ': ' + CRAN_VEC_ADV_Utils.getAllErrorsService(omsResponse.errors));
                } else if (omsResponse.errors == null 
                    && omsResponse.omsIdList != null
                    && omsResponse.omsIdList.size() > 0
                    && String.isNotBlank( omsResponse.omsIdList[0].id)) {		
                        omsId = omsResponse.omsIdList[0].id;			
                } else {
                    throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_SignatureExceptionDocId);
                }			
            }

        } catch (Exception ex) {

            // Logs exception details
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
                restCallOut, 
                res, 
                CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10016.name());

            // If it isn't an asynchronous call, throws the exception
            if (!isAsynchronous()) {
                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10016.name()
                }));
            }                                        

        }

        return omsId;
    }

   /**
    * Gets a base64 PDF from the OMS service
    * @param omsId OMS Id for the PDF
    * @return base64 PDF file
    */   
    public String getBase64DocumentFromService(String omsId) {
        
        CRAN_VAS_KER_BusPDFResponse pdfResponse;
        CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
        HttpResponse res; 
       
        try {

            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeStringField('omsId', omsId);
            gen.writeEndObject();
            gen.close();
            
            String endPoint = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().GetBase64PDFEndPoint__c;
            restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint);
            res = restCallOut.sendSSLJSONRequest(gen.getAsString());

            // Any status code different from 200 will be considered an exception
            if (res.getStatusCode() != 200) {
                throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_ErrorGettingExternalDocument);
            } else {

                pdfResponse = (CRAN_VAS_KER_BusPDFResponse) JSON.deserialize(res.getBody(), CRAN_VAS_KER_BusPDFResponse.class);

                // If the response is empty, throws an exception
                if (pdfResponse == null || String.isBlank(pdfResponse.pdfContent))
                    throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_ErrorGettingExternalDocument);
            }

        } catch (Exception ex) {

            // Logs exception details
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
                restCallOut, 
                res, 
                CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10015.name());

            // If it isn't an asynchronous call, throws the exception
            if (!isAsynchronous()) {
                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10015.name()
                }));
            }                                        

        }        

        return pdfResponse.pdfContent;
        
    }
    
    /**
    * Gets the metadata generated by Avaloq based on an order number. It will later be used
    * to properly archive DocuSign files.
    * @param orderNr order number
    * @return metadata which later will be sent along with the file to be archived
    */       
    public CRAN_VAS_KER_MetadataResponse getArchivalMetadata(String orderNr) {		
        
        CRAN_VAS_KER_MetadataResponse metaData;
        CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
        HttpResponse res;

        try {

            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeFieldName('orderList');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField('orderNr', orderNr);
            gen.writeEndObject();
            gen.writeEndArray();
            gen.writeEndObject();
            gen.close();            

            String endPoint = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().MetadataRetrievalEndPoint__c;
            restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint);
            res = restCallOut.sendSSLJSONRequestWithEncryption(gen.getAsString());
            
            // Any status code different from 200 will be considered an exception
            if (res.getStatusCode() != 200) {
                throw new CRAN_VAS_KER_SignatureException(System.Label.CRAN_VAS_KER_ErrorGettingMetaData);
            } else {

                metaData = (CRAN_VAS_KER_MetadataResponse) JSON.deserialize(res.getBody(), CRAN_VAS_KER_MetadataResponse.class);

                // If the response is empty, throws an exception
                if (metaData == null || metaData.orderList == null)
                    throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_ErrorGettingMetaData);

            }

        } catch (Exception ex) {

            // Logs exception details
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
                restCallOut, 
                res, 
                CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10014.name());

            // If it isn't an asynchronous call, throws the exception
            if (!isAsynchronous()) {
                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10014.name()
                }));
            }                                        

        }
        
        return metaData;		
    }	
    
    /**
    * Asynchronous method that sends a file to archive
    * @param eSignXml metadata that will be sent along with the file
    * @param attachBody file content
    * @param bpEmail BP email
    * @param eSignatureId Id of the eSignature file
    */       
    @future(callout=true)
    public static void sendToArchiveFuture(String eSignXml, Blob attachBody, String bpEmail, Id eSignatureId) {
        // Instantiates Event log
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_General', CRAN_VAS_KER_BusHandler.class.getName());

        // Sends the file to be archived 
        sendToArchive(eSignXml, attachBody, bpEmail, eSignatureId, true);
    }

    /**
    * Synchronous method that sends a file to archive
    * @param eSignXml metadata that will be sent along with the file
    * @param attachBody file content
    * @param bpEmail BP's email
    * @param eSignatureId Id of the eSignature file
    * @param updateEsign if true updates the eSignature file
    * @return eSignature sObject containing information about the callout
    */       
    public static CRAN_VAS_KER_ESignature__c sendToArchive(String eSignXml, Blob attachBody, String bpEmail, 
        Id eSignatureId, Boolean updateEsign) {

        CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
        HttpResponse res;

        // Resets error properties
        CRAN_VAS_KER_ESignature__c eSign = new CRAN_VAS_KER_ESignature__c( Id = eSignatureId );
        eSign.CRAN_VAS_ADV_ErrorCode__c = null;
        eSign.CRAN_VAS_ADV_ErrorDatetime__c = null;
        eSign.CRAN_VAS_ADV_ErrorDescription__c = null;
        eSign.CRAN_VAS_ADV_HasError__c = false;        

        try {
            
            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeStringField('xmlPrint', eSignXml);
            gen.writeStringField('pdf', EncodingUtil.base64Encode(attachBody));
            gen.writeEndObject();
            gen.close();                    
            
            String endPoint = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().SendToArchiveEndPoint__c;
            restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint);
            res = restCallOut.sendSSLJSONRequest(gen.getAsString());
            
            // If no errors occur, sets it as sent to archive 
            // Later it will be verified if it was properly archived
            eSign.CRAN_VAS_KER_Status__c = 'Sent to Archive';
            eSign.CRAN_VAS_KER_Archive_Date__c = System.now();
            eSign.CRAN_VAS_KER_RetryArchive__c = false;            

        } catch (Exception ex) {
            
            // Sets error properties
            eSign.CRAN_VAS_ADV_ErrorCode__c = CRAN_VAS_KER_EmailHelper.InterfaceType.ARCHIVE.name();
            eSign.CRAN_VAS_ADV_ErrorDatetime__c = System.now();
            eSign.CRAN_VAS_ADV_ErrorDescription__c = ex.getMessage() + '\n' + ex.getStackTraceString();
            eSign.CRAN_VAS_ADV_HasError__c = true;
            eSign.CRAN_VAS_KER_Status__c = 'Error';

            // Logs exception details
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, restCallOut, res, CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10020.name());

        } finally {
            // In bulk operation the eSignature is not updated invidually
            if (updateEsign)
                update eSign;
        }

        // Commits the event log
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_BusHandler.class.getName());

        return eSign;

    }

    /**
    * Asynchronous method that sends a notification when a contract is signed
    * @param accountNumber BP account number
    */ 
    @future(callout=true)
    public static void notifyContractSigned(String accountNumber) {
        // Instantiates Event log
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_General', CRAN_VAS_KER_BusHandler.class.getName());

        // Notify that the contract was signed
        notifyContractSignedSync(accountNumber);
    }

    /**
    * Synchronous method that sends a notification when a contract is signed
    * @param accountNumber BP account number
    * @return http response
    */   
    public static HttpResponse notifyContractSignedSync(String accountNumber) {
        
        HttpResponse res;
        CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
        					
        try {

            String origin = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().Origin__c;
            String enviro = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().AvaloqEnvironment__c;                 

            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeFieldName('objList');
            gen.writeStartObject();
            gen.writeStringField('objType', 'bp');
            gen.writeFieldName('obj');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField('avqId', accountNumber);
            gen.writeEndObject();
            gen.writeEndArray();
            gen.writeEndObject();
            gen.writeFieldName('keyValue');
            gen.writeStartObject();
            gen.writeStringField('keyType', 'symbol');
            gen.writeStringField('value', 'AF');
            gen.writeEndObject();
            gen.writeStringField('signtDate', System.now().format('YYYY-MM-dd hh:mm', UserInfo.getTimeZone().getID()));
            gen.writeEndObject();
            
            String escapedContent = gen.getAsString();      
            
            gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeStringField('service', 'SfSignContrReq');
            gen.writeStringField('content', escapedContent);
            gen.writeStringField('codAppOrigin', origin);
            gen.writeStringField('codEnv', enviro);
            gen.writeEndObject();
            gen.close();            

            String endPoint = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().PrintOMSEndPoint__c;
            
            Datetime now = Datetime.now();
            String headerDate = now +':'+  now.millisecond();        
            Map<String, String> additionalHeaders = new Map<String, String>();
            additionalHeaders.put('Date', headerDate);
            
            restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint, additionalHeaders);

            // As per definition, no action is required to assess
            // if the call out was successful
            res = restCallOut.sendSSLJSONRequestWithEncryption(gen.getAsString());

        } catch (Exception ex) {

            // Logs exception details
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
                restCallOut, 
                res, 
                CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10017.name());   

            // If it isn't an asynchronous call, throws the exception
            if (!isAsynchronous()) {
                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10017.name()
                }));
            }   

        }

        return res;

    }
    
    /**
    * Updates medium for an Opportunity
    * @param oppId id of an opportunity
    */      
    public static void setAvaloqMediumToSalesforce(String oppId) {
        
        try {
           
           // Calls Vector's helper
    	   CRAN_VEC_ADV_GenTrx_AUC.updateMedium(oppId);

        } catch (Exception ex) {

            // Logs exception details
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
                null, 
                CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10019.name());
            
            // If it isn't an asynchronous call, throws the exception
            if (!isAsynchronous()) {
                throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
                    CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10019.name()
                }));
            }
        }  

    }

    /**
    * Retrieves the PDF file from Archive
    * @param orderNr order number to get the PDF file
    * @param bp BP avaloq Id
    * @param referenceLine reference line to get the PDF file
    * @return file content
    */ 
    public String getDocumentArchive(String orderNr, String bp, String referenceLine) {
                                                  
        String response = null;
        HttpResponse res; 
        CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
        Map<String, Object> parameters = new Map<String, Object>();                                                       
        
        try {

            // Checks whether the optional parameters were informed or not.
            // If so, adds them to the JSON body
            if (String.isNotBlank(orderNr) && !orderNr.equalsIgnoreCase('undefined'))                                                 
                parameters.put('orderNr', orderNr);
            
            if (String.isNotBlank(bp) && !bp.equalsIgnoreCase('undefined'))
                parameters.put('bpId', bp);
            
            if (String.isNotBlank(referenceLine) && !referenceLine.equalsIgnoreCase('undefined'))
                parameters.put('referenceLine',referenceLine);            

            String endPoint = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().GetFromArchiveEndPoint__c;
            restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint);            
            res = restCallOut.sendSSLJSONRequest(JSON.serialize(parameters));

            CRAN_VAS_KER_BusPDFResponse pdfResponse = (CRAN_VAS_KER_BusPDFResponse) JSON.deserialize(res.getBody(), CRAN_VAS_KER_BusPDFResponse.class);
            
            if (pdfResponse != null && String.isNotBlank(pdfResponse.pdfContent))
                response = pdfResponse.pdfContent;

        } catch (Exception ex) {

            // Logs exception details
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
                restCallOut, 
                res, 
                CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10002.name());               

        }
    
        return response;    
    }

    /**
    * Sends the Certificate and Envelope to Registro de Firma
    * @param eSignDocument eSignature sObject of an Envelope
    * @param eSignCertificate eSignature sObject of a Certificate
    * @param documentFileContent file content of an Envelope
    * @param certificateFileContent file content of a Certifiate
    * @param bpEmail BP's email
    * @param updateESign if true updates the eSignature file     
    * @return map containing the Envelope and Certificate eSignature sObject file
    */ 
    public static  Map<String, CRAN_VAS_KER_ESignature__c> sentToSignRegister(CRAN_VAS_KER_ESignature__c eSignDocument, 
        CRAN_VAS_KER_ESignature__c eSignCertificate, Blob documentFileContent, 
        Blob certificateFileContent, String bpEmail, Boolean updateESign) {
        
        String signType;
        HttpResponse res;
        CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;

        try {

            // Sets the signature type based on the eSignature type
            if (eSignDocument.CRAN_VAS_KER_Signature_Type__c == 'Form') {
                signType = 'advisory.perfilado';
            } else if (eSignDocument.CRAN_VAS_KER_Signature_Type__c == 'Proposal') {
                signType = 'advisory.propuesta.inversion';
            } else if (eSignDocument.CRAN_VAS_KER_Signature_Type__c == 'Contract') {
                signType = 'advisory.contract';
            } else if (eSignDocument.CRAN_VAS_KER_Order__r.CRAN_VEC_ADV_P_MetaType__c == 'STEX') {
                if (eSignDocument.CRAN_VAS_KER_Order__r.Type == 'Compra') {
                    signType = 'operacion.compra.va99';
                } else {
                    signType = 'operacion.venta.va99';
                }
            } else {
                if (eSignDocument.CRAN_VAS_KER_Order__r.Type == 'Compra') {
                    signType = 'operacion.compra.di99';
                } else {
                    signType = 'operacion.venta.di99';
                }
            }

            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeStringField('orderNr', eSignDocument.CRAN_VAS_KER_Core_Id__c);
            gen.writeFieldName('operacion');
            gen.writeStartObject();

            // When it's a contract, its avaloq Id is also informed
            if (String.isNotBlank(eSignDocument.CRAN_VAS_KER_T_ContractId__c))
            {
                if(eSignDocument.CRAN_VAS_KER_T_ContractId__c.contains(';'))
                {
                    List<String> etmp = eSignDocument.CRAN_VAS_KER_T_ContractId__c.split(';');
                    gen.writeNumberField('contractId', Integer.valueOf(etmp[0]));
                }
                else
                {
                    gen.writeNumberField('contractId', Integer.valueOf(eSignDocument.CRAN_VAS_KER_T_ContractId__c));
                }
            }
            else
            {
                gen.writeNumberField('contractId', 9999999);
            }
            gen.writeStringField('personId', eSignDocument.CRAN_VAS_KER_Person_Id__c);
            gen.writeStringField('personName', eSignDocument.CRAN_VAS_KER_Client_Name__c);
            gen.writeNumberField('bpId', Integer.valueOf(eSignDocument.CRAN_VAS_KER_BP_Id__c));
            gen.writeStringField('tipo', signType);
            gen.writeDateTimeField('fechaInicio', eSignDocument.CreatedDate);
            gen.writeDateTimeField('fechaFinalizacion', eSignDocument.CreatedDate);
            gen.writeStringField('estado', '0');
            gen.writeStringField('businessUnit', 'CA');
            gen.writeStringField('canal', 'SALESFORCE');
            gen.writeEndObject();
            gen.writeStringField('contFirmado', EncodingUtil.base64Encode(documentFileContent));
            gen.writeStringField('certificado', EncodingUtil.base64Encode(certificateFileContent));
            gen.writeEndObject();
            gen.close();

            String endPoint = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().SignatureRegister__c;
            restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint);
            res = restCallOut.sendSSLJSONRequest(gen.getAsString());

            if (res.getStatusCode() == 201) {

                CRAN_VAS_KER_SignatureRegister_CLS signRegister = (CRAN_VAS_KER_SignatureRegister_CLS) JSON.deserialize(res.getBody(), CRAN_VAS_KER_SignatureRegister_CLS.class);
                
                eSignDocument.CRAN_VAS_KER_N_SignatureRegisterOpCode__c = signRegister.codOperacion;
                eSignDocument.CRAN_VAS_KER_SignatureRegisterSignCode__c = signRegister.codFirma;

                eSignCertificate.CRAN_VAS_KER_N_SignatureRegisterOpCode__c = signRegister.codOperacion;
                eSignCertificate.CRAN_VAS_KER_SignatureRegisterSignCode__c = signRegister.codFirma;
                eSignCertificate.CRAN_VAS_KER_Status__c = 'Sent to Registro de Firma';

            } else {
               throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_ErrorSendingSignatureRegistration);
            } 

        }  catch (Exception ex) {

            // Logs exception details
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
                restCallOut, 
                res, 
                CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10018.name());               

        } finally {
            if (updateEsign) {
                update eSignDocument;
                update eSignCertificate;
            }
        }

        return new Map<String, CRAN_VAS_KER_ESignature__c>{ 'Envelope' => eSignDocument,
                                                              'Certificate' => eSignCertificate};
        
    }

    /**
    * Checks if the transaction is running in asynchronous mode
    * @return true if it's an asynchronous context
    */ 
    private static Boolean isAsynchronous() {
        return System.isBatch() || System.isFuture() || System.isQueueable() || System.isScheduled();
    }    
    
}