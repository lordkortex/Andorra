/**
* 
* Class that creates testing data for the insurance apex classes
* 
* Date: April 2017
* @author TDA - Rui Marques (rmarques@tda.ad)
* @version 1.0
*/

@isTest
public class CRAS_ICA_ASS_TestDataFactory_TST {
    
    private static Schema.RecordTypeInfo rt;
    private static Map<Id, RecordType> recordTypeCache;
    private Static User userTest;
    
    static {
        recordTypeCache = new Map<Id, RecordType>([Select Id, DeveloperName from RecordType]);
    }
    
    public static Schema.RecordTypeInfo recordTypeIdByDeveloperName(SObject auxObject, String recordTypeName) {
        List<Schema.RecordTypeInfo> recordTypes = auxObject.getSObjectType().getDescribe().getRecordTypeInfos();
        for (Schema.RecordTypeInfo recordType : recordTypes) {
            if (recordType.isAvailable() && recordTypeCache.containsKey(recordType.getRecordTypeId()) && recordTypeName == recordTypeCache.get(recordType.getRecordTypeId()).DeveloperName) {
                return recordType;
            }
        }
        return null;
    }
    
    public static Contact createContact(String recType, Integer i, Account acc){
        Contact cnt = new Contact();
        rt = recordTypeIdByDeveloperName(cnt,recType);
        cnt.RecordTypeId = rt.getRecordTypeId();
        cnt.Description = rt.getName();
        cnt.FirstName = 'Contacto ';
        cnt.LastName = String.valueOf(i);
        cnt.CRAS_ICA_ASS_PC_PctSiniestralidad__c = Math.random()*100;
        cnt.OwnerId = UserInfo.getUserId();
        cnt.CRAS_ICA_ASS_T_AxisPersonID__c = String.valueOf(i);
        cnt.CRAN_VEC_ADV_N_NumericSort__c = String.valueOf(i);
        cnt.AccountId = acc.Id;
        
        if(Math.mod(i, 2) == 0)
        {
            cnt.CRAN_ICA_KER_P_Identity__c = '101';
        }
        
        if(Math.mod(i, 3) == 0)
        {
            cnt.CRAN_ICA_KER_P_Identity__c = '102';
        }
        
        if(Math.mod(i, 5) == 0)
        {
            cnt.CRAN_ICA_KER_P_Identity__c = '103';
        }
        
        if(Math.mod(i, 7) == 0)
        {
            cnt.CRAN_ICA_KER_P_Identity__c = '104';
        }
        
        if(Math.mod(i, 11) == 0)
        {
            cnt.CRAN_ICA_KER_P_Identity__c = '105';
        }
        
        return cnt;
    }
    
    
    public static List<Contact> createContactList() {
        List<Contact> cntLst = new List<Contact>();
        List<Account> accLst = new List<Account>();
        
        for (integer i=0; i<50; i++){
            Account acc = createAccountContact(i);
            accLst.add(acc);
        }
        
        insert accLst;
        
        for (integer i=0; i<25; i++){
            Contact cnt = createContact('CRAN_VEC_ADV_Individual', i, accLst[i]);
            cntLst.add(cnt);
        }
        for (integer i=25; i<50; i++){
            Contact cnt = createContact('CRAN_VEC_ADV_Business', i, accLst[i]);
            cntLst.add(cnt);
        }
        insert cntLst;
        
        for (integer i=0; i<50; i++){
            accLst[i].FinServ__PrimaryContact__c = cntLst[i].Id;
        }
        
        update accLst;
        
        return cntLst;
    }
    
    public static Account createAccountContact(Integer i) {
        Account acc = new Account();
        acc.Name = 'Account ' + i;
        acc.OwnerId = UserInfo.getUserId();
        return acc;
    }
    
