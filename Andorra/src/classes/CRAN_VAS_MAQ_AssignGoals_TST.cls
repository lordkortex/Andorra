/**
 * CRAN_VAS_MAQ_AssignGoals_TST Assign Goals Component Tests Suite
 * Fecha: Abril 2017
 * @author VASS
 * @version 1.0
*/
@isTest
public class CRAN_VAS_MAQ_AssignGoals_TST {

    @testSetup 
	static void loadTestData() {

       	User 		dummyManager;
        
        System.runAs(new User ( Id = UserInfo.getUserId())) {
            dummyManager 	= CRAN_VAS_KER_TestDataFactory_TST.createDummyUser();        
        }
        
        Account 	client 		= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(dummyManager.Id);
        Contact		con 		= [SELECT Id, AccountId FROM Contact WHERE AccountId =: client.Id];
        Account 	bp 			= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(dummyManager.Id)[0];
        Campaign 	campaign;
        
        System.runAs(dummyManager) {
            
            campaign = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns()[1];
            
        	CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test1', campaign.Id, bp.Id, client.Id);
        	CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test2', campaign.Id, bp.Id, client.Id);
        	CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test3', campaign.Id, bp.Id, client.Id);
        	CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test4', campaign.Id, bp.Id, client.Id);              
        }
        
        CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(campaign.Id,
                                                                     con.Id,
                                                                     bp.Id,
                                                                     UserInfo.getUserId(),
                                                                     'No Trabajado'
                                                                    );
        
	}
    
    /**
     * Test method getGoalsAssignedToDummy(campaign, fieldNames) and getGoalsAssignedToDummyByOffice(campaign,office,fieldNames) with a user with global view.
     * */
    @isTest static void testAssignGoalsGlobal() {       	
        
        User director = CRAN_VAS_KER_TestDataFactory_TST.createDirector();
        
        System.runAs(director) {
            Campaign 	c 		= [SELECT Id from Campaign where Name = 'Test Sistematica Campaign'];
            String 		results = CRAN_VAS_MAQ_AssignGoals_AUC.getGoalsAssignedToDummy(c.Id,'Name','Global');
            String 		resultsByOffice = CRAN_VAS_MAQ_AssignGoals_AUC.getGoalsAssignedToDummyByOffice(c.Id,'6312', 'Name','Global');
 		}
    }
    
    /**
     * Test method getGoalsAssignedToDummy(campaign, fieldNames) with an office director user
     * */
    @isTest static void testAssignGoalsOfficeDirector() {       	
        
        User director = CRAN_VAS_KER_TestDataFactory_TST.createDirector();
        
        System.runAs(director) {
            Campaign c = [SELECT Id from Campaign where Name = 'Test Sistematica Campaign'];
            String s = CRAN_VAS_MAQ_AssignGoals_AUC.getGoalsAssignedToDummy(c.Id,'Name','Office');
        }
    }
    
    @isTest static void testAssignGoalAdivor() {       	
        
        User advisor = CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(null); 
        
        System.runAs(advisor) {
        	Campaign c = [SELECT Id from Campaign where Name = 'Test Sistematica Campaign'];
        	String s = CRAN_VAS_MAQ_AssignGoals_AUC.getGoalsAssignedToDummy(c.Id,'Name','User');
 		}
    }    
    
    /**
     * Test method getGoalDetailsController(goal, fieldNames)
     * */
    @isTest static void testGetGoalDetailsController() {
                
        Opportunity goal = [SELECT Id from Opportunity where Name = 'Test1'];
        
        String goalDetail = CRAN_VAS_MAQ_AssignGoals_AUC.getGoalDetailsController(goal.Id,'Name');

    }
    
    /**
     * Test method assignGoalsToUser(campaign,goals). Check if the goal owner and campaign member advisor has changed.
     * */
    @isTest static void testAssignGoalsToUser() {	
        
		Opportunity goal = [SELECT Id,OwnerId from Opportunity where Name = 'Test1'];
        List<String> goalsIds = new List<String>();
        goalsIds.add(String.valueOf(goal.Id));  
                
        Campaign c = [SELECT Id from Campaign where Name = 'Test Sistematica Campaign'];
        
        System.assert(CRAN_VAS_MAQ_AssignGoals_AUC.assignGoalsToUser(c.Id,goalsIds));
        System.assert(CRAN_VAS_MAQ_AssignGoals_AUC.assignGoalsToUser(c.Id,goalsIds, null));
        System.assert(!CRAN_VAS_MAQ_AssignGoals_AUC.assignGoalsToUser(c.Id,goalsIds, goal.Id));
        
        goal = [SELECT Id, OwnerId, CRAN_VAS_MAQ_L_BP__c from Opportunity where Name = 'Test1'];    
        
        CampaignMember cm = [SELECT Id, CRAN_VAS_MAQ_L_GestorMiembroCampana__c 
                             FROM CampaignMember 
                             where CRAN_VAS_MAQ_L_BP__c = :goal.CRAN_VAS_MAQ_L_BP__c];
        System.assert(cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c == UserInfo.getUserId());
        
    }
}