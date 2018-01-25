public with sharing class CRAS_ICA_ASS_CAHController_AUC {
    
    @AuraEnabled
    public static CRAS_ICA_ASS_ClaimAmountHistory__c getClaimDetails(id claimId) {
        return [SELECT  CRAS_ICA_ASS_C_TotalNaturalYear__c, 
                		CRAS_ICA_ASS_N_Year__c, 
                		CRAS_ICA_ASS_L_Role__r.FinServ__RelatedContact__r.FirstName, 
                		CRAS_ICA_ASS_L_Role__r.FinServ__RelatedContact__r.LastName, 
                		CRAS_ICA_ASS_L_Role__r.FinServ__RelatedContact__r.Id, 
                		CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.Name, 
                		CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.Id,
	                 	CurrencyIsoCode 
                FROM CRAS_ICA_ASS_ClaimAmountHistory__c 
                WHERE Id = :claimId];
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getCompactLayoutFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'CRAS_ICA_ASS_N_Year__c' => 1, 
            															'CRAS_ICA_ASS_C_TotalNaturalYear__c' => 2};
        List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(CRAS_ICA_ASS_ClaimAmountHistory__c.SObjectType, requestFields);
        Map<String, Integer> requestFields2 = new Map<String, Integer>{'FinServ__RelatedContact__c' => 1,
            															'FinServ__FinancialAccount__c' => 2};
        List<CRAS_ICA_ASS_SFField_OBJ> responseList2 = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccountRole__c.SObjectType, requestFields2); 
        responseList.addAll(responseList2);
        return responseList;
    } 
    
}