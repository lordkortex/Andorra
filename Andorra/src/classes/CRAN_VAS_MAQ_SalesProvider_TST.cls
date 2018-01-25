@isTest
private class CRAN_VAS_MAQ_SalesProvider_TST {
    
    @isTest static void testAdvisorFromCampaign() {
        
        User 			advisor;
        Account 		indClient;
        Contact 		con;
        CampaignMember	cpMember;
        List<Account> 	bp;
        List<Campaign> 	campaigns;
                   
        	//advisor 	= CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(null); 
            indClient 	= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(UserInfo.getUserId());
            con 		= [SELECT Id, AccountId FROM Contact WHERE AccountId =: indClient.Id];
            bp 			= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(UserInfo.getUserId());  
                    
            
            campaigns 	= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
            cpMember 	= CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(campaigns[1].Id, con.Id, bp[0].Id, UserInfo.getUserId(), 'Worked');
            
            List<Opportunity> sales = new List<Opportunity>();
            insert CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale('Sale 4 Test', campaigns[1].Id, bp[0].Id, indClient.Id, null, false);
        
        Opportunity sale = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale('Sale 5 Test', campaigns[1].Id, bp[0].Id, indClient.Id, null, false);
        insert sale;
        insert new OpportunityTeamMember (OpportunityId = sale.Id, 
                                          UserId = UserInfo.getUserId(), 
                                          TeamMemberRole = 'Sales Manager',
                                          OpportunityAccessLevel = 'Read'); 
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('recordId', 		campaigns[1].Id);
            params.put('fieldNames', 	'Name, StageName');
            params.put('displayType', 	'userRecords');
            params.put('displayLimit', 	'10');
            params.put('vision', 		'User');
            
            CRAN_VAS_MAQ_SalesProvider_CLS provider = new CRAN_VAS_MAQ_SalesProvider_CLS(); 
            CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = 
                (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
            
            system.assert(result.records.size() > 0);   
            
            params.put('recordId', cpMember.Id);
            
            provider 	= new CRAN_VAS_MAQ_SalesProvider_CLS(); 
            result 		= (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), 
                                                                                   CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
            
            system.assert(result.records.size() > 0);
        
    }  
    
    @isTest static void testDirectorFromCampaign() {
        
        User 			director;
        User 			advisor;
        List<Campaign> 	campaigns;
        Account 		indClient;
        Contact 		con;
        List<Account> 	bp;
		CampaignMember	cpMember;     
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            director 	= CRAN_VAS_KER_TestDataFactory_TST.createDirector();
            advisor 	= CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(director.UserRoleId);
                
            indClient 	= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(advisor.Id);
            con 		= [SELECT Id, AccountId FROM Contact WHERE AccountId =: indClient.Id];
            bp 			= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(advisor.Id);                 
        }
        
        system.runAs(advisor) {     
            
            campaigns 	= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
            cpMember 	= CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(campaigns[1].Id, con.Id, bp[0].Id, advisor.Id, 'Worked');
            
            List<Opportunity> sales = new List<Opportunity>();
            sales.add(CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale('Sale 4 Test', campaigns[1].Id, bp[0].Id, indClient.Id, null, false));
            sales.add(CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale('Sale 5 Test', campaigns[1].Id, bp[0].Id, indClient.Id, null, false));
            insert sales;            
        }            

        Test.startTest();
        
        system.runAs(director) {
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('recordId', 		campaigns[1].Id);
            params.put('fieldNames', 	'Name, StageName');
            params.put('displayType', 	'advisorRecords');
            params.put('displayLimit', 	'10');
            params.put('vision', 		'Office');
            
            CRAN_VAS_MAQ_SalesProvider_CLS provider = new CRAN_VAS_MAQ_SalesProvider_CLS(); 
            CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = 
                (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
            
            if(result!=null && result.records!=null){
            	system.assert(result.records.size() > 0);    
            }
            
            
            params.put('recordId', cpMember.Id);
            
            provider 	= new CRAN_VAS_MAQ_SalesProvider_CLS(); 
            result 		= (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), 
                                                                         CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
            
            if(result!=null && result.records!=null){
            	system.assert(result.records.size() > 0);    
            }
            
     
        }
        
		Test.stopTest();              
        
    }

}