    public static Account createAccount(String recType, Integer i, String office){
        Account acc = new Account();
        rt = recordTypeIdByDeveloperName(acc,recType);
        acc.RecordTypeId = rt.getRecordTypeId();
        acc.Description = rt.getName();
        acc.Name = 'Cuenta BP Seguros ' + i;
        //acc.CRAN_VEC_ADV_L_MainMngr__r.Id = UserInfo.getUserId();
        acc.CRAN_ICA_KER_L_SalesManager__c = UserInfo.getUserId();
        acc.CRAN_ICA_KER_P_Oficina__c = office;
        acc.CRAN_VEC_ADV_P_Branch__c = '63' + String.valueOf(i);
        if(Math.Mod(i, 2) == 0)
        {
            acc.CRAS_ICA_ASS_T_AxisBPID__c = String.valueOf(i);
        }
        else
        {
            acc.CRAN_VEC_ADV_T_BPId__c = String.valueOf(i);
            
        }
        
        return acc;
    }
    
    
    public static List<Account> createAccountList() {
        List<Account> accLst = new List<Account>();
        List<String> office = new List<String>{'6','7','10'}; 
            for (integer i=0; i<50; i++){
                Account acc = createAccount('CRAS_ICA_ASS_BPInsuranceRecordType',i,office.get(Math.floor(Math.random()*3).intValue()));
                accLst.add(acc); 
            }
        insert accLst;  
        return accLst;
    }
    
    public static FinServ__FinancialAccount__c createFA(Account acc, Integer accNum, String recType){
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        
        Integer month;
        Integer day;
        Integer year = Date.today().year();
        FinServ__FinancialAccount__c fa = new FinServ__FinancialAccount__c();
        fa.Name = 'FA - ' + acc.get('Name');
        fa.RecordTypeId = recordTypeIdByDeveloperName(fa,recType).getRecordTypeId();
        fa.FinServ__PrimaryOwner__c = acc.id;
        fa.FinServ__FinancialAccountNumber__c = 'FAN - ' + String.valueOf(accNum);
        fa.CRAS_ICA_ASS_C_PrimaAnual__c = Math.random()*10000;
        fa.CRAS_ICA_ASS_C_DebtAmount__c = Math.random()*10000;
        fa.CRAS_ICA_ASS_D_SaleDate__c = Date.today();
        fa.CRAS_ICA_ASS_PE_PctSiniestralidad__c = Math.random()*300;
        fa.CRAN_VEC_ADV_P_PFMMkt__c = '804123ASS';
        fa.CRAS_ICA_ASS_D_FCargaAlta__c = CRAS_ICA_ASS_Helpers_CLS.DateNow().addMonths(-5);
        fa.CRAS_ICA_ASS_D_FCargaBaja__c = CRAS_ICA_ASS_Helpers_CLS.DateNow().addMonths(1);
        //fa.CRAS_ICA_ASS_N_NumUnpaidInvoices__c = Math.round(Math.random());
        fa.CRAS_ICA_ASS_T_ProductoPoliza__c = 'Producto ' + accNum;
        
        if(userTest != null)
        {
            fa.OwnerId = userTest.Id;
        }
        
        
        if(Math.Mod(accNum, 2) == 0)
        {
            fa.CRAS_ICA_ASS_T_AxisFAID__c = String.valueOf(accNum*Math.random());
        }
        else
        {
            fa.CRAN_VEC_DEV_T_ContainerID__c = String.valueOf(accNum*Math.random());
        }
        
        
        if (accNum < 5){
            fa.FinServ__Status__c = '105ASS';
            fa.FinServ__OpenDate__c = Date.today();
            fa.CRAN_VEC_ADV_P_PFMMkt__c = null;
            //fa.CRAS_ICA_ASS_T_SolicitudAxisID__c = '0' + Math.random()*10000;
        }else if (accNum < 35){
            fa.FinServ__Status__c = '101ASS';
            if (accNum < 10){
                month = Date.today().month();
                day = Date.today().day();
                day = Integer.valueOf(Math.ceil(Math.random()*day));
                day = day==0 ? 1: day;
                fa.FinServ__OpenDate__c = Date.newInstance(year, month, day);
                fa.CRAN_VEC_ADV_P_PFMMkt__c = '804131ASS';
            }else{
                day = Date.today().dayOfYear()-1;
                day = Integer.valueOf(Math.ceil(Math.random()* day));
                fa.FinServ__OpenDate__c = Date.today().addDays(-day);
                fa.CRAN_VEC_ADV_P_PFMMkt__c = savingsCode;
            }
        }else{
            fa.FinServ__Status__c = '102ASS';
            if (accNum < 45){
                month = Date.today().month();
                day = Date.today().day();
                day = Integer.valueOf(Math.ceil(Math.random()*day));
                day = day==0 ? 1: day;
                fa.FinServ__OpenDate__c = Date.newInstance(year, month, day);
                fa.CRAN_VEC_ADV_P_PFMMkt__c = savingsCode;
                
            }else {
                day = Date.today().dayOfYear()-1;
                day = Integer.valueOf(Math.ceil(Math.random()* day));
                fa.FinServ__OpenDate__c = Date.today().addDays(-day);
                fa.FinServ__CloseDate__c = Date.today().addMonths(Math.round(Math.random()*10)+1);
            }
        }
        
        return fa;
    }
    
