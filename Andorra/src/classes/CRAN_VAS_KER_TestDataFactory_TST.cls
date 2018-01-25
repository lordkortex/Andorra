/**
 * 
 * Fecha: Marzo 2017
 * @author  VASS
 * @version 1.0 
*/
@isTest
public class CRAN_VAS_KER_TestDataFactory_TST { 


    public Map<String, RecordType> mapRecordType;

    public static String Account_IndividualCA_Name = 'CRAN_VEC_ADV_Individual';
    public static String Account_BusinessCA_Name = 'CRAN_VEC_ADV_Business';
    public static String Account_BusinessPartner_Name = 'CRAN_VEC_ADV_Business_Partner';

    public static String Contact_IndividualCA_Name = 'CRAN_VEC_ADV_Individual';
    public static String Contact_BusinessCA_Name = 'CRAN_VEC_ADV_Business';

    public static String FAR_ContactRole_Name = 'ContactRole';
    public static String FA_Container_Name = 'CRAN_VEC_ADV_Container';

    public static String Opportunity_Sale_Name = 'CRAN_VAS_MAQ_Venta';
    public static String Opportunity_Obj_Marketing = 'CRAN_VAS_MAQ_Objetivo_Marqueting';
    public static String Opportunity_Obj_Sistematica = 'CRAN_VAS_MAQ_Objetivo_Sistematica';
    public static String Campaign_Sistematica_Name = 'CRAN_VAS_MAQ_SistComRecordType';
    public static String Campaign_Marketing_Name = 'CRAN_VAS_MAQ_MarquetingRecordType';
    
    private static final Map<String, Schema.SObjectType> GlobalDescribe = Schema.getGlobalDescribe();

    public static Profile perfilAdministrador = [   Select Id
            From Profile
            Where Name = 'Administrador del sistema' or Name = 'System Administrator']; //userProfile
    public static string defaultCountry = 'Spain'; //DefaultCountry
    public static string defaultState = 'Madrid'; //DefaultState

    /**
    * Recupera el Id de record type por defecto para el sObject que se pasa por parametro.
    *
    * @param sObject auxobject -
    *
    * @return ID - RecordTypeId por defecto
    */


    private static Map<Id, RecordType> recordTypeCache;
    static {
        recordTypeCache = new Map<Id, RecordType>([Select Id, DeveloperName from RecordType]);
    }

    public static Id recordTypeIdByDeveloperName(SObject auxObject, String recordTypeName) {
        List<Schema.RecordTypeInfo> recordTypes = auxObject.getSObjectType().getDescribe().getRecordTypeInfos();
        for (Schema.RecordTypeInfo recordType : recordTypes) {
            if (recordType.isAvailable() && recordTypeCache.containsKey(recordType.getRecordTypeId()) && recordTypeName == recordTypeCache.get(recordType.getRecordTypeId()).DeveloperName) {
                return recordType.getRecordTypeId();
            }
        }
        return null;
    }

    public static User updateUserDepartment(Id userId){
        User u = [Select Id, Department from User where Id = :userId];
        String dpt = 'Test deparment';
        u.Department = dpt;
        update u;
        return u;
    }
    
    public static Account createIndividualClient(){
        Account a = new Account();
        a.Name = 'Test Individual Cliente';
        a.RecordTypeId = recordTypeIdByDeveloperName(a,Account_IndividualCA_Name);
        insert a;
        return a;
    }
    

    
    public static Account createBP(){
        Account a = new Account();
        a.Name = 'Test BP';
        a.RecordTypeId = recordTypeIdByDeveloperName(a,Account_BusinessPartner_Name);
        insert a;
        return a;
    }    
    
    public static List<Campaign> createSistematicaMarketingCampaigns() {
        List<Campaign> cmps = new List<Campaign>();
        cmps.add(createMarketingCampaign());
        cmps.add(createSistematicaCampaign());
        insert cmps;
        return cmps;
    }
    
    public static Campaign createMarketingCampaign() {
        Campaign ca = new Campaign();
        ca.Name = 'Test Marketing Campaign';
        ca.IsActive = true;
        Date today = System.today();
        Date endDate = today.addYears(1);
        ca.StartDate = today;
        ca.EndDate = endDate;
        ca.Status = 'In Progress';
        ca.RecordTypeId = recordTypeIdByDeveloperName(ca,Campaign_Marketing_Name);
        return ca;
    }
    
    public static Campaign createSistematicaCampaign() {
        Campaign ca = new Campaign();
        ca.Name = 'Test Sistematica Campaign';
        ca.IsActive = true;
        Date today = System.today();
        Date endDate = today.addYears(1);
        ca.StartDate = today;
        ca.EndDate = endDate;
        ca.Status = 'In Progress';
        ca.RecordTypeId = recordTypeIdByDeveloperName(ca,Campaign_Sistematica_Name);
        return ca;
    }
    
    public static CampaignMember addCampaignMemberToCampaign(Id campaignId, Id contactId, Opportunity opp, String status){
        
        CampaignMember    cm                                             = new CampaignMember();
        cm.Status                                     = status;
        cm.ContactId                                 = contactId;
        cm.CampaignId                                 = campaignId;
        cm.CRAN_VAS_MAQ_Origen__c                    = CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_ORIGEN_NEW;
        cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c    = opp.OwnerId;
        cm.CRAN_VAS_MAQ_L_BP__c                     = opp.CRAN_VAS_MAQ_L_BP__c;
        
        insert cm;
        return cm;
    }
    
   public static CampaignMember addCampaignMemberToCampaign(Id campaignId, Id contactId, Id bpId, Id ownerId, String status) {
        
        CampaignMember    cm                         = new CampaignMember();
        cm.Status                                    = status;
        cm.ContactId                                 = contactId;
        cm.CampaignId                                = campaignId;
        cm.CRAN_VAS_MAQ_Origen__c                    = CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_ORIGEN_NEW;
        cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c    = ownerId;
        cm.CRAN_VAS_MAQ_L_BP__c                      = bpId;
        
        insert cm;
        return cm;
    }    
    
