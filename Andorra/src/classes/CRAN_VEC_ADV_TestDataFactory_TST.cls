/**
 * Esta clase proporciona unas funciones para generar los datos para las clases de test
 *
 * Fecha: 17/10/2016
 * @author  Cloud Coachers (Iñaki Hernando Urcullu - inakihu@gmail.com)
 * @version 1.1
 * @FIX Advisory Test execution for non 'Administra' profiles
 *
 * F - Finacial Service;
 * FA - Finacial Account;
 * FAR - Finacial AccountRole;
*/
public class CRAN_VEC_ADV_TestDataFactory_TST {

    public Map<String, RecordType> mapRecordType;

    public static String Account_IndividualCA_Name = 'CRAN_VEC_ADV_Individual';
    public static String Account_BusinessCA_Name = 'CRAN_VEC_ADV_Business';
    public static String Account_BusinessPartner_Name = 'CRAN_VEC_ADV_Business_Partner';

    public static String Contact_IndividualCA_Name = 'CRAN_VEC_ADV_Individual';
    public static String Contact_BusinessCA_Name = 'CRAN_VEC_ADV_Business';

    public static String FAR_ContactRole_Name = 'ContactRole';
    public static String FA_Container_Name = 'CRAN_VEC_ADV_Container';

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


    // debria llamarse recordTypeIdByName
    public ID recordTypeIdByDeveloperName(SObject auxObject, String recordTypeName) {
        List<Schema.RecordTypeInfo> recordTypes = auxObject.getSObjectType().getDescribe().getRecordTypeInfos();
        for (Schema.RecordTypeInfo recordType : recordTypes) {
            if (recordType.isAvailable() && recordTypeCache.containsKey(recordType.getRecordTypeId()) && recordTypeName == recordTypeCache.get(recordType.getRecordTypeId()).DeveloperName) {
                return recordType.getRecordTypeId();
            }
        }
        return null;
    }

    public Contact createIndividualContact() {
        Contact c = new Contact();
        c.LastName = 'Test Individual CA';
        c.CRAN_VEC_ADV_P_PersonType__c = '120';
        c.CRAN_VEC_ADV_P_Bunit__c = '9';
        c.recordTypeId = recordTypeIdByDeveloperName(c, Contact_IndividualCA_Name);
        insert c;
        return c;
    }

    public Contact createBusinessContact() {
        Contact c = new Contact();
        c.LastName = 'Test Business CA';
        c.CRAN_VEC_ADV_P_PersonType__c = '121';
        c.recordTypeId = recordTypeIdByDeveloperName(c, Contact_BusinessCA_Name);
        insert c;
        return c;
    }

    public Account createBPAccount() {

        Account a = new Account();
        a.Name = 'Test Business Partner';
        a.CRAN_VEC_ADV_T_BPId__c = '9_9000001';
        a.CRAN_VEC_ADV_P_Bunit__c = '9';
        a.recordTypeId = recordTypeIdByDeveloperName(a, Account_BusinessPartner_Name);
        insert a;
        return a;
    }

    public Account createBusinessAccount() {
        Account a = new Account();
        a.Name = 'Test Business CA';
        a.recordTypeId = recordTypeIdByDeveloperName(a, Account_BusinessCA_Name);
        insert a;
        return a;
    }

    public FinServ__FinancialAccountRole__c createFS_FinancialAccountRole(FinServ__FinancialAccount__c fa, Contact c) {
        FinServ__FinancialAccountRole__c fsr = new FinServ__FinancialAccountRole__c();
        fsr.FinServ__RelatedContact__c = c.Id;
        fsr.FinServ__FinancialAccount__c = fa.Id;
        fsr.FinServ__Role__c = '1';  // Account Owner
        fsr.FinServ__StartDate__c = Date.today().addDays(-30);
        fsr.FinServ__SourceSystemId__c = '' + String.valueOf(Integer.valueOf(Math.random()*100000));
        fsr.RecordTypeId = recordTypeIdByDeveloperName(fsr, FAR_ContactRole_Name);
        insert fsr;
        return fsr;
    }

    public FinServ__FinancialAccountRole__c createFS_FinancialAccountRoleNullContainer(FinServ__FinancialAccount__c fa, Contact c, Account bp) {
        //Container related null for testing FinServ__FinancialAccountRole__c Trigger
        FinServ__FinancialAccountRole__c fsr = new FinServ__FinancialAccountRole__c();
        fsr.FinServ__RelatedAccount__c = bp.Id;
        fsr.FinServ__RelatedContact__c = c.Id;
        fsr.CRAN_VEC_ADV_T_PersonId__c = '9_9000001';
        fsr.CRAN_VEC_ADV_T_BPId__c = '9_9000001';
        fsr.FinServ__SourceSystemId__c = '' + String.valueOf(Integer.valueOf(Math.random()*100000));
        fsr.FinServ__Role__c = '1';  // Account Owner
        fsr.FinServ__StartDate__c = Date.today().addDays(-30);
        fsr.FinServ__Active__c = true;
        fsr.FinServ__Editable__c = true;
        fsr.RecordTypeId = recordTypeIdByDeveloperName(fsr, FAR_ContactRole_Name);
        
        //fsr.FinServ__FinancialAccount__c = fa.Id;
        insert fsr;
        return fsr;
    }