    public static List<FinServ__FinancialAccount__c> createFAList(List<Account> accLst) {
        List<FinServ__FinancialAccount__c> faLst = new List<FinServ__FinancialAccount__c>();
        Integer accNum = 0;
        for (Account acc :accLst){
            FinServ__FinancialAccount__c fa = createFA(acc, accNum, 'CRAS_ICA_ASS_FAInsuranceRecordType');
            accNum ++;
            faLst.add(fa);
        }
        insert faLst;  
        return faLst;
    }
    
    public static FinServ__FinancialAccountRole__c createFAR(Contact cnt, FinServ__FinancialAccount__c fa, String recType,Integer i, String role, Integer axis){
        FinServ__FinancialAccountRole__c far = new FinServ__FinancialAccountRole__c();
        far.FinServ__RelatedContact__c = cnt.id;
        far.FinServ__FinancialAccount__c = fa.id;
        far.FinServ__Role__c = role;
        far.RecordTypeId = recordTypeIdByDeveloperName(far, recType).getRecordTypeId();
        CRAS_ICA_ASS_RelatedLists_CS__c relCS = CRAS_ICA_ASS_RelatedLists_CS__c.getOrgDefaults();
        
        if(Math.Mod(axis, 2) == 0)
        {
            if(Math.Mod(axis, 4) == 0)
            {
                far.finserv__role__c = '102ASS';
            }
            
            far.CRAS_ICA_ASS_T_AxisFARoleID__c = String.valueOf(axis*Math.random());
        }
        else
        {
            far.CRAN_VEC_ADV_T_BPId__c = String.valueOf(axis*Math.random());
        }
        
        return far;
    }
    
    public static List<FinServ__FinancialAccountRole__c> createFARList(List<Contact> conLst, List<FinServ__FinancialAccount__c> faLst) {
        List<FinServ__FinancialAccountRole__c> farLst = new List<FinServ__FinancialAccountRole__c>();
        for (integer i=0; i<50; i++){    
            FinServ__FinancialAccountRole__c farPH = createFAR(conLst[i], faLst[i], 'CRAS_ICA_ASS_FARInsuranceRecordType', i, '101ASS', i);
            farLst.add(farPH);
            FinServ__FinancialAccountRole__c farIns = createFAR(conLst[i], faLst[i], 'CRAS_ICA_ASS_FARInsuranceRecordType', i, '102ASS', i+50);
            farLst.add(farIns);
        }
        insert farLst;
        return farLst;
    }
    
