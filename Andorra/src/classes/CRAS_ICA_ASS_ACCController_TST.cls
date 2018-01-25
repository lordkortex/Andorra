@istest
public class CRAS_ICA_ASS_ACCController_TST {
    
    @testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }
    
    @isTest 
    static void testGetGlobalSettings(){
        try{
            CRAS_ICA_ASS_InsuranceGlobal_CS__c gs = CRAS_ICA_ASS_ACCController_AUC.getGlobalSettings();            
            system.assert(gs != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetRolesFromAccount(){
        Account acc = [SELECT ID FROM Account Limit 1];
        try{
            List<FinServ__FinancialAccountRole__c> rolesLst = CRAS_ICA_ASS_ACCController_AUC.getRolesFromAccount(acc.ID);          
            system.assert(rolesLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void  testGetClaimsFromAccount(){
        
        List<Contact> contLst = [SELECT ID, AccountId FROM Contact WHERE AccountId != ''];
        List<Account> accLst = [SELECT ID, Name FROM Account];
        
        FinServ__FinancialAccount__c faInsrt = 
            CRAS_ICA_ASS_TestDataFactory_TST.createFA(accLst[57], 80, 'CRAS_ICA_ASS_FAInsuranceRecordType');
        
        Insert faInsrt;
        
        FinServ__FinancialAccountRole__c farInsrt = 
            CRAS_ICA_ASS_TestDataFactory_TST.createFAR(contLst[0], faInsrt, 'CRAS_ICA_ASS_FARInsuranceRecordType', 80, '102ASS', 80);
                    
        insert farInsrt;
        
        CRAS_ICA_ASS_ClaimAmountHistory__c claimInsrt = CRAS_ICA_ASS_TestDataFactory_TST.createClaim(farInsrt, 80, 2017);
        
        insert claimInsrt;
        
        Test.startTest();
        List<CRAS_ICA_ASS_MapList_OBJ> insLst = CRAS_ICA_ASS_ACCController_AUC.getClaimsFromAccount(contLst[0].AccountId);
        Test.stopTest();
        
        system.assert(insLst != null);             
    }
    
    @isTest 
    static void testGetInsuranceRolesCount(){
        List<Account> accLst = [SELECT ID FROM Account Limit 1];
        try{
            Integer insRolCnt = CRAS_ICA_ASS_ACCController_AUC.getInsuranceRolesCount(accLst[0].ID);           
            system.assert(insRolCnt != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetClaimsCount(){
        List<Account> accLst = [SELECT ID FROM Account Limit 1];
        try{
            Integer clmCount = CRAS_ICA_ASS_ACCController_AUC.getClaimsCount(accLst[0].ID);            
            system.assert(clmCount != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetInsurancePHICount(){
        List<Account> accLst = [SELECT ID FROM Account];
        try{
            Integer clmCount = CRAS_ICA_ASS_ACCController_AUC.getInsurancePHICount(accLst[1].ID);            
            system.assert(clmCount != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void  testGetInsurancePHI(){
        List<Contact> contctLst = [SELECT AccountId FROM Contact WHERE AccountId != '' AND Account.CRAS_ICA_ASS_F_AxisPersonID__c != null];
        
        List<FinServ__FinancialAccountRole__c> insLst = CRAS_ICA_ASS_ACCController_AUC.getInsurancePHI(contctLst[0].AccountId);         
        system.assert(insLst != null);
         
    }
    
    @isTest 
    static void testGetRolesPHFromAccount(){
        List<Account> accLst = [SELECT ID FROM Account];
        Test.startTest();
        //Filtrar Datos a pasar
        
        List<FinServ__FinancialAccountRole__c> rolPHAccLst = CRAS_ICA_ASS_ACCController_AUC.getRolesPHFromAccount(accLst[1].Id);           
        system.assert(rolPHAccLst != null);
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetInsuranceRolesPHCount(){
        List<Account> accLst = [SELECT ID FROM Account];
        try{
            Integer insRolPHCount = CRAS_ICA_ASS_ACCController_AUC.getInsuranceRolesPHCount(accLst[1].ID);         
            system.assert(insRolPHCount != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest
    static void testGetRelListRolesFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> rolFNLst = CRAS_ICA_ASS_ACCController_AUC.getRelListRolesFieldNames();          
            system.assert(rolFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        }
    }
    
    @isTest
    static void testGetPHRelListRolesFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> rolFNLst = CRAS_ICA_ASS_ACCController_AUC.getPHRelListRolesFieldNames();          
            system.assert(rolFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        }
    }
    
    @isTest
    static void testGetRelListClaimsFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> clmFNLst = CRAS_ICA_ASS_ACCController_AUC.getRelListClaimsFieldNames();         
            system.assert(clmFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        }
    }
    
    @isTest
    static void testGetCalcClaimsHistory(){
        List<Account> accLst = [SELECT ID FROM Account Limit 1];
        try{
            Boolean calcClmHst = CRAS_ICA_ASS_ACCController_AUC.getCalcClaimsHistory(accLst[0].Id);            
            system.assert(calcClmHst != null);            
        } catch (Exception ex) {
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        }
    }
}