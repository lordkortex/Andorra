@isTest
public class CRAS_ICA_ASS_CallAxis_TST {
    @testSetup 
    static void loadTestData() 
    {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }
    
    @isTest  
    static void testCallAxisSuccess()
    {
    	try
    	{
		    List<CRAS_ICA_ASS_ClaimAmountHistory__c> claims = 
		        [SELECT Id FROM CRAS_ICA_ASS_ClaimAmountHistory__c LIMIT 1];
		    
		    String body = 
		        '{"encrypted":"fcFMDb776vw9Ss78ZTSZ82TruLuPM9Lol2EB7QEEd/JT2LsR3Jr7Kb9gD5MYSLZZLYh+BVlwm2b9RNwI/Jgsg4Ak2wYefgXXIY/Gvrc6E902PCteLa6rsTgEoRGkZczcaJqaC4nov5Qa9U0rdm4sOSUS1xxuqfbkdY32TmLxLGbz4OmQ67NQui77okaX2Mwp3qD8ocm/o/GP8JBqt3J4JwHzQMswi8Vc0PT6uMSNuA27B4WMyu0xs7Jy0Ojm2kl5BLwTVi/NyBfjqmgpHPHXfJdznSDXZGRZzY0cYg5GFweabRQKpatdrkuT10a9YNvTSXr4JJWYtYOhsWvYANO2ETppcbcb2Yrdis9TbXeUMLCpd/ZDl4TjLT4sSzDdh/93Lt+2m/wGtesriUAtPXRaog+uTa0cJ9ECnYeAOfBLBfizhUBBi+MK07OU84TPd9FFah8YUtnXI8NYGeGUsrD9BrsD+v0A3zqEs608YD8qq184sy3wyPsU3ZsUUJNoTqcVb0hCxZW1iFuODSORVtrwWUjMyYzWvwKAmqiFQwPpORCWYe2nnopdGEIaf4rh4K2X"}';
		    Map<String, String> headerMap = new Map<String, String>{'Content-Type' => 'application/json'};
		    
		    Test.startTest();
		    Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
		    List<CRAS_ICA_ASS_ClaimDetails_OBJ> claimDetails = CRAS_ICA_ASS_CallAxis_AUC.callAxis(claims[0].Id);
		    Test.stopTest();
		    
		    System.assert(claimDetails.Size() != 0);
        }
        catch(System.CalloutException  e)
        {
        	
        }
        
    }
    