    public static FinServ__FinancialHolding__c createFH(FinServ__Securities__c sec, FinServ__FinancialAccountRole__c far, Integer i, String recType, String axis){
        FinServ__FinancialHolding__c fh = new FinServ__FinancialHolding__c();
        rt = recordTypeIdByDeveloperName(fh,recType);
        fh.RecordTypeId = rt.getRecordTypeId();
        fh.Name = 'FH '+ rt.getName() + '' + i;
        fh.FinServ__Securities__c = sec.id;
        fh.FinServ__FinancialAccount__c = far.FinServ__FinancialAccount__c;
        If (axis == 'CRAS_ICA_ASS_T_AxisProductID__c'){
            fh.CRAS_ICA_ASS_T_AxisProductID__c = (String)sec.get(axis);
        }else{
            //fh.CRAS_ICA_ASS_MD_FinancialAccountRole__c = far.id;
            fh.CRAS_ICA_ASS_T_AxisGuaranteeID__c = (String)sec.get(axis);
        }
        return fh;
    }
    
    public static List<FinServ__FinancialHolding__c> createFHList(List<FinServ__Securities__c> secGuaLst, List<FinServ__Securities__c> secProLst, List<FinServ__FinancialAccountRole__c> farLst) 
    {
        List<FinServ__FinancialHolding__c> fhLst = new List<FinServ__FinancialHolding__c>();
        for (integer i=0; i<50; i++){
            FinServ__FinancialHolding__c fh = createFH(secProLst[i], farLst[i], i, 'CRAS_ICA_ASS_FHInsuranceRecordType', 'CRAS_ICA_ASS_T_AxisProductID__c');
            fhLst.add(fh);
        }
        for (integer i=0; i<50; i++){
            FinServ__FinancialHolding__c fh = createFH(secGuaLst[i], farLst[i], i, 'CRAS_ICA_ASS_GarantiaPolizaRecordType', 'CRAS_ICA_ASS_T_AxisGuaranteeID__c');
            fhLst.add(fh);
        }
        insert fhLst;  
        return fhLst;
    }
    
    public static CRAS_ICA_ASS_Invoice__c createInvoice(FinServ__FinancialAccountRole__c far, Integer i, String recType){
        CRAS_ICA_ASS_Invoice__c inv = new CRAS_ICA_ASS_Invoice__c();
        rt = recordTypeIdByDeveloperName(inv, recType);
        inv.RecordTypeId = rt.getRecordTypeId();
        inv.Name = 'Recibo ' + i;
        inv.CRAS_ICA_ASS_C_TotalPremium__c = 4400;
        inv.CRAS_ICA_ASS_D_InvoiceExpirationDate__c = Date.Today().addMonths(Math.round(Math.random()*10)+1);
        inv.CRAS_ICA_ASS_MD_FinancialAccountRole__c = far.id;
        inv.CRAS_ICA_ASS_P_InvoiceStatus__c = '102ASS';
        inv.CRAS_ICA_ASS_T_AxisInvoiceNumber__c = String.valueOf(i);
        return inv;
    }
    
    
    public static List<CRAS_ICA_ASS_Invoice__c> createInvList(List<FinServ__FinancialAccountRole__c> farLst) {
        List<CRAS_ICA_ASS_Invoice__c> invLst = new List<CRAS_ICA_ASS_Invoice__c>();
        for (integer i=0; i<50; i++){
            CRAS_ICA_ASS_Invoice__c inv = createInvoice(farLst[i], i, 'CRAS_ICA_ASS_InvoiceRecordType');
            invLst.add(inv);
        }
        insert invLst;  
        return invLst;
    }
    