    public FinServ__FinancialAccountRole__c createFS_FinancialAccountRoleNullContainer(Contact c, Account bp) {
        FinServ__FinancialAccountRole__c fsr = new FinServ__FinancialAccountRole__c();
        fsr.FinServ__RelatedAccount__c = bp.Id;
        fsr.FinServ__RelatedContact__c = c.Id;
        fsr.CRAN_VEC_ADV_T_PersonId__c = '9_9000001';
        fsr.CRAN_VEC_ADV_T_BPId__c = '9_9000021';
        fsr.FinServ__SourceSystemId__c = '' + String.valueOf(Integer.valueOf(Math.random()*100000));
        fsr.FinServ__Role__c = '1';  // Account Owner
        fsr.FinServ__StartDate__c = Date.today().addDays(-30);
        fsr.FinServ__Active__c = true;
        fsr.FinServ__Editable__c = true;
        fsr.RecordTypeId = recordTypeIdByDeveloperName(fsr, FAR_ContactRole_Name);
        System.debug(Logginglevel.WARN, '##### fsr: ' + fsr);
        insert fsr;
        return fsr;
    }

    public FinServ__FinancialAccount__c createFS_FinancialAccount(Account a) {
        FinServ__FinancialAccount__c fa = new FinServ__FinancialAccount__c();
        fa.Name = 'Test Finacial Account';
        fa.CRAN_VEC_ADV_P_Bunit__c = '9';
        fa.CRAN_VEC_DEV_T_ContainerID__c = '9_8000001';
        fa.RecordTypeId = recordTypeIdByDeveloperName(fa, FA_Container_Name);
        fa.FinServ__PrimaryOwner__c = a.Id;
        insert fa;
        return fa;
    }

    public Contact createIndividualContactWithTwoBps() {
        System.debug('INIT createIndividualContactWithTwoBps');
        Contact c = createIndividualContact();
        Account bp1 = createBPAccount();
        Account bp2 = createBPAccount();
        FinServ__FinancialAccount__c fa1 = createFS_FinancialAccount(bp1);
        FinServ__FinancialAccount__c fa2 = createFS_FinancialAccount(bp2);
        FinServ__FinancialAccountRole__c far1 = createFS_FinancialAccountRole(fa1, c);
        FinServ__FinancialAccountRole__c far2 = createFS_FinancialAccountRole(fa2, c);
        return c;
    }

    public Contact createBusinessContactWithTwoBpsNullContainers() {
        Contact c = createBusinessContact();
        Account bp1 = createBPAccount();
        Account bp2 = createBPAccount();
        FinServ__FinancialAccount__c fa1 = createFS_FinancialAccount(bp1);
        FinServ__FinancialAccount__c fa2 = createFS_FinancialAccount(bp2);
        FinServ__FinancialAccountRole__c far1 = createFS_FinancialAccountRoleNullContainer(fa1, c, bp1);
        FinServ__FinancialAccountRole__c far2 = createFS_FinancialAccountRoleNullContainer(fa2, c, bp2);
        return c;
    }

    public Contact createTwoBusinessContactWithOneBpAndTwoFA() {
        Contact c = createBusinessContact();
        Contact c2 = createBusinessContact();
        Account bp1 = createBPAccount();
        FinServ__FinancialAccount__c fa1 = createFS_FinancialAccount(bp1);
        FinServ__FinancialAccount__c fa2 = createFS_FinancialAccount(bp1);
        System.debug(Logginglevel.WARN, '##### ' + bp1);
        FinServ__FinancialAccountRole__c far1 = createFS_FinancialAccountRoleNullContainer(fa1, c, bp1);
        FinServ__FinancialAccountRole__c far2 = createFS_FinancialAccountRoleNullContainer(fa1, c2, bp1);
        return c;
    }

