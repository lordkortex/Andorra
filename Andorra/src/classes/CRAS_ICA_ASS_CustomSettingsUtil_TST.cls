@isTest
public class CRAS_ICA_ASS_CustomSettingsUtil_TST {    
    @isTest 
    static void testSetSettings(){
        try{
          	CRAS_ICA_ASS_CustomSettingsUtil_CLS.setSettings();	               
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testCleanInsuranceDataLoad(){
        //Crear lista de Contactos
        List<Contact> cntLst = CRAS_ICA_ASS_TestDataFactory_TST.createContactList();
        //Crear lista de BP Seguros
        List<Account> accLst = CRAS_ICA_ASS_TestDataFactory_TST.createAccountList();
        //Crear lista de Financial Account Seguros
        List<FinServ__FinancialAccount__c> faLst = CRAS_ICA_ASS_TestDataFactory_TST.createFAList(accLst);
		//Cargar CSV de Securities Garantias/Productos y crear sus respectivas listas
        CRAS_ICA_ASS_CustomSettingsUtil_CLS.cleanInsuranceDataLoad(false);
    }
    
    @isTest 
    static void testCleanInsuranceDataLoad2(){
        //Crear lista de Contactos
        List<Contact> cntLst = CRAS_ICA_ASS_TestDataFactory_TST.createContactList();
        //Crear lista de BP Seguros
        List<Account> accLst = CRAS_ICA_ASS_TestDataFactory_TST.createAccountList();
        //Crear lista de Financial Account Seguros
        List<FinServ__FinancialAccount__c> faLst = CRAS_ICA_ASS_TestDataFactory_TST.createFAList(accLst);
		//Crear lista de Financial Account Role Tomador y Asegurado
        List<FinServ__FinancialAccountRole__c> farLst = CRAS_ICA_ASS_TestDataFactory_TST.createFARList(cntLst, faLst);

        CRAS_ICA_ASS_CustomSettingsUtil_CLS.cleanInsuranceDataLoad(false);
    }
    
    @isTest 
    static void testCleanInsuranceDataLoad3(){
        CRAS_ICA_ASS_CustomSettingsUtil_CLS.setSettings();
        //Crear lista de Contactos
        List<Contact> cntLst = CRAS_ICA_ASS_TestDataFactory_TST.createContactList();
        //Crear lista de BP Seguros
        List<Account> accLst = CRAS_ICA_ASS_TestDataFactory_TST.createAccountList();
        //Crear lista de Financial Account Seguros
        List<FinServ__FinancialAccount__c> faLst = CRAS_ICA_ASS_TestDataFactory_TST.createFAList(accLst);
		//Cargar CSV de Securities Garantias/Productos y crear sus respectivas listas
        List<FinServ__Securities__c> secGuaLst = CRAS_ICA_ASS_TestDataFactory_TST.createSecurityGuaranteeList(faLst); 
        List<FinServ__Securities__c> secProLst = CRAS_ICA_ASS_TestDataFactory_TST.createSecurityProductList(faLst);
        //Crear lista de Financial Account Role Tomador y Asegurado
        List<FinServ__FinancialAccountRole__c> farLst = CRAS_ICA_ASS_TestDataFactory_TST.createFARList(cntLst, faLst);
        //Crear lista de Financial Holding Garantias/Productos
        List<FinServ__FinancialHolding__c> fhLst = CRAS_ICA_ASS_TestDataFactory_TST.createFHList(secGuaLst, secProLst, farLst);
        CRAS_ICA_ASS_CustomSettingsUtil_CLS.cleanInsuranceDataLoad(false);
    }
    
    @isTest 
    static void testCleanInsuranceDataLoad4(){
        //Crear lista de Contactos
        List<Contact> cntLst = CRAS_ICA_ASS_TestDataFactory_TST.createContactList();
        //Crear lista de BP Seguros
        List<Account> accLst = CRAS_ICA_ASS_TestDataFactory_TST.createAccountList();
        //Crear lista de Financial Account Seguros
        List<FinServ__FinancialAccount__c> faLst = CRAS_ICA_ASS_TestDataFactory_TST.createFAList(accLst);
		//Cargar CSV de Securities Garantias/Productos y crear sus respectivas listas
        //Crear lista de Financial Account Role Tomador y Asegurado
        List<FinServ__FinancialAccountRole__c> farLst = CRAS_ICA_ASS_TestDataFactory_TST.createFARList(cntLst, faLst);
        //Crear lista de Recibos
        List<CRAS_ICA_ASS_Invoice__c> invLst = CRAS_ICA_ASS_TestDataFactory_TST.createInvList(farLst);

        CRAS_ICA_ASS_CustomSettingsUtil_CLS.cleanInsuranceDataLoad(false);
    }
    
    @isTest 
    static void testCleanInsuranceDataLoad5(){
        //Crear lista de Contactos
        List<Contact> cntLst = CRAS_ICA_ASS_TestDataFactory_TST.createContactList();
        //Crear lista de BP Seguros
        List<Account> accLst = CRAS_ICA_ASS_TestDataFactory_TST.createAccountList();
        //Crear lista de Financial Account Seguros
        List<FinServ__FinancialAccount__c> faLst = CRAS_ICA_ASS_TestDataFactory_TST.createFAList(accLst);
        List<FinServ__FinancialAccountRole__c> farLst = CRAS_ICA_ASS_TestDataFactory_TST.createFARList(cntLst, faLst);
        
        List<CRAS_ICA_ASS_ClaimAmountHistory__c> ClaimLst =  CRAS_ICA_ASS_TestDataFactory_TST.createClaimList(farLst);
        CRAS_ICA_ASS_CustomSettingsUtil_CLS.cleanInsuranceDataLoad(false);
    }
    
    @isTest 
    static void testCleanInsuranceDataLoad6(){
        CRAS_ICA_ASS_CustomSettingsUtil_CLS.setSettings();	 
        //Crear lista de Contactos
        List<Contact> cntLst = CRAS_ICA_ASS_TestDataFactory_TST.createContactList();
        //Crear lista de BP Seguros
        List<Account> accLst = CRAS_ICA_ASS_TestDataFactory_TST.createAccountList();
        //Crear lista de Financial Account Seguros
        List<FinServ__FinancialAccount__c> faLst = CRAS_ICA_ASS_TestDataFactory_TST.createFAList(accLst);
		//Cargar CSV de Securities Garantias/Productos y crear sus respectivas listas
        List<FinServ__Securities__c> secGuaLst = CRAS_ICA_ASS_TestDataFactory_TST.createSecurityGuaranteeList(faLst); 
        List<FinServ__Securities__c> secProLst = CRAS_ICA_ASS_TestDataFactory_TST.createSecurityProductList(faLst);
        CRAS_ICA_ASS_CustomSettingsUtil_CLS.cleanInsuranceDataLoad(false);
    }
    
    @isTest 
    static void testCleanInsuranceDataLoad7(){
        //Crear lista de Contactos
        List<Contact> cntLst = CRAS_ICA_ASS_TestDataFactory_TST.createContactList();
        CRAS_ICA_ASS_CustomSettingsUtil_CLS.cleanInsuranceDataLoad(false);
    }
    
    @isTest 
    static void testCleanInsuranceDataLoad8(){
        //Crear lista de Contactos
        List<Contact> cntLst = CRAS_ICA_ASS_TestDataFactory_TST.createContactList();
        //Crear lista de BP Seguros
        List<Account> accLst = CRAS_ICA_ASS_TestDataFactory_TST.createAccountList();
        //Crear lista de Financial Account Seguros
        List<FinServ__FinancialAccount__c> faLst = CRAS_ICA_ASS_TestDataFactory_TST.createFAList(accLst);
        //Crear lista de Primas
        //
        List<CRAS_ICA_ASS_FA_PremiumHistory__c> invLst = CRAS_ICA_ASS_TestDataFactory_TST.createFAPremHistList(faLst);

        CRAS_ICA_ASS_CustomSettingsUtil_CLS.cleanInsuranceDataLoad(false);
    }
}