    @isTest  
    static void testCallAxisFail()
    {
    	try
    	{
	        List<CRAS_ICA_ASS_ClaimAmountHistory__c> claims = 
	            [SELECT Id FROM CRAS_ICA_ASS_ClaimAmountHistory__c LIMIT 1];
	        
	        String body = 'Not Found';
	        Map<String, String> headerMap = new Map<String, String>{'Content-Type' => 'application/json'};
	        
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(404, 'Error', body, headerMap));
	        List<CRAS_ICA_ASS_ClaimDetails_OBJ> claimDetails = CRAS_ICA_ASS_CallAxis_AUC.callAxis(claims[0].Id);
	        Test.stopTest();
	        
	        System.assert(claimDetails.Size() == 0);
        }
        catch(System.CalloutException  e)
        {
        	
        } 
    }
    
    @isTest  
    static void testCallAxisNotElement()
    {
        String body = 
            '{"encrypted":"fcFMDb776vw9Ss78ZTSZ82TruLuPM9Lol2EB7QEEd/JT2LsR3Jr7Kb9gD5MYSLZZLYh+BVlwm2b9RNwI/Jgsg4Ak2wYefgXXIY/Gvrc6E902PCteLa6rsTgEoRGkZczcaJqaC4nov5Qa9U0rdm4sOSUS1xxuqfbkdY32TmLxLGbz4OmQ67NQui77okaX2Mwp3qD8ocm/o/GP8JBqt3J4JwHzQMswi8Vc0PT6uMSNuA27B4WMyu0xs7Jy0Ojm2kl5BLwTVi/NyBfjqmgpHPHXfJdznSDXZGRZzY0cYg5GFweabRQKpatdrkuT10a9YNvTSXr4JJWYtYOhsWvYANO2ETppcbcb2Yrdis9TbXeUMLCpd/ZDl4TjLT4sSzDdh/93Lt+2m/wGtesriUAtPXRaog+uTa0cJ9ECnYeAOfBLBfizhUBBi+MK07OU84TPd9FFah8YUtnXI8NYGeGUsrD9BrsD+v0A3zqEs608YD8qq184sy3wyPsU3ZsUUJNoTqcVb0hCxZW1iFuODSORVtrwWUjMyYzWvwKAmqiFQwPpORCWYe2nnopdGEIaf4rh4K2X"}';
        Map<String, String> headerMap = new Map<String, String>{'Content-Type' => 'application/json'};
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
        List<CRAS_ICA_ASS_ClaimDetails_OBJ> claimDetails = CRAS_ICA_ASS_CallAxis_AUC.callAxis('a0n9E0000005N93QAE');
        Test.stopTest();
        
        System.assert(claimDetails.Size() == 0);
        
    }
    
    
    @isTest  
    static void testCallAxisFHSuccess()
    {
    	try
    	{ 
		    String body = 
                '{"encrypted":"94bvbVl/nHk72+Dt3DIIWcpH9Jk0UEWYzBbdlY4oWmo7tSw7GOKGaExiLO53QVfZrwPXUXqDiylwZLRuaBjqjJrkMmOxEYUPFK35vXXAz6JMbsxGeO9KjcJ0RddaWTTndNmxRCkEgZ68ZH9v2rZAgMRHJgK8ONukN0FZeqvBSu+2N6Q6WdipQvvET3XG412ZXDhG1/eC5+u/1M3qvrSQ/b3sNdCF78Aq/naWwA5g05MpdL700tUbEtw6M91NbsrGKp/iNpue7G+SkewDUCQY1Sf6kPFXT0H0BItM/uKDsVJu4ikL3ZdoVLPrafD0mlA7NYRrNAor/hqNCAq2LZ42ozAsW7ZJH3jaWaTBzqhe0OIqP9EOkI69T/7pOA7kccjflK80cLkaKJOUtwIA179YR+89FHjaM6XhHpfvRlvdTP6/UAClhq2R6Q0rGFaih/pH"}';
		    Map<String, String> headerMap = new Map<String, String>{'Content-Type' => 'application/json'};
		    
		    Test.startTest();
		    Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
		    List<FinServ__FinancialHolding__c> fhDetails = CRAS_ICA_ASS_CallFHGuar_CLS.callAxis('26589');
		    Test.stopTest();
		    
		    System.assert(fhDetails.Size() != 0);
        }
        catch(System.CalloutException  e)
        {
        	
        } 
    }
    
    @isTest  
    static void testCallAxisFailFH()
    {
    	try
    	{
	        String body = 'Not Found';
	        Map<String, String> headerMap = new Map<String, String>{'Content-Type' => 'application/json'};
	        
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(404, 'Error', body, headerMap));
	        List<FinServ__FinancialHolding__c> fhDetails = CRAS_ICA_ASS_CallFHGuar_CLS.callAxis('563453');
	        Test.stopTest();
	        
	        System.assert(fhDetails.Size() == 0);
        }
        catch(System.CalloutException  e)
        {
        	
        } 
    }
    
    @isTest  
    static void testCallAxisNotElementFH()
    {
        String body = 
            '{"encrypted":"pWGfZtsXqOreWNmKqwh6+WMPsC66mVRpOeKKuSKz9XyDn6aK6nLI0YpTXYHEtWTwmP5DAQnZw+yLKJ1QFTgQcbs0a8d2XRZqaYWVQJdSwgb3zgBbBbOz7cDLFRTopn9CyU6bJ39sBdKZLY4+tDmQjTUQ6UG1I/hMDzVWIQScnLWYNKjWjA5BhrMtPQkrxu6YgDSTIeshLghV9ON3M7L+HW0sjjkl6P78dLrbgsOhwFhx3IaJ0+UC+FAgwkT+QxlYRnrOrSMcaO5gcf5Ep5Q+nNuSyQlwhq90azsPS5KVF6wBeLpC4qc/7kxVb8tJ+qZB86t7B07L7g3nczULDVwoz5NLvGiwOjhmZKWBCfbEZi60L2HE103uMrNfzAo36iw5vVUmScHf1rIXDqaQslhEpmA3r/sRAOYjg0jDr9NMJLe5otaue12zVbPzjqz1sOCXhAgnSLBfTaDk3y6CZmDLIGSFJQ+oQ3bvjhM9K/9SfHuE8RiJCK3O93Ysg5vvUv32mpqEvwwO7CWu1XirY1oz4Uuzlssb/j1t/g/O08Csu964/esrH3TLSDiLh0JjyLGMd24lDqbki+2WJdUHrXsi7t4VAoQYjKh9oXtfkLCJBNu2vsPEpHcgLPPXyqwHdgkt2rrPVPjJ+r0eAENaXyhAIYLjthx0qVZADKrbDT/wjfCIDk11zKswh7r03a7w8auWfDfSJM5+YbbroEjmBr3BSqMvP/OpzO9U+dqlbnNYryuBV7GNFULWGtVsF++RZTfjZHls1OgBFc3SNe9+wFm1O/HTBSu4znon52syugK0z6IZMJIOvdh0+JIDfPZBaXR5Qrxg1cGHSzBIubApqtio6JL98kSp1U+NhQMtnzKDP8JlLA+MxoPqv8mwI28b2s6zcuaPw0XPM0zt8nPUUtkhYC3Vu00J5CxZY5UwV8HAhDAcAlz9Tv+ojb/lozwm5xhvBBco3wNzBdneHfCn8fJswWGeSjRmbwQTvfRsyTrpCazcDbgUQWwUu+M4FSQQJ0U6Dx61aHFmoqQ/B2Rydyw91Zg9qY4TkGi6A7xr2C46kLz38BHWCUapFTU7TCYvbLWvwzIXaFcnTCfSLAeEgzXdLOjoxlcyz8b+hiN18zdT4QPFtJgweVpdnT/TMdD9bYp4AFdTouRb0y+xcUiLXm4shyZhkiya8hw1o++HnC0rbGkoSJVHIQQh5aMQTSeC5JQ+8wrCMSQA95bBFpky6DLKCPQVIx8rGWwWf9zQxi4uTRLO14f4n8I7RjI+jtSCm3wESsBioOegBP/ihUfzJvUVxu1R64xZivCNspqm74oU/jeI7sEnOqDD9vu43e/fT0ky8sop8RymcWSWTJMuUIvrLU50RiTutrBQvSpeBzRiyzydWbFiKgNQSnRPc/FsV0zqSzB4xsfyeyB5PVeD0JvsREzdAfl5+jjeTHP97/mZ5qm/GdFjcuQSzDuYxUOAYk0DT37zne67qenungkdLzI2KBRG+dywHREZLxlGWqLNbOggeqSHRRj2zFT57VaA8/1RJ8tSDeupjd1IMTl/UXNBpYb9QicbO89Z0YYgnnu4pJ4="}';
        Map<String, String> headerMap = new Map<String, String>{'Content-Type' => 'application/json'};
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
        List<FinServ__FinancialHolding__c> fhDetails = CRAS_ICA_ASS_CallFHGuar_CLS.callAxis('');
        Test.stopTest();
        
        System.assert(fhDetails.Size() == 0);
        
    }
    
}