    public CRAN_VEC_ADV_CustomForm__c create_CustomForm_TemplatePF() {

        CRAN_VEC_ADV_CustomForm__c cf = new CRAN_VEC_ADV_CustomForm__c();
        cf.CRAN_VEC_ADV_B_Enable__c = true;
        cf.CRAN_VEC_ADV_N_Version__c = 1;
        cf.CRAN_VEC_ADV_P_PersonType__c = '120';
        cf.CRAN_VEC_ADV_P_Type__c = 'mdb$mifid';
        cf.CRAN_VEC_ADV_T_Metadata_Types_ID__c = 'CRAN_VEC_ADV_CF_SUIV2PF';
        insert cf;

        List<CRAN_VEC_ADV_CustomForm_Section__c> lstSections = new List<CRAN_VEC_ADV_CustomForm_Section__c>();
        lstSections.add(new CRAN_VEC_ADV_CustomForm_Section__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1',
                        CRAN_VEC_ADV_MD_CustomForm__c = cf.Id,
                        CRAN_VEC_ADV_N_Order__c = 1));
        lstSections.add(new CRAN_VEC_ADV_CustomForm_Section__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g2',
                        CRAN_VEC_ADV_MD_CustomForm__c = cf.Id,
                        CRAN_VEC_ADV_N_Order__c = 2));
        lstSections.add(new CRAN_VEC_ADV_CustomForm_Section__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g3',
                        CRAN_VEC_ADV_MD_CustomForm__c = cf.Id,
                        CRAN_VEC_ADV_N_Order__c = 3));

        insert lstSections;

        List<CRAN_VEC_ADV_CustomForm_Question__c> lstQuestionsSection = new List<CRAN_VEC_ADV_CustomForm_Question__c>();
        lstQuestionsSection.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g0_q0',
                                CRAN_VEC_ADV_L_Question_Father__c = null,
                                CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                CRAN_VEC_ADV_N_Order__c = 1,
                                CRAN_VEC_ADV_P_AnswerType__c = 'Number',
                                CRAN_VEC_ADV_P_Child_Type__c = ''
                                                                       ));
        lstQuestionsSection.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q1',
                                CRAN_VEC_ADV_L_Question_Father__c = null,
                                CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                CRAN_VEC_ADV_N_Order__c = 2,
                                CRAN_VEC_ADV_P_AnswerType__c = 'Picklist',
                                CRAN_VEC_ADV_P_Child_Type__c = ''
                                                                       ));
        lstQuestionsSection.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q2',
                                CRAN_VEC_ADV_L_Question_Father__c = null,
                                CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                CRAN_VEC_ADV_N_Order__c = 3,
                                CRAN_VEC_ADV_P_AnswerType__c = 'Multipicklist',
                                CRAN_VEC_ADV_P_Child_Type__c = ''
                                                                       ));
        lstQuestionsSection.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q4',
                                CRAN_VEC_ADV_L_Question_Father__c = null,
                                CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                CRAN_VEC_ADV_N_Order__c = 4,
                                CRAN_VEC_ADV_P_AnswerType__c = 'Matrix',
                                CRAN_VEC_ADV_P_Child_Type__c = ''
                                                                       ));
        insert lstQuestionsSection;

        List<CRAN_VEC_ADV_CustomForm_Question__c> lstQuestionsMatrixChild = new List<CRAN_VEC_ADV_CustomForm_Question__c>();

        lstQuestionsMatrixChild.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q4_c2',
                                    CRAN_VEC_ADV_L_Question_Father__c = lstQuestionsSection[3].Id,
                                    CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                    CRAN_VEC_ADV_N_Order__c = 1,
                                    CRAN_VEC_ADV_P_AnswerType__c = 'Column',
                                    CRAN_VEC_ADV_P_Child_Type__c = 'Picklist'
                                                                           ));

        lstQuestionsMatrixChild.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q4_c3',
                                    CRAN_VEC_ADV_L_Question_Father__c = lstQuestionsSection[3].Id,
                                    CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                    CRAN_VEC_ADV_N_Order__c = 2,
                                    CRAN_VEC_ADV_P_AnswerType__c = 'Column',
                                    CRAN_VEC_ADV_P_Child_Type__c = 'Text'
                                                                           ));

        lstQuestionsMatrixChild.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q4_r1',
                                    CRAN_VEC_ADV_L_Question_Father__c = lstQuestionsSection[3].Id,
                                    CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                    CRAN_VEC_ADV_N_Order__c = 1,
                                    CRAN_VEC_ADV_P_AnswerType__c = 'Row',
                                    CRAN_VEC_ADV_P_Child_Type__c = ''
                                                                           ));

        lstQuestionsMatrixChild.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q4_r2',
                                    CRAN_VEC_ADV_L_Question_Father__c = lstQuestionsSection[3].Id,
                                    CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                    CRAN_VEC_ADV_N_Order__c = 2,
                                    CRAN_VEC_ADV_P_AnswerType__c = 'Row',
                                    CRAN_VEC_ADV_P_Child_Type__c = ''
                                                                           ));
        lstQuestionsMatrixChild.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q4_r2',
                                    CRAN_VEC_ADV_L_Question_Father__c = lstQuestionsSection[3].Id,
                                    CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                    CRAN_VEC_ADV_N_Order__c = 3,
                                    CRAN_VEC_ADV_P_AnswerType__c = 'Row',
                                    CRAN_VEC_ADV_P_Child_Type__c = ''
                                                                           ));
        lstQuestionsMatrixChild.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q4_r2',
                                    CRAN_VEC_ADV_L_Question_Father__c = lstQuestionsSection[3].Id,
                                    CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                    CRAN_VEC_ADV_N_Order__c = 4,
                                    CRAN_VEC_ADV_P_AnswerType__c = 'Row',
                                    CRAN_VEC_ADV_P_Child_Type__c = ''
                                                                           ));
        lstQuestionsMatrixChild.add(new CRAN_VEC_ADV_CustomForm_Question__c(Name = 'CRAN_VEC_ADV_CF_SUIV2PF_g1_q4_r2',
                                    CRAN_VEC_ADV_L_Question_Father__c = lstQuestionsSection[3].Id,
                                    CRAN_VEC_ADV_MD_Section__c = lstSections[0].Id,
                                    CRAN_VEC_ADV_N_Order__c = 5,
                                    CRAN_VEC_ADV_P_AnswerType__c = 'Row',
                                    CRAN_VEC_ADV_P_Child_Type__c = ''
                                                                           ));

        insert lstQuestionsMatrixChild;
        return cf;
    }


    /** Utilidades para la creación de registros***/

    public CRAN_VEC_ADV_CustomForm_Response__c addCustomFormResponse(String templateId, String contactId) {

        CRAN_VEC_ADV_CustomForm_Response__c pSuitableTestRespond = new CRAN_VEC_ADV_CustomForm_Response__c();
        //INSERT NEW FORMULARIO CON EL CLIENTE
        pSuitableTestRespond.CRAN_VEC_ADV_MD_CustomForm__c = templateId;
        pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__c = contactId;

        pSuitableTestRespond.CRAN_VEC_ADV_DT_StartDate__c = Datetime.now();
        insert pSuitableTestRespond;

        //RECUPERA ESTRUCTURA DEL TEMPLATE
        List<CRAN_VEC_ADV_CustomForm_Section__c> lstSuitableAnswer = [SELECT
                Id,
                Name,
                CRAN_VEC_ADV_N_Order__c,
                CRAN_VEC_ADV_MD_CustomForm__c,
                (SELECT
                 Id,
                 Name,
                 CRAN_VEC_ADV_N_Order__c,
                 CRAN_VEC_ADV_P_AnswerType__c,
                 CRAN_VEC_ADV_MD_Section__c
                 FROM CRAN_VEC_ADV_Questions__r
                 WHERE   CRAN_VEC_ADV_P_AnswerType__c != 'Row' AND
                 CRAN_VEC_ADV_P_AnswerType__c != 'Column'
                 ORDER BY CRAN_VEC_ADV_N_Order__c)
                FROM CRAN_VEC_ADV_CustomForm_Section__c
                WHERE CRAN_VEC_ADV_MD_CustomForm__c = :pSuitableTestRespond.CRAN_VEC_ADV_MD_CustomForm__c
                        ORDER BY CRAN_VEC_ADV_N_Order__c];
        //CREAMOS NUEVO FORMULARIO

        List<CRAN_VEC_ADV_CustomForm_Answer__c> lstAnswers = new List<CRAN_VEC_ADV_CustomForm_Answer__c>();
        for (CRAN_VEC_ADV_CustomForm_Section__c section : lstSuitableAnswer) {
            for (CRAN_VEC_ADV_CustomForm_Question__c q : section.CRAN_VEC_ADV_Questions__r) {
                CRAN_VEC_ADV_CustomForm_Answer__c emptyAnswer = new CRAN_VEC_ADV_CustomForm_Answer__c();
                emptyAnswer.CRAN_VEC_ADV_MD_Question__c = q.Id;
                emptyAnswer.CRAN_VEC_ADV_MD_Question__r = q;
                //Asignar a Answer el id del formulario al que pertenece
                emptyAnswer.CRAN_VEC_ADV_MD_CustomFormResponse__c = pSuitableTestRespond.Id;
                CRAN_VEC_ADV_CustomForm_Wrapper answerW = new CRAN_VEC_ADV_CustomForm_Wrapper(q, emptyAnswer);
                lstAnswers.add(emptyAnswer);
            }
        }
        //INSERT ANSWERS NUEVAS AL FORMULARIO
        insert lstAnswers;
        return pSuitableTestRespond;
    }


    public CRAN_VEC_ADV_CustomForm_Response__c addCustomFormResponseBatch(String templateId, String contactId) {

        CRAN_VEC_ADV_CustomForm_Response__c pSuitableTestRespond = new CRAN_VEC_ADV_CustomForm_Response__c();
        //INSERT NEW FORMULARIO CON EL CLIENTE
        pSuitableTestRespond.CRAN_VEC_ADV_MD_CustomForm__c = templateId;
        pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__c = contactId;
        pSuitableTestRespond.CRAN_VEC_ADV_T_Avaloq_ID__c = '9_34534';
        pSuitableTestRespond.CRAN_VEC_ADV_T_Bu_Id__c = '9';
        pSuitableTestRespond.CRAN_VEC_ADV_T_Avaloq_External_Id__c = '34534';
        pSuitableTestRespond.CRAN_VEC_ADV_DT_StartDate__c = Datetime.now();
        insert pSuitableTestRespond;

        return pSuitableTestRespond;
    }


    public  void createAvaloqSetting() {
        CRAN_VEC_ADV_AvaloqSettings__c aCS = new CRAN_VEC_ADV_AvaloqSettings__c();
        aCS.CRAN_VEC_ADV_T_AlgorithmName__c = 'AES256';
        aCS.CRAN_VEC_ADV_DatapowerEncrypted__c = 'https://test.herokuapp.com';
        aCS.CRAN_VEC_ADV_T_PrivateKey__c = 'SSvO0bmA0Xk62lgfhMzaHjb5Ng4a4cbp';
        aCS.CRAN_VEC_ADV_T_TimeOut__c = 10000.0;
        aCS.CRAN_VEC_ADV_B_Debug__c = true;
        aCS.CRAN_VEC_ADV_B_MockServices__c = false;
        aCS.SetupOwnerId = UserInfo.getOrganizationId();
        insert aCS;
    }

    public  void createAvaloqSettingMockTrue() {
        CRAN_VEC_ADV_AvaloqSettings__c aCS = new CRAN_VEC_ADV_AvaloqSettings__c();
        aCS.CRAN_VEC_ADV_T_AlgorithmName__c = 'AES256';
        aCS.CRAN_VEC_ADV_DatapowerEncrypted__c = 'https://test.herokuapp.com';
        aCS.CRAN_VEC_ADV_T_PrivateKey__c = 'SSvO0bmA0Xk62lgfhMzaHjb5Ng4a4cbp';
        aCS.CRAN_VEC_ADV_T_TimeOut__c = 10000.0;
        aCS.CRAN_VEC_ADV_B_Debug__c = true;
        aCS.CRAN_VEC_ADV_B_MockServices__c = true;
        aCS.CRAN_VEC_ADV_MockServiceList__c = 'SfQuestList;SfNewQuest;SfPortfolio;SfDiscdProf;SfModQuest;SfVfyProf;SfDiscdRebalpReq;SfNewRebalpReq;SfSignRebalpReq;SfReGenRebalp;SfRebalpDetReq;SfCloseRebalpReq;SfCalcRebalpReq;SfSignContrReq;SfRebalpList;SfOmsPrint;SfWaitSign;SfExecReq;SfRebalpDet3;';
        aCS.SetupOwnerId = UserInfo.getOrganizationId();
        insert aCS;
    }

    public  void createAvaloqSettingMockTrueExec() {
        CRAN_VEC_ADV_AvaloqSettings__c aCS = new CRAN_VEC_ADV_AvaloqSettings__c();
        aCS.CRAN_VEC_ADV_T_AlgorithmName__c = 'AES256';
        aCS.CRAN_VEC_ADV_DatapowerEncrypted__c = 'https://test.herokuapp.com';
        aCS.CRAN_VEC_ADV_T_PrivateKey__c = 'SSvO0bmA0Xk62lgfhMzaHjb5Ng4a4cbp';
        aCS.CRAN_VEC_ADV_T_TimeOut__c = 10000.0;
        aCS.CRAN_VEC_ADV_B_Debug__c = true;
        aCS.CRAN_VEC_ADV_B_MockServices__c = true;
        aCS.CRAN_VEC_ADV_MockServiceList__c = 'SfQuestList;SfNewQuest;SfPortfolio;SfDiscdProf;SfExecReq;SfRebalpDet2;SfExecRebalp;/service1/avaloqService/confirmOrders;fOmsListPrint;SfOmsPrint;/service1/avaloqService/discardOrders;SfSignRebalp2;SfOmsListPrint;/service1/avaloqService/manualExec';
        aCS.SetupOwnerId = UserInfo.getOrganizationId();
        insert aCS;
    }

    public  void createAvaloqSettingEncrypted() {
        CRAN_VEC_ADV_AvaloqSettings__c aCS = new CRAN_VEC_ADV_AvaloqSettings__c();
        aCS.CRAN_VEC_ADV_T_AlgorithmName__c = 'AES256';
        aCS.CRAN_VEC_ADV_DatapowerEncrypted__c = 'https://test.herokuapp.com';
        aCS.CRAN_VEC_ADV_T_PrivateKey__c = 'SSvO0bmA0Xk62lgfhMzaHjb5Ng4a4cbp';
        aCS.CRAN_VEC_ADV_T_TimeOut__c = 10000.0;
        aCS.CRAN_VEC_ADV_B_Debug__c = true;
        aCS.CRAN_VEC_ADV_B_MockServices__c = false;
        aCS.SetupOwnerId = UserInfo.getOrganizationId();
        insert aCS;
    }

    public  void createOrdersManualConfirm() {
        CRAN_VEC_ADV_OrdersManualConfirm__c aCS = new CRAN_VEC_ADV_OrdersManualConfirm__c();
        aCS.CATACTIVO__c = '504783';
        aCS.INSTRGROUP__c = '';
        aCS.FOREX__c = true;
        aCS.STEX__c = false;
        aCS.SetupOwnerId = UserInfo.getOrganizationId();
        insert aCS;
    }

    public  void createOrdersManualConfirm8034() {
        CRAN_VEC_ADV_OrdersManualConfirm__c aCS = new CRAN_VEC_ADV_OrdersManualConfirm__c();
        aCS.CATACTIVO__c = '504783';
        aCS.INSTRGROUP__c = '';
        aCS.FOREX__c = true;
        aCS.STEX__c = false;
        aCS.INSTRGROUPUNMARK__c = '8034';
        aCS.SetupOwnerId = UserInfo.getOrganizationId();
        insert aCS;
    }


    public  void createOrdersManualConfirmInstr() {
        CRAN_VEC_ADV_OrdersManualConfirm__c aCS = new CRAN_VEC_ADV_OrdersManualConfirm__c();
        aCS.CATACTIVO__c = '';
        aCS.INSTRGROUP__c = '7789';
        aCS.FOREX__c = true;
        aCS.STEX__c = false;
        aCS.SetupOwnerId = UserInfo.getOrganizationId();
        insert aCS;
    }

    public  void createOrdersManualConfirmStex() {
        CRAN_VEC_ADV_OrdersManualConfirm__c aCS = new CRAN_VEC_ADV_OrdersManualConfirm__c();
        aCS.CATACTIVO__c = '';
        aCS.INSTRGROUP__c = '';
        aCS.FOREX__c = true;
        aCS.STEX__c = true;
        aCS.SetupOwnerId = UserInfo.getOrganizationId();
        insert aCS;
    }

    public void createSetting_AvaloqOppInvestProposal() {
        CRAN_VEC_ADV_AvaloqOppInvestProposal__c ipCS = new CRAN_VEC_ADV_AvaloqOppInvestProposal__c();
        ipCS.CRAN_VEC_ADV_N_Days_from__c = 365;
        ipCS.CRAN_VEC_ADV_T_Proposal_status_codes__c = '50;90';
        insert ipCS;
    }

    public List<FinServ__Securities__c> createSecurities() {
        List<FinServ__Securities__c> securiList = new List<FinServ__Securities__c>();
        
        for(Integer i=0; i<5; i++){
            securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security '+i,FinServ__SourceSystemId__c = '9_' + i));
        }
        
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_32924',FinServ__SourceSystemId__c = '6_32924'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_33022',FinServ__SourceSystemId__c = '6_33022'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_33383',FinServ__SourceSystemId__c = '6_33383'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_34045',FinServ__SourceSystemId__c = '6_34045'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_34162',FinServ__SourceSystemId__c = '6_34162'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_51224',FinServ__SourceSystemId__c = '6_51224'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_54475',FinServ__SourceSystemId__c = '6_54475'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_55730',FinServ__SourceSystemId__c = '6_55730'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_56615',FinServ__SourceSystemId__c = '6_56615'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_3237853',FinServ__SourceSystemId__c = '6_3237853'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_3306149',FinServ__SourceSystemId__c = '6_3306149'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_5655043',FinServ__SourceSystemId__c = '6_5655043'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_6249916',FinServ__SourceSystemId__c = '6_6249916'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_6354045',FinServ__SourceSystemId__c = '6_6354045'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_7067516',FinServ__SourceSystemId__c = '6_7067516'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_7439387',FinServ__SourceSystemId__c = '6_7439387'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_8958540',FinServ__SourceSystemId__c = '6_8958540'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_9223012',FinServ__SourceSystemId__c = '6_9223012'));
        securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security 6_9508205',FinServ__SourceSystemId__c = '6_9508205'));
        
        insert securiList;
        return securiList;
    }

    
    public Opportunity createOppwithVersionwithIPLs(Id finAccId, Id accId) {

        List<RecordType> invsPropRecordType = CRAN_VEC_ADV_Constants_CLS.INVSPROP_RECORDTYPE;
        //Create a map between the Record Type SobjectType and Id for easy retrieval
        Map<String,Id> recordTypesMap = new Map<String,Id>();
        for(RecordType rt: invsPropRecordType){
            recordTypesMap.put(rt.SobjectType,rt.Id);
        }

        Opportunity newOpportunity = new Opportunity(CRAN_VEC_ADV_T_AvaloqPropId__c = '99485433', Name = 'nameOpportunity', CRAN_VEC_ADV_P_Bunit__c = '9', RecordTypeId = recordTypesMap.get('Opportunity'), StageName = 'advOpen', CloseDate = Date.today().addDays(30), CRAN_VEC_ADV_P_InvMethod__c = 'IPS', CRAN_VEC_ADV_D_StartDate__c = Date.today(), AccountId = accId, FinServ__FinancialAccount__c = finAccId, CRAN_VEC_ADV_B_isService__c = true);
        insert newOpportunity;

        Quote myQuote = new Quote(CRAN_VEC_ADV_P_Quote_ID__c = '222', Name = 'nameOpportunity', CRAN_VEC_ADV_N_Version__c = 1, OpportunityId = newOpportunity.Id, CRAN_VEC_ADV_P_Currency__c = 'AFN', CRAN_VEC_ADV_N_InvAmount__c = 20, CRAN_VEC_ADV_D_StartDate__c = Date.today(), CRAN_VEC_ADV_B_OverrideAll__c = false, CRAN_VEC_ADV_B_Final__c = true, CRAN_VEC_ADV_B_FinalBK__c = true, CRAN_VEC_ADV_P_CurrencyBK__c = 'ALL', CRAN_VEC_ADV_N_InvAmountBK__c = 20, RecordTypeId = recordTypesMap.get('Quote'));
        insert myQuote;

        List<FinServ__Securities__c> secList = createSecurities();
        List<CRAN_VEC_ADV_Investment_Proposition_Line__c> iplList = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
        for (FinServ__Securities__c sec : secList){
            iplList.add( new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = sec.Name,CRAN_VEC_ADV_N_Secuence__c=1, CRAN_VEC_ADV_FieldChangedbyUser__c='Quantity',CRAN_VEC_ADV_N_PercentQtty__c=12,CRAN_VEC_ADV_N_PropMktValue__c=12,CRAN_VEC_ADV_L_Version__c  = myQuote.Id, RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c'),CRAN_VEC_ADV_L_Assets__c = sec.Id));
        }


        insert iplList;

        List<CRAN_VEC_ADV_IPL_Restriction__c> restList = new List<CRAN_VEC_ADV_IPL_Restriction__c>();
        for(Integer i=0; i<5; i++){
            // Hemos eliminado el campo CRAN_VEC_ADV_L_Node__c
            //restList.add(new CRAN_VEC_ADV_IPL_Restriction__c(Name = 'Restriction '+i, RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_IPL_Restriction__c'), CRAN_VEC_ADV_L_Node__c = iplList[i].Id, CRAN_VEC_ADV_L_Version__c = myQuote.Id));
            restList.add(new CRAN_VEC_ADV_IPL_Restriction__c(Name = 'Restriction '+i, RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_IPL_Restriction__c'), CRAN_VEC_ADV_L_Version__c = myQuote.Id));
        }
        insert restList;

        return newOpportunity;
    }

    public Opportunity createOppForRelatedLists(Id finAccId, Id accId) {

        List<RecordType> invsPropRecordType = CRAN_VEC_ADV_Constants_CLS.INVSPROP_RECORDTYPE;
        //Create a map between the Record Type SobjectType and Id for easy retrieval
        Map<String,Id> recordTypesMap = new Map<String,Id>();
        for(RecordType rt: invsPropRecordType){
            recordTypesMap.put(rt.SobjectType,rt.Id);
        }

        Opportunity newOpportunity = new Opportunity(CRAN_VEC_ADV_T_AvaloqPropId__c = '11111', Name = 'nameOpportunity', CRAN_VEC_ADV_P_Bunit__c = '9', RecordTypeId = recordTypesMap.get('Opportunity'), StageName = 'advOpen', CloseDate = Date.today().addDays(30), CRAN_VEC_ADV_P_InvMethod__c = 'IPS', CRAN_VEC_ADV_D_StartDate__c = Date.today(), AccountId = accId, FinServ__FinancialAccount__c = finAccId);
        insert newOpportunity;
        system.debug('newOpportunity: ' + newOpportunity);

        Quote myQuote = new Quote(CRAN_VEC_ADV_P_Quote_ID__c = '222', Name = 'nameOpportunity', CRAN_VEC_ADV_N_Version__c = 1, OpportunityId = newOpportunity.Id, CRAN_VEC_ADV_P_Currency__c = 'AFN', CRAN_VEC_ADV_N_InvAmount__c = 20, CRAN_VEC_ADV_B_OverrideAll__c = false, CRAN_VEC_ADV_B_Final__c = true, RecordTypeId = recordTypesMap.get('Quote'));                
        insert myQuote;
        system.debug('myQuote: ' + myQuote);

        List<FinServ__Securities__c> securiList = new List<FinServ__Securities__c>();        
        for(Integer i=0; i<5; i++){
            securiList.add(new FinServ__Securities__c(FinServ__SecuritiesName__c = 'Security '+i,FinServ__SourceSystemId__c = '9_' + i));
        }
        insert securiList;
        system.debug('securiList: ' + securiList);
        
        List<CRAN_VEC_ADV_Investment_Proposition_Line__c> iplList = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
        iplList.add( new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name='All Assets',CRAN_VEC_ADV_N_Secuence__c=1, CRAN_VEC_ADV_L_Version__c=myQuote.Id, RecordTypeId=recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c'),
                                                                        CRAN_VEC_ADV_T_Rating__c='',
                                                                        CRAN_VEC_ADV_N_Price__c=0,
                                                                        CRAN_VEC_ADV_P_Currency__c='',
                                                                        CRAN_VEC_ADV_N_PropQtty__c=400.05,
                                                                        CRAN_VEC_ADV_N_PropAccrual__c=200.30,
                                                                        CRAN_VEC_ADV_N_PropMktValue__c=390.78,
                                                                        CRAN_VEC_ADV_N_PercentQtty__c=24.60,
                                                                        CRAN_VEC_ADV_N_Delta__c=0,
                                                                        CRAN_VEC_ADV_N_MPF__c=0,
                                                                        CRAN_VEC_ADV_B_Extl__c=false,
                                                                        CRAN_VEC_ADV_B_AggrPosition__c=false,
                                                                        CRAN_VEC_ADV_T_Remark__c='',
                                                                        CRAN_VEC_ADV_T_RestrInfo__c='',
                                                                        CRAN_VEC_ADV_P_nodeType__c='node',
                                                                        CRAN_VEC_ADV_N_Level__c=1,
                                                                        CRAN_VEC_ADV_FieldChangedbyUser__c='Quantity'));
        iplList.add( new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name='Fondos',CRAN_VEC_ADV_N_Secuence__c=2, CRAN_VEC_ADV_L_Version__c=myQuote.Id, RecordTypeId=recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c'),
                                                                        CRAN_VEC_ADV_T_Rating__c='',
                                                                        CRAN_VEC_ADV_N_Price__c=0,
                                                                        CRAN_VEC_ADV_P_Currency__c='',
                                                                        CRAN_VEC_ADV_N_PropQtty__c=400.05,
                                                                        CRAN_VEC_ADV_N_PropAccrual__c=200.30,
                                                                        CRAN_VEC_ADV_N_PropMktValue__c=390.78,
                                                                        CRAN_VEC_ADV_N_PercentQtty__c=24.60,
                                                                        CRAN_VEC_ADV_N_Delta__c=0,
                                                                        CRAN_VEC_ADV_N_MPF__c=0,
                                                                        CRAN_VEC_ADV_B_Extl__c=false,
                                                                        CRAN_VEC_ADV_B_AggrPosition__c=false,
                                                                        CRAN_VEC_ADV_T_Remark__c='',
                                                                        CRAN_VEC_ADV_T_RestrInfo__c='',
                                                                        CRAN_VEC_ADV_P_nodeType__c='node',
                                                                        CRAN_VEC_ADV_N_Level__c=2,
                                                                        CRAN_VEC_ADV_FieldChangedbyUser__c='Quantity'));
        
        
        Integer j = 3; // Contador para Secuence
        for (FinServ__Securities__c sec : securiList){
            iplList.add( new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name=sec.Name,CRAN_VEC_ADV_L_Assets__c=sec.Id,CRAN_VEC_ADV_N_Secuence__c=j, CRAN_VEC_ADV_L_Version__c=myQuote.Id, RecordTypeId=recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c'),
                                                                        CRAN_VEC_ADV_T_Rating__c='Rating',
                                                                        CRAN_VEC_ADV_N_Price__c=29.90*j,
                                                                        CRAN_VEC_ADV_P_Currency__c='EUR',
                                                                        CRAN_VEC_ADV_N_PropQtty__c=25.50*j,
                                                                        CRAN_VEC_ADV_N_PropAccrual__c=23.99*j,
                                                                        CRAN_VEC_ADV_N_PropMktValue__c=39.76*j,
                                                                        CRAN_VEC_ADV_N_PercentQtty__c=2.78*j,
                                                                        CRAN_VEC_ADV_N_Delta__c=289*j,
                                                                        CRAN_VEC_ADV_N_MPF__c=634*j,
                                                                        CRAN_VEC_ADV_B_Extl__c=true,
                                                                        CRAN_VEC_ADV_B_AggrPosition__c=false,
                                                                        CRAN_VEC_ADV_T_Remark__c='Remark',
                                                                        CRAN_VEC_ADV_T_RestrInfo__c='Restriction Info',
                                                                        CRAN_VEC_ADV_P_nodeType__c='pos',
                                                                        CRAN_VEC_ADV_N_Level__c=3,
                                                                        CRAN_VEC_ADV_FieldChangedbyUser__c='Quantity'));
            j++;
        }
        insert iplList;
        system.debug('iplList: ' + iplList);
        
        List<CRAN_VEC_ADV_IPL_Restriction__c> restList = new List<CRAN_VEC_ADV_IPL_Restriction__c>();
        for(Integer i=0; i<5; i++){
            restList.add(new CRAN_VEC_ADV_IPL_Restriction__c(Name = 'Restriction '+i, RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_IPL_Restriction__c'), CRAN_VEC_ADV_L_Version__c = myQuote.Id,
                                                            CRAN_VEC_ADV_B_Override__c=false,
                                                            CRAN_VEC_ADV_T_Justification__c='',
                                                            CRAN_VEC_ADV_T_Priority__c='',
                                                            CRAN_VEC_ADV_T_TopRestriction__c='',
                                                            CRAN_VEC_ADV_T_ValueFrom__c='',
                                                            CRAN_VEC_ADV_T_ValueTo__c='',
                                                            CRAN_VEC_ADV_T_ViolObject__c='',
                                                            CRAN_VEC_ADV_T_ViolClass__c='',
                                                            CRAN_VEC_ADV_T_ViolValue__c=''));

        }
        insert restList;
        system.debug('restList: ' + restList);

        return newOpportunity;
    }   


    public Order createrOrder() {
        Account myAccount = createBPAccount();
        Order myOrder = new Order();
        myOrder.AccountId = myAccount.Id;
        myOrder.Name = 'nombre Test';
        myOrder.EffectiveDate = Date.today();
        myOrder.CRAN_VEC_ADV_P_MetaType__c = 'STEX';
        myOrder.Status = 'Draft';
        
        insert myOrder;
        return myOrder;
    } 

    public Order createrOrderSimulated() {
        List<RecordType> invsPropRecordType = CRAN_VEC_ADV_Constants_CLS.INVSPROP_RECORDTYPE;
        //Create a map between the Record Type SobjectType and Id for easy retrieval
        Map<String,Id> recordTypesMap = new Map<String,Id>();
        for(RecordType rt: invsPropRecordType){
            recordTypesMap.put(rt.SobjectType,rt.Id);
        }
        Account myAccount = createBPAccount();
        Order myOrder = new Order();
        myOrder.AccountId = myAccount.Id;
        myOrder.Name = 'nombre Test' + String.valueOf(Integer.valueOf(Math.random()*100000));
        myOrder.EffectiveDate = Date.today();
        myOrder.CRAN_VEC_ADV_P_MetaType__c = 'STEX';
        myOrder.Status = 'Simulated';       
        myOrder.RecordTypeId = recordTypesMap.get('Order');

        insert myOrder;
        return myOrder;
    } 

    public Order createrOrder2() {
        List<RecordType> invsPropRecordType = CRAN_VEC_ADV_Constants_CLS.INVSPROP_RECORDTYPE;
        //Create a map between the Record Type SobjectType and Id for easy retrieval
        Map<String,Id> recordTypesMap = new Map<String,Id>();
        for(RecordType rt: invsPropRecordType){
            recordTypesMap.put(rt.SobjectType,rt.Id);
        }
        Account myAccount = createBPAccount();
        Order myOrder = new Order();
        myOrder.AccountId = myAccount.Id;
        myOrder.Name = 'nombre Test';
        myOrder.EffectiveDate = Date.today();
        myOrder.CRAN_VEC_ADV_P_MetaType__c = 'STEX';
        myOrder.Status = 'Simulated';
        myOrder.CRAN_VEC_ADV_T_OrderId__c = '111111';
        myOrder.RecordTypeId = recordTypesMap.get('Order');
        myOrder.CRAN_VEC_ADV_B_Signed__c=false;
        myOrder.CRAN_VEC_ADV_P_SFStatus__c = 'advSimulated';

        insert myOrder;
        return myOrder;
    }

}