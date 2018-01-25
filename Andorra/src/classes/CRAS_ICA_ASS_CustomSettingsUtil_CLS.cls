public class CRAS_ICA_ASS_CustomSettingsUtil_CLS {
    
    public class RecordTypeException extends Exception{}
    
    public static String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName){
        String objType = String.valueOf(sObjectType);
        List<RecordType> resRT = [SELECT Id FROM RecordType WHERE SObjectType = :objType and DeveloperName = :recordTypeName];
        if (resRT.isEmpty()){
            throw new RecordTypeException('Record type: "'+ recordTypeName +'" no existe.');
        }
        return resRT[0].Id;
    }
    
    public static String getListViewId(SObjectType sObjectType, String listViewName){
        Database.QueryLocator ql = Database.getQueryLocator('select id from ' + sObjectType + ' LIMIT 1');
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(ql);
        System.SelectOption[] listViews = setController.getListViewOptions();
        String listViewID = null;
        for(System.SelectOption listView : listViews)
        {
            if(listView.getLabel() == listViewName) 
            {
                listViewID = listView.getValue();
            }
        }    
        return listViewID;
    }
    
    public static void setSettings(){
        createGlobalCustomSettings();
        createRelatedListsCustomSettings();
    }
    
    public static void createGlobalCustomSettings(){
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        
        gCS.CRAS_ICA_ASS_FA_Unpaid_LV_ID__c = getListViewId(FinServ__FinancialAccount__c.SObjectType, 'Pólizas con recibos devueltos');
        gCS.CRAS_ICA_ASS_FA_Pending_LV_ID__c = getListViewId(FinServ__FinancialAccount__c.SObjectType, 'Propuestas Pendientes');
        gCS.CRAS_ICA_ASS_FAInsurance_RT_ID__c = getObjectRecordTypeId(FinServ__FinancialAccount__c.SObjectType, 'CRAS_ICA_ASS_FAInsuranceRecordType');
        gCS.CRAS_ICA_ASS_OppObjetivos_RT__c = getObjectRecordTypeId(Opportunity.SObjectType, 'CRAS_ICA_ASS_ObjetivoSeguros_RT');
        gCS.CRAS_ICA_ASS_OppVentas_RT__c = getObjectRecordTypeId(Opportunity.SObjectType, 'CRAS_ICA_ASS_VentaSeguros_RT');
        gCS.CRAS_ICA_ASS_CampaignRT_ID__c = getObjectRecordTypeId(Campaign.SObjectType, 'CRAS_ICA_ASS_Seguros_RT');
        gCS.CRAS_ICA_ASS_SecurityProducts_RT__c = getObjectRecordTypeId(FinServ__Securities__c.SObjectType, 'CRAS_ICA_ASS_ProductInsuranceRecordType');
        gCS.CRAS_ICA_ASS_SecurityGuarantee_RT__c = getObjectRecordTypeId(FinServ__Securities__c.SObjectType, 'CRAS_ICA_ASS_GuaranteesInsuranceRecordType');
        gCS.CRAS_ICA_ASS_PctVariable__c = 0.05;
        gCS.CRAS_ICA_ASS_Corr40User_ID__c = 'ASS40';
        gCS.CRAS_ICA_ASS_Corr41User_ID__c = 'ASS41';
        gCS.CRAS_ICA_ASS_Corr42User_ID__c = 'ASS42';
        gCS.CRAS_ICA_ASS_Corr43User_ID__c = 'ASS43';
        gCS.CRAS_ICA_ASS_Corr44User_ID__c = 'ASS44';
        gCS.CRAS_ICA_ASS_Corr45User_ID__c = 'ASS45';
        gCS.CRAS_ICA_ASS_Tele46User_ID__c = 'ASS46';
        gCS.CRAS_ICA_ASS_Corr47User_ID__c = 'ASS47';
        gCS.CRAS_ICA_ASS_Corr48User_ID__c = 'ASS48';
        gCS.CRAS_ICA_ASS_Corr49User_ID__c = 'ASS49';
        gCS.CRAS_ICA_ASS_RRHHUser_ID__c = '9999';

        gCS.SetupOwnerId = UserInfo.getOrganizationId();
        
        upsert gCS;
    }
    
    public static void createRelatedListsCustomSettings(){
        CRAS_ICA_ASS_RelatedLists_CS__c  relCS = CRAS_ICA_ASS_RelatedLists_CS__c.getOrgDefaults();
        
        relCS.CRAS_ICA_ASS_FAR_Insurance_RT_ID__c = getObjectRecordTypeId(FinServ__FinancialAccountRole__c.SObjectType, 'CRAS_ICA_ASS_FARInsuranceRecordType');
        relCS.CRAS_ICA_ASS_FH_Guarantees_RT_ID__c = getObjectRecordTypeId(FinServ__FinancialHolding__c.SObjectType, 'CRAS_ICA_ASS_GarantiaPolizaRecordType');
        relCS.CRAS_ICA_ASS_FH_Products_RT_ID__c = getObjectRecordTypeId(FinServ__FinancialHolding__c.SObjectType,'CRAS_ICA_ASS_FHInsuranceRecordType');
        relCS.CRAS_ICA_ASS_InsuranceInvoices_RT_ID__c = getObjectRecordTypeId(CRAS_ICA_ASS_Invoice__c.SObjectType,'CRAS_ICA_ASS_InvoiceRecordType');
        relCS.CRAS_ICA_ASS_BPInsurance_RT__c = getObjectRecordTypeId(Account.SObjectType,'CRAS_ICA_ASS_BPInsuranceRecordType');
        
        if (relCS.Name != 'Default'){
            relCS.Name = 'Default';
        }
        relCS.SetupOwnerId = UserInfo.getOrganizationId();
        
        upsert relCS;
    }
    
    public static void cleanInsuranceDataLoad(Boolean onlyReport){
        Set<Id> idsInInvoices = new Set<Id>();
        Set<Id> idsInRoles = new Set<Id>();
        Set<Id> idsInGuarantees = new Set<Id>();
        
        Id FAInsuranceRT = getObjectRecordTypeId(FinServ__FinancialAccount__c.SObjectType,'CRAS_ICA_ASS_FAInsuranceRecordType');
        Id FHInsuranceProductRT = getObjectRecordTypeId(FinServ__FinancialHolding__c.SObjectType,'CRAS_ICA_ASS_FHInsuranceRecordType');
        Id FARInsuranceRT = getObjectRecordTypeId(FinServ__FinancialAccountRole__c.SObjectType, 'CRAS_ICA_ASS_FARInsuranceRecordType');
        Id FHInsuranceGuaranteeRT = getObjectRecordTypeId(FinServ__FinancialHolding__c.SObjectType,'CRAS_ICA_ASS_GarantiaPolizaRecordType');
        Id OPVInsuranceRT = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Opportunity.SObjectType, 'CRAS_ICA_ASS_VentaSeguros_RT');
        
        /*List<CRAS_ICA_ASS_Invoice__c> lstInInvoices =[SELECT CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c != null];
for (CRAS_ICA_ASS_Invoice__c inv : lstInInvoices){
idsInInvoices.add(inv.CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c);
}*/
        List<FinServ__FinancialAccountRole__c> lstInRoles = [SELECT FinServ__FinancialAccount__c FROM FinServ__FinancialAccountRole__c WHERE RecordTypeId = :FARInsuranceRT];
        for (FinServ__FinancialAccountRole__c rol : lstInRoles){
            idsInRoles.add(rol.FinServ__FinancialAccount__c);
        }
        List<FinServ__FinancialHolding__c> lstInGuarantees = [SELECT FinServ__FinancialAccount__c FROM FinServ__FinancialHolding__c WHERE RecordTypeId = :FHInsuranceGuaranteeRT];
        for (FinServ__FinancialHolding__c guarantee : lstInGuarantees){
            idsInGuarantees.add(guarantee.FinServ__FinancialAccount__c);
        }
        
        /* Se debe verificar que cada rol tenga al menos una garantia */		
        /*Roles*/List<FinServ__FinancialAccount__c> lst1 = [SELECT Id, Name, FinServ__FinancialAccountNumber__c FROM FinServ__FinancialAccount__c WHERE RecordTypeId = :FAInsuranceRT AND Id NOT IN :idsInRoles AND FinServ__Status__c NOT IN ('102ASS','105ASS') ];
        /*Recibos*///List<FinServ__FinancialAccount__c> lst2 = [SELECT Id, Name, FinServ__FinancialAccountNumber__c FROM FinServ__FinancialAccount__c WHERE RecordTypeId = :FAInsuranceRT AND Id NOT IN :idsInInvoices AND Id IN :idsInRoles AND CRAS_ICA_ASS_C_PrimaAnual__c > 0 AND Id NOT IN :lst1 AND FinServ__Status__c NOT IN ('102ASS','105ASS')];
        /*Garantías*/List<FinServ__FinancialAccount__c> lst3 = [SELECT Id, Name, FinServ__FinancialAccountNumber__c FROM FinServ__FinancialAccount__c WHERE RecordTypeId = :FAInsuranceRT AND Id IN :idsInRoles AND Id NOT IN :idsInGuarantees AND Id NOT IN :lst1 AND FinServ__Status__c NOT IN ('102ASS','105ASS')];
        
        //Financial Accounts without products
        /*Productos*/List<FinServ__FinancialAccount__c> lst4 = [SELECT Id, Name, FinServ__FinancialAccountNumber__c FROM FinServ__FinancialAccount__c WHERE CRAS_ICA_ASS_T_AxisFAID__c != null AND (CRAS_ICA_ASS_T_ProductoPoliza__c = '' OR CRAN_VEC_ADV_P_PFMMkt__c = '' OR CRAN_VEC_ADV_P_PFMMktClass__c = '') AND Id NOT IN :lst1 AND Id NOT IN :lst3 AND FinServ__Status__c NOT IN ('102ASS','105ASS')];
        
        List<FinServ__FinancialAccount__c> lstFA = new List<FinServ__FinancialAccount__c>();
        lstFA.addAll(lst1);
        //lstFA.addAll(lst2);
        lstFA.addAll(lst3);
        lstFA.addAll(lst4);
        Set<Id> idsFA = new Set<Id>();
        for (FinServ__FinancialAccount__c FA : lstFA){
            idsFA.add(FA.Id);
        }
        
        
        Integer numResFA = [SELECT count() FROM FinServ__FinancialAccount__c WHERE Id IN :idsFA] /*En caso sean más de 50mil*/;
        
        Integer numResFHP = [SELECT count() FROM FinServ__FinancialHolding__c WHERE RecordTypeId = :FHInsuranceProductRT AND FinServ__FinancialAccount__c IN :idsFA];
        
        Integer numResFHG = [SELECT count() FROM FinServ__FinancialHolding__c WHERE RecordTypeId = :FHInsuranceGuaranteeRT AND FinServ__FinancialAccount__c IN :idsFA];
        
        Integer numResFAR = [SELECT count() FROM FinServ__FinancialAccountRole__c WHERE RecordTypeId = :FARInsuranceRT AND FinServ__FinancialAccount__c IN :idsFA];        
        Integer numResINV = [SELECT count() FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c IN :idsFA];        
        Integer numResCAH = [SELECT count() FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__c IN :idsFA];
        
        Integer numResCPH = [SELECT count() FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :idsFA];
        
        Integer numResFAPH = [SELECT count() FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :idsFA];
        
        Integer numResOPV = [SELECT count() FROM Opportunity WHERE RecordTypeId = :OPVInsuranceRT AND FinServ__FinancialAccount__c IN :idsFA];
        
        Integer numTotalReg = numResFA + numResFHP + numResFHG + numResFAR + numResINV + numResCAH + numResCPH + numResFAPH + numResOPV;
        
        Document reportFileLst1= new Document();
        Document reportFileLst2 = new Document();
        Document reportFileLst3 = new Document();
        Document reportFileLst4 = new Document();
        String bodyLst1 = 'Id,Name,AccountNumber\n';
        String bodyLst2 = 'Id,Name,AccountNumber\n';
        String bodyLst3 = 'Id,Name,AccountNumber\n';
        String bodyLst4 = 'Id,Name,AccountNumber\n';
        List<Document> lstReportFile = new List<Document>();
        
        String LongDate = '';
        
        Datetime current = System.now();
        
        Date currDate = current.date();
        Time currTime = current.time();
        
        Datetime local = datetime.newinstance(currDate,currTime);
        
        longDate = local.format('yyyyMMdd\'T\'hhmmss','Europe/Berlin');
        
        
        //añadir el fichero solo si tiene algún registro
        if (lst1.size()>0){
            for (FinServ__FinancialAccount__c badRegis : lst1){
                bodyLst1 +=  String.valueOf(badRegis.Id) + ',' +  String.valueOf(badRegis.Name) + ',' +  String.valueOf(badRegis.FinServ__FinancialAccountNumber__c) + '\n';
            }
            
            reportFileLst1.folderid = UserInfo.getUserId();
            reportFileLst1.Body = Blob.valueOf(bodyLst1);
            reportFileLst1.Name = longDate + ' - Polizas_sin_roles_ni_recibos.csv';
            lstReportFile.add(reportFileLst1);
        } 
        
        //añadir el fichero solo si tiene algún registro
        /*if (lst2.size()>0){
for (FinServ__FinancialAccount__c badRegis : lst2){
bodyLst2 +=  String.valueOf(badRegis.Id) + ',' +  String.valueOf(badRegis.Name) + ',' +  String.valueOf(badRegis.FinServ__FinancialAccountNumber__c) + '\n';
}

reportFileLst2.folderid = UserInfo.getUserId();
reportFileLst2.Body = Blob.valueOf(bodyLst2);
reportFileLst2.Name = longDate +' - Polizas_sin_recibos.csv';
lstReportFile.add(reportFileLst2);
} else {
System.debug('No se genera el fichero Polizas_sin_recibos.csv porque está vacío');
} */
        
        //añadir el fichero solo si tiene algún registro
        if (lst3.size()>0){
            
            for (FinServ__FinancialAccount__c badRegis : lst3){
                bodyLst3 +=  String.valueOf(badRegis.Id) + ',' +  String.valueOf(badRegis.Name) + ',' +  String.valueOf(badRegis.FinServ__FinancialAccountNumber__c) + '\n';
            }
            
            reportFileLst3.folderid = UserInfo.getUserId();
            reportFileLst3.Body = Blob.valueOf(bodyLst3);
            reportFileLst3.Name = longDate + ' - Polizas_sin_garantias.csv';
            lstReportFile.add(reportFileLst3);
        }
        
        if (lst4.size()>0){
            
            for (FinServ__FinancialAccount__c badRegis : lst4){
                bodyLst4 +=  String.valueOf(badRegis.Id) + ',' +  String.valueOf(badRegis.Name) + ',' +  String.valueOf(badRegis.FinServ__FinancialAccountNumber__c) + '\n';
            }
            
            reportFileLst4.folderid = UserInfo.getUserId();
            reportFileLst4.Body = Blob.valueOf(bodyLst4);
            reportFileLst4.Name = longDate + ' - Polizas_sin_productos.csv';
            lstReportFile.add(reportFileLst4);
        } 
        
        if (lstReportFile.size()>0){
            insert lstReportFile;
        } 
        
        if (numTotalReg > 0 && onlyReport == false){
            
            Integer LimitQuery = 9999;
            
            if (Test.isRunningTest()){                
                LimitQuery = 10;
            }
            
            CRAS_ICA_ASS_CleanInsuranceData_Job cJob = new CRAS_ICA_ASS_CleanInsuranceData_Job(idsFA, numTotalReg, numResFA, numResFHP + numResFHG, numResFAR, numResINV, numResCAH, numResCPH, numResFAPH, numResOPV, LimitQuery, 1);
            ID jobID = System.enqueueJob(cJob);
            System.debug('Llamada 1 - JOB ID: ' + jobID);
        }
    }
}