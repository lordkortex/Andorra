@isTest
public class CRAS_ICA_ASS_FAController_TST {
    @testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }
    
    @isTest 
    static void testGetGlobalSettings(){
        try{
            CRAS_ICA_ASS_InsuranceGlobal_CS__c gs = CRAS_ICA_ASS_FAController_AUC.getGlobalSettings();         
            system.assert(gs != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceGuarantees(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            List<FinServ__FinancialHolding__c> insGuaLst = CRAS_ICA_ASS_FAController_AUC.getInsuranceGuarantees(faLst[0].ID, 1, 1);            
            system.assert(insGuaLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceGuaranteesCount(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            Integer insGuaCnt = CRAS_ICA_ASS_FAController_AUC.getInsuranceGuaranteesCount(faLst[0].ID);            
            system.assert(insGuaCnt != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceProducts(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            List<FinServ__FinancialHolding__c> insPrdLst = CRAS_ICA_ASS_FAController_AUC.getInsuranceProducts(faLst[0].ID, 1, 1);          
            system.assert(insPrdLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceProductsCount(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            Integer insPrdCnt = CRAS_ICA_ASS_FAController_AUC.getInsuranceProductsCount(faLst[0].ID);          
            system.assert(insPrdCnt != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetClaims(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            List<CRAS_ICA_ASS_ClaimAmountHistory__c> clmLst = CRAS_ICA_ASS_FAController_AUC.getClaims(faLst[0].ID, 1, 1);          
            system.assert(clmLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetClaimsCount(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            Integer clmCnt = CRAS_ICA_ASS_FAController_AUC.getClaimsCount(faLst[0].ID);            
            system.assert(clmCnt != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceInvoices(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            List<CRAS_ICA_ASS_Invoice__c> insInvLst = CRAS_ICA_ASS_FAController_AUC.getInsuranceInvoices(faLst[0].ID, 1, 1);           
            system.assert(insInvLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceInvoicesCount(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            Integer insInvCnt = CRAS_ICA_ASS_FAController_AUC.getInsuranceInvoicesCount(faLst[0].ID);          
            system.assert(insInvCnt != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceRoles(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            List<FinServ__FinancialAccountRole__c> insRolLst = CRAS_ICA_ASS_FAController_AUC.getInsuranceRoles(faLst[0].ID, 1, 1);         
            system.assert(insRolLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceRolesCount(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            Integer insRolCnt = CRAS_ICA_ASS_FAController_AUC.getInsuranceRolesCount(faLst[0].ID);         
            system.assert(insRolCnt != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsurancePolicyHolderRole(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            List<FinServ__FinancialAccountRole__c> insPHLst = CRAS_ICA_ASS_FAController_AUC.getInsurancePolicyHolderRole(faLst[0].ID, 1, 1);           
            system.assert(insPHLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsurancePolicyHolderRoleCount(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            Integer insPHCnt = CRAS_ICA_ASS_FAController_AUC.getInsurancePolicyHolderRoleCount(faLst[0].ID);           
            system.assert(insPHCnt != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetFinAccountData(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            FinServ__FinancialHolding__c FAData = CRAS_ICA_ASS_FAController_AUC.getFinAccountData(faLst[0].ID);            
            system.assert(FAData != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetFinAccountPolicyHolder(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        try{
            Account FAPH = CRAS_ICA_ASS_FAController_AUC.getFinAccountPolicyHolder(faLst[0].ID);            
            system.assert(FAPH != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceRolesPHICount(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        
        try{
            Integer FAData = CRAS_ICA_ASS_FAController_AUC.getInsuranceRolesPHICount(faLst[0].ID);            
            system.assert(FAData != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsuranceRolesPHI(){
        List<FinServ__FinancialAccount__c> faLst = [SELECT ID FROM FinServ__FinancialAccount__c Limit 1];
        
        try{
            List<FinServ__FinancialAccountRole__c> FAData = CRAS_ICA_ASS_FAController_AUC.getInsuranceRolesPHI(faLst[0].ID, 1, 1);            
            system.assert(FAData != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetFAWithUnpaidInvoicesWithOwner(){
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        System.runAs(userTest) 
        {
            Test.startTest();
            List<FinServ__FinancialAccountRole__c> unpInvLst = CRAS_ICA_ASS_FAController_AUC.getFAWithUnpaidInvoices(1);           
            system.assert(unpInvLst != null);
            Test.stopTest();
        }
         
    }
    
    @isTest 
    static void testGetFAWithUnpaidInvoicesWithoutOwner()
    {
        Test.startTest();
        List<FinServ__FinancialAccountRole__c> unpInvLst = CRAS_ICA_ASS_FAController_AUC.getFAWithUnpaidInvoices(1);           
        system.assert(unpInvLst != null);
        Test.stopTest();
    }
    
    @isTest 
    static void testGetFAWithUnpaidInvoicesCountWithOwner(){
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        System.runAs(userTest) 
        {
            Test.startTest();
            Integer unpInvCnt = CRAS_ICA_ASS_FAController_AUC.getFAWithUnpaidInvoicesCount();          
            system.assert(unpInvCnt != null);            
        	Test.stopTest();
        }
    }
    
    @isTest 
    static void testGetFAWithUnpaidInvoicesCountWithoutOwner()
    {
        Test.startTest();
        Integer unpInvCnt = CRAS_ICA_ASS_FAController_AUC.getFAWithUnpaidInvoicesCount();          
        system.assert(unpInvCnt != null);            
        Test.stopTest();
    }
    
    @isTest 
    static void testGetFAWithPendingStatusWithOwner(){
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        System.runAs(userTest) 
        {
            Test.startTest();
            List<FinServ__FinancialAccount__c> penStaLst = CRAS_ICA_ASS_FAController_AUC.getFAWithPendingStatus(1);            
            system.assert(penStaLst != null);            
        	Test.stopTest();
        } 
    }
    
    @isTest 
    static void testGetFAWithPendingStatusWithoutOwner()
    {
        Test.startTest();
        List<FinServ__FinancialAccount__c> penStaLst = CRAS_ICA_ASS_FAController_AUC.getFAWithPendingStatus(1);            
        system.assert(penStaLst != null);            
        Test.stopTest();
    }
    
    @isTest 
    static void testGetFAWithPendingStatusCountWithOwner(){
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        System.runAs(userTest) 
        {
            Test.startTest();
            Integer penStaCnt = CRAS_ICA_ASS_FAController_AUC.getFAWithPendingStatusCount();           
            system.assert(penStaCnt != null);            
        	Test.stopTest();
        }
    }
    
    @isTest 
    static void testGetFAWithPendingStatusCountWithoutOwner()
    {
        Test.startTest();
        Integer penStaCnt = CRAS_ICA_ASS_FAController_AUC.getFAWithPendingStatusCount();           
        system.assert(penStaCnt != null);            
        Test.stopTest(); 
    }
    
    @isTest 
    static void testGetCompactLayoutFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> CLFNLst = CRAS_ICA_ASS_FAController_AUC.getCompactLayoutFieldNames();           
            system.assert(CLFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetHLUnpaidInvLayoutFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> unpInvFNLst = CRAS_ICA_ASS_FAController_AUC.getHLUnpaidInvLayoutFieldNames();           
            system.assert(unpInvFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetHLPendingStatusLayoutFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> penStaFNLst = CRAS_ICA_ASS_FAController_AUC.getHLPendingStatusLayoutFieldNames();           
            system.assert(penStaFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetRelListRolesFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> RLRolFNLst = CRAS_ICA_ASS_FAController_AUC.getRelListRolesFieldNames();         
            system.assert(RLRolFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testgetRelListPhFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> RLPHFNLst = CRAS_ICA_ASS_FAController_AUC.getRelListPhFieldNames();         
            system.assert(RLPHFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetRelListProductsFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> RLProFNLst = CRAS_ICA_ASS_FAController_AUC.getRelListProductsFieldNames();          
            system.assert(RLProFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetClaimsListFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> clmFNLst = CRAS_ICA_ASS_FAController_AUC.getClaimsListFieldNames();         
            system.assert(clmFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetRelListGuaranteesFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> RLGuaFNLst = CRAS_ICA_ASS_FAController_AUC.getRelListGuaranteesFieldNames();            
            system.assert(RLGuaFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetRelListInvoicesFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> RLInvFNLst = CRAS_ICA_ASS_FAController_AUC.getRelListInvoicesFieldNames();          
            system.assert(RLInvFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
}