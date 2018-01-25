@isTest
private class CRAN_VAS_MAQ_ReassignGoals_TST {
    
    @testSetup 
	static void loadTestData() {
        
           User 		dummyUser;
            
            System.runAs(new User ( Id = UserInfo.getUserId())) {
                dummyUser 	= CRAN_VAS_KER_TestDataFactory_TST.createDummyUser();        
            }
        Account 	client 	= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(UserInfo.getUserId());
        Contact		con 	= [SELECT Id, AccountId FROM Contact WHERE AccountId =: client.Id];
        Account 	bp 		= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(UserInfo.getUserId())[0];

                        
            Campaign campaign 	= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns()[1];
            
        	CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test1', campaign.Id, bp.Id, client.Id);
        	CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test2', campaign.Id, bp.Id, client.Id);
        	CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test3', campaign.Id, bp.Id, client.Id);
        	CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Test4', campaign.Id, bp.Id, client.Id);
            CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(campaign.Id,
                                                                     con.Id,
                                                                     bp.Id,
                                                                     UserInfo.getUserId(),
                                                                     'No Trabajado'
                                                                    );            
        
	}

    @isTest static void testAssignGoalsGlobal() {       	

            
        	Campaign 	campaign	= [SELECT Id FROM Campaign WHERE Name = 'Test Sistematica Campaign'];
            User		dummyUser	= [SELECT Id, CRAN_ICA_KER_P_Oficina__c FROM User WHERE Alias = 'alidummy'];
            
            
          	Account 	client = [	SELECT 	Id 
                               		FROM 	Account 
                               		WHERE 	CRAN_VEC_ADV_T_BPId__c = '9_998877'
                         			AND 	RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual')];   
            
        	Account		bp 			= [SELECT  Id FROM Account 
                              		WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Business_Partner') LIMIT 1];            
            
            Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper> offices = (Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>)JSON.deserialize(
                																CRAN_VAS_MAQ_ReassignGoals_AUC.getOfficesAndUsers(null) 
                                                                                , Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>.class);

            offices = (Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>)JSON.deserialize(
                CRAN_VAS_MAQ_ReassignGoals_AUC.getOfficesAndUsers(dummyUser.CRAN_ICA_KER_P_Oficina__c) 
                                       , Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>.class);

            Map<String, Object> params = new Map<String, Object>();
            params.put('user'			, dummyUser.Id );
            params.put('workedByOther'	, false);
            params.put('startDate'		, String.valueOf(system.today()));
            params.put('closeDate'		, String.valueOf(system.today().addDays(10)));
        	
            String results = CRAN_VAS_MAQ_ReassignGoals_AUC.getFilteredData(params,'Name');

            // With BP and Client and Campaign
            params.put('bp'			, bp.Id);
            params.put('client'		, client.Id);
            params.put('campaign'	, campaign.Id);
            
            results = CRAN_VAS_MAQ_ReassignGoals_AUC.getFilteredData(params,'Name');

            
            List<Opportunity> goals = [SELECT Id from Opportunity];
            List<String> goalIds = new List<String>();
            for (Opportunity o: goals) {
                goalIds.add(o.Id);
            }
            
            system.assert(CRAN_VAS_MAQ_ReassignGoals_AUC.reassignGoalsToUser(goalIds, null));
            
            system.assert(!CRAN_VAS_MAQ_ReassignGoals_AUC.reassignGoalsToUser(goalIds, client.Id));

    }    
        

}