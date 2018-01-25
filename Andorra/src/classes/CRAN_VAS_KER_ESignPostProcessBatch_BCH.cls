/**
* Batch class responsible to assessing that DocuSign files 
* were properly archived, purging them from Salesforce and DocuSign afterwards
* @author Zuinglio Lopes Ribeiro Júnior
* @version 1.0
*/
global class CRAN_VAS_KER_ESignPostProcessBatch_BCH implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	
	global CRAN_VAS_KER_DocusignAPIMngr manager;

	global CRAN_VAS_KER_ESignPostProcessBatch_BCH() {
		manager = CRAN_VAS_KER_DocusignAPIMngr.getInstance();
		manager.userLogin();
	}

	global Database.QueryLocator start(Database.BatchableContext bc) {
		// Gets all eSignature that were sent to archive and registro de firma
		return Database.getQueryLocator([SELECT Id, 
												CRAN_VAS_KER_Core_Id__c, 
												CRAN_VAS_KER_Reference_Line__c, 
												CRAN_VAS_KER_BP_Id__c, 
												CRAN_VAS_KER_File_Name__c, 
												CRAN_VAS_KER_Signature_Id__c,
												CRAN_VAS_KER_Postprocessed__c,
												CRAN_VAS_KER_P_DocumentType__c,
												CRAN_VAS_KER_RetryArchive__c
										FROM 	CRAN_VAS_KER_ESignature__c 
										WHERE 	CRAN_VAS_KER_N_SignatureRegisterOpCode__c != NULL
										AND 	CRAN_VAS_KER_Postprocessed__c = FALSE
										AND 	CRAN_VAS_KER_RetryArchive__c = FALSE
										AND 	CRAN_VAS_ADV_HasError__c = FALSE]);			
	}
	
	global void execute(Database.BatchableContext bc, List<sObject> scope) {

		// Starting event log
		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_ArchivePostProcessing', CRAN_VAS_KER_ESignPostProcessBatch_BCH.class.getName());

		CRAN_VAS_KER_BusHandler bus = new CRAN_VAS_KER_BusHandler();
		List<CRAN_VAS_KER_ESignature__c> toUpdate = new List<CRAN_VAS_KER_ESignature__c>();
		Set<String> filesToBeDeleted = new Set<String>();

		for (CRAN_VAS_KER_ESignature__c eSign : (List<CRAN_VAS_KER_ESignature__c>)scope) {

		 	try {

		 		String pdfContent;

		 		if (eSign.CRAN_VAS_KER_P_DocumentType__c == 'Envelope') {

			 		if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().isDebugEnabled()) {
			 			System.debug('eSignature of Envelope type to be verified if it was archived');
			 			System.debug(eSign);
			 		}

		 			// If the call out limit is reached, post processing will continue on the next execution
			 		if (Limits.getCallouts() == Limits.getLimitCallouts()) {
						CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Label.CRAN_VAS_KER_CalloutLimitReached, CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel(), 
							CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10006.name());
			 			break;
			 		}

			 		// Tries to retrive eSignature document from archive
			 		pdfContent = bus.getDocumentArchive(eSign.CRAN_VAS_KER_Core_Id__c, eSign.CRAN_VAS_KER_BP_Id__c, 
						eSign.CRAN_VAS_KER_Reference_Line__c);


			 		if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().isDebugEnabled()) {
			 			System.debug('eSignature of Envelope type archive response');
			 			System.debug(pdfContent);
			 		}

			 	}

		 		// If the content is not blank the document was properly archived and won't be checked again.
		 		// If it's blank, the eSignature of Envelope type is checked to a new retry after
		 		// the batch finishes the execution of all chunks
		 		// As certificates are not archived they can be purged straight away
				if (eSign.CRAN_VAS_KER_P_DocumentType__c == 'Certificate' || String.isNotBlank(pdfContent)) { 

					// If the call out limit is reached, post processing will continue on the next execution
			 		if (Limits.getCallouts() == Limits.getLimitCallouts()) {
						CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(Label.CRAN_VAS_KER_CalloutLimitReached, 
							CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel(), CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10006.name());
			 			break;
			 		}

			 		if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().isDebugEnabled()) {
			 			System.debug('eSignature to be purged');
			 			System.debug(eSign);
			 		}

					// Purges the envelope from DocuSign
					manager.purgeEnvelope(eSign.CRAN_VAS_KER_Signature_Id__c);

					// Sets the record as processed and clear error state
					eSign.CRAN_VAS_KER_Postprocessed__c = true;			

					// Attachments that can be deleted
					filesToBeDeleted.add(eSign.CRAN_VAS_KER_File_Name__c);

				} else {
					eSign.CRAN_VAS_KER_RetryArchive__c = true;
					CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(getFormmatedError(eSign, null), 
						CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel(), 
						CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10005.name());	
				}

				// Regardless of the outcome all eSignature are updated
				toUpdate.add(eSign);

			} catch (Exception ex) {
	           	
	           	String errorMsg = ex.getMessage();

	            if (String.isNotBlank(errorMsg) && !errorMsg.contains('CRAN_ERR_')) {
					CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, null, 
						CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10001.name());
				}
			}								

		}

		if (!toUpdate.isEmpty()) {

			Database.DeleteResult[] deleteResults = Database.delete([SELECT Id FROM Attachment WHERE Name =: filesToBeDeleted], false);
			CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(deleteResults, Attachment.sObjectType.getDescribe().getLabel());

			Database.SaveResult[] saveResults = Database.update(toUpdate, false);
			CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(saveResults, CRAN_VAS_KER_ESignature__c.sObjectType.getDescribe().getLabel());

		}
		
		// Commits the event log
		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_ESignPostProcessBatch_BCH.class.getName());
	}

	private String getFormmatedError(CRAN_VAS_KER_ESignature__c eSign, Exception ex) {

		String exMsg = '';
		if (ex != null) {
			exMsg = CRAN_VAS_KER_EventLogHelper_CLS.getInstance().getFormattedException(ex);
		}

		return String.format(Label.CRAN_VAS_KER_FileNotArchived, 
					new String[] {
						eSign.Id,
						eSign.CRAN_VAS_KER_File_Name__c,
						exMsg
					});
	}
	
	global void finish(Database.BatchableContext bc) {
	    
	    // Check batch status - IF COMPLETED then 
	    AsyncApexJob job = [SELECT 	Id, 
	    							Status
	        				FROM 	AsyncApexJob 
	        				WHERE Id = :bc.getJobId()];        

	    // Chaining Batch execution
	    if (job.Status == 'Completed') {

	    	// If post processing retry is not scheduled then schedule it
	    	List<CronTrigger> scheduledJobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'eSignaturePostProcess'];

	    	if (scheduledJobs.isEmpty()) {

	    		String batchName = CRAN_VAS_KER_ESignPostProcessBatch_BCH.class.getName();
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
					System.scheduleBatch(new CRAN_VAS_KER_ESignPostProcessBatch_BCH(), 'eSignaturePostProcess', 
						minutes.intValue(), chunkSize.intValue());
	    	}
	    }

	}
    
}