    public static Opportunity createMarketingGoal(String name, Id campaignId, Id accountId) {
        return createMarketingGoal (name,campaignId,accountId,true);
    }
	public static Opportunity createMarketingGoal(String name, Id campaignId, Id accountId,Boolean insertRecord) {
        Opportunity o = new Opportunity();
        o.Name = name;
        o.Amount = 100;
        o.CampaignId = campaignId;
        o.AccountId = accountId;
        o.StageName = 'Objetivo';
        Date closeDate = Date.today();
        closeDate.addDays(10);
        o.CloseDate = closeDate;
        o.RecordTypeId = recordTypeIdByDeveloperName(o,Opportunity_Obj_Marketing);
        o.OwnerId = UserInfo.getUserId();
        if(insertRecord){
	        insert o;            
        }

        return o;
    }
    public static Opportunity createMarketingDepartmentGoal(String name, Id campaignId, Id accountId) {

        return createMarketingDepartmentGoal(name,campaignId,accountId,true);
    }
    public static Opportunity createMarketingDepartmentGoal(String name, Id campaignId, Id accountId,Boolean insertRecord) {
        Opportunity o = new Opportunity();
        o.Name = name;
        o.Amount = 100;
        o.CampaignId = campaignId;
        o.AccountId = accountId;
        o.StageName = 'Objetivo';
        o.CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c = true;
        Date closeDate = Date.today();
        closeDate.addDays(10);
        o.CloseDate = closeDate;
        o.RecordTypeId = recordTypeIdByDeveloperName(o,Opportunity_Obj_Marketing);
        o.OwnerId = UserInfo.getUserId();
        if(insertRecord){
        	insert o;    
        }
        
        return o;
    }  
    public static Opportunity createSistematicaGoal(String name, Id campaignId, Id bpId, Id accountId) {
        return createSistematicaGoal (name,campaignId,bpId,accountId,true);
    }
    public static Opportunity createSistematicaGoal(String name, Id campaignId, Id bpId, Id accountId, Boolean insertRecord) {
        Opportunity o = new Opportunity();
        o.Name = name;
        o.Amount = 100;
        o.CampaignId = campaignId;
        o.AccountId = accountId;
        o.CRAN_VAS_MAQ_L_BP__c = bpId;
        o.StageName = 'Objetivo';
        Date closeDate = Date.today();
        closeDate.addDays(10);
        o.CloseDate = closeDate;
        o.RecordTypeId = recordTypeIdByDeveloperName(o,Opportunity_Obj_Sistematica);
        o.OwnerId = UserInfo.getUserId();
        if(insertRecord){
            insert o;
        }
        	
        return o;
    }
    public static Opportunity createMarketingSale (String name, Id campaignId, Id bpId, Id accountId, Id goalId) {
        Opportunity o = new Opportunity();
        o.Name = name;
        o.CRAN_VAS_MAQ_L_Objetivo_Asociado__c = goalId;        
        o.Amount = 100;
        o.CampaignId = campaignId;
        o.CRAN_VAS_MAQ_L_BP__c = bpId;
        o.AccountId = accountId;
        o.StageName = 'In Progress';
        Date closeDate = Date.today();
        closeDate.addDays(10);
        o.CloseDate = closeDate;
        o.RecordTypeId = recordTypeIdByDeveloperName(o,Opportunity_Sale_Name);
        o.OwnerId = UserInfo.getUserId();
        insert o;
        return o;
    }
    
    public static Opportunity createSistematicaSale (String name, Id campaignId, Id bpId, Id accountId, Id goalId) {
        return createSistematicaSale (name,campaignId,bpId,accountId,goalId,true);
    }
    
    public static Opportunity createSistematicaSale (String name, Id campaignId, Id bpId, Id accountId, Id goalId,boolean insertRecord) {
        Opportunity o = new Opportunity();
        o.Name = name;
        o.CRAN_VAS_MAQ_L_Objetivo_Asociado__c = goalId;
        o.Amount = 100;
        o.TotalOpportunityQuantity = 1;
        o.CampaignId = campaignId;
        o.CRAN_VAS_MAQ_L_BP__c = bpId;
        o.AccountId = accountId;
        o.StageName = 'In Progress';
        Date closeDate = Date.today();
        closeDate.addDays(10);
        o.CloseDate = closeDate;
        o.RecordTypeId = recordTypeIdByDeveloperName(o,Opportunity_Sale_Name);
        o.OwnerId = UserInfo.getUserId();
        
        if(insertRecord){
            insert o;
        }
            
        return o;
    }
    
