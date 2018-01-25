global class CRAN_VAS_KER_EventLogPurge_BCH implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	
    global CRAN_VAS_KER_BatchSettings__mdt batchSettings;
    
	global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String batchName = CRAN_VAS_KER_EventLogPurge_BCH.class.getName();
        batchSettings = [SELECT	CRAN_VAS_KER_N_BatchChainingInterval__c, 
                                CRAN_VAS_KER_N_BatchChunkSize__c,
                                CRAN_VAS_KER_B_ChainingExecution__c,
                                CRAN_VAS_KER_T_DeleteCondition__c
                         FROM	CRAN_VAS_KER_BatchSettings__mdt
                         WHERE 	DeveloperName =: batchName];        
        
		// Gets all eSignature that were sent to archive and registro de firma
        return Database.getQueryLocator(String.format('SELECT Id FROM CRAN_VAS_KER_EventLog__c WHERE {0}',
                                                      new String[] {
                                                         batchSettings.CRAN_VAS_KER_T_DeleteCondition__c
                                                      }));			
	}
	
	global void execute(Database.BatchableContext bc, List<sObject> scope) {
	
		// Starting event log
		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_General', CRAN_VAS_KER_EventLogPurge_BCH.class.getName());

		Set<Id> entitiesId = new Set<Id>();
		Set<Id> contentDocumentsId = new Set<Id>();

		for (sObject sObj : scope) {
			entitiesId.add(sObj.Id);
		}

		for (ContentDocumentLink documentLink : [SELECT ContentDocumentId
												FROM ContentDocumentLink
												WHERE LinkedEntityId =: entitiesId]) {
			contentDocumentsId.add(documentLink.ContentDocumentId);
		}

        Database.DeleteResult[] filesDeleteResults;
        Database.DeleteResult[] entitiesDeleteResults;

        try {
        	filesDeleteResults = Database.delete([SELECT Id FROM ContentDocument WHERE Id =: contentDocumentsId], false);
            entitiesDeleteResults = Database.delete(scope, false);
        } catch (Exception ex) {
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(filesDeleteResults, 
                                                                     CRAN_VAS_KER_EventLog__c.sObjectType.getDescribe().getLabel());         	
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(entitiesDeleteResults, 
                                                                     CRAN_VAS_KER_EventLog__c.sObjectType.getDescribe().getLabel());         
        }
        
        // Commits the event log
        if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().size() != null
            && CRAN_VAS_KER_EventLogHelper_CLS.getInstance().size() > 0)
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_EventLogHelper_CLS.class.getName());           
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
	    	List<CronTrigger> scheduledJobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'EventLogPurge'];

	    	if (scheduledJobs.isEmpty()) {

	    		Decimal minutes = 1440;
	    		Decimal chunkSize = 200;
	    		Boolean isChaining = true;

	    		if (batchSettings != null) {
	    			minutes = batchSettings.CRAN_VAS_KER_N_BatchChainingInterval__c;
	    			chunkSize = batchSettings.CRAN_VAS_KER_N_BatchChunkSize__c;
	    			isChaining = batchSettings.CRAN_VAS_KER_B_ChainingExecution__c;
	    		}

	    		if (isChaining)
					System.scheduleBatch(new CRAN_VAS_KER_ESignPostProcessBatch_BCH(), 'EventLogPurge', 
						minutes.intValue(), chunkSize.intValue());
	    	}
	    }

	}
    
}