global class CRAN_VAS_KER_ESignRegistroDeFirma_BCH implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Gets all eSignature that were not properly archived
        return Database.getQueryLocator([SELECT Id, 
                                         CRAN_VAS_KER_File_Name__c,
                                         CRAN_VAS_KER_Sent_XML__c,
                                         CRAN_VAS_KER_RetryArchive__c,
                                         CRAN_VAS_KER_Signature_Type__c,
                                         CRAN_VAS_KER_Order__r.CRAN_VEC_ADV_P_MetaType__c,
                                         CRAN_VAS_KER_Order__r.Type,
                                         CRAN_VAS_KER_Core_Id__c,
                                         CRAN_VAS_KER_T_ContractId__c,
                                         CRAN_VAS_KER_Person_Id__c,
                                         CRAN_VAS_KER_Client_Name__c,
                                         CRAN_VAS_KER_BP_Id__c,
                                         CRAN_VAS_ADV_ErrorCode__c,
                                         CRAN_VAS_ADV_ErrorDescription__c,
                                         CRAN_VAS_ADV_HasError__c,
                                         CRAN_VAS_KER_Status__c,
                                         CRAN_VAS_KER_Archive_Date__c,
                                         CRAN_VAS_KER_Signature_Id__c,
                                         CRAN_VAS_KER_P_DocumentType__c,
                                         CRAN_VAS_KER_N_SignatureRegisterOpCode__c,
                                         CRAN_VAS_KER_SignatureRegisterSignCode__c,
                                         CreatedDate												
                                         FROM CRAN_VAS_KER_ESignature__c 
                                         WHERE CRAN_VAS_KER_N_SignatureRegisterOpCode__c = NULL
                                         ORDER BY CreatedDate]);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        
        // Starting event log
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_PostProcessingRegistroFirma', CRAN_VAS_KER_ESignRegistroDeFirma_BCH.class.getName());
        
        Set<String> fileNames = new Set<String>();
        Map<String, Map<String, Blob>> attachmentsByEnvelopeId = new Map<String, Map<String, Blob>>();
        Map<String, Map<String, CRAN_VAS_KER_ESignature__c>> eSignaturesByEnvelopeId = new Map<String, Map<String, CRAN_VAS_KER_ESignature__c>>();
        
        // Creates a list containing the file's name and
        // maps eSignatures by its envelope id
        for (CRAN_VAS_KER_ESignature__c eSign : (List<CRAN_VAS_KER_ESignature__c>)scope) {
            
            Map<String, CRAN_VAS_KER_ESignature__c> eSignaturesByType = eSignaturesByEnvelopeId.get(eSign.CRAN_VAS_KER_Signature_Id__c);
            
            if (eSignaturesByType == null) {
                eSignaturesByType = new Map<String, CRAN_VAS_KER_ESignature__c>();
                eSignaturesByEnvelopeId.put(eSign.CRAN_VAS_KER_Signature_Id__c, eSignaturesByType);
            }
            
            eSignaturesByType.put(eSign.CRAN_VAS_KER_P_DocumentType__c, eSign);
            
            fileNames.add(eSign.CRAN_VAS_KER_File_Name__c);
        }
        
        // Fetches attachment based on its name
        Pattern envelopeIdPattern = Pattern.compile('(?<=(Certificate|Envelope)\\s)(.*)(?=.pdf)');
        Pattern typePattern = Pattern.compile('(Certificate|Envelope)');
        
        for (Attachment attach : [SELECT Name, Body FROM Attachment WHERE Name=: fileNames]) {
            
            Matcher matcher = envelopeIdPattern.matcher(attach.Name);
            matcher.find();
            String envelopeId = attach.Name.substring(matcher.start(0), matcher.end(0));
            
            matcher = typePattern.matcher(attach.Name);
            matcher.find();
            String eSignType = attach.Name.substring(matcher.start(0), matcher.end(0));	
            
            Map<String, Blob> attachmentsByType = attachmentsByEnvelopeId.get(envelopeId);
            
            if (attachmentsByType == null) {
                attachmentsByType = new  Map<String, Blob>();
                attachmentsByEnvelopeId.put(envelopeId, attachmentsByType);
            }        
            
            attachmentsByType.put(eSignType, attach.Body);
        }
        
        for (String envelopeId : eSignaturesByEnvelopeId.keySet()) {
            
            Map<String, CRAN_VAS_KER_ESignature__c> eSignaturesByType = eSignaturesByEnvelopeId.get(envelopeId);
            Map<String, Blob> attachmentsByType = attachmentsByEnvelopeId.get(envelopeId);
            
            if (attachmentsByType != null 
                && attachmentsByType.get('Envelope') != null 
                && attachmentsByType.get('Certificate') != null
               && eSignaturesByType.get('Certificate') != null
               && eSignaturesByType.get('Envelope') != null) {
                eSignaturesByType.putAll(CRAN_VAS_KER_BusHandler.sentToSignRegister(eSignaturesByType.get('Envelope'), 
                                                                                    eSignaturesByType.get('Certificate'), 
                                                                                    attachmentsByType.get('Envelope'), 
                                                                                    attachmentsByType.get('Certificate'), null, false));
            } else {
                
                if (eSignaturesByType.get('Certificate') == null) {
                    
                    String fileNotFound = String.format(Label.CRAN_VAS_KER_EsignatureNotFound,
                                                        new String[] {
    															envelopeId
                                                                });
                    CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(fileNotFound, CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel(), CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10003.name());
                }         
                
                if (eSignaturesByType.get('Envelope') == null) {
                    
                    String fileNotFound = String.format(Label.CRAN_VAS_KER_EsignatureNotFound,
                                                        new String[] {
    															envelopeId
                                                                });
                    CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(fileNotFound, CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel(), CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10003.name());
                }                                
                
                if (eSignaturesByType.get('Envelope') != null 
                    && eSignaturesByType.get('Envelope').CRAN_VAS_KER_Status__c == 'Sent to Archive'
                    && (attachmentsByType == null || attachmentsByType.get('Envelope') == null)) {
                    
                    String fileNotFound = String.format(Label.CRAN_VAS_KER_AttachmentNotFound,
                                                        new String[] {
                                                            eSignaturesByType.get('Envelope').Id,
                                                                eSignaturesByType.get('Envelope').CRAN_VAS_KER_File_Name__c
                                                                });
                    CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(fileNotFound, Attachment.sObjectType.getDescribe().getLabel(), CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10007.name());
                }
                
                if (eSignaturesByType.get('Certificate') != null
                    && (attachmentsByType == null || attachmentsByType.get('Certificate') == null)) {
                        
                        if (eSignaturesByType.get('Envelope') != null 
                            && eSignaturesByType.get('Envelope').CRAN_VAS_KER_Status__c == 'Sent to Archive') {
                                
                                String fileNotFound = String.format(Label.CRAN_VAS_KER_AttachmentNotFound,
                                                                    new String[] {
                                                                        eSignaturesByType.get('Certificate').Id,
                                                                            eSignaturesByType.get('Certificate').CRAN_VAS_KER_File_Name__c
                                                                            });
                                CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(fileNotFound, Attachment.sObjectType.getDescribe().getLabel(), CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10007.name());
                            }
                    }		          	
            }
        }
        
        // Whether or not was successful, updates the records and commit the event log
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Database.update(scope, false),
                                                                 CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel());
        
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_ESignRegistroDeFirma_BCH.class.getName());		
    }
    
    global void finish(Database.BatchableContext bc) {
        
        // Check batch status - IF COMPLETED then 
        AsyncApexJob job = [SELECT 	Id, 
                            Status
                            FROM 	AsyncApexJob 
                            WHERE Id = :bc.getJobId()];        
        
        // Chaining Batch execution
        if (job.Status == 'Completed') {
            
            // If post processing is not scheduled then schedule it
            List<CronTrigger> scheduledJobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'eSignatureRegistroDeFirma'];
            
            if (scheduledJobs.isEmpty()) {
                
                String batchName = CRAN_VAS_KER_ESignRegistroDeFirma_BCH.class.getName();
                CRAN_VAS_KER_BatchSettings__mdt batchSettings = [SELECT CRAN_VAS_KER_N_BatchChainingInterval__c, 
                                                                 CRAN_VAS_KER_N_BatchChunkSize__c,
                                                                 CRAN_VAS_KER_B_ChainingExecution__c
                                                                 FROM	CRAN_VAS_KER_BatchSettings__mdt
                                                                 WHERE 	DeveloperName =: batchName];
                
                Decimal minutes = 30;
                Decimal chunkSize = 200;
                Boolean isChaining = true;
                
                if (batchSettings != null) {
                    minutes = batchSettings.CRAN_VAS_KER_N_BatchChainingInterval__c;
                    chunkSize = batchSettings.CRAN_VAS_KER_N_BatchChunkSize__c;
                    isChaining = batchSettings.CRAN_VAS_KER_B_ChainingExecution__c;
                }
                
                if (isChaining)
                    System.scheduleBatch(new CRAN_VAS_KER_ESignRegistroDeFirma_BCH(), 'eSignatureRegistroDeFirma', minutes.intValue(), chunkSize.intValue());
            }
        }
        
    }
    
}