    public static List<Contact> createIndividualContact() {
        
        List<Contact> toInsert = new List<Contact>();
        
        Contact c = new Contact();
        c.LastName = 'Test Individual CA';
        c.CRAN_VEC_ADV_P_PersonType__c = '120';
        c.CRAN_VEC_ADV_P_Bunit__c = '9';
        c.recordTypeId = recordTypeIdByDeveloperName(c, Contact_IndividualCA_Name);
        toInsert.add(c);
        
        Contact con = new Contact();
        con.LastName = 'Garcia';
        con.FirstName = 'Ramon Casas';
        con.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Contact','CRAN_VEC_ADV_Individual');
        con.OtherCountry = 'United States';
        con.OtherCountryCode = 'US';
        con.MailingStreet = 'Carrer Doctor Fàbregas';
        con.MailingCity = 'Tiana';
        con.MailingPostalCode = '08391';
        con.MailingCountry = 'Spain';
        con.MailingCountryCode = 'ES';
        con.Phone = '+343998787';
        con.MobilePhone = '+34678888888';
        con.Email = 'email@anon.ad';
        con.Title = 'Sr.';
        con.Birthdate = Date.valueOf('1975-10-01 00:00:00');
        con.CurrencyIsoCode = 'EUR';
        con.HasOptedOutOfFax = false;
        con.DoNotCall = false;
        con.FinServ__CountryOfBirth__c = 'United States';
        con.FinServ__CreatedFromLead__c = false;
        con.FinServ__Gender__c = 'Male';
        con.FinServ__PrimaryAddressIsBilling__c = false;
        con.FinServ__PrimaryAddressIsMailing__c = false;
        con.FinServ__PrimaryAddressIsOther__c = false;
        con.FinServ__PrimaryAddressIsShipping__c = false;
        con.FinServ__PrimaryLanguage__c = 'English';
        con.FinServ__SecondaryLanguage__c = 'English';
        con.FinServ__TaxId__c = '48873239L';
        con.CRAN_VEC_ADV_B_IsCondominium__c = false;
        con.CRAN_VEC_ADV_B_IsEmployee__c = false;
        con.CRAN_VEC_ADV_B_IsProspect__c = false;
        con.CRAN_VEC_ADV_B_Numbered__c = false;
        con.CRAN_VEC_ADV_D_AvOpenDate__c = Date.valueOf('1989-07-13 00:00:00');
        con.CRAN_VEC_ADV_MP_Nationalities__c = 'AD';
        con.CRAN_VEC_ADV_N_NumericSort__c = '1599760';
        con.CRAN_VEC_ADV_P_Bunit__c = '9';
        con.CRAN_VEC_ADV_P_EmpStatus__c = '7949';
        con.CRAN_VEC_ADV_P_IsPEP__c = '500554';
        con.CRAN_VEC_ADV_P_Language__c = 'ca';
        con.CRAN_VEC_ADV_P_LegalForm__c = '209';
        con.CRAN_VEC_ADV_P_MIFIDCLASS__c = '5810';
        con.CRAN_VEC_ADV_P_MaritalStatus__c = '101';
        con.CRAN_VEC_ADV_P_Nationality__c = 'AD';
        con.CRAN_VEC_ADV_P_OccupStatus__c = '7542';
        con.CRAN_VEC_ADV_P_PersonType__c = '120';
        con.CRAN_VEC_ADV_T_EBContract__c = '171154';
        con.CRAN_VEC_ADV_T_PersonId__c = '9_354472';
        con.CRAS_ICA_ASS_B_RRestri__c = false;
        con.CRAS_ICA_ASS_T_AxisPersonID__c = '00088663';
        toInsert.add(con);
        
        insert toInsert;
        
        return toInsert;
    }

    public static Contact createBusinessContact() {
        Contact c = new Contact();
        c.LastName = 'Test Business CA';
        c.CRAN_VEC_ADV_P_PersonType__c = '121';
        c.recordTypeId = recordTypeIdByDeveloperName(c, Contact_BusinessCA_Name);
        insert c;
        return c;
    }
    

    public Account createBusinessAccount() {
        Account a = new Account();
        a.Name = 'Test Business CA';
        a.recordTypeId = recordTypeIdByDeveloperName(a, Account_BusinessCA_Name);
        insert a;
        return a;
    }        

