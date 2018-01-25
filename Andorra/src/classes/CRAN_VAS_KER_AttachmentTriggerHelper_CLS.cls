public with sharing class CRAN_VAS_KER_AttachmentTriggerHelper_CLS {

    private static CRAN_VAS_KER_AttachmentTriggerHelper_CLS instance;
    private CRAN_VAS_KER_BusHandler bus;
    private Map<String, Blob> attachmentsByFileName;
    private Map<String, List<CRAN_VAS_KER_ESignature__c>> eSignaturesByFileName;
	private Map<String, String> bpEmailByFileName;
    private Set<String> contractBPNumbersToNotify;
    
    public static CRAN_VAS_KER_AttachmentTriggerHelper_CLS getInstance() {
	
        if (instance != null) {
        	return instance;
        } else {
        	instance = new CRAN_VAS_KER_AttachmentTriggerHelper_CLS();
        	return instance;
        }        
    }    
    
    private CRAN_VAS_KER_AttachmentTriggerHelper_CLS() {
		
    	bus = new CRAN_VAS_KER_BusHandler();
    	attachmentsByFileName = new Map<String, Blob>();
        eSignaturesByFileName = new Map<String, List<CRAN_VAS_KER_ESignature__c>>();
        contractBPNumbersToNotify = new Set<String>();
        bpEmailByFileName = new Map<String, String>();

    }

    public void run() {
        searchForExistingSignatures();
        sendToArchive();
        sendNotifications();        
    }   
    
    public void addToMap(Attachment attach) {
        if (attach.Name.contains('Envelope'))
            attachmentsByFileName.put(attach.Name, attach.Body);
    }    

	private void searchForExistingSignatures() {

		Set<String> customFormIds = new Set<String>();
        Set<String> bpNumbers = new Set<String>();
		Map<String, String>	emailByBpNumber = new Map<String, String>();
		
		List<CRAN_VAS_KER_ESignature__c> eSignatures =  [SELECT Id,    													  
                                                                CRAN_VAS_KER_BP_Id__c,
                                                                CRAN_VAS_KER_Account__c,
                                                                CRAN_VAS_KER_Opportunity__c,
                                                                CRAN_VAS_KER_File_Name__c,
																CRAN_VAS_KER_Core_Id__c,
                                                                CRAN_VAS_KER_Contract__c,
                                                                CRAN_VAS_KER_Contract__r.CRAN_VAS_KER_BP__r.AccountNumber,
                                                                CRAN_VAS_KER_Sent_XML__c
														FROM 	CRAN_VAS_KER_ESignature__c
														WHERE 	CRAN_VAS_KER_File_Name__c =: attachmentsByFileName.keySet()];                     
		 
		for (CRAN_VAS_KER_ESignature__c eSignature : eSignatures) {

            List<CRAN_VAS_KER_ESignature__c> eSignaturesList = eSignaturesByFileName.get(eSignature.CRAN_VAS_KER_File_Name__c);

            if (eSignaturesList == null) {
                eSignaturesList = new List<CRAN_VAS_KER_ESignature__c>();
                eSignaturesByFileName.put(eSignature.CRAN_VAS_KER_File_Name__c, eSignaturesList);
            }

            eSignaturesList.add(eSignature);

			bpNumbers.add(eSignature.CRAN_VAS_KER_BP_Id__c);
			
			// Si es la firma existente de una perfilado a la que le llega el adjunto hemos de cambiar su estado
			if (String.isNotBlank(eSignature.CRAN_VAS_KER_Account__c) && String.isNotBlank(eSignature.CRAN_VAS_KER_Opportunity__c))
				customFormIds.add(eSignature.CRAN_VAS_KER_Core_Id__c);

            if (String.isNotBlank(eSignature.CRAN_VAS_KER_Contract__c))
                contractBPNumbersToNotify.add(eSignature.CRAN_VAS_KER_Contract__r.CRAN_VAS_KER_BP__r.AccountNumber);
				
		}
		
		for (Account bpAccount : [	SELECT 	CRAN_VEC_ADV_N_Number__c,
											CRAN_VEC_ADV_L_MainMngr__r.Email
									FROM	Account
									WHERE 	CRAN_VEC_ADV_N_Number__c =: bpNumbers]) {
			emailByBpNumber.put(bpAccount.CRAN_VEC_ADV_N_Number__c, bpAccount.CRAN_VEC_ADV_L_MainMngr__r.Email);							
		}
		
		for (CRAN_VAS_KER_ESignature__c eSignature : eSignatures) {		
			bpEmailByFileName.put(eSignature.CRAN_VAS_KER_File_Name__c, emailByBpNumber.get(eSignature.CRAN_VAS_KER_BP_Id__c));			
		}		
		
		if (!customFormIds.isEmpty())
			markCustomformResponsesAsSigned(customFormIds);
		
    }
    
    private void sendToArchive() {

        for (String fileName : attachmentsByFileName.keySet()) {

            List<CRAN_VAS_KER_ESignature__c> eSignatures = eSignaturesByFileName.get(fileName);

            if (eSignatures != null) {

                for (CRAN_VAS_KER_ESignature__c eSignature : eSignatures) {
                    CRAN_VAS_KER_BusHandler.sendToArchiveFuture(eSignature.CRAN_VAS_KER_Sent_XML__c, 
                        attachmentsByFileName.get(fileName),
                        bpEmailByFileName.get(fileName),
                        eSignature.Id);
                }
            }
        }
    }
    
    private void markCustomformResponsesAsSigned(Set<String> ids) {

		for (List<CRAN_VEC_ADV_CustomForm_Response__c> responses : [	SELECT 	Id, 
																			CRAN_VEC_ADV_P_Acceptance_Status__c
																	FROM 	CRAN_VEC_ADV_CustomForm_Response__c
																	WHERE 	CRAN_VEC_ADV_T_Avaloq_External_Id__c IN :ids]) {
	    	
			for (CRAN_VEC_ADV_CustomForm_Response__c toUpdate : responses) {
				toUpdate.CRAN_VEC_ADV_P_Acceptance_Status__c = 'Signed';    		
			}    	
			update responses;
		}
    }    
    
    private void sendNotifications() {
		
    	for (String bpNumber : contractBPNumbersToNotify) {
    		//The Avaloq update needs BP Id without BU - that's in AccountNumber, not Number like Archive    		
    		CRAN_VAS_KER_BusHandler.notifyContractSigned(bpNumber);
		}			
    }    
}