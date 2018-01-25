@isTest
private class CRAN_VAS_MAQ_CampaignMembersProvider_TST {
    
    @isTest static void testAdvisor() {
        
        Account 		indClient;
        Contact			con;
        User 			advisor;
        List<Account> 	bp;
        
        System.runAs(new User ( Id = UserInfo.getUserId())) {
            
            advisor 	= CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(null);
            
            indClient 	= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(advisor.Id);
            con 		= [SELECT Id, AccountId FROM Contact WHERE AccountId =: indClient.Id];
            bp 			= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(advisor.Id);
            
        }
        
        System.runAs(advisor) {     

            List<Campaign> 	campaigns 	= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
            CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(campaigns[0].Id, con.Id, bp[0].Id, UserInfo.getUserId(), 'Worked');
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('recordId', 		campaigns[0].Id);
            params.put('fieldNames', 	'Name, Status');
            params.put('displayType', 	'userRecords');
            params.put('displayLimit', 	'10');
			params.put('vision', 		'User');            
            
            CRAN_VAS_MAQ_CampaignMembersProvider_CLS provider = new CRAN_VAS_MAQ_CampaignMembersProvider_CLS(); 
            CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = 
                (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
            
            system.assert(result.records.size() > 0);            
        }
        
    }     
    
    @isTest static void testDirector() {
        
        Account 		indClient;
        Contact			con;
        User 			advisor;
        User 			director;
        List<Account> 	bp;
        List<Campaign>	campaigns;
        
        System.runAs(new User ( Id = UserInfo.getUserId())) {
            
			director 	= CRAN_VAS_KER_TestDataFactory_TST.createDirector();             
            advisor 	= CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(director.UserRoleId);

            indClient 	= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(advisor.Id);
            con 		= [SELECT Id, AccountId FROM Contact WHERE AccountId =: indClient.Id];
            bp 			= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(advisor.Id);
            
        }
        
        system.runAs(advisor) {     
            campaigns 	= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
            CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(campaigns[0].Id, con.Id, bp[0].Id, UserInfo.getUserId(), 'Worked');            
        }
        
        system.runAs(director) {     

            Map<String, Object> params = new Map<String, Object>();
            params.put('recordId', 		campaigns[0].Id);
            params.put('fieldNames', 	'Name, Status');
            params.put('displayType', 	'advisorRecords');
            params.put('displayLimit', 	'10');
    		params.put('vision', 		'Office');            
            
            CRAN_VAS_MAQ_CampaignMembersProvider_CLS provider = new CRAN_VAS_MAQ_CampaignMembersProvider_CLS();
            
            String providerResult = provider.getRecords(params);
            
            CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = 
                (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(providerResult, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
            
            system.assert(result.records.size() > 0);
            
            CRAN_VAS_KER_Datatable_AUC.deleteRecord(result.records[0][0].value);
        }
        
    }    
}