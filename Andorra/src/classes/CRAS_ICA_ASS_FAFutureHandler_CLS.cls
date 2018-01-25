public class CRAS_ICA_ASS_FAFutureHandler_CLS {
    
	public static void changeOffice(List<Id> idsFALst)
    {
        List<FinServ__FinancialAccount__c> fALst = [SELECT Id, CRAN_ICA_KER_P_Oficina__c, FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_Oficina__c FROM FinServ__FinancialAccount__c WHERE Id IN :idsFALst];
        
        for(FinServ__FinancialAccount__c fA :faLst)
        {
            if(String.isNotBlank(fA.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_Oficina__c))
            {
                fa.CRAN_ICA_KER_P_Oficina__c = fA.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_Oficina__c;
            }
        }
        
        update fALst;
    }
        
    @future
    public static void updatePropuestasPendientesOwners(List<Id> propuestasIds){
        
        CRAS_ICA_ASS_Helpers_CLS.setUsersForOficinasAssCorredurias(CRAS_ICA_ASS_Helpers_CLS.oficinasAssCorredurias);
        CRAS_ICA_ASS_Helpers_CLS.setUsersForOficinasAssegurances(CRAS_ICA_ASS_Helpers_CLS.oficinasAssCorredurias);
        Set<Id> bpIdsSet = new Set<Id>();
        Map<Id, CRAS_ICA_ASS_FALogicHandler_CLS.SecuritySet> bp_SecuritySet_Map = new Map<Id, CRAS_ICA_ASS_FALogicHandler_CLS.SecuritySet>();
        
        List<FinServ__FinancialAccount__c> propuestas = [SELECT Id, OwnerId, 
                                                                CRAN_ICA_KER_P_Oficina__c, 
                                                                CRAN_ICA_KER_P_Identity__c, 
                                                                FinServ__PrimaryOwner__c,
                                                                FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_OficinaVenta__c,
                                                                FinServ__PrimaryOwner__r.CRAN_ICA_KER_L_SalesManager__c
                                                         FROM FinServ__FinancialAccount__c WHERE Id IN :propuestasIds];
        
        for (FinServ__FinancialAccount__c prop : propuestas){
            CRAS_ICA_ASS_FALogicHandler_CLS.SecuritySet ss = new CRAS_ICA_ASS_FALogicHandler_CLS.SecuritySet();
            ss.MainMngr = prop.FinServ__PrimaryOwner__r.CRAN_ICA_KER_L_SalesManager__c;
            ss.Office = prop.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_OficinaVenta__c;
            if (String.isNotBlank(ss.Office) && CRAS_ICA_ASS_Helpers_CLS.oficinasAssCorredurias.containsKey(ss.Office)){
                ss.Identity = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_CORREDURIAS;
                ss.MainMngr = CRAS_ICA_ASS_Helpers_CLS.oficinasAssCorredurias.get(ss.Office);
            }
            else if (prop.CRAN_ICA_KER_P_Identity__c == CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION_RESTRINGIDO){
                ss.Identity = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION_RESTRINGIDO;
            }
            else {
                ss.Identity = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION;
            }
            
            ss.MainMngr = ss.MainMngr != null ? ss.MainMngr : UserInfo.getUserId();
            ss.Office = String.isNotBlank(ss.Office) ? ss.Office : CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_DEFAULT;
            ss.Identity = String.isNotBlank(ss.Identity) ? ss.Identity : CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION;
            
            prop.OwnerId = ss.MainMngr;
            prop.CRAN_ICA_KER_P_Oficina__c = ss.Office;
            prop.CRAN_ICA_KER_P_Identity__c = ss.Identity;
            
            bpIdsSet.add(prop.FinServ__PrimaryOwner__c);
            bp_SecuritySet_Map.put(prop.FinServ__PrimaryOwner__c, ss);
        }
        
        update propuestas;
        
        List<Account> bps = [SELECT Id, OwnerId,
                             		CRAN_ICA_KER_P_Oficina__c, 
                                    CRAN_ICA_KER_P_Identity__c,
                             		CRAN_VEC_ADV_L_MainMngr__c
                             FROM Account WHERE Id IN :bpIdsSet]; 
        for (Account a : bps){
            a.OwnerId = (bp_SecuritySet_Map.get(a.Id)).MainMngr;
            a.CRAN_VEC_ADV_L_MainMngr__c = (bp_SecuritySet_Map.get(a.Id)).MainMngr;
            a.CRAN_ICA_KER_P_Oficina__c = (bp_SecuritySet_Map.get(a.Id)).Office;
            a.CRAN_ICA_KER_P_Identity__c = (bp_SecuritySet_Map.get(a.Id)).Identity;
        }
        
        update bps;
        
    }
}