    public static List<Account> createBPAccounts(Id ownerId) {

        List<Account> toInsert = new List<Account>();
        
        Account acc = new Account();
        acc.Name = 'Ramon Casas Garcia ADVTST';
        acc.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Business_Partner');
        acc.BillingCountry = 'United States';
        acc.BillingCountryCode = 'US';
        acc.ShippingCountry = 'United States';
        acc.ShippingCountryCode = 'US';
        acc.AccountNumber = '7638667';
        acc.CurrencyIsoCode = 'EUR';
        acc.FinServ__ClientCategory__c = '508052';
        acc.FinServ__TotalAUMJointOwner__c = 0;
        acc.FinServ__TotalAUMPrimaryOwner__c = 0;
        acc.FinServ__TotalBankDepositsJointOwner__c = 0.00;
        acc.FinServ__TotalBankDepositsPrimaryOwner__c = 0.00;
        acc.FinServ__TotalInsuranceJointOwner__c = 0.00;
        acc.FinServ__TotalInsurancePrimaryOwner__c = 0.00;
        acc.FinServ__TotalInvestmentsJointOwner__c = 0.00;
        acc.FinServ__TotalInvestmentsPrimaryOwner__c = 0.00;
        acc.FinServ__TotalLiabilitiesJointOwner__c = 0.00;
        acc.FinServ__TotalLiabilitiesPrimaryOwner__c = 0.00;
        acc.FinServ__TotalNonfinancialAssetsJointOwner__c = 0.00;
        acc.FinServ__TotalNonfinancialAssetsPrimaryOwner__c = 0.00;
        acc.CRAN_VEC_ADV_B_AdvAccount__c = true;
        acc.CRAN_VEC_ADV_B_BigCliUnit__c = false;
        acc.CRAN_VEC_ADV_B_CliSBD__c = false;
        acc.CRAN_VEC_ADV_B_ContractSigned__c = false;
        acc.CRAN_VEC_ADV_B_Resident__c = true;
        acc.CRAN_VEC_ADV_B_ULK__c = false;
        acc.CRAN_VEC_ADV_D_Open__c = System.today();
        acc.CRAN_VEC_ADV_N_Number__c = '1180879';
        acc.CRAN_VEC_ADV_P_BPLegalForm__c = '209';
        acc.CRAN_VEC_ADV_P_BPPersonType__c = '1';
        acc.CRAN_VEC_ADV_P_BPType__c = '2';
        acc.CRAN_VEC_ADV_P_Bdivision__c = '6722';
        acc.CRAN_VEC_ADV_P_Branch__c = '6320';
        acc.CRAN_VEC_ADV_P_Bunit__c = '9';
        acc.CRAN_VEC_ADV_P_CliNature__c = '500450';
        acc.CRAN_VEC_ADV_P_Country__c = 'AD';
        acc.CRAN_VEC_ADV_P_CustType__c = '8270';
        acc.CRAN_VEC_ADV_P_DomRefm__c = 'AD';
        acc.CRAN_VEC_ADV_P_Language__c = 'es';
        acc.CRAN_VEC_ADV_P_MngBranch__c = '508796';
        acc.CRAN_VEC_ADV_P_NatCliSubt__c = '500455';
        acc.CRAN_VEC_ADV_P_ReportingCcy__c = 'EUR';
        acc.CRAN_VEC_ADV_P_TaxResid__c = 'AD';
        acc.CRAN_VEC_ADV_T_BPId__c = '9_7638667';
        acc.CRAN_VEC_ADV_T_FullName__c = 'Ramon Casas Garcia';
        acc.Cash_and_Money_FA__c = 0.00;
        acc.Loans_FA__c = 0.00;
        acc.Credit_Card_FA__c = 0.00;
        acc.OwnerId	= ownerId;
        toInsert.add(acc);
        
       
        Account acc2 = new Account();
        acc2.Name = 'Luisa T Mora ADVTST';
        acc2.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Business_Partner');
        acc2.BillingCountry = 'United States';
        acc2.BillingCountryCode = 'US';
        acc2.ShippingCountry = 'United States';
        acc2.ShippingCountryCode = 'US';
        acc2.AccountNumber = '7641413';
        acc2.CurrencyIsoCode = 'EUR';
        acc2.FinServ__ClientCategory__c = '508052';
        acc2.FinServ__TotalAUMJointOwner__c = 0;
        acc2.FinServ__TotalAUMPrimaryOwner__c = 0;
        acc2.FinServ__TotalBankDepositsJointOwner__c = 0.00;
        acc2.FinServ__TotalBankDepositsPrimaryOwner__c = 0.00;
        acc2.FinServ__TotalInsuranceJointOwner__c = 0.00;
        acc2.FinServ__TotalInsurancePrimaryOwner__c = 0.00;
        acc2.FinServ__TotalInvestmentsJointOwner__c = 0.00;
        acc2.FinServ__TotalInvestmentsPrimaryOwner__c = 0.00;
        acc2.FinServ__TotalLiabilitiesJointOwner__c = 0.00;
        acc2.FinServ__TotalLiabilitiesPrimaryOwner__c = 0.00;
        acc2.FinServ__TotalNonfinancialAssetsJointOwner__c = 0.00;
        acc2.FinServ__TotalNonfinancialAssetsPrimaryOwner__c = 0.00;
        acc2.CRAN_VEC_ADV_B_AdvAccount__c = true;
        acc2.CRAN_VEC_ADV_B_BigCliUnit__c = false;
        acc2.CRAN_VEC_ADV_B_CliSBD__c = false;
        acc2.CRAN_VEC_ADV_B_ContractSigned__c = true;
        acc2.CRAN_VEC_ADV_B_Resident__c = true;
        acc2.CRAN_VEC_ADV_B_ULK__c = false;
        acc2.CRAN_VEC_ADV_D_Open__c = System.today();
        acc2.CRAN_VEC_ADV_D_SignDate__c = System.today();
        acc2.CRAN_VEC_ADV_N_Number__c = '1180887';
        acc2.CRAN_VEC_ADV_P_BPLegalForm__c = '209';
        acc2.CRAN_VEC_ADV_P_BPPersonType__c = '1';
        acc2.CRAN_VEC_ADV_P_BPType__c = '2';
        acc2.CRAN_VEC_ADV_P_Bdivision__c = '6722';
        acc2.CRAN_VEC_ADV_P_Branch__c = '6320';
        acc2.CRAN_VEC_ADV_P_Bunit__c = '9';
        acc2.CRAN_VEC_ADV_P_CliNature__c = '500450';
        acc2.CRAN_VEC_ADV_P_Country__c = 'AD';
        acc2.CRAN_VEC_ADV_P_CustType__c = '8270';
        acc2.CRAN_VEC_ADV_P_DomRefm__c = 'AD';
        acc2.CRAN_VEC_ADV_P_Language__c = 'es';
        acc2.CRAN_VEC_ADV_P_MngBranch__c = '508796';
        acc2.CRAN_VEC_ADV_P_NatCliSubt__c = '500455';
        acc2.CRAN_VEC_ADV_P_ReportingCcy__c = 'EUR';
        acc2.CRAN_VEC_ADV_P_RiskProfile__c = '535010';
        acc2.CRAN_VEC_ADV_P_TaxResid__c = 'AD';
        acc2.CRAN_VEC_ADV_T_BPId__c = '9_7641413';
        acc2.Cash_and_Money_FA__c = 0.00;
        acc2.Loans_FA__c = 0.00;
        acc2.Credit_Card_FA__c = 0.00;
		acc2.OwnerId = ownerId;        
        toInsert.add(acc2);
        
        insert toInsert;
        return toInsert;
    }
    
    public static List<Account> createBPAccounts() {
        return createBPAccounts(UserInfo.getUserId());
    }
    
