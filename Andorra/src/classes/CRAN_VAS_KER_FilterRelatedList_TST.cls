@isTest
public class CRAN_VAS_KER_FilterRelatedList_TST {
        
    @testSetup 
	static void loadTestData() {
        CRAN_VAS_KER_TestDataFactory_TST dataFactory = new CRAN_VAS_KER_TestDataFactory_TST();
		//Creates one account and four opportunities
		Account acc = dataFactory.createBPAccount();
        Campaign camp = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaCampaign();
        CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test1', camp.Id, acc.Id, acc.Id);
        CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test2', camp.Id, acc.Id, acc.Id);
        CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test3', camp.Id, acc.Id, acc.Id);
        CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test4', camp.Id, acc.Id, acc.Id);
	}
    
    @isTest static Map<String,Id> testGetAvailableRecordTypes() {       	
        Map<String,Id> availableRTs = new Map<String,Id>();
        String objName='Opportunity';
        
        try{            
          //Test our method
          availableRTs = CRAN_VAS_KER_FilterRelatedList_AUC.getAvailableRecordTypes(objName);
         
          //Check result  
          System.assert(!availableRTs.isEmpty());    
         
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            System.assert(false);
        }
        
        return availableRTs;
    }
    
    @isTest static void testGetsObjectLabel() {       	
            
        try{            
            
            update new User ( Id = UserInfo.getUserId(), LanguageLocaleKey='en_US' );
            
            System.runAs(new User( Id = UserInfo.getUserId())) {    
                Account acc = [SELECT Id FROM Account LIMIT 1][0];
                
                //Test our method
                String sObjectLabel = CRAN_VAS_KER_FilterRelatedList_AUC.getsObjectLabel(acc.Id);
                
                //Check result    
                List<String> listResult = (List<String>) JSON.deserialize(sObjectLabel, List<String>.class);
                
                System.debug('listResult:'+listResult);
                System.assert(listResult.get(0) == 'ACCOUNTS');
                System.assert(listResult.get(1).contains('BUSINESS PARTNER'));
                System.assert(listResult.get(2) == 'Account');
            }
            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            System.assert(false);
        }
    }

}