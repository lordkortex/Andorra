public class CRAN_ICA_ADV_ReporteConsistencia_CTR {
    @RemoteAction
    @readOnly
    public static Map<String, List<Integer>> getReportDetail(){
        AggregateResult[] gRFA = [SELECT FinServ__PrimaryOwner__c, count(Id) num FROM FinServ__FinancialAccount__c WHERE CRAN_VEC_DEV_T_ContainerID__c != null GROUP BY FinServ__PrimaryOwner__c ORDER BY FinServ__PrimaryOwner__c DESC];
        //AggregateResult[] gRFA = [SELECT FinServ__PrimaryOwner__c, count(Id) num FROM FinServ__FinancialAccount__c WHERE CRAN_VEC_DEV_T_ContainerID__c != null GROUP BY FinServ__PrimaryOwner__c ORDER BY FinServ__PrimaryOwner__c DESC LIMIT 200];
        Map<String, Integer> faMap = new Map<String, Integer>();
        Set<Id> ids = new Set<id>();
        
        for (AggregateResult ar : gRFA){
            faMap.put((String)ar.get('FinServ__PrimaryOwner__c'), (Integer)ar.get('num'));
            ids.add((String)ar.get('FinServ__PrimaryOwner__c'));
        }
        
        /*List<Account> listaBPs = [SELECT Id, CRAN_VEC_ADV_T_BPId__c FROM Account WHERE Id IN :ids];
        Set<String> idsBPs = new Set<String>();
        for (Account acc: listaBPs){
        idsBPs.add(acc.CRAN_VEC_ADV_T_BPId__c);
        }*/
        
        //AggregateResult[] gRRoles = [SELECT FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c po, count(Id) num FROM FinServ__FinancialAccountRole__c WHERE CRAN_VEC_ADV_T_BPId__c != null AND CRAN_VEC_ADV_T_BPId__c IN :idsBPs GROUP BY FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c ORDER BY FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c DESC];
        AggregateResult[] gRRoles = [SELECT FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c po, count(Id) num FROM FinServ__FinancialAccountRole__c WHERE CRAN_VEC_ADV_T_BPId__c != null GROUP BY FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c ORDER BY FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c DESC];
        Map<String, Integer> rolesMap = new Map<String, Integer>();
        Map<String, List<Integer>> resultMap = new Map<String, List<Integer>>();
        for (AggregateResult ar : gRRoles){
            rolesMap.put((String)ar.get('po'), (Integer)ar.get('num'));
        }
        if(rolesMap.size() > 0)
        {
            Integer cont = 0;
            for (String key : faMap.keySet()){
                List<Integer> lista = new List<Integer>();
                Integer numFA = (Integer)faMap.get(key);
                Integer numRoles = (Integer)rolesMap.get(key);
                Integer valid = 1;
                if (math.mod(numRoles, numFA) != 0){
                    valid = 0;
                }
                if (valid == 0){
                    lista.add(numFA);
                    lista.add(numRoles);
                    lista.add(valid);
                    resultMap.put(key, lista);   
                    cont++;
                    //   return resultMap;
                }
            }
        }
        
        return resultMap;
    }
    
    @RemoteAction
    @readOnly
    public static Map<String, Integer> getReportTotalesContact(){
        
        Integer totalRegQueries = 0;
        
        //contacts
        
        String RecordTypeICA = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Contact.SObjectType, 'CRAN_VEC_ADV_Individual');
        String RecordTypeBCA = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Contact.SObjectType, 'CRAN_VEC_ADV_Business');
                
        Integer totalContactBK_ICA = 0;
        Integer totalContactBK_BCA = 0;
        Integer totalContactBK_ICANoNS = 0;
        Integer totalContactBK_BCANoNS = 0;
        Integer totalContactBK_SinRT = 0;
        
        Integer totalContactASS_ICA = 0;
        Integer totalContactASS_BCA = 0;
        Integer totalContactASS_ICANoNS = 0;
        Integer totalContactASS_BCANoNS = 0;
        Integer totalContactASS_SinRT = 0;
        
        Integer IdentityContact101 = 0;
        Integer IdentityContact102 = 0;
        Integer IdentityContact103 = 0;
        Integer IdentityContact104 = 0;
        Integer IdentityContact105 = 0;
        Integer idsContactsBanking = 0;
        Integer idsContactsInsurance = 0;
        Integer idsContacts = 0;
        for (List<Contact> lstContacts : [SELECT Id, CRAN_VEC_ADV_T_PersonId__c, CRAN_VEC_ADV_N_NumericSort__c, CRAS_ICA_ASS_T_AxisPersonID__c, RecordTypeID, CRAN_ICA_KER_P_Identity__c FROM Contact]){
            totalRegQueries++;
            for(Contact c: lstContacts){
                idsContacts++;
                if (c.CRAN_ICA_KER_P_Identity__c == '101'){
                    IdentityContact101++;
                }  
                else if (c.CRAN_ICA_KER_P_Identity__c == '102'){
                    IdentityContact102++;
                } 
                else if (c.CRAN_ICA_KER_P_Identity__c == '103'){
                    IdentityContact103++;
                }
                else if (c.CRAN_ICA_KER_P_Identity__c == '104'){
                    IdentityContact104++;
                }
                else if (c.CRAN_ICA_KER_P_Identity__c == '105'){
                    IdentityContact105++;
                }
                
                if (String.isBlank(c.CRAS_ICA_ASS_T_AxisPersonID__c)){
                    idsContactsBanking++;
                    if (c.RecordTypeID == RecordTypeICA){
                        totalContactBK_ICA++;
                        if (String.isBlank(c.CRAN_VEC_ADV_N_NumericSort__c)){
                            totalContactBK_ICANoNS++;
                        }
                    }else if (c.RecordTypeID == RecordTypeBCA){
                        totalContactBK_BCA++;
                        if (String.isBlank(c.CRAN_VEC_ADV_N_NumericSort__c)){
                            totalContactBK_BCANoNS++;
                        }
                    }
                    else{
                        totalContactBK_SinRT++;
                    }
                }
                else {
                    idsContactsInsurance++;
                    if (c.RecordTypeID == RecordTypeICA){
                        totalContactASS_ICA++;
                        if (String.isBlank(c.CRAN_VEC_ADV_N_NumericSort__c)){
                            totalContactASS_ICANoNS++;
                        }
                    }else if (c.RecordTypeID == RecordTypeBCA){
                        totalContactASS_BCA++;
                        if (String.isBlank(c.CRAN_VEC_ADV_N_NumericSort__c)){
                            totalContactASS_BCANoNS++;
                        }
                    }
                    else{
                        totalContactASS_SinRT++;
                    }
                }
            }
        }
                
        Map<String, Integer> reportMap = new Map<String, Integer>();
        reportMap.put('0----------------------- GENERAL --------------------', 0);
        reportMap.put('Total Contacts: ', idsContacts);
        reportMap.put('Total de Queries: ', totalRegQueries);
        
        reportMap.put('1---------------------- IDENTITY --------------------', 0);
        reportMap.put('Total Contacts 101 - Banca: ', IdentityContact101);
        reportMap.put('Total Contacts 102 - Seguros: ', IdentityContact102);
        reportMap.put('Total Contacts 103 - Banca & Seguros: ', IdentityContact103);
        reportMap.put('Total Contacts 104 - Seguros Corredurias: ', IdentityContact104);
        reportMap.put('Total Contacts 105 - Seguros Dirección: ', IdentityContact105);

        reportMap.put('21------------------------ BANCA ---------------------', 0);
        reportMap.put('Total Contacts (Individual CA): ', totalContactBK_ICA);
        reportMap.put('Total Contacts (Individual CA) Sin NumSort: ', totalContactBK_ICANoNS);
        reportMap.put('Total Contacts (Business CA): ', totalContactBK_BCA);
        reportMap.put('Total Contacts (Business CA) Sin NumSort: ', totalContactBK_BCANoNS);
        reportMap.put('Total Contacts sin RecordType: ', totalContactBK_SinRT);
                        
        reportMap.put('3----------------------- SEGUROS --------------------', 0);
        reportMap.put('Total Contacts (Individual CA) Ass: ', totalContactASS_ICA);
        reportMap.put('Total Contacts (Individual CA) Ass Sin NumSort: ', totalContactASS_ICANoNS);
        reportMap.put('Total Contacts (Business CA) Ass: ', totalContactASS_BCA);
        reportMap.put('Total Contacts (Business CA) Ass Sin NumSort: ', totalContactASS_BCANoNS);
        reportMap.put('Total Contacts sin RecordType: ', totalContactASS_SinRT);

        return reportMap;
    }
    
    @RemoteAction
    @readOnly
    public static Map<String, Integer> getReportTotalesAccount(){
        
        Integer totalRegQueries = 0;
        
        //accounts
        
        String RecordTypeICA = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Account.SObjectType, 'CRAN_VEC_ADV_Individual');
        String RecordTypeBCA = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Account.SObjectType, 'CRAN_VEC_ADV_Business');
        String RecordTypeBP = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Account.SObjectType, 'CRAN_VEC_ADV_Business_Partner');
        String RecordTypeBPIns = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Account.SObjectType, 'CRAS_ICA_ASS_BPInsuranceRecordType');
               
        Integer totalAccountBK_ICA = 0;
        Integer totalAccountBK_BCA = 0;
        Integer totalAccountBK_ICANoNS = 0;
        Integer totalAccountBK_BCANoNS = 0;
        Integer totalAccountBK_SinRT = 0;
        Integer totalAccountAss_ICA = 0;
        Integer totalAccountAss_BCA = 0;
        Integer totalAccountAss_ICANoNS = 0;
        Integer totalAccountAss_BCANoNS = 0;
        Integer totalAccountAss_SinRT = 0;
        
        Integer IdentityAcc101 = 0;
        Integer IdentityAcc102 = 0;
        Integer IdentityAcc103 = 0;
        Integer IdentityAcc104 = 0;
        Integer IdentityAcc105 = 0;
        Integer idsAccountBanking = 0;
        Integer idsAccountInsurance = 0;
       	Integer idsAccounts = 0;
        //Persons
        for (List<Account> lstAcc : [SELECT Id, 
                                      		 CRAN_VEC_ADV_F_Person_Number__c, 
                                      		 CRAS_ICA_ASS_F_AxisPersonID__c, 
                                      		 CRAS_ICA_ASS_T_AxisBPID__c, 
                                      		 CRAN_VEC_ADV_T_BPId__c, 
                                      		 CRAN_ICA_KER_P_Identity__c, 
                                      		 CRAN_ICA_KER_P_Oficina__c, 
                                      		 RecordTypeID 
                                      FROM Account WHERE CRAN_VEC_ADV_T_BPId__c = '' AND CRAS_ICA_ASS_T_AxisBPID__c = '']){
            totalRegQueries++; 
            for (Account a: lstAcc){
                idsAccounts++;
                
                if (a.CRAN_ICA_KER_P_Identity__c == '101'){
                    IdentityAcc101++;
                }  
                else if (a.CRAN_ICA_KER_P_Identity__c == '102'){
                    IdentityAcc102++;
                } 
                else if (a.CRAN_ICA_KER_P_Identity__c == '103'){
                    IdentityAcc103++;
                }
                else if (a.CRAN_ICA_KER_P_Identity__c == '104'){
                    IdentityAcc104++;
                }
                else if (a.CRAN_ICA_KER_P_Identity__c == '105'){
                    IdentityAcc105++;
                }
                if (String.isBlank(a.CRAS_ICA_ASS_F_AxisPersonID__c)){
                    if (a.RecordTypeID == RecordTypeICA){
                        totalAccountBK_ICA++;
                        if (String.isBlank(a.CRAN_VEC_ADV_F_Person_Number__c)){
                            totalAccountBK_ICANoNS++;
                        }
                    } else if (a.RecordTypeID == RecordTypeBCA){
                        totalAccountBK_BCA++;
                        if (String.isBlank(a.CRAN_VEC_ADV_F_Person_Number__c)){
                            totalAccountBK_BCANoNS++;
                        }
                    }
                    else{
                        totalAccountBK_SinRT++;
                    }
                    idsAccountBanking++;
                } 
                else {
                    if (a.RecordTypeID == RecordTypeICA){
                        totalAccountAss_ICA++;
                        if (String.isBlank(a.CRAN_VEC_ADV_F_Person_Number__c)){
                            totalAccountAss_ICANoNS++;
                        }
                    } else if (a.RecordTypeID == RecordTypeBCA){
                        totalAccountAss_BCA++;
                        if (String.isBlank(a.CRAN_VEC_ADV_F_Person_Number__c)){
                            totalAccountAss_BCANoNS++;
                        }
                    }
                    else{
                        totalAccountAss_SinRT++;
                    }
                    idsAccountInsurance++;
                }                
            }
        }

        
        Map<String, Integer> reportMap = new Map<String, Integer>();
        reportMap.put('0----------------------- GENERAL --------------------', 0);
        reportMap.put('Total Accounts: ', idsAccounts);
        reportMap.put('Total de queries: ', totalRegQueries);
        
        reportMap.put('1---------------------- IDENTITY --------------------', 0);
        reportMap.put('Total Accounts 101 - Banca: ', IdentityAcc101);
        reportMap.put('Total Accounts 102 - Seguros: ', IdentityAcc102);
        reportMap.put('Total Accounts 103 - Banca & Seguros: ', IdentityAcc103);
        reportMap.put('Total Accounts 104 - Seguros Corredurías: ', IdentityAcc104);
        reportMap.put('Total Accounts 105 - Seguros Dirección: ', IdentityAcc105);
        
        reportMap.put('21------------------------ BANCA ---------------------', 0);
        reportMap.put('Total Accounts (Individual CA): ', totalAccountBK_ICA);
        reportMap.put('Total Accounts (Individual CA) Sin NumSort: ', totalAccountBK_ICANoNS);
        reportMap.put('Total Accounts (Business CA): ', totalAccountBK_BCA);
        reportMap.put('Total Accounts (Business CA) Sin NumSort: ', totalAccountBK_BCANoNS);
        reportMap.put('Total Accounts sin RecordType: ', totalAccountBK_SinRT);  
                        
        reportMap.put('3----------------------- SEGUROS --------------------', 0);
        reportMap.put('Total Accounts (Individual CA) Ass: ', totalAccountAss_ICA);
        reportMap.put('Total Accounts (Individual CA) Ass Sin NumSort: ', totalAccountAss_ICANoNS);
        reportMap.put('Total Accounts (Business CA) Ass: ', totalAccountAss_BCA);
        reportMap.put('Total Accounts (Business CA) Ass Sin NumSort: ', totalAccountAss_BCANoNS);
        reportMap.put('Total Accounts sin RecordType: ', totalAccountAss_SinRT);
        
        return reportMap;
    }
    
    @RemoteAction
    @readOnly
    public static Map<String, Integer> getReportTotalesBP(){
        
        Integer totalRegQueries = 0;
        
        //accounts
        
        String RecordTypeICA = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Account.SObjectType, 'CRAN_VEC_ADV_Individual');
        String RecordTypeBCA = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Account.SObjectType, 'CRAN_VEC_ADV_Business');
        String RecordTypeBP = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Account.SObjectType, 'CRAN_VEC_ADV_Business_Partner');
        String RecordTypeBPIns = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Account.SObjectType, 'CRAS_ICA_ASS_BPInsuranceRecordType');
               
        Integer totalAccountBK_BP = 0;
        Integer totalAccountBK_BPSinRT = 0;
        Integer totalAccountAss_BPIns = 0;
        Integer totalAccountAss_BPInsSinRT = 0;
        Integer totalBK_BPwOffice = 0;
        Integer totalAss_BPwOffice = 0;
        
        Integer IdentityAccBp101 = 0;
        Integer IdentityAccBp102 = 0;
        Integer IdentityAccBp103 = 0;
        Integer IdentityAccBp104 = 0;
        Integer IdentityAccBp105 = 0;
        Integer IdentityAccBpIns101 = 0;
        Integer IdentityAccBpIns102 = 0;
        Integer IdentityAccBpIns103 = 0;
        Integer IdentityAccBpIns104 = 0;
        Integer IdentityAccBpIns105 = 0;
        Integer idsAccountBPBanking = 0;
        Integer idsAccountBPInsurance = 0;
       	Integer idsAccounts = 0;
        
        Integer totalSinMainManagerBK = 0;
        Integer totalSinMainManagerASS = 0;
        
        //BPs
		for (List<Account> lstAcc : [SELECT Id, 
                                      		 CRAN_VEC_ADV_F_Person_Number__c, 
                                      		 CRAS_ICA_ASS_F_AxisPersonID__c, 
                                      		 CRAS_ICA_ASS_T_AxisBPID__c, 
                                      		 CRAN_VEC_ADV_T_BPId__c,
                                     		 CRAN_VEC_ADV_L_MainMngr__c,
                                      		 CRAN_ICA_KER_P_Identity__c, 
                                      		 CRAN_ICA_KER_P_Oficina__c, 
                                      		 RecordTypeID 
                                      FROM Account WHERE CRAN_VEC_ADV_T_BPId__c != '' OR CRAS_ICA_ASS_T_AxisBPID__c != '']){
            totalRegQueries++; 
            for (Account a: lstAcc){
                idsAccounts++;
                
                if (String.isNotBlank(a.CRAN_VEC_ADV_T_BPId__c)){
                    idsAccountBPBanking++;
                    
                    if (a.CRAN_ICA_KER_P_Identity__c == '101'){
                        IdentityAccBp101++;
                    }  
                    else if (a.CRAN_ICA_KER_P_Identity__c == '102'){
                        IdentityAccBp102++;
                    } 
                    else if (a.CRAN_ICA_KER_P_Identity__c == '103'){
                        IdentityAccBp103++;
                    }
                    else if (a.CRAN_ICA_KER_P_Identity__c == '104'){
                        IdentityAccBp104++;
                    }
                    else if (a.CRAN_ICA_KER_P_Identity__c == '105'){
                        IdentityAccBp105++;
                    }
                    
                    if (a.RecordTypeID == RecordTypeBP){
                        totalAccountBK_BP++;
                    }
                    else{
                        totalAccountBK_BPSinRT++;
                    }
                    
                    if (String.isNotBlank(a.CRAN_ICA_KER_P_Oficina__c)){
                        totalBK_BPwOffice++;
                    }
                    
                    if (a.CRAN_VEC_ADV_L_MainMngr__c == null){
                        totalSinMainManagerBK++;
                    }
                }
                else if (String.isNotBlank(a.CRAS_ICA_ASS_T_AxisBPID__c)){
                    idsAccountBPInsurance++;
                    
                    if (a.CRAN_ICA_KER_P_Identity__c == '101'){
                        IdentityAccBpIns101++;
                    }  
                    else if (a.CRAN_ICA_KER_P_Identity__c == '102'){
                        IdentityAccBpIns102++;
                    } 
                    else if (a.CRAN_ICA_KER_P_Identity__c == '103'){
                        IdentityAccBpIns103++;
                    }
                    else if (a.CRAN_ICA_KER_P_Identity__c == '104'){
                        IdentityAccBpIns104++;
                    }
                    else if (a.CRAN_ICA_KER_P_Identity__c == '105'){
                        IdentityAccBpIns105++;
                    }
                    
                    if (a.RecordTypeID == RecordTypeBPIns){
                        totalAccountAss_BPIns++;
                    }
                    else{
                        totalAccountAss_BPInsSinRT++;
                    }
                    
                    if (String.isNotBlank(a.CRAN_ICA_KER_P_Oficina__c)){
                        totalAss_BPwOffice++;
                    }
                    
                    if (a.CRAN_VEC_ADV_L_MainMngr__c == null){
                        totalSinMainManagerASS++;
                    }
                }
            }
        }
        
        Map<String, Integer> reportMap = new Map<String, Integer>();
        reportMap.put('0----------------------- GENERAL --------------------', 0);
        reportMap.put('Total Accounts: ', idsAccounts);
        reportMap.put('Total de queries: ', totalRegQueries);
        
        reportMap.put('1---------------------- IDENTITY --------------------', 0);
        reportMap.put('Total BP 101 - Banca: ', IdentityAccBp101);
        reportMap.put('Total BP 102 - Seguros: ', IdentityAccBp102);
        reportMap.put('Total BP 103 - Banca & Seguros: ', IdentityAccBp103);
        reportMap.put('Total BP 104 - Seguros Corredurías: ', IdentityAccBp104);
        reportMap.put('Total BP 105 - Seguros Dirección: ', IdentityAccBp105);
        reportMap.put('Total BPAss 101 - Banca: ', IdentityAccBpIns101);
        reportMap.put('Total BPAss 102 - Seguros: ', IdentityAccBpIns102);
        reportMap.put('Total BPAss 103 - Banca & Seguros: ', IdentityAccBpIns103);
        reportMap.put('Total BPAss 104 - Seguros Corredurías: ', IdentityAccBpIns104);
        reportMap.put('Total BPAss 105 - Seguros Dirección: ', IdentityAccBpIns105);
        
        reportMap.put('2-------------------- MAIN MANAGER ------------------', 0);
        reportMap.put('Total BP Banca Sin MainManager: ', totalSinMainManagerBK);
        reportMap.put('Total BP Seguros Sin MainManager: ', totalSinMainManagerASS);
        
        reportMap.put('3----------------------- OFICINA --------------------', 0);
        reportMap.put('Total BP Banca con oficina: ', totalBK_BPwOffice);
        reportMap.put('Total BP Seguros con oficina: ', totalAss_BPwOffice);
        
        reportMap.put('4------------------------ BANCA ---------------------', 0);
        reportMap.put('Total BPs: ', totalAccountBK_BP);
        reportMap.put('Total BPs sin RecordType: ', totalAccountBK_BPSinRT);      
                        
        reportMap.put('5----------------------- SEGUROS --------------------', 0);
        reportMap.put('Total BPs seguros: ', totalAccountAss_BPIns);
        reportMap.put('Total BPs seguros sin RecordType: ', totalAccountAss_BPInsSinRT);
        
        return reportMap;
    }
    
    @RemoteAction
    @readOnly
    public static Map<String, Integer> getReportTotalesFA(){
        
        Integer totalRegQueries = 0;
        
        //financial account
        
        String RecordTypeContainer = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(FinServ__FinancialAccount__c.SObjectType, 'CRAN_VEC_ADV_Container');
        String RecordTypePoliza = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(FinServ__FinancialAccount__c.SObjectType, 'CRAS_ICA_ASS_FAInsuranceRecordType');
                
        Integer IdentityBK_FA101 = 0;
        Integer IdentityBK_FA102 = 0;
        Integer IdentityBK_FA103 = 0;
        Integer IdentityBK_FA104 = 0;
        Integer IdentityBK_FA105 = 0;
        Integer IdentityAss_FA101 = 0;
        Integer IdentityAss_FA102 = 0;
        Integer IdentityAss_FA103 = 0;
        Integer IdentityAss_FA104 = 0;
        Integer IdentityAss_FA105 = 0;
        Integer totalAccountBK_FA = 0;
        Integer totalAccountBK_FANoNS = 0;
        Integer totalAccountAss_FA = 0;
        Integer totalAccountAss_FANoNS = 0;
        Integer totalBK_FAwOffice = 0;
        Integer totalAss_FAwOffice = 0;
        Integer totalSinMainManagerBK = 0;
        Integer totalSinMainManagerASS = 0;
        
        Integer idsFAs = 0;
        for (List<FinServ__FinancialAccount__c> lstfa : [SELECT 	Id, 
                                                                CRAS_ICA_ASS_T_AxisFAID__c, 
                                                                CRAN_VEC_DEV_T_ContainerID__c, 
                                                                CRAN_ICA_KER_P_Identity__c, 
                                                                CRAN_ICA_KER_P_Oficina__c,
                                                         		CRAS_ICA_ASS_F_MainMngr__c,
                                                                RecordTypeId 
                                                        FROM FinServ__FinancialAccount__c]){
           	totalRegQueries++;
            for (FinServ__FinancialAccount__c fa: lstfa){
                idsFAs++;
                
                if (String.isBlank(fa.CRAS_ICA_ASS_T_AxisFAID__c)){
                    if (fa.CRAN_ICA_KER_P_Identity__c == '101'){
                        IdentityBK_FA101++;
                    }  
                    else if (fa.CRAN_ICA_KER_P_Identity__c == '102'){
                        IdentityBK_FA102++;
                    } 
                    else if (fa.CRAN_ICA_KER_P_Identity__c == '103'){
                        IdentityBK_FA103++;
                    }
                    else if (fa.CRAN_ICA_KER_P_Identity__c == '104'){
                        IdentityBK_FA104++;
                    }
                    else if (fa.CRAN_ICA_KER_P_Identity__c == '105'){
                        IdentityBK_FA105++;
                    }
                    
                    if (fa.recordTypeId == RecordTypeContainer){
                        totalAccountBK_FA++;
                    }
                    else{
                        totalAccountBK_FANoNS++;
                    }
                    
                    if (String.isNotBlank(fa.CRAN_ICA_KER_P_Oficina__c)){
                        totalBK_FAwOffice++;
                    }
                    
                    if (String.isBlank(fa.CRAS_ICA_ASS_F_MainMngr__c)){
                        totalSinMainManagerBK++;
                    }
                }
                else {
                    if (fa.CRAN_ICA_KER_P_Identity__c == '101'){
                        IdentityAss_FA101++;
                    }  
                    else if (fa.CRAN_ICA_KER_P_Identity__c == '102'){
                        IdentityAss_FA102++;
                    } 
                    else if (fa.CRAN_ICA_KER_P_Identity__c == '103'){
                        IdentityAss_FA103++;
                    }
                    else if (fa.CRAN_ICA_KER_P_Identity__c == '104'){
                        IdentityAss_FA104++;
                    }
                    else if (fa.CRAN_ICA_KER_P_Identity__c == '105'){
                        IdentityAss_FA105++;
                    }
                    
                    if (fa.recordTypeId == RecordTypePoliza){
                        totalAccountAss_FA++;
                    }
                    else{
                        totalAccountAss_FANoNS++;
                    }
                    
                    if (String.isNotBlank(fa.CRAN_ICA_KER_P_Oficina__c)){
                        totalAss_FAwOffice++;
                    }
                    
                    if (String.isBlank(fa.CRAS_ICA_ASS_F_MainMngr__c)){
                        totalSinMainManagerASS++;
                    }
                }
            }
        }
                
        Map<String, Integer> reportMap = new Map<String, Integer>();
        reportMap.put('0----------------------- GENERAL --------------------', 0);
		reportMap.put('Total Financial Accounts: ', idsFAs);
        reportMap.put('Total Queries: ', totalRegQueries);
        
        reportMap.put('1---------------------- IDENTITY --------------------', 0);
        reportMap.put('Total FA 101 - Banca: ', IdentityBK_FA101);
        reportMap.put('Total FA 102 - Seguros: ', IdentityBK_FA102);
        reportMap.put('Total FA 103 - Banca & Seguros: ', IdentityBK_FA103);
        reportMap.put('Total FA 104 - Seguros Corredurías: ', IdentityBK_FA104);
        reportMap.put('Total FA 105 - Seguros Dirección: ', IdentityBK_FA105);
        reportMap.put('Total FAAss 101 - Banca: ', IdentityAss_FA101);
        reportMap.put('Total FAAss 102 - Seguros: ', IdentityAss_FA102);
        reportMap.put('Total FAAss 103 - Banca & Seguros: ', IdentityAss_FA103);
        reportMap.put('Total FAAss 104 - Seguros Corredurías: ', IdentityAss_FA104);
        reportMap.put('Total FAAss 105 - Seguros Dirección: ', IdentityAss_FA105);
        
        reportMap.put('2----------------------- OFICINA ---------------------', 0);
        reportMap.put('Total FA Banca con oficina: ', totalBK_FAwOffice);
        reportMap.put('Total FA Seguros con oficina: ', totalAss_FAwOffice);
        
        reportMap.put('3--------------------- MAIN MANAGER ------------------', 0);
        reportMap.put('Total FA Banca sin MainManager: ', totalSinMainManagerBK);
        reportMap.put('Total FA Seguros sin MainManager: ', totalSinMainManagerASS);
        
        reportMap.put('4------------------------ BANCA ----------------------', 0);
        reportMap.put('Total Containers: ', totalAccountBK_FA);
        reportMap.put('Total Containers sin RecordType: ', totalAccountBK_FANoNS);
                        
        reportMap.put('5----------------------- SEGUROS --------------------', 0);
        reportMap.put('Total Pólizas: ', totalAccountAss_FA);
        reportMap.put('Total Pólizas sin RecordType: ', totalAccountAss_FANoNS);
 
        return reportMap;
    }
    
    @RemoteAction
    @readOnly
    public static Map<String, Integer> getReportTotalesRolesPO(){
        
        Integer totalRegQueries = 0;
        
        //financial account role
                
        Integer totalPrimaryOwnerBK = 0;
        Integer totalPrimaryOwnerAss = 0;
        Integer totalPrimaryOwnerSinRT = 0;
        Integer totalAccountOwnerBK = 0;
        Integer totalOtrosRolesBK = 0;
        Integer totalRolesCaducadosBK = 0;
		Integer totalTomadorAss = 0;
        Integer totalOtrosRolesAss = 0;
		Integer totalRolesCaducadosAss = 0;
        Integer totalRolesContactBK = 0;
        Integer totalRolesContactAss = 0;
            
        Integer idsRolesPO = 0;
        for (List<FinServ__FinancialAccountRole__c> lstrol : [SELECT Id, 
                                                                     FinServ__Role__c,
                                                                     FinServ__EndDate__c,
                                                                     FinServ__FinancialAccount__r.CRAN_VEC_DEV_T_ContainerID__c,
                                                                     FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c
                                                             FROM FinServ__FinancialAccountRole__c WHERE FinServ__Role__c = 'Primary Owner'])
        {
            totalRegQueries++;                                                         
            for (FinServ__FinancialAccountRole__c rol: lstrol){                     
                idsRolesPO++;
                
                if (String.isNotBlank(rol.FinServ__FinancialAccount__r.CRAN_VEC_DEV_T_ContainerID__c)){
                    totalPrimaryOwnerBK++;
                }
                else if (String.isNotBlank(rol.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c)){
                    totalPrimaryOwnerAss++;
                }else{
                    totalPrimaryOwnerSinRT++;
                }
            }
        }
                
        Map<String, Integer> reportMap = new Map<String, Integer>();
        reportMap.put('0----------------------- GENERAL --------------------', 0);
        reportMap.put('Total Roles', idsRolesPO);
        reportMap.put('Total Queries: ', totalRegQueries);
        
        reportMap.put('21------------------------ BANCA ---------------------', 0);
        reportMap.put('Total Roles Tipo Primary Owner (BP): ', totalPrimaryOwnerBK);
                        
        reportMap.put('3----------------------- SEGUROS --------------------', 0);
        reportMap.put('Total Roles Tipo Primary Owner (BP Seguros): ', totalPrimaryOwnerAss);
        
        reportMap.put('0----------------------- OTROS --------------------', 0);
		reportMap.put('Total Roles PrimaryOwner sin RecordType', totalPrimaryOwnerSinRT);        
        
        return reportMap;
    }
    
    @RemoteAction
    @readOnly
    public static Map<String, Integer> getReportTotalesRolesBK(){
        
        Integer totalRegQueries = 0;
        
        //financial account role
                
        Integer totalAccountOwnerBK = 0;
        Integer totalOtrosRolesBK = 0;
        Integer totalRolesCaducadosBK = 0;
		
        Integer totalRolesContactBK = 0;
            
        Integer idsRolesBK = 0;
        for (List<FinServ__FinancialAccountRole__c> lstrol : [SELECT Id, 
                                                                     CRAS_ICA_ASS_T_AxisFARoleID__c, 
                                                                     FinServ__Role__c,
                                                                     FinServ__EndDate__c
                                                             FROM FinServ__FinancialAccountRole__c WHERE FinServ__Role__c != 'Primary Owner' 
                                                              		AND CRAS_ICA_ASS_T_AxisFARoleID__c = ''])
        {
            totalRegQueries++;                                                         
            for (FinServ__FinancialAccountRole__c rol: lstrol){                     
                idsRolesBK++;
                
                totalRolesContactBK++;
                
                if (rol.FinServ__Role__c == '1'){
                    totalAccountOwnerBK++;
                } else { totalOtrosRolesBK++; }
                
                if (rol.FinServ__EndDate__c != null){
                    totalRolesCaducadosBK++;
                } 
            }
            
        }
                
        Map<String, Integer> reportMap = new Map<String, Integer>();
        reportMap.put('0----------------------- GENERAL --------------------', 0);
        reportMap.put('Total Roles', idsRolesBK);
        reportMap.put('Total Queries: ', totalRegQueries);
        
        reportMap.put('21------------------------ BANCA ---------------------', 0);
		reportMap.put('Total Roles Tipo Contact', totalRolesContactBK);
        reportMap.put('Total Roles Tipo Contact AccountOwner(1): ', totalAccountOwnerBK);
        reportMap.put('Total Roles Tipo Contact Otros: ', totalOtrosRolesBK);   
        
        return reportMap;
    }
    
    @RemoteAction
    @readOnly
    public static Map<String, Integer> getReportTotalesRolesASS(){
        
        Integer totalRegQueries = 0;
        
        //financial account role
                
		Integer totalTomadorAss = 0;
        Integer totalOtrosRolesAss = 0;
		Integer totalRolesCaducadosAss = 0;
        Integer totalRolesContactAss = 0;
            
        Integer idsRolesAss = 0;
        for (List<FinServ__FinancialAccountRole__c> lstrol : [SELECT Id, 
                                                                     CRAS_ICA_ASS_T_AxisFARoleID__c, 
                                                                     FinServ__Role__c,
                                                                     FinServ__EndDate__c
                                                             FROM FinServ__FinancialAccountRole__c WHERE FinServ__Role__c != 'Primary Owner' 
                                                              		AND CRAS_ICA_ASS_T_AxisFARoleID__c != ''])
        {
            totalRegQueries++;                                                         
            for (FinServ__FinancialAccountRole__c rol: lstrol){                     
                idsRolesAss++;
                
                totalRolesContactAss++;
                
                if (rol.FinServ__Role__c == '101ASS'){
                    totalTomadorAss++;
                } 
                else { totalOtrosRolesAss++; }
                
                if (rol.FinServ__EndDate__c != null){
                    totalRolesCaducadosAss++;
                }
            }
            
        }
                
        Map<String, Integer> reportMap = new Map<String, Integer>();
        reportMap.put('0----------------------- GENERAL --------------------', 0);
        reportMap.put('Total Roles', idsRolesAss);
        reportMap.put('Total Queries: ', totalRegQueries);
                        
        reportMap.put('3----------------------- SEGUROS --------------------', 0);
        reportMap.put('Total Roles Tipo Contact: ', totalRolesContactAss);
        reportMap.put('Total Roles Tipo Contact Tomador(101ASS): ', totalTomadorAss);
        reportMap.put('Total Roles Tipo Contact Otros: ', totalOtrosRolesAss);
             
        return reportMap;
    }
}