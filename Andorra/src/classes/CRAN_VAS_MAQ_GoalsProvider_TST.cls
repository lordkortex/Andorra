@isTest
private class CRAN_VAS_MAQ_GoalsProvider_TST {
    
    @isTest static void testAdvisorFromCampaign() {
        
        User 			advisor;
        Account 		indClient;
        Contact			con;   
        Opportunity 	objMaq;
        Opportunity 	objSist; 
        List<Campaign> 	campaigns;
        List<Account> 	bp;        
        
            //advisor 	= CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(null); 
            indClient 	= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(UserInfo.getUserId());
            con 		= [SELECT Id FROM Contact WHERE AccountId =: indClient.Id];
            bp 			= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(UserInfo.getUserId());            
        
            campaigns 	= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
            CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(campaigns[0].Id, con.Id, bp[0].Id, UserInfo.getUserId(), 'Worked');
            
            objMaq 	= CRAN_VAS_KER_TestDataFactory_TST.createMarketingGoal('Marketing Goal Test', campaigns[0].Id, indClient.Id);
            objSist = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Sistematica Goal Test', campaigns[1].Id, bp[1].Id, indClient.Id);
            
            List<Opportunity> goals = new List<Opportunity>();
            goals.add(new Opportunity ( Id = objMaq.Id, OwnerId = UserInfo.getUserId()));
            goals.add(new Opportunity ( Id = objSist.Id, OwnerId = UserInfo.getUserId() ));
            
            update goals;                          
                        
          
            Map<String, Object> params = new Map<String, Object>();
            params.put('recordId', 		campaigns[0].Id);
            params.put('fieldNames', 	'Name, StageName');
            params.put('displayType', 	'userRecords');
            params.put('displayLimit', 	'10');
            params.put('vision', 		'User');            
            
            CRAN_VAS_MAQ_GoalsProvider_CLS provider = new CRAN_VAS_MAQ_GoalsProvider_CLS(); 
            CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = 
                (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
            
            system.assert(result.records.size() == 1);      
        
    }
    
    @isTest static void testDirectorFromCampaignMember() {
        
        User 			director;
        User 			advisor;
        Account 		indClient;
        Contact			con;
        Opportunity 	objMaq;
        Opportunity 	objSist;
        CampaignMember	cpMember;
        List<Campaign> 	campaigns;
        List<Account> 	bp;        
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            director 	= CRAN_VAS_KER_TestDataFactory_TST.createDirector();
            advisor 	= CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(director.UserRoleId);
            indClient 	= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(advisor.Id);
            con 		= [SELECT Id, AccountId FROM Contact WHERE AccountId =: indClient.Id];
            bp 			= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(advisor.Id);            
        }
        
        System.runAs(advisor) {     
            campaigns 	= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
            cpMember 	= CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(campaigns[1].Id, con.Id, bp[1].Id, advisor.Id, 'Worked');
        }            
          
        System.runAs( new User(Id = UserInfo.getUserId()) ) {             
            objMaq 	= CRAN_VAS_KER_TestDataFactory_TST.createMarketingGoal('Marketing Goal Test',campaigns[0].Id,indClient.Id);
            objSist = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Sistematica Goal Test', campaigns[1].Id, bp[1].Id, indClient.Id);
            
            List<Opportunity> goals = new List<Opportunity>();
            goals.add(new Opportunity ( Id = objMaq.Id, OwnerId = advisor.Id ));
            goals.add(new Opportunity ( Id = objSist.Id, OwnerId = advisor.Id ));
            
            update goals;            
        }
        
        System.runAs(director) {
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('recordId', 		cpMember.Id);
            params.put('fieldNames', 	'Name, StageName');
            params.put('displayType', 	'advisorRecords');
            params.put('displayLimit', 	'10');
            params.put('vision', 		'Office');              
            
            CRAN_VAS_MAQ_GoalsProvider_CLS provider = new CRAN_VAS_MAQ_GoalsProvider_CLS(); 
            CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = 
                (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
            
            //system.assert(result.records.size() == 1);
        }        
        
    }         
    
    @isTest static void testDirectorOfficeGoalFromCampaign() {
        
        User 			director;
        User 			advisor;
        Account 		indClient;
        Contact			con;   
        Opportunity 	objMaq;
        Opportunity 	objSist;  
        List<Campaign> 	campaigns;
        List<Account> 	bp;        
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            director 	= CRAN_VAS_KER_TestDataFactory_TST.createDirector();
            advisor 	= CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(director.UserRoleId);
            indClient 	= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount(advisor.Id);
            con 		= [SELECT Id, AccountId FROM Contact WHERE AccountId =: indClient.Id];
            bp 			= CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts(advisor.Id);         
        }
        
        System.runAs(advisor) {     
            campaigns 	= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
            CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(campaigns[0].Id, con.Id, bp[0].Id, UserInfo.getUserId(), 'Worked');
        }            
            
        System.runAs( new User(Id = UserInfo.getUserId()) ) {             
            objMaq 	= CRAN_VAS_KER_TestDataFactory_TST.createMarketingGoal('Marketing Goal Test',campaigns[0].Id,indClient.Id);
            objSist = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Sistematica Goal Test', campaigns[1].Id, bp[1].Id, indClient.Id);
            
            List<Opportunity> goals = new List<Opportunity>();
            goals.add(new Opportunity ( Id = objMaq.Id, OwnerId = advisor.Id ));
            goals.add(new Opportunity ( Id = objSist.Id, OwnerId = advisor.Id, CRAN_ICA_KER_P_Oficina__c = '12', CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c = true ));
            
            update goals;               
        }

        System.runAs(director) {           
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('recordId', 		campaigns[1].Id);
            params.put('fieldNames', 	'Name, StageName');
            params.put('displayType', 	'officeRecords');
            params.put('displayLimit', 	'10');
            params.put('vision', 		'Office');           
            
            CRAN_VAS_MAQ_GoalsProvider_CLS provider = new CRAN_VAS_MAQ_GoalsProvider_CLS(); 
            CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = 
                (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
            
            //system.assert(result.records.size() > 0);      
        }        
        
    }       

}