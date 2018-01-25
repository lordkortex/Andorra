public with sharing class CRAN_VAS_ADV_RecordDetail_AUC{
    @AuraEnabled
    public static Account getRecordById(String recordId) {
        Id recId = Id.valueOf(recordId);
        
        Account acc = [SELECT Id,CRAN_VEC_ADV_L_Advisor__r.Name,CRAN_VEC_ADV_B_ContractSigned__c,CRAN_VEC_ADV_D_SignDate__c
                       FROM Account WHERE Id =: recId LIMIT 1];
      
        return acc;
	}
}