    public static Account createFsIndividualAccount(Id ownerId) {
        
        Account acc = new Account();
        acc.Name = 'Ramon Casas Garcia ADVTST';
        acc.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual');
        acc.BillingCountry = 'United States';
        acc.BillingCountryCode = 'US';
        acc.ShippingCountry = 'United States';
        acc.ShippingCountryCode = 'US';
        acc.CurrencyIsoCode = 'EUR';
        acc.CRAN_VEC_ADV_P_Language__c = 'en';
        /*No es un BP: utilizamos este campo para buscar el cliente en el test*/
        acc.CRAN_VEC_ADV_T_BPId__c = '9_998877';
        acc.FinServ__IndividualType__c = 'Individual';
        acc.FinServ__TotalAUMJointOwner__c = 0;
        acc.FinServ__TotalAUMPrimaryOwner__c = 0;
        acc.FinServ__TotalBankDepositsJointOwner__c = 0.00;
        acc.FinServ__TotalBankDepositsPrimaryOwner__c = 0.00;
        acc.FinServ__TotalInsuranceJointOwner__c = 0.00;
        acc.FinServ__TotalInsurancePrimaryOwner__c = 0.00;
        acc.FinServ__TotalInvestmentsJointOwner__c = 0.00;
        acc.FinServ__TotalInvestmentsPrimaryOwner__c = 0.00;
        acc.FinServ__TotalLiabilitiesJointOwner__c = 0.00;
        acc.FinServ__TotalLiabilitiesPrimaryOwner__c = 0.00;
        acc.FinServ__TotalNonfinancialAssetsJointOwner__c = 0.00;
        acc.FinServ__TotalNonfinancialAssetsPrimaryOwner__c = 0.00;
        acc.CRAN_VEC_ADV_B_AdvAccount__c = false;
        acc.CRAN_VEC_ADV_B_BigCliUnit__c = false;
        acc.CRAN_VEC_ADV_B_CliSBD__c = false;
        acc.CRAN_VEC_ADV_B_ContractSigned__c = false;
        acc.CRAN_VEC_ADV_B_Resident__c = false;
        acc.CRAN_VEC_ADV_B_ULK__c = false;
        acc.Cash_and_Money_BP__c = 0;
        acc.Loans_BP__c = 0;
        acc.Credit_Card_BP__c = 0;
        acc.OwnerId = ownerId;
        
        insert acc;
        
        acc.FinServ__PrimaryContact__c = [select Id from Contact where AccountId = :acc.Id].get(0).Id;
        update acc;
		        
        return acc;
    }
    
    public static Account createFsIndividualAccount() {
        return createFsIndividualAccount(UserInfo.getUserId());
    }
    
    public static List<FinServ__Securities__c> createFsSecurities() {
        
        List<FinServ__Securities__c> toInsert = new List<FinServ__Securities__c>();
        
        FinServ__Securities__c sec = new FinServ__Securities__c();        
        sec.Name = 'Compte corrent - EUR 32907';
        sec.CurrencyIsoCode = 'EUR';
        sec.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__Securities__c','CRAN_VEC_ADV_Advisory');
        sec.FinServ__SecuritiesName__c = 'Compte corrent - EUR 32907';
        sec.FinServ__SourceSystemId__c = '9_32907';
        sec.CRAN_VEC_ADV_N_CRANCode__c = '874951';
        sec.CRAN_VEC_ADV_P_AQAssetType__c = '1512';
        sec.CRAN_VEC_ADV_P_AssetCategory__c = '1';
        sec.CRAN_VEC_ADV_P_CashType__c = '13251';
        sec.CRAN_VEC_ADV_P_CatActivo__c = '504782';
        sec.CRAN_VEC_ADV_P_DenomCcy__c = 'EUR';
        sec.CRAN_VEC_ADV_P_InstrGroup__c = '8042';
        sec.CRAN_VEC_ADV_P_PFMMktCat__c = '504000';
        sec.CRAN_VEC_ADV_P_PFMMktClass__c = '504001';
        sec.CRAN_VEC_ADV_P_PFMMkt__c = '504002';
        sec.CRAN_VEC_ADV_P_RegulatedMkt__c = '202950';
        sec.CRAN_VEC_ADV_P_RiskCcy__c = 'EUR';
        sec.CRAN_VEC_ADV_P_YieldCcy__c = 'EUR';
        sec.CRAN_VEC_ADV_T_Abbreviation__c = '15.5';
        sec.CRAN_VEC_ADV_T_FullName__c = 'Current account - EUR';
        sec.CRAS_ICA_ASS_B_Activo__c = true;
        toInsert.add(sec);
        
        FinServ__Securities__c sec2 = new FinServ__Securities__c();  
        sec2.Name = 'Utilització de targetes - EUR 32947';
        sec2.CurrencyIsoCode = 'EUR';
        sec2.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__Securities__c','CRAN_VEC_ADV_Advisory');
        sec2.FinServ__SecuritiesName__c = 'Utilització de targetes - EUR 32947';
        sec2.FinServ__SourceSystemId__c = '6_32947';
        sec2.CRAN_VEC_ADV_N_CRANCode__c = '10177965';
        sec2.CRAN_VEC_ADV_P_AQAssetType__c = '1512';
        sec2.CRAN_VEC_ADV_P_AssetCategory__c = '1';
        sec2.CRAN_VEC_ADV_P_CashType__c = '13251';
        sec2.CRAN_VEC_ADV_P_CatActivo__c = '504787';
        sec2.CRAN_VEC_ADV_P_DenomCcy__c = 'EUR';
        sec2.CRAN_VEC_ADV_P_InstrGroup__c = '8042';
        sec2.CRAN_VEC_ADV_P_PFMMktCat__c = '504041';
        sec2.CRAN_VEC_ADV_P_PFMMktClass__c = '504042';
        sec2.CRAN_VEC_ADV_P_PFMMkt__c = '504043';
        sec2.CRAN_VEC_ADV_P_RegulatedMkt__c = '202950';
        sec2.CRAN_VEC_ADV_P_RiskCcy__c = 'EUR';
        sec2.CRAN_VEC_ADV_P_YieldCcy__c = 'EUR';
        sec2.CRAN_VEC_ADV_T_Abbreviation__c = 'MACC.CARD.EUR';
        sec2.CRAN_VEC_ADV_T_FullName__c = 'Card account - EUR';
        sec2.CRAS_ICA_ASS_B_Activo__c = true;
        toInsert.add(sec2);
        
        insert toInsert;
        return toInsert;
    }
    
