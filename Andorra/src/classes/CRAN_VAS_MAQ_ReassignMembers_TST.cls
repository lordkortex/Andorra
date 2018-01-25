@isTest
private class CRAN_VAS_MAQ_ReassignMembers_TST {
	
	  @testSetup 
	static void loadTestData() {
        
       	User 		dummyManager;
        
        System.runAs(new User ( Id = UserInfo.getUserId())) {
            dummyManager 	= CRAN_VAS_KER_TestDataFactory_TST.createDummyUser();        
        }
        
        Account 	client 	= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(dummyManager.Id);
        Contact		con 	= [SELECT Id, AccountId FROM Contact WHERE AccountId =: client.Id];
        Account 	bp 		= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(dummyManager.Id)[0];

        System.runAs(dummyManager) {
                        
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
        
	}

    @isTest static void testAssignMemberGlobal() {       	
		User dummyManager = [SELECT Id FROM User WHERE Alias = 'alidummy'];
            
        	Campaign 	campaign	= [SELECT Id FROM Campaign WHERE Name = 'Test Sistematica Campaign'];
            User		dummyUser	= [SELECT Id, CRAN_ICA_KER_P_Oficina__c FROM User WHERE Alias = 'alidummy'];
            
            
          	Account 	client = [	SELECT 	Id 
                               		FROM 	Account 
                               		WHERE 	CRAN_VEC_ADV_T_BPId__c = '9_998877'
                         			AND 	RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual')];   
            
        	Account		bp 			= [SELECT  Id FROM Account 
                              		WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Business_Partner') LIMIT 1];            
            
            Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper> offices = (Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>)JSON.deserialize(
                																CRAN_VAS_MAQ_ReassignMembers_AUC.getOfficesAndUsers(null,null) 
                                                                                , Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>.class);

            offices = (Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>)JSON.deserialize(
                CRAN_VAS_MAQ_ReassignMembers_AUC.getOfficesAndUsers(dummyUser.CRAN_ICA_KER_P_Oficina__c,dummyManager.Id) 
                                       , Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>.class);

            Map<String, Object> params = new Map<String, Object>();
            params.put('user'			, dummyUser.Id );
            params.put('workedByOther'	, false);
            params.put('startDate'		, String.valueOf(system.today()));
            params.put('closeDate'		, String.valueOf(system.today().addDays(10)));
        	
            String results = CRAN_VAS_MAQ_ReassignMembers_AUC.getFilteredData(params,'Name');

            // With BP and Client and Campaign
            params.put('bp'			, bp.Id);
            params.put('client'		, client.Id);
            params.put('campaign'	, campaign.Id);
            
            results = CRAN_VAS_MAQ_ReassignMembers_AUC.getFilteredData(params,'Name');

            
            List<CampaignMember> members = [SELECT Id from CampaignMember];
            List<String> membersIds = new List<String>();
            for (CampaignMember o: members) {
                 membersIds.add(o.Id);
            }
            
            system.assert(CRAN_VAS_MAQ_ReassignMembers_AUC.reassignMembersToUser(membersIds, null));
            
            system.assert(CRAN_VAS_MAQ_ReassignMembers_AUC.reassignMembersToUser(membersIds, dummyManager.Id));
    } 
	@isTest
	static void testAssignMemberGlobal2() {       	

    	User dummyManager = [SELECT Id FROM User WHERE Alias = 'alidummy'];
        
            
            User		dummyUser	= [SELECT Id, CRAN_ICA_KER_P_Oficina__c, ProfileId FROM User WHERE Alias = 'alidummy'];


        	Campaign 	campaign	= [SELECT Id FROM Campaign WHERE Name = 'Test Sistematica Campaign'];
            
            
          	Account 	client = [	SELECT 	Id 
                               		FROM 	Account 
                               		WHERE 	CRAN_VEC_ADV_T_BPId__c = '9_998877'
                         			AND 	RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual')];   
            
        	Account		bp 			= [SELECT  Id FROM Account 
                              		WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Business_Partner') LIMIT 1]; 
            Profile  	Pf 			= [SELECT Id, Name FROM Profile WHERE PermissionsModifyAllData = true Limit 1];              		           
            dummyUser.CRAN_ICA_KER_P_Oficina__c = '10';
            update dummyUser;
            Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper> offices = (Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>)JSON.deserialize(
                																CRAN_VAS_MAQ_ReassignMembers_AUC.getOfficesAndUsers(null,null) 
                                                                                , Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>.class);

            offices = (Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>)JSON.deserialize(
                CRAN_VAS_MAQ_ReassignMembers_AUC.getOfficesAndUsers(dummyUser.CRAN_ICA_KER_P_Oficina__c,dummyManager.Id) 
                                       , Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>.class);

            Map<String, Object> params = new Map<String, Object>();
            params.put('user'			, dummyUser.Id );
            params.put('workedByOther'	, false);
            params.put('startDate'		, String.valueOf(system.today()));
            params.put('closeDate'		, String.valueOf(system.today().addDays(10)));
        	
            String results = CRAN_VAS_MAQ_ReassignMembers_AUC.getFilteredData(params,'Name');

            // With BP and Client and Campaign
            params.put('bp'			, bp.Id);
            params.put('client'		, client.Id);
            params.put('campaign'	, campaign.Id);
            
            results = CRAN_VAS_MAQ_ReassignMembers_AUC.getFilteredData(params,'Name');

            
            List<CampaignMember> members = [SELECT Id from CampaignMember];
            List<String> membersIds = new List<String>();
            for (CampaignMember o: members) {
                 membersIds.add(o.Id);
            }
            
            system.assert(CRAN_VAS_MAQ_ReassignMembers_AUC.reassignMembersToUser(membersIds, UserInfo.getUserId()));
    } 
        
}