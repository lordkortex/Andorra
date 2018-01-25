public with sharing class CRAS_ICA_ASS_FAController_AUC {
    private static CRAS_ICA_ASS_RelatedLists_CS__c relCS = CRAS_ICA_ASS_RelatedLists_CS__c.getOrgDefaults();
    
    @AuraEnabled
    public static CRAS_ICA_ASS_InsuranceGlobal_CS__c getGlobalSettings(){
        return CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialHolding__c> getInsuranceGuarantees(id finAccId, decimal rpp, decimal os) {
        Integer offset = (integer)os;
        Integer lim = (integer)rpp;
        return [SELECT Id, Name, CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__RelatedContact__r.Id, CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__RelatedContact__r.FirstName, CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__RelatedContact__r.LastName, FORMAT(CRAS_ICA_ASS_C_CapitalAsegurado__c) CapAsegurado, FORMAT(CRAS_ICA_ASS_C_PrimaAnual__c) PrimaAnual  FROM FinServ__FinancialHolding__c WHERE FinServ__FinancialAccount__c = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FH_Guarantees_RT_ID__c ORDER BY Name LIMIT :lim OFFSET :offset];
    }
    
    @AuraEnabled
    public static Integer getInsuranceGuaranteesCount(id finAccId) {
        return [SELECT Count() FROM FinServ__FinancialHolding__c WHERE FinServ__FinancialAccount__c = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FH_Guarantees_RT_ID__c];
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialHolding__c> getInsuranceProducts(id finAccId, decimal rpp, decimal os) {
        Integer offset = (integer)os;
        Integer lim = (integer)rpp;
        return [SELECT Id, Name FROM FinServ__FinancialHolding__c WHERE FinServ__FinancialAccount__c = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FH_Products_RT_ID__c LIMIT :lim OFFSET :offset];
    }
    
    @AuraEnabled
    public static Integer getInsuranceProductsCount(id finAccId) {
        return [SELECT Count() FROM FinServ__FinancialHolding__c WHERE FinServ__FinancialAccount__c = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FH_Products_RT_ID__c];
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_ClaimAmountHistory__c> getClaims(id finAccId, decimal rpp, decimal os) {
        try 
        {
            List<FinServ__FinancialAccountRole__c> lstFAR = [SELECT Id From FinServ__FinancialAccountRole__c WHERE FinServ__FinancialAccount__c = :finAccId];
            
            List<Id> lstFARId = new List<Id>();
            for(FinServ__FinancialAccountRole__c fAR : lstFAR)
            {
                lstFARId.add(fAR.Id);
            }
            
            Integer offset = (integer)os;
            Integer lim = (integer)rpp;
            return [SELECT Id,Name,CRAS_ICA_ASS_L_Role__r.FinServ__RelatedContact__c, CRAS_ICA_ASS_L_Role__r.FinServ__RelatedContact__r.FirstName, CRAS_ICA_ASS_L_Role__r.FinServ__RelatedContact__r.LastName, CRAS_ICA_ASS_N_Year__c, CRAS_ICA_ASS_T_AxisClaimId__c, FORMAT(CRAS_ICA_ASS_C_TotalNaturalYear__c) Total FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__c IN :lstFARId AND CRAS_ICA_ASS_N_Year__c != null ORDER BY CRAS_ICA_ASS_N_Year__c DESC LIMIT :lim OFFSET :offset];
            
        }
        catch(exception e) 
        {
            return null;
        }
        
    }
    
    @AuraEnabled
    public static Integer getClaimsCount(id finAccId) {
        try
        { 
            List<FinServ__FinancialAccountRole__c> lstFAR = [SELECT Id From FinServ__FinancialAccountRole__c WHERE FinServ__FinancialAccount__c = :finAccId];
            
            List<Id> lstFARId = new List<Id>();
            for(FinServ__FinancialAccountRole__c fAR : lstFAR)
            {
                lstFARId.add(fAR.Id);
            }
            
            return [SELECT Count() FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__c IN :lstFARId AND CRAS_ICA_ASS_N_Year__c != null];
        }
        catch (Exception e)
        {
            return 0;
        }
        
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_Invoice__c> getInsuranceInvoices(id finAccId, decimal rpp, decimal os) {
        Integer offset = (integer)os;
        Integer lim = (integer)rpp;
        return [SELECT Id, Name, CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__RelatedContact__r.Id, CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__RelatedContact__r.FirstName, CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__RelatedContact__r.LastName, FORMAT(CRAS_ICA_ASS_C_TotalPremium__c) Premium, toLabel(CRAS_ICA_ASS_P_InvoiceStatus__c) Status, CRAS_ICA_ASS_P_InvoiceStatus__c, FORMAT(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) EffDate, FORMAT(CRAS_ICA_ASS_D_StatusDate__c) StatusDate FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c = :finAccId AND CRAS_ICA_ASS_C_TotalPremium__c > 0 AND RecordTypeId = :relCS.CRAS_ICA_ASS_InsuranceInvoices_RT_ID__c ORDER BY CRAS_ICA_ASS_D_InvoiceEffectiveDate__c DESC LIMIT :lim OFFSET :offset];
    }
    
    @AuraEnabled
    public static Integer getInsuranceInvoicesCount(id finAccId) {
        return [SELECT Count() FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c = :finAccId AND CRAS_ICA_ASS_C_TotalPremium__c > 0 AND RecordTypeId = :relCS.CRAS_ICA_ASS_InsuranceInvoices_RT_ID__c];
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialAccountRole__c> getInsuranceRoles(id finAccId, decimal rpp, decimal os) {
        Integer offset = (integer)os;
        Integer lim = (integer)rpp;
        return [SELECT Id, CRAS_ICA_ASS_PE_PorcentajeCopago__c,FinServ__Active__c, FORMAT(FinServ__EndDate__c) EndDate,FinServ__RelatedContact__r.Id, FinServ__RelatedContact__r.Name, toLabel(FinServ__Role__c) Role, FORMAT(FinServ__StartDate__c) StartDate FROM FinServ__FinancialAccountRole__c WHERE FinServ__FinancialAccount__c = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__c != null AND FinServ__Role__c != '101ASS' LIMIT :lim OFFSET :offset];
    }
    
    @AuraEnabled
    public static Integer getInsuranceRolesCount(id finAccId) {
        return [SELECT Count() FROM FinServ__FinancialAccountRole__c WHERE FinServ__FinancialAccount__c = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__c != null AND FinServ__Role__c != '101ASS'];
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialAccountRole__c> getInsurancePolicyHolderRole(id finAccId, decimal rpp, decimal os) {
        Integer offset = (integer)os;
        Integer lim = (integer)rpp;
        return [SELECT Id, CRAS_ICA_ASS_PE_PorcentajeCopago__c,FinServ__Active__c, FORMAT(FinServ__EndDate__c) EndDate,FinServ__RelatedContact__r.Id, FinServ__RelatedContact__r.FirstName, FinServ__RelatedContact__r.LastName, toLabel(FinServ__Role__c) Role, FORMAT(FinServ__StartDate__c) StartDate FROM FinServ__FinancialAccountRole__c WHERE FinServ__FinancialAccount__c = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__c != null AND FinServ__Role__c = '101ASS' LIMIT :lim OFFSET :offset];
    }
    
    @AuraEnabled
    public static Integer getInsurancePolicyHolderRoleCount(id finAccId) {
        return [SELECT Count() FROM FinServ__FinancialAccountRole__c WHERE FinServ__FinancialAccount__c = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__c != null AND FinServ__Role__c = '101ASS'];
    }
    
    @AuraEnabled
    public static FinServ__FinancialHolding__c getFinAccountData(id finAccId) {
        List <FinServ__FinancialHolding__c> FAlst = [SELECT FinServ__FinancialAccount__r.Id, FinServ__FinancialAccount__r.CurrencyIsoCode, FinServ__FinancialAccount__r.Name, FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, toLabel(FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c), toLabel(FinServ__FinancialAccount__r.FinServ__Status__c), FORMAT(FinServ__FinancialAccount__r.CRAS_ICA_ASS_C_SumaAport__c), FORMAT(FinServ__FinancialAccount__r.CRAS_ICA_ASS_C_PrimaAnual__c), FORMAT(FinServ__FinancialAccount__r.CRAS_ICA_ASS_D_FechaProxRec__c), FinServ__FinancialAccount__r.CRAS_ICA_ASS_Invoices_Status__c, FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c, FinServ__FinancialAccount__r.CRAS_ICA_ASS_PE_PctSiniestralidad__c, FinServ__Securities__r.CRAS_ICA_ASS_P_BenchmarkGreen__c, FinServ__Securities__r.CRAS_ICA_ASS_P_BenchmarkYellow__c, FinServ__Securities__r.CRAN_VEC_ADV_P_PFMMkt__c FROM FinServ__FinancialHolding__c WHERE FinServ__FinancialAccount__r.Id = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FH_Products_RT_ID__c];
        if(FAlst.size() != 0)
        {
            return FAlst[0];
        }
        else
        {
            return new FinServ__FinancialHolding__c();
        }
    }
    
    @AuraEnabled
    public static Account getFinAccountPolicyHolder(id finAccId) {
        List<FinServ__FinancialAccountRole__c> PH = [SELECT FinServ__RelatedContact__r.AccountId FROM FinServ__FinancialAccountRole__c WHERE FinServ__FinancialAccount__r.Id = :finAccId AND FinServ__Role__c = '101ASS'];
        
        if(PH.size() != 0)
        {
            List<Account> acc = [SELECT Id, Name FROM Account WHERE Id = :PH[0].FinServ__RelatedContact__r.AccountId];
            if(acc.size() != 0)
            {
                System.debug(acc[0]);
                return acc[0];
            }
            else
            {
                return new Account();
            }
        }
        
        else
        {
            return new Account();
        } 
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialAccountRole__c> getFAWithUnpaidInvoices(Integer limitList) {        
        //get privileges
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        	return [SELECT FinServ__FinancialAccount__c, FinServ__FinancialAccount__r.Name, FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, toLabel(FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c), FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c, FORMAT(FinServ__FinancialAccount__r.CRAS_ICA_ASS_C_DebtAmount__c), CurrencyIsoCode FROM FinServ__FinancialAccountRole__c WHERE  FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c > 0 AND FinServ__Role__c = '101ASS' and FinServ__FinancialAccount__r.OwnerId in :owners ORDER BY FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c DESC LIMIT :limitList];
        }
        else if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
        	return [SELECT FinServ__FinancialAccount__c, FinServ__FinancialAccount__r.Name, FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, toLabel(FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c), FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c, FORMAT(FinServ__FinancialAccount__r.CRAS_ICA_ASS_C_DebtAmount__c), CurrencyIsoCode FROM FinServ__FinancialAccountRole__c WHERE  FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c > 0 AND FinServ__Role__c = '101ASS' and FinServ__FinancialAccount__r.CRAN_ICA_KER_P_Oficina__c = :CRAS_ICA_ASS_Helpers_CLS.getUserOffice() ORDER BY FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c DESC LIMIT :limitList];
        }
        else{
            return [SELECT FinServ__FinancialAccount__c, FinServ__FinancialAccount__r.Name, FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, toLabel(FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c), FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c, FORMAT(FinServ__FinancialAccount__r.CRAS_ICA_ASS_C_DebtAmount__c), CurrencyIsoCode FROM FinServ__FinancialAccountRole__c WHERE  FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c > 0 AND FinServ__Role__c = '101ASS' ORDER BY FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c DESC LIMIT :limitList];
        }
		
    }
    
    @AuraEnabled
    public static Integer getFAWithUnpaidInvoicesCount() {
        //get privileges
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        	return [SELECT Count() FROM FinServ__FinancialAccountRole__c WHERE  FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c > 0 AND FinServ__Role__c = '101ASS' and FinServ__FinancialAccount__r.OwnerId in :owners];
        }
        else if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
        	return [SELECT Count() FROM FinServ__FinancialAccountRole__c WHERE  FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c > 0 AND FinServ__Role__c = '101ASS' and FinServ__FinancialAccount__r.CRAN_ICA_KER_P_Oficina__c = :CRAS_ICA_ASS_Helpers_CLS.getUserOffice()];
        }
        else{
        	return [SELECT Count() FROM FinServ__FinancialAccountRole__c WHERE  FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_NumUnpaidInvoices__c > 0 AND FinServ__Role__c = '101ASS'];
        }
		
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialAccount__c> getFAWithPendingStatus(Integer limitList) {
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
        	List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        	return [SELECT Id, Name, FinServ__FinancialAccountNumber__c, FORMAT(FinServ__OpenDate__c) OpenDate, toLabel(CRAN_VEC_ADV_P_PFMMkt__c), toLabel(FinServ__Status__c) Status, CurrencyIsoCode FROM FinServ__FinancialAccount__c WHERE (FinServ__Status__c IN ('105ASS') OR CRAS_ICA_ASS_T_SolicitudAxisID__c != '') AND OwnerId in :owners ORDER BY FinServ__OpenDate__c DESC LIMIT :limitList];    
        }
        else if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
        	return [SELECT Id, Name, FinServ__FinancialAccountNumber__c, FORMAT(FinServ__OpenDate__c) OpenDate, toLabel(CRAN_VEC_ADV_P_PFMMkt__c), toLabel(FinServ__Status__c) Status, CurrencyIsoCode FROM FinServ__FinancialAccount__c WHERE (FinServ__Status__c IN ('105ASS') OR CRAS_ICA_ASS_T_SolicitudAxisID__c != '') AND CRAN_ICA_KER_P_Oficina__c = :CRAS_ICA_ASS_Helpers_CLS.getUserOffice() ORDER BY FinServ__OpenDate__c DESC LIMIT :limitList];    
        }
        else{
        	return [SELECT Id, Name, FinServ__FinancialAccountNumber__c, FORMAT(FinServ__OpenDate__c) OpenDate, toLabel(CRAN_VEC_ADV_P_PFMMkt__c), toLabel(FinServ__Status__c) Status, CurrencyIsoCode FROM FinServ__FinancialAccount__c WHERE FinServ__Status__c IN ('105ASS') OR CRAS_ICA_ASS_T_SolicitudAxisID__c != '' ORDER BY FinServ__OpenDate__c DESC LIMIT :limitList];
        }
        
    }
    
    @AuraEnabled
    public static Integer getFAWithPendingStatusCount() {

        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
            return [SELECT Count() FROM FinServ__FinancialAccount__c WHERE (FinServ__Status__c IN ('105ASS') OR CRAS_ICA_ASS_T_SolicitudAxisID__c != '') AND OwnerId in :owners];
        }
        else if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
            return [SELECT Count() FROM FinServ__FinancialAccount__c WHERE (FinServ__Status__c IN ('105ASS') OR CRAS_ICA_ASS_T_SolicitudAxisID__c != '') AND CRAN_ICA_KER_P_Oficina__c = :CRAS_ICA_ASS_Helpers_CLS.getUserOffice()];
        }
        else{
            return [SELECT Count() FROM FinServ__FinancialAccount__c WHERE FinServ__Status__c IN ('105ASS') OR CRAS_ICA_ASS_T_SolicitudAxisID__c != ''];
        }
        
    }
    
    @AuraEnabled
    public static List<FinServ__FinancialAccountRole__c> getInsuranceRolesPHI(id finAccId, decimal rpp, decimal os) {
        Integer offset = (integer)os;
        Integer lim = (integer)rpp;
        return [SELECT Id, FinServ__FinancialAccount__r.CRAS_ICA_ASS_N_ValorCopagoEmpresa__c,
                FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c,
                FinServ__Active__c, FORMAT(FinServ__EndDate__c) EndDate,FinServ__RelatedContact__r.Id, 
                FinServ__RelatedContact__r.FirstName, FinServ__RelatedContact__r.LastName, 
                toLabel(FinServ__Role__c) Role, FORMAT(FinServ__StartDate__c) StartDate, 
                FinServ__FinancialAccount__c FROM FinServ__FinancialAccountRole__c 
                WHERE FinServ__FinancialAccount__c = :finAccId 
                AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c 
                AND FinServ__RelatedContact__c != null 
                AND (FinServ__Role__c = '101ASS' OR FinServ__Role__c = '102ASS') 
                LIMIT :lim OFFSET :offset];
    }
    
    @AuraEnabled
    public static Integer getInsuranceRolesPHICount(id finAccId) {
        return [SELECT Count() FROM FinServ__FinancialAccountRole__c WHERE FinServ__FinancialAccount__c = :finAccId AND RecordTypeId = :relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c AND FinServ__RelatedContact__c != null AND (FinServ__Role__c = '101ASS' OR FinServ__Role__c = '102ASS')];
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getCompactLayoutFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'FinServ__FinancialAccountNumber__c' => 1, 
            'CRAN_VEC_ADV_P_PFMMkt__c' => 2, 
            'CRAS_ICA_ASS_C_SumaAport__c' => 3, 
            'CRAS_ICA_ASS_C_PrimaAnual__c' => 4, 
            'FinServ__Status__c' => 5, 
            'CRAS_ICA_ASS_Invoices_Status__c' => 6,
            'CRAS_ICA_ASS_PE_PctSiniestralidad__c' => 7};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccount__c.SObjectType, requestFields);
        Map<String, Integer> requestFields2 = new Map<String, Integer>{'FinServ__RelatedContact__c' => 1};
            List<CRAS_ICA_ASS_SFField_OBJ> responseList2 = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccountRole__c.SObjectType, requestFields2); 
        responseList.addAll(responseList2);
        return responseList;
    } 
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getHLUnpaidInvLayoutFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'Name' => 1, 
            'FinServ__FinancialAccountNumber__c' => 2, 
            'CRAN_VEC_ADV_P_PFMMkt__c' => 3, 
            'CRAS_ICA_ASS_N_NumUnpaidInvoices__c' => 4, 
            'CRAS_ICA_ASS_C_DebtAmount__c' => 5};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccount__c.SObjectType, requestFields); //new List<CRAS_ICA_ASS_SFField_OBJ>();
        return responseList;
    } 
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getHLPendingStatusLayoutFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'Name' => 1, 
            'FinServ__FinancialAccountNumber__c' => 2, 
            'CRAN_VEC_ADV_P_PFMMkt__c' => 3, 
            'FinServ__OpenDate__c' => 4, 
            'FinServ__Status__c' => 5};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccount__c.SObjectType, requestFields); //new List<CRAS_ICA_ASS_SFField_OBJ>();
        return responseList;
    } 
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getRelListRolesFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'FinServ__Role__c' => 1, 
            'FinServ__RelatedContact__c' => 2, 
            'CRAS_ICA_ASS_PE_PorcentajeCopago__c' => 3, 
            'FinServ__StartDate__c' => 4};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccountRole__c.SObjectType, requestFields); //new List<CRAS_ICA_ASS_SFField_OBJ>();
        return responseList;
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getRelListPhFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'FinServ__Role__c' => 1, 
            'FinServ__RelatedContact__c' => 2, 
            'FinServ__StartDate__c' => 3};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccountRole__c.SObjectType, requestFields); //new List<CRAS_ICA_ASS_SFField_OBJ>();
        return responseList;
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getRelListProductsFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'CRAS_ICA_ASS_T_Name__c' => 1};
            List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialHolding__c.SObjectType, requestFields); //new List<CRAS_ICA_ASS_SFField_OBJ>();
        return responseList;
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getClaimsListFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'CRAS_ICA_ASS_N_Year__c' => 1, 
            'CRAS_ICA_ASS_C_TotalNaturalYear__c' => 2};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(CRAS_ICA_ASS_ClaimAmountHistory__c.SObjectType, requestFields);
        Map<String, Integer> requestFields2 = new Map<String, Integer>{'FinServ__RelatedContact__c' => 1};
            List<CRAS_ICA_ASS_SFField_OBJ> responseList2 = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialAccountRole__c.SObjectType, requestFields2); 
        responseList.addAll(responseList2);
        
        return responseList;
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getRelListGuaranteesFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{'CRAS_ICA_ASS_T_Name__c' => 1, 
            'CRAS_ICA_ASS_F_PAsegurada__c' => 2, 
            'CRAS_ICA_ASS_C_CapitalAsegurado__c' => 3, 
            'CRAS_ICA_ASS_C_PrimaAnual__c' => 4};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(FinServ__FinancialHolding__c.SObjectType, requestFields); //new List<CRAS_ICA_ASS_SFField_OBJ>();
        return responseList;
    }
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_SFField_OBJ> getRelListInvoicesFieldNames(){
        Map<String, Integer> requestFields = new Map<String, Integer>{	'CRAS_ICA_ASS_P_InvoiceName__c' => 1, 
            'CRAS_ICA_ASS_F_NTomador__c' => 2, 
            'CRAS_ICA_ASS_C_TotalPremium__c' => 3, 
            'CRAS_ICA_ASS_P_InvoiceStatus__c' => 4, 
            'CRAS_ICA_ASS_D_InvoiceEffectiveDate__c' => 5};
                List<CRAS_ICA_ASS_SFField_OBJ> responseList = CRAS_ICA_ASS_Helpers_CLS.getFieldsLabelForAura(CRAS_ICA_ASS_Invoice__c.SObjectType, requestFields); //new List<CRAS_ICA_ASS_SFField_OBJ>();
        return responseList;
    }
    
}