    public static List<FinServ__FinancialAccount__c> createFsAccounts(List<Account> bpAccounts) {
        
        List<FinServ__FinancialAccount__c> toInsert = new List<FinServ__FinancialAccount__c>();
        
        FinServ__FinancialAccount__c fa = new FinServ__FinancialAccount__c();
        fa.Name = 'Adolphus F Orellana ADVTST';
        fa.CurrencyIsoCode = 'EUR';
        fa.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__FinancialAccount__c','CRAN_VEC_ADV_Container');
        fa.FinServ__AssetRebalance__c = false;
        fa.FinServ__AverageBalance__c = 0.00;
        fa.FinServ__Discretionary__c = false;
        fa.FinServ__FinancialAccountNumber__c = '1180879.101';
        fa.FinServ__HeldAway__c = false;
        fa.FinServ__Managed__c = false;
        fa.FinServ__MinimumBalance__c = 0.00;
        fa.FinServ__PaperlessDelivery__c = false;
        fa.FinServ__PrimaryOwner__c = bpAccounts[0].Id;
        fa.FinServ__OwnerType__c = bpAccounts[0].Id;
        fa.CRAN_VEC_ADV_B_USMktAccess__c = true;
        fa.CRAN_VEC_ADV_P_Bunit__c = '9';
        fa.CRAN_VEC_ADV_P_RefCcy__c = 'EUR';
        fa.CRAN_VEC_ADV_P_TypeProd__c = '7101';
        fa.CRAN_VEC_DEV_T_ContainerID__c = '9_7638668';
        toInsert.add(fa);
        
        FinServ__FinancialAccount__c fa2 = new FinServ__FinancialAccount__c();
        fa2.Name = 'Antígona T Mora ADVTST';
        fa2.CurrencyIsoCode = 'EUR';
        fa2.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__FinancialAccount__c','CRAN_VEC_ADV_Container');
        fa2.FinServ__AssetRebalance__c = false;
        fa2.FinServ__AverageBalance__c = 0.00;
        fa2.FinServ__Discretionary__c = false;
        fa2.FinServ__FinancialAccountNumber__c = '1180887.101';
        fa2.FinServ__HeldAway__c = false;
        fa2.FinServ__Managed__c = false;
        fa2.FinServ__MinimumBalance__c = 0.00;
        fa2.FinServ__PaperlessDelivery__c = false;
        fa2.FinServ__PrimaryOwner__c = bpAccounts[1].Id;
        fa2.FinServ__OwnerType__c = bpAccounts[1].Id;        
        fa2.CRAN_VEC_ADV_B_USMktAccess__c = true;
        fa2.CRAN_VEC_ADV_P_Bunit__c = '9';
        fa2.CRAN_VEC_ADV_P_RefCcy__c = 'EUR';
        fa2.CRAN_VEC_ADV_P_TypeProd__c = '7101';
        fa2.CRAN_VEC_DEV_T_ContainerID__c = '9_7641414'; 
        toInsert.add(fa2);
        
        insert toInsert;
        
        return toInsert;
    }
    