    public static CRAS_ICA_ASS_ClaimAmountHistory__c createClaim(FinServ__FinancialAccountRole__c far, Integer i, Decimal year){
        CRAS_ICA_ASS_ClaimAmountHistory__c clm = new CRAS_ICA_ASS_ClaimAmountHistory__c();
        clm.CRAS_ICA_ASS_C_TotalAmount__c = Math.random()*2800;
        clm.CRAS_ICA_ASS_C_TotalNaturalYear__c = Math.random()*2600;
        clm.CRAS_ICA_ASS_D_StartDate__c = Date.today();
        clm.CRAS_ICA_ASS_D_EndDate__c = Date.today().addMonths(Math.round(Math.random()*10)+1);
        clm.CRAS_ICA_ASS_L_Role__c = far.id;
        clm.CRAS_ICA_ASS_N_Year__c = year;
        clm.CRAS_ICA_ASS_T_AxisClaimId__c = String.valueOf(i);
        
        if(Math.mod(i, 2) == 0)
        {
            clm.CRAS_ICA_ASS_C_TotalPagoPrimas__c = Math.random()*1600;
        }
        
        return clm;
    }
    
    public static List<CRAS_ICA_ASS_ClaimAmountHistory__c> createClaimList(List<FinServ__FinancialAccountRole__c> farLst) {
        List<CRAS_ICA_ASS_ClaimAmountHistory__c> clmLst = new List<CRAS_ICA_ASS_ClaimAmountHistory__c>();
        List<String> yearLst = new List<String>{'2011','2012','2013','2014','2015','2016','2017'};
            for (integer i=0; i<50; i++){
                Decimal year = Decimal.valueOf(yearLst.get(Math.floor(Math.random()*7).intValue()));
                CRAS_ICA_ASS_ClaimAmountHistory__c clm = createClaim(farLst[i], i, year);
                clmLst.add(clm);
            }
        insert clmLst;
        return clmLst;
    }
    
    public static CRAS_ICA_ASS_FA_PremiumHistory__c createFAPremHist(FinServ__FinancialAccount__c fa, Integer i){
        CRAS_ICA_ASS_FA_PremiumHistory__c preHst = new CRAS_ICA_ASS_FA_PremiumHistory__c();
        preHst.CRAS_ICA_ASS_C_Premium__c  = 1900;
        preHst.CRAS_ICA_ASS_D_StartDate__c = Date.today();
        preHst.CRAS_ICA_ASS_D_EndDate__c = Date.today().addYears(1);
        preHst.CRAS_ICA_ASS_L_FinancialAccount__c = fa.id;
        preHst.CRAS_ICA_ASS_T_AxisPrimeId__c = String.valueOf(i);
        return preHst;
    }
    
    public static List<CRAS_ICA_ASS_FA_PremiumHistory__c> createFAPremHistList(List<FinServ__FinancialAccount__c> faLst){
        List<CRAS_ICA_ASS_FA_PremiumHistory__c> preHstLst = new List<CRAS_ICA_ASS_FA_PremiumHistory__c>();
        for (integer i=0; i<50; i++){
            CRAS_ICA_ASS_FA_PremiumHistory__c preHst = createFAPremHist(faLst[i], i);
            preHstLst.add(preHst);
        }
        insert preHstLst;
        return preHstLst;
    }
    
    public static Opportunity createObjetivoOpportunity (Id cpId, Account acc, String market,Decimal toq ,Date closeDate, Decimal amount, String stageName){
        CRAS_ICA_ASS_InsuranceGlobal_CS__c relCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        
        Opportunity opp = new Opportunity();
        opp.CRAN_VEC_ADV_P_PFMMkt__c=market;
        opp.Amount = amount;
        opp.CloseDate = closeDate;
        opp.StageName = stageName;
        opp.TotalOpportunityQuantity = toq;
        opp.Name = 'Test ' + amount;
        opp.CampaignId = cpId;
        opp.CRAN_ICA_KER_P_Oficina__c = '10';
        opp.AccountId = acc.Id;
        opp.RecordTypeId = relCS.CRAS_ICA_ASS_OppObjetivos_RT__c;
        opp.OwnerId = userTest.Id;
        
        return opp;
    }
    
    public static List<Opportunity> createOppObjectivesList(List<Account> accLst, Id cpId){
        List<Opportunity> ObjList = new List<Opportunity> ();
        
        Date dateNow = CRAS_ICA_ASS_Helpers_CLS.DateNow();
        Integer cont = 0;
        
        for (integer i=0; i<15; i++)
        {
            Opportunity opp;
            if(i<5) {
                opp = createObjetivoOpportunity(cpId, accLst[i], '804123ASS', 1, dateNow, (++cont + 100), 'Alta');
            } else if(i<10) {  
                opp = createObjetivoOpportunity(cpId, accLst[i], '804102ASS', 1, dateNow, (++cont + 100), 'Alta');    
            } else {
                opp = createObjetivoOpportunity(cpId, accLst[i], '804131ASS', 1, dateNow, (++cont + 100), 'Alta');    
            }    
            ObjList.add(opp);
            
        }
        
        
        insert ObjList;
        return ObjList;
    }
    
    public static FinServ__Securities__c createSecurityProduct (Integer count, FinServ__FinancialAccount__c fa){
        CRAS_ICA_ASS_InsuranceGlobal_CS__c relCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        FinServ__Securities__c secuProd = new FinServ__Securities__c();
        
        secuProd.Name = 'ASSEGUR JUBILACIÓ ' + count;
        secuProd.RecordTypeId = relCS.CRAS_ICA_ASS_SecurityProducts_RT__c;
        secuProd.FinServ__SecuritiesName__c = 'ASSEGUR JUBILACIÓ ' + count;
        secuProd.CRAN_VEC_ADV_P_PFMMKTCAT__C = '804ASS';
        secuProd.CRAN_VEC_ADV_P_PFMMKTCLASS__C = '8041ASS';
        secuProd.CRAN_VEC_ADV_P_PFMMkt__c = '804123ASS';
        secuProd.CRAS_ICA_ASS_B_Activo__c = true;
        secuProd.CRAS_ICA_ASS_T_AxisProductID__c = 0 + '' + count;
        secuProd.CRAS_ICA_ASS_P_BenchmarkGreen__c = 20;
        secuProd.CRAS_ICA_ASS_P_BenchmarkYellow__c = 60;
        
        return secuProd;
    }
    
    
    public static List<FinServ__Securities__c> createSecurityProductList(List<FinServ__FinancialAccount__c> faLst){
        List<FinServ__Securities__c> securityProdLst = new List<FinServ__Securities__c> ();
        
        for (integer i=0; i<50; i++)
        {	
            FinServ__Securities__c securityProd = createSecurityProduct(i, faLst[i]);    
            securityProdLst.add(securityProd);
            
        }
        
        insert securityProdLst;
        return securityProdLst;
    }
    
    
    public static FinServ__Securities__c createSecurityGuarantee (Integer count, FinServ__FinancialAccount__c fa){
        CRAS_ICA_ASS_InsuranceGlobal_CS__c relCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        FinServ__Securities__c secuGuarantee = new FinServ__Securities__c();
        
        secuGuarantee.Name = 'ASSEGUR JUBILACIÓ ' + count;
        secuGuarantee.RecordTypeId = relCS.CRAS_ICA_ASS_SecurityGuarantee_RT__c;
        secuGuarantee.FinServ__SecuritiesName__c = fa.CRAS_ICA_ASS_T_ProductoPoliza__c;
        secuGuarantee.CRAS_ICA_ASS_T_AxisGuaranteeID__c = 1 + '' + count;
        secuGuarantee.CRAS_ICA_ASS_P_BenchmarkGreen__c = 20;
        secuGuarantee.CRAS_ICA_ASS_P_BenchmarkYellow__c = 60;
        secuGuarantee.CRAN_VEC_ADV_P_PFMMkt__c = '804102ASS';
        
        return secuGuarantee;
    }
    
    
    public static List<FinServ__Securities__c> createSecurityGuaranteeList(List<FinServ__FinancialAccount__c> faLst){
        List<FinServ__Securities__c> securityGuaLst = new List<FinServ__Securities__c> ();
        
        for (integer i=0; i<50; i++)
        {	
            FinServ__Securities__c securityGua = createSecurityGuarantee(i, faLst[i]);    
            securityGuaLst.add(securityGua);
            
        }
        
        insert securityGuaLst;
        return securityGuaLst;
    }
    
    private static void loadCustomSettings(){
        CRAS_ICA_ASS_CustomSettingsUtil_CLS.setSettings();
    }
    
    private static Campaign  createCampaign()
    {
        Campaign cpInsrt = new Campaign(Name = 'TestCampaign');
        
        insert cpInsrt;
        return cpInsrt;
    }
    
    private static UserRole createRole()
    {
        UserRole rolInsrt = new UserRole(DeveloperName = 'TestRoleSeguros', Name= 'TestRoleSeguros', ParentRoleId = null);
        
        insert rolInsrt;
        return rolInsrt;
    }
    
    @future(callout=true)
    private static void createTestUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CRAS Gestor Assegurances - Andorra'];
        UserRole r = createRole();
        
        User userTestInsrt = new User(
            Alias = 'standt', 
            Email='standarduser@testorg.com',                               
            EmailEncodingKey='ISO-8859-1',
            FirstName = 'Testing',
            LastName='Testing',
            LanguageLocaleKey='es', 
            LocaleSidKey='es_ES',
            UserRoleId = r.Id,
            ProfileId = p.Id,
            TimeZoneSidKey='Europe/Paris',
            CommunityNickname = 'testingUserCRAS',
            UserName='testingUserCRAS@testingUserCRAS.com');
        
        insert userTestInsrt;
    }

    private static void updateFAR()
    {
        List<Contact> cntc = [SELECT Id FROM Contact Limit 3];
        List<Finserv__FinancialAccountRole__c> far = [SELECT Id, FinServ__RelatedAccount__c From Finserv__FinancialAccountRole__c WHERE CRAS_ICA_ASS_T_AxisFARoleID__c != '' Limit 1];

        if(far.Size() > 0 && cntc.Size() > 2)
        {
            far[0].FinServ__RelatedContact__c = cntc[2].Id;
        }
        
        update far;
    }
    
    public static void testLoadData() {
        //Inicializar customSettings
        Test.startTest();
        createTestUser();
        Test.stopTest();
        
        userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        loadCustomSettings();
        
        //Crear lista de Contactos
        List<Contact> cntLst = createContactList();
        
        //Crear lista de BP Seguros
        List<Account> accLst = createAccountList();
        
        //Crear lista de Financial Account Seguros
        List<FinServ__FinancialAccount__c> faLst = createFAList(accLst);
        
        //Crear lista de Financial Account Role Tomador y Asegurado
        List<FinServ__FinancialAccountRole__c> farLst = createFARList(cntLst, faLst);
        
        //Crear Securities
        List<FinServ__Securities__c> secGuaLst = createSecurityGuaranteeList(faLst);
        List<FinServ__Securities__c> secProLst = createSecurityProductList(faLst);
        
        CRAS_ICA_ASS_RelatedLists_CS__c relCS = CRAS_ICA_ASS_RelatedLists_CS__c.getOrgDefaults();
        List<Contact> contctLst = [SELECT AccountId FROM Contact WHERE AccountId != ''];
         
        //Crear lista de Financial Holding Garantias/Productos
        createFHList(secGuaLst, secProLst, farLst);
        
        //Crear lista de Recibos
        createInvList(farLst);
        
        //Recuperar apenas los FAR de asegurados y crear lista de siniestros
        List<FinServ__FinancialAccountRole__c> insuredFAR = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE FinServ__Role__c = '102ASS']; 
        createClaimList(insuredFAR);
        
        //Crear lista de Historico de prima
        createFAPremHistList(faLst);
        
        Campaign cp = createCampaign();
        
        //Crear ventas y objetivos
        createOppObjectivesList(accLst, cp.Id);

        updateFAR();
    }
    
}