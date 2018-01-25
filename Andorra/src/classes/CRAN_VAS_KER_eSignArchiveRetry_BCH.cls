global class CRAN_VAS_KER_eSignArchiveRetry_BCH implements Database.Batchable<sObject>, Database.AllowsCallouts {
	
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
                                                CreatedDate												
										FROM 	CRAN_VAS_KER_ESignature__c 
										WHERE 	(CRAN_VAS_KER_RetryArchive__c = TRUE
												OR CRAN_VAS_ADV_HasError__c = TRUE)
												AND CRAN_VAS_KER_P_DocumentType__c = 'Envelope'
										ORDER BY CreatedDate]);
	}

   	global void execute(Database.BatchableContext bc, List<sObject> scope) {

   		// Starting event log
		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_PostProcessingArchiveRetry', CRAN_VAS_KER_eSignArchiveRetry_BCH.class.getName());

   		Map<String, Blob> attachmentsByFileName = new Map<String, Blob>();
   		Map<String, CRAN_VAS_KER_ESignature__c> eSignaturesByFileName = new Map<String, CRAN_VAS_KER_ESignature__c>();

   		// Creates a list containing the file's name and
   		// maps eSignatures by its envelope id
		for (CRAN_VAS_KER_ESignature__c eSign : (List<CRAN_VAS_KER_ESignature__c>)scope) {
			eSignaturesByFileName.put(eSign.CRAN_VAS_KER_File_Name__c, eSign);
		}

		if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().isDebugEnabled()) {
			System.debug('eSignaturesByFileName');
			System.debug(eSignaturesByFileName);
		}

		// Retrieves attachments related to each eSignature envelope
		for (Attachment attach : [SELECT Name, Body FROM Attachment WHERE Name=: eSignaturesByFileName.keySet()]) {
			attachmentsByFileName.put(attach.Name, attach.Body);
		}

		if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().isDebugEnabled()) {
			System.debug('attachmentsByFileName');
			System.debug(attachmentsByFileName);
		}

		for (String eSignName : eSignaturesByFileName.keySet()) {

			CRAN_VAS_KER_ESignature__c eSignatureEnvelope = eSignaturesByFileName.get(eSignName); 
			
			// If the call out limit is reached, post processing will continue on the next execution
	 		if (Limits.getCallouts() == Limits.getLimitCallouts()) {
				CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Label.CRAN_VAS_KER_CalloutLimitReached, 
					CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel(),
				 	CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10006.name());
	 			break;
	 		}

	 		Blob file = attachmentsByFileName.get(eSignName);
	 		
			if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().isDebugEnabled()) {
	 			System.debug('document to be archived ' + file);
	 		}

	 		// If the file was found, sends it to archive. If not, log an error
	 		if (file != null) {

				CRAN_VAS_KER_ESignature__c returnedESignatureEnvelope = CRAN_VAS_KER_BusHandler.sendToArchive(eSignatureEnvelope.CRAN_VAS_KER_Sent_XML__c, 
													  file, 
	                                                  null,
	                                                  eSignatureEnvelope.Id, false);

    			eSignatureEnvelope.CRAN_VAS_ADV_ErrorCode__c = returnedESignatureEnvelope.CRAN_VAS_ADV_ErrorCode__c;
    			eSignatureEnvelope.CRAN_VAS_ADV_ErrorDatetime__c = returnedESignatureEnvelope.CRAN_VAS_ADV_ErrorDatetime__c;
		        eSignatureEnvelope.CRAN_VAS_ADV_ErrorDescription__c = returnedESignatureEnvelope.CRAN_VAS_ADV_ErrorDescription__c;
		        eSignatureEnvelope.CRAN_VAS_ADV_HasError__c = returnedESignatureEnvelope.CRAN_VAS_ADV_HasError__c;   
		        eSignatureEnvelope.CRAN_VAS_KER_Status__c = returnedESignatureEnvelope.CRAN_VAS_KER_Status__c;
        		eSignatureEnvelope.CRAN_VAS_KER_Archive_Date__c = returnedESignatureEnvelope.CRAN_VAS_KER_Archive_Date__c;
        		eSignatureEnvelope.CRAN_VAS_KER_RetryArchive__c = returnedESignatureEnvelope.CRAN_VAS_KER_RetryArchive__c;  	

        		if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().isDebugEnabled()) {
					System.debug('eSignatureEnvelope after archiving');
					System.debug(eSignatureEnvelope);
				}
			
          	} else {
          		String fileNotFound = String.format(Label.CRAN_VAS_KER_AttachmentNotFound,
          			new String[] {
          					eSignatureEnvelope.Id,
          					eSignatureEnvelope.CRAN_VAS_KER_File_Name__c
          				});
          		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(fileNotFound, CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel(), CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10007.name());
          	}

		}

		// Whether or not was successful, updates the records and commit the event log
		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Database.update(scope, false),
			CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel());

		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_eSignArchiveRetry_BCH.class.getName());		
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
	    	List<CronTrigger> scheduledJobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'eSignaturePostProcessArchiveRetry'];

	    	if (scheduledJobs.isEmpty()) {

	    		String batchName = CRAN_VAS_KER_eSignArchiveRetry_BCH.class.getName();
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
					System.scheduleBatch(new CRAN_VAS_KER_eSignArchiveRetry_BCH(), 'eSignaturePostProcessArchiveRetry', minutes.intValue(), chunkSize.intValue());
	    	}
	    }

	}
	
}