    public static List<FinServ__FinancialHolding__c> createFsAccountHoldings(List<Account> bpAccounts, List<FinServ__FinancialAccount__c> fas, List<FinServ__Securities__c> securities) {
        
        List<FinServ__FinancialHolding__c> toInsert = new List<FinServ__FinancialHolding__c>();
        
        FinServ__FinancialHolding__c fah = new FinServ__FinancialHolding__c();
        fah.Name = 'Cuenta corriente - EUR - AD0400031101118087 ADVTST';
        fah.CurrencyIsoCode = 'EUR';
        fah.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__FinancialHolding__c','CRAN_VEC_ADV_Position');
        fah.FinServ__FinancialAccount__c = fas[0].Id;
        fah.FinServ__PrimaryOwner__c = bpAccounts[0].Id;
        fah.FinServ__Securities__c = securities[0].Id;
        fah.FinServ__Shares__c = 80227.5800;
        fah.FinServ__SourceSystemId__c = '7638700';
        fah.CRAN_VEC_ADV_N_HistPrice__c = 1.0000;
        fah.CRAN_VEC_ADV_N_currValAsset__c = 80227.58;
        fah.CRAN_VEC_ADV_N_currValNoAccr__c = 80227.58;
        fah.CRAN_VEC_ADV_N_currVal__c = 80227.58;
        fah.CRAN_VEC_ADV_N_percAllocParent__c = 100.00;
        fah.CRAN_VEC_ADV_N_qtyHistPrice__c = 80227.58;
        fah.CRAN_VEC_ADV_P_PFMMktCat__c = '504000';
        fah.CRAN_VEC_ADV_P_PFMMktClass__c = '504001';
        fah.CRAN_VEC_ADV_P_PFMMkt__c = '504002';
        fah.CRAN_VEC_ADV_P_posCcy__c = 'EUR';
        fah.CRAN_VEC_ADV_T_Number__c = '7638700';
        fah.CRAN_VEC_ADV_T_PercVar__c = 0.00;
        toInsert.add(fah); 
        
        FinServ__FinancialHolding__c fah2 = new FinServ__FinancialHolding__c();
        fah2.Name = 'Utilizacion de tarjetas - EUR - Clau Visa Classic - Ramon Casas Garcia - ADVTST';
        fah2.CurrencyIsoCode = 'EUR';
        fah2.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__FinancialHolding__c','CRAN_VEC_ADV_Position');
        fah2.FinServ__FinancialAccount__c = fas[0].Id;
        fah2.FinServ__PrimaryOwner__c = bpAccounts[0].Id;
        fah2.FinServ__Securities__c = securities[1].Id;
        fah2.FinServ__Shares__c = 0.0000;
        fah2.FinServ__SourceSystemId__c = '7673462';
        fah2.CRAN_VEC_ADV_N_HistPrice__c = 1.0000;
        fah2.CRAN_VEC_ADV_N_currValAsset__c = 0.00;
        fah2.CRAN_VEC_ADV_N_currValNoAccr__c = 0.00;
        fah2.CRAN_VEC_ADV_N_currVal__c = 0.00;
        fah2.CRAN_VEC_ADV_N_qtyHistPrice__c = 0.00;
        fah2.CRAN_VEC_ADV_P_PFMMktCat__c = '504041';
        fah2.CRAN_VEC_ADV_P_PFMMktClass__c = '504042';
        fah2.CRAN_VEC_ADV_P_PFMMkt__c = '504043';
        fah2.CRAN_VEC_ADV_P_posCcy__c = 'EUR';
        fah2.CRAN_VEC_ADV_T_Number__c = '7673462';
        fah2.CRAN_VEC_ADV_T_PercVar__c = 0.00;        
        toInsert.add(fah2); 
        
        FinServ__FinancialHolding__c fah3 = new FinServ__FinancialHolding__c();
        fah3.Name = 'Cuenta corriente - EUR - AD6100031101118088 ADVTST';
        fah3.CurrencyIsoCode = 'EUR';
        fah3.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__FinancialHolding__c','CRAN_VEC_ADV_Position');
        fah3.FinServ__FinancialAccount__c = fas[1].Id;
        fah3.FinServ__PrimaryOwner__c = bpAccounts[1].Id;
        fah3.FinServ__Securities__c = securities[0].Id;
        fah3.FinServ__Shares__c = 652.9800;
        fah3.FinServ__SourceSystemId__c = '7641420';
        fah3.CRAN_VEC_ADV_N_HistPrice__c = 1.0000;
        fah3.CRAN_VEC_ADV_N_currValAsset__c = 652.98;
        fah3.CRAN_VEC_ADV_N_currValNoAccr__c = 652.98;
        fah3.CRAN_VEC_ADV_N_currVal__c = 652.98;
        fah3.CRAN_VEC_ADV_N_percAllocParent__c = 100.00;
        fah3.CRAN_VEC_ADV_N_qtyHistPrice__c = 652.98;
        fah3.CRAN_VEC_ADV_P_PFMMktCat__c = '504000';
        fah3.CRAN_VEC_ADV_P_PFMMktClass__c = '504001';
        fah3.CRAN_VEC_ADV_P_PFMMkt__c = '504002';
        fah3.CRAN_VEC_ADV_P_posCcy__c = 'EUR';
        fah3.CRAN_VEC_ADV_T_Number__c = '7641420';
        fah3.CRAN_VEC_ADV_T_PercVar__c = 0.00;
        toInsert.add(fah3);
        
        FinServ__FinancialHolding__c fah4 = new FinServ__FinancialHolding__c();
        fah4.Name = 'Utilizacion de tarjetas - EUR - Clau Visa Classic - Ramon Casas Garcia - ADVTST';
        fah4.CurrencyIsoCode = 'EUR';
        fah4.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__FinancialHolding__c','CRAN_VEC_ADV_Position');
        fah4.FinServ__FinancialAccount__c = fas[1].Id;
        fah4.FinServ__PrimaryOwner__c = bpAccounts[1].Id;
        fah4.FinServ__Securities__c = securities[1].Id;
        fah4.FinServ__Shares__c = 0.0000;
        fah4.FinServ__SourceSystemId__c = '7673473';
        fah4.CRAN_VEC_ADV_N_HistPrice__c = 1.0000;
        fah4.CRAN_VEC_ADV_N_currValAsset__c = 0.00;
        fah4.CRAN_VEC_ADV_N_currValNoAccr__c = 0.00;
        fah4.CRAN_VEC_ADV_N_currVal__c = 0.00;
        fah4.CRAN_VEC_ADV_N_qtyHistPrice__c = 0.00;
        fah4.CRAN_VEC_ADV_P_PFMMktCat__c = '504041';
        fah4.CRAN_VEC_ADV_P_PFMMktClass__c = '504042';
        fah4.CRAN_VEC_ADV_P_PFMMkt__c = '504043';
        fah4.CRAN_VEC_ADV_P_posCcy__c = 'EUR';
        fah4.CRAN_VEC_ADV_T_Number__c = '7673473';
        fah4.CRAN_VEC_ADV_T_PercVar__c = 0.00;
        toInsert.add(fah4);
        
        insert toInsert;
        
        return toInsert;
    }
    
    public static List<FinServ__FinancialAccountRole__c> createFsAccountRoles(List<FinServ__FinancialAccount__c> fas, Contact con) {

        List<FinServ__FinancialAccountRole__c> toInsert = new List<FinServ__FinancialAccountRole__c>();
     
        FinServ__FinancialAccountRole__c far = new FinServ__FinancialAccountRole__c();
        far.CurrencyIsoCode = 'EUR';
        far.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__FinancialAccountRole__c','ContactRole');
        far.FinServ__FinancialAccount__c = fas[0].Id;
        far.FinServ__Active__c = true;
        far.FinServ__Editable__c = true;
        far.FinServ__EndDate__c = Date.valueOf('4000-12-31 00:00:00');
        far.FinServ__RelatedAccount__c = fas[0].FinServ__PrimaryOwner__c;
        far.FinServ__RelatedContact__c = con.Id;
        far.FinServ__Role__c = '1';
        far.FinServ__SourceSystemId__c = '9_1119417';
        far.FinServ__StartDate__c = System.today();
        far.CRAN_VEC_ADV_P_Bunit__c = '9';
        far.CRAN_VEC_ADV_T_BPId__c = '9_7638667';
        far.CRAN_VEC_ADV_T_PersonId__c = '9_354472';
      
        toInsert.add(far);
        
        FinServ__FinancialAccountRole__c far2 = new FinServ__FinancialAccountRole__c();
        far2.CurrencyIsoCode = 'EUR';
        far2.RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('FinServ__FinancialAccountRole__c','ContactRole');
        far2.FinServ__FinancialAccount__c = fas[1].Id;
        far2.FinServ__Active__c = true;
        far2.FinServ__Editable__c = true;
        far2.FinServ__EndDate__c = Date.valueOf('4000-12-31 00:00:00');
        far2.FinServ__RelatedAccount__c = fas[1].FinServ__PrimaryOwner__c;
        far2.FinServ__RelatedContact__c = con.Id;
        far2.FinServ__Role__c = '1';
        far2.FinServ__SourceSystemId__c = '9_1119424';
        far2.FinServ__StartDate__c = System.today();
        far2.CRAN_VEC_ADV_P_Bunit__c = '9';
        far2.CRAN_VEC_ADV_T_BPId__c = '9_7641413';
        far2.CRAN_VEC_ADV_T_PersonId__c = '9_354472';        
        toInsert.add(far2);

        insert toInsert;
   
        return toInsert;
    }
    
