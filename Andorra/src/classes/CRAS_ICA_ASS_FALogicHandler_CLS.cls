public class CRAS_ICA_ASS_FALogicHandler_CLS {
    
    /*-------------------------------------------------------------------------------*/
    /*---------------------------- SET OWNERS NEW -----------------------------------*/
    /*-------------------------------------------------------------------------------*/
    
    public static void setOwners(List<FinServ__FinancialAccountRole__c> roles){
        Set<Id> contactIdsSet = new Set<Id>();
        Set<Id> faIdsSet = new Set<Id>();
        Set<Id> bpIdsSet = new Set<Id>();
        Map<Id, SecuritySet> contact_MainMngr_Map = new Map<Id, SecuritySet>();
        Map<Id, Id> fa_Contact_Map = new Map<Id, Id>();
        Id DummyManagerId = CRAS_ICA_ASS_Helpers_CLS.getDummyManagerUserID();
        Id CreditAndorraId = CRAS_ICA_ASS_Helpers_CLS.getCAUserID();
        CRAS_ICA_ASS_Helpers_CLS.setUsersForOficinasAssCorredurias(CRAS_ICA_ASS_Helpers_CLS.oficinasAssCorredurias);
        CRAS_ICA_ASS_Helpers_CLS.setUsersForOficinasAssegurances(CRAS_ICA_ASS_Helpers_CLS.oficinasAssCorredurias);
        Map<Id, String> dummyIds = new Map<Id, String>{ DummyManagerId => 'Dummy Manager', CreditAndorraId => 'Credit Andorra' };
        Map<Id, SecuritySet> bp_SecuritySet_Map = new Map<Id, SecuritySet>();
            
        for (FinServ__FinancialAccountRole__c rol : roles){
            contactIdsSet.add(rol.FinServ__RelatedContact__c);
            contact_MainMngr_Map.put(rol.FinServ__RelatedContact__c, null);
            
            faIdsSet.add(rol.FinServ__FinancialAccount__c);
            fa_Contact_Map.put(rol.FinServ__FinancialAccount__c, rol.FinServ__RelatedContact__c);
        }
        
        List<Contact> contactos = [SELECT Id, CRAS_ICA_ASS_L_BPBankingMainMngr__c, CRAS_ICA_ASS_L_BPBankingMainMngr__r.CRAN_ICA_KER_P_Oficina__c FROM Contact WHERE id IN :contactIdsSet AND CRAS_ICA_ASS_L_BPBankingMainMngr__c != null];
        for (Contact c: contactos){
            SecuritySet ss = new SecuritySet();
            ss.MainMngr = c.CRAS_ICA_ASS_L_BPBankingMainMngr__c;
            ss.Office = c.CRAS_ICA_ASS_L_BPBankingMainMngr__r.CRAN_ICA_KER_P_Oficina__c;
            contact_MainMngr_Map.put(c.Id, ss);
        }
        
        List<FinServ__FinancialAccount__c> fas = [SELECT Id, OwnerId, 
                                                  		 CRAN_ICA_KER_P_Oficina__c, 
                                                  		 CRAN_ICA_KER_P_Identity__c, 
                                                  		 FinServ__PrimaryOwner__c,
                                                  		 FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_OficinaVenta__c,
                                                  		 FinServ__PrimaryOwner__r.CRAN_ICA_KER_L_SalesManager__c
                                                  FROM FinServ__FinancialAccount__c WHERE id IN :faIdsSet];
        for (FinServ__FinancialAccount__c fa: fas){
            SecuritySet ss = new SecuritySet();
            SecuritySet ssFromContact = contact_MainMngr_Map.get(fa_Contact_Map.get(fa.Id));
            if (fa.CRAN_ICA_KER_P_Identity__c != CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION_RESTRINGIDO && 
                (fa.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_OficinaVenta__c == null || 
                 (!CRAS_ICA_ASS_Helpers_CLS.oficinasAssCorredurias.containsKey(fa.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_OficinaVenta__c) && 
                  !CRAS_ICA_ASS_Helpers_CLS.oficinasAssDireccion.containsKey(fa.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_OficinaVenta__c))
                ))
            {
                if (ssFromContact != null && ssFromContact.MainMngr != null && ssFromContact.MainMngr != CreditAndorraId){
                    ss.MainMngr = ssFromContact.MainMngr;
                    ss.Identity = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_BANCA_Y_SEGUROS;
                    if (ssFromContact.MainMngr == DummyManagerId){
                        ss.Office = fa.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_OficinaVenta__c;
                    } else {
                        ss.Office = ssFromContact.Office;
                    }
                }
                else {// ssFromContact = null || ssFromContact.MainMngr = null || ssFromContact.MainMngr = CreditAndorraId
                    ss.MainMngr = fa.FinServ__PrimaryOwner__r.CRAN_ICA_KER_L_SalesManager__c;
                    ss.Office = fa.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_OficinaVenta__c;
                    ss.Identity = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS;
                }
            } else {
                ss.MainMngr = fa.OwnerId;
                ss.Office = fa.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_OficinaVenta__c;
                if (String.isNotBlank(ss.Office) && CRAS_ICA_ASS_Helpers_CLS.oficinasAssCorredurias.containsKey(ss.Office)){
                    ss.Identity = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_CORREDURIAS;
                    ss.MainMngr = CRAS_ICA_ASS_Helpers_CLS.oficinasAssCorredurias.get(ss.Office);
                }
                else if (fa.CRAN_ICA_KER_P_Identity__c == CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION_RESTRINGIDO){
                    ss.Identity = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION_RESTRINGIDO;
                }
                else {
                    ss.Identity = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION;
                }
            }
            
            ss.MainMngr = ss.MainMngr != null ? ss.MainMngr : UserInfo.getUserId();
            ss.Office = String.isNotBlank(ss.Office) ? ss.Office : CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_DEFAULT;
            ss.Identity = String.isNotBlank(ss.Identity) ? ss.Identity : CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION;
            
            fa.OwnerId = ss.MainMngr;
            fa.CRAN_ICA_KER_P_Oficina__c = ss.Office;
            fa.CRAN_ICA_KER_P_Identity__c = ss.Identity;
            
            bpIdsSet.add(fa.FinServ__PrimaryOwner__c);
            bp_SecuritySet_Map.put(fa.FinServ__PrimaryOwner__c, ss);
        }
        
        update fas;
        
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
    
    public class SecuritySet{
        public Id MainMngr;
        public String Identity;
        public String Office;
    }
}