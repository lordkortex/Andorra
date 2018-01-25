public with sharing class CRAS_ICA_ASS_ACCController_AUC {
    private static CRAS_ICA_ASS_RelatedLists_CS__c relCS = CRAS_ICA_ASS_RelatedLists_CS__c.getOrgDefaults();
    
    @AuraEnabled
    public static CRAS_ICA_ASS_InsuranceGlobal_CS__c getGlobalSettings(){
        return CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialAccountRole__c> getRolesFromAccount(id accId) {
        return [SELECT CRAS_ICA_ASS_PE_PorcentajeCopago__c,FinServ__Active__c, FORMAT(FinServ__EndDate__c) EndDate,FinServ__FinancialAccount__r.Id, FinServ__FinancialAccount__r.Name, FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, toLabel(FinServ__Role__c) Role, FORMAT(FinServ__StartDate__c) StartDate, toLabel(FinServ__FinancialAccount__r.FinServ__Status__c)  FROM FinServ__FinancialAccountRole__c WHERE FinServ__Role__c != '101ASS' AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__r.AccountId = :accId ORDER BY FinServ__StartDate__c DESC];
    }
    
    @AuraEnabled
    public static Integer getClaimsCount(id accId) {
        List<Account> idContact = [Select FinServ__PrimaryContact__c FROM Account WHERE Id = :accId];
        
        return [SELECT Count() FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__c IN (SELECT Id FROM FinServ__FinancialAccountRole__c WHERE FinServ__RelatedContact__c = :idContact[0].FinServ__PrimaryContact__c) AND CRAS_ICA_ASS_N_Year__c != null];
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_MapList_OBJ> getClaimsFromAccount(id accId) {
        List<Account> idContact = [Select FinServ__PrimaryContact__c FROM Account WHERE Id = :accId];
        
        List<CRAS_ICA_ASS_ClaimAmountHistory__c> lstFAN = 
            [SELECT Id,Name, CRAS_ICA_ASS_T_AxisClaimId__c, FORMAT(CRAS_ICA_ASS_C_TotalNaturalYear__c) Total,
             CRAS_ICA_ASS_N_Year__c, 
             CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c, 
             CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c 
             FROM CRAS_ICA_ASS_ClaimAmountHistory__c 
             WHERE CRAS_ICA_ASS_L_Role__c IN 
             (SELECT Id 
              FROM FinServ__FinancialAccountRole__c 
              WHERE FinServ__RelatedContact__c = :idContact[0].FinServ__PrimaryContact__c) AND 
             CRAS_ICA_ASS_N_Year__c != null 
             ORDER BY CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, 
             CRAS_ICA_ASS_N_Year__c Desc];
        
        List<CRAS_ICA_ASS_MapList_OBJ> mapListResult = new List<CRAS_ICA_ASS_MapList_OBJ>();
        
        if(lstFAN.Size() > 0)
        {
            Integer auxIndex = 1;
            String nameFA = lstFAN[0].CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c;
            CRAS_ICA_ASS_MapList_OBJ result = new CRAS_ICA_ASS_MapList_OBJ();
            result.Index = auxIndex;
            
            for (CRAS_ICA_ASS_ClaimAmountHistory__c fAN : lstFAN)
            {
                if(nameFA.equals(fAN.CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c))
                {
                    result.RelList.add(fAN);
                    result.Label = fAN.CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c;
                }
                else
                {
                    mapListResult.add(result);
                    result = new CRAS_ICA_ASS_MapList_OBJ();
                    auxIndex = auxIndex + 1;
                    result.Index = auxIndex;
                    nameFA = fAN.CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c;
                    result.Label = nameFA;
                    result.RelList.add(fAN);
                }
            }
            
            mapListResult.add(result);            
        }
        
        return mapListResult;
    }
    
    @AuraEnabled
    public static Integer getInsuranceRolesCount(id accId) {
        return [SELECT Count() FROM FinServ__FinancialAccountRole__c WHERE FinServ__Role__c != '101ASS' AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__r.AccountId = :accId];
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialAccountRole__c> getRolesPHFromAccount(id accId) {
        List<FinServ__FinancialAccountRole__c> PHlist;
        PHlist =  [SELECT Id, CRAS_ICA_ASS_PE_PorcentajeCopago__c,FinServ__Active__c, FORMAT(FinServ__EndDate__c) EndDate,FinServ__FinancialAccount__r.Id, FinServ__FinancialAccount__r.Name, FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, toLabel(FinServ__Role__c) Role, FinServ__Role__c, FORMAT(FinServ__StartDate__c) StartDate, toLabel(FinServ__FinancialAccount__r.FinServ__Status__c), CRAS_ICA_ASS_PctSiniestralidad__c, FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c FROM FinServ__FinancialAccountRole__c WHERE FinServ__Role__c = '101ASS' AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__r.AccountId = :accId ORDER BY FinServ__StartDate__c DESC];
        
        
        List<FinServ__FinancialAccountRole__c> auxList = checkBenchmark(PHlist, accId);
        return auxList;
    }
    
    @AuraEnabled
    public static Integer getInsuranceRolesPHCount(id accId) {
        return [SELECT Count() FROM FinServ__FinancialAccountRole__c WHERE FinServ__Role__c = '101ASS' AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__r.AccountId = :accId];
    }
    
    @AuraEnabled
    public static Integer getInsurancePHICount(id accId) {
        return [SELECT Count() FROM FinServ__FinancialAccountRole__c WHERE (FinServ__Role__c = '101ASS' OR FinServ__Role__c = '102ASS') AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__r.AccountId = :accId];
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialAccountRole__c> getInsurancePHI(id accId) {
        List<FinServ__FinancialAccountRole__c> PHlist;
        PHlist = [SELECT Id, CRAS_ICA_ASS_PE_PorcentajeCopago__c,FinServ__Active__c, FORMAT(FinServ__EndDate__c) EndDate, 
                  FinServ__FinancialAccount__r.Id, FinServ__FinancialAccount__r.Name, 
                  FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, toLabel(FinServ__Role__c) Role, 
                  FinServ__Role__c, FORMAT(FinServ__StartDate__c) StartDate, 
                  toLabel(FinServ__FinancialAccount__r.FinServ__Status__c), 
                  FinServ__FinancialAccount__r.CRAS_ICA_ASS_PE_PctSiniestralidad__c, 
                  FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c 
                  FROM FinServ__FinancialAccountRole__c 
                  WHERE (FinServ__Role__c = '101ASS' OR FinServ__Role__c = '102ASS') AND 
                  RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND 
                  FinServ__RelatedContact__r.AccountId = :accId 
                  ORDER BY FinServ__StartDate__c DESC, FinServ__Role__c DESC];
        
        return checkBenchmark(PHlist, accId);
    }
    @AuraEnabled
    public static List<FinServ__FinancialAccountRole__c> checkBenchmark(List<FinServ__FinancialAccountRole__c> PHlist, Id accId){
        
        //recuperar los FA Name
        Set <String> FANames = new Set <String>();
        for(FinServ__FinancialAccountRole__c PH : PHlist){
            FANames.add(PH.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c);
            System.debug('test: ' + PH.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c);
        }
        
        
        
        if(FANames.size() > 0)
        {
            List<FinServ__Securities__c> secList = [SELECT id,name,CRAS_ICA_ASS_P_BenchmarkGreen__c,CRAS_ICA_ASS_P_BenchmarkYellow__c
                                                    FROM FinServ__Securities__c 
                                                    WHERE name in : FANames];
            
            //recuperamos la rendibilidad
            Map<Id,Decimal> rendibility = CRAS_ICA_ASS_Sinistrality_CLS.siniestralityByPolicy(accId);
            Integer i ;
            for (i = 0; i<PHlist.size(); i++){
                PHlist[i].CRAS_ICA_ASS_PctSiniestralidad__c = rendibility.get(PHlist[i].Id);
            }
            
            //recuperamos los benchmark a partir de los names
            Integer j;
            Integer k;
            
            for(j = 0; j<PHlist.size(); j++){
                for(k = 0; k<secList.size(); k++){

                    if (PHlist[j].FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c.equals(secList[k].Name) && PHlist[j].FinServ__Role__c.equals('101ASS')){
                        PHlist[j].CRAS_ICA_ASS_P_BenchmarkGreen__c = secList[k].CRAS_ICA_ASS_P_BenchmarkGreen__c;
                        PHlist[j].CRAS_ICA_ASS_P_BenchmarkYellow__c = secList[k].CRAS_ICA_ASS_P_BenchmarkYellow__c;
                        
                        if(secList[k].CRAS_ICA_ASS_P_BenchmarkGreen__c > 0 && secList[k].CRAS_ICA_ASS_P_BenchmarkYellow__c > 0){
                            
                            if(PHlist[j].CRAS_ICA_ASS_PctSiniestralidad__c > PHlist[j].CRAS_ICA_ASS_P_BenchmarkYellow__c){
                                PHlist[j].CRAS_ICA_ASS_P_BenchmarkStatus__c = 'Red';
                            } else if(PHlist[j].CRAS_ICA_ASS_PctSiniestralidad__c > PHlist[j].CRAS_ICA_ASS_P_BenchmarkGreen__c){
                                PHlist[j].CRAS_ICA_ASS_P_BenchmarkStatus__c = 'Yellow';
                            } else {
                                PHlist[j].CRAS_ICA_ASS_P_BenchmarkStatus__c = 'Green';
                            }
                            
                        } else {
                            PHlist[j].CRAS_ICA_ASS_P_BenchmarkStatus__c = 'None';
                        }
                        
                        break;
                    }
                }
                if(PHlist[j].CRAS_ICA_ASS_P_BenchmarkStatus__c == null){
                    PHlist[j].CRAS_ICA_ASS_P_BenchmarkStatus__c = 'None';
                }
            }
            
            System.debug('Salida:' + PHlist);
            
            return PHlist;  
        }
        
        return PHlist;
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getRelListRolesFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'FinServ__Role__c' => 1, 
            'FinServ__FinancialAccount__c' => 2, 
            'CRAN_VEC_ADV_T_Account_Number__c' => 3, 
            'FinServ__StartDate__c' => 4};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccountRole__c.SObjectType, requestFields); 
        Map<String, Integer> requestFields2 = new Map<String, Integer>{'FinServ__Status__c' => 1};
            List<CRAS_ICA_ASS_SFField_OBJ> responseList2 = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccount__c.SObjectType, requestFields2); 
        responseList.addAll(responseList2);
        return responseList;
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getPHRelListRolesFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'FinServ__Role__c' => 1, 
            'FinServ__FinancialAccount__c' => 2, 
            'CRAN_VEC_ADV_T_Account_Number__c' => 3, 
            'FinServ__StartDate__c' => 4};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccountRole__c.SObjectType, requestFields); 
        Map<String, Integer> requestFields2 = new Map<String, Integer>{'FinServ__Status__c' => 1,
            'CRAS_ICA_ASS_PE_PctSiniestralidad__c' => 2};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList2 = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccount__c.SObjectType, requestFields2); 
        responseList.addAll(responseList2);
        return responseList;
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getRelListClaimsFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'CRAS_ICA_ASS_N_Year__c' => 1, 
            'CRAS_ICA_ASS_C_TotalNaturalYear__c' => 2};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(CRAS_ICA_ASS_ClaimAmountHistory__c.SObjectType, requestFields); 
        Map<String, Integer> requestFields2 = new Map<String, Integer>{'FinServ__FinancialAccountNumber__c' => 1};
            List<CRAS_ICA_ASS_SFField_OBJ> responseList2 = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccount__c.SObjectType, requestFields2); 
        responseList.addAll(responseList2);
        return responseList;
    }
    
    @AuraEnabled
    public static Boolean getCalcClaimsHistory(id accId){
        return CRAS_ICA_ASS_CalcClaimsPct_CLS.calcHistory(accId);
    }
}