    public static void createFsBaseDataAdvisory() {
        
        List<FinServ__Securities__c> securities = createFsSecurities();

        Account acc = createFsIndividualAccount();
        
        // 20170407 El campo Name esta encriptado, en su lugar utilizamos el PersonId
        Contact con = [SELECT Id, MobilePhone, AccountId FROM Contact WHERE AccountId =: acc.Id];
                con.MobilePhone = '34 555 222 222';
        		con.Email = 'test@test' + UserInfo.getUserId() + '.com';
        		con.CRAN_VEC_ADV_P_Language__c = 'en';
        
        acc.FinServ__PrimaryContact__c = con.Id;
        
        update con;
        update acc;
        
        List<Account>                       bpAccounts  = createBPAccounts();
        List<FinServ__FinancialAccount__c>  fas         = createFsAccounts(bpAccounts);

        createFsAccountRoles(fas,con);
      
        createFsAccountHoldings(bpAccounts, fas, securities);
         
        
    }
        
     public Account createBPAccount(){
        Account a = new Account();
        a.Name = 'Test Business Partner';
        a.CRAN_VEC_ADV_P_Branch__c = '6312';
        a.recordTypeId = recordTypeIdByDeveloperName(a,Account_BusinessPartner_Name);
        insert a;
        return a;
    }
    
    public static User createUser(Id roleId, String profile, String office, String userName, String alias, List<String> permissionSetDeveloperNames) {

        String			profileName = '%' + profile + '%';
        
        List<Profile> 	profiles = [SELECT Id FROM Profile WHERE Name LIKE :profileName]; 
        
        User user = new User(Alias = alias, Email='testing@creditandorra.vass.test', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profiles[0].Id, UserRoleId = roleId,
            TimeZoneSidKey='America/Los_Angeles', UserName= userName,
            Department = office,
            CRAN_ICA_KER_P_Oficina__c = '12');
        
        insert user;
        
        if (permissionSetDeveloperNames != null && !permissionSetDeveloperNames.isEmpty()) {
            List<PermissionSetAssignment> permissionSetAssigments = new List<PermissionSetAssignment>();
            for (PermissionSet permissionSet : [SELECT Id From PermissionSet WHERE Name =: permissionSetDeveloperNames]) {
                permissionSetAssigments.add(new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permissionSet.Id ));
            }
            
            insert permissionSetAssigments;
        }
        
        return user;
    }
    
    public static User createUser(Id roleId,String profile, String office, List<String> permissionSetDeveloperNames) {
        return createUser(roleId, profile, 'Oficina Escaldes', 'testingUser123456@creditandorra.vass.test', 'alitest', permissionSetDeveloperNames);
    }  
    
    public static User createDummyUser() {
        List<String> permissionSetDeveloperNames 	= new String[] { 'Admin_Marketing_Permission', 'Admin_Sistematica_Permission' };
        return createUser(null, 'Banking Director', 'Oficina Escaldes', 'testingdummy@creditandorra.vass.test', 'alidummy', permissionSetDeveloperNames);
    }
    
    public static UserRole createUserRole(String name, Id parentRoleId) {
        UserRole userRole = new UserRole( Name = name, DeveloperName = name.replaceAll(' +', ''), ParentRoleId = parentRoleId);
        insert userRole;
        return userRole;
    }
    
    public static User createDirector() {
        
        List<String> 	permissionSetDeveloperNames = new String[] { 'Admin_Marketing_Permission', 'Admin_Sistematica_Permission' };
		UserRole 		directorRole 				= CRAN_VAS_KER_TestDataFactory_TST.createUserRole('Director Global', null);
       
        return CRAN_VAS_KER_TestDataFactory_TST.createUser(directorRole.Id, 'Director', null, 
                                                           'directorCpProvider@creditandorra.vass.test',
                                                           'dirAlias',
                                                           permissionSetDeveloperNames);       
    }
    
    public static User createAdvisor(Id directorRoleId) {
        
        List<String> 	permissionSetDeveloperNames = new String[] { 'Admin_Marketing_Permission', 'Admin_Sistematica_Permission' };
        UserRole 		advisorRole 				= CRAN_VAS_KER_TestDataFactory_TST.createUserRole('Gestor Canillo', directorRoleId);
        
        return CRAN_VAS_KER_TestDataFactory_TST.createUser(advisorRole.Id,'Banking Manager', null,
                                                           permissionSetDeveloperNames); 	        
    }
    
    public static void createCampaignInfluence(Id campaignId, Id opportunityId, Id contactId){
        	CampaignInfluenceModel cim = [SELECT Id FROM CampaignInfluenceModel where IsDefaultModel = true];
            
            
            CampaignInfluence ci = new CampaignInfluence();
            
            ci.CampaignId=campaignId;
            ci.ContactId=contactId;
            ci.Influence=100;
            ci.OpportunityId=opportunityId;
            ci.ModelId=cim.Id;           	
            
            insert ci;
    }
    
}