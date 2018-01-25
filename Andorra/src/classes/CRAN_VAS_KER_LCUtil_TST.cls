@isTest
private class CRAN_VAS_KER_LCUtil_TST {
	
    @isTest
    static void testGetResults() {
        
        CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts();
        
        String clause = ' FROM Account WHERE RecordTypeId =\''  + 
            CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account', 'CRAN_VEC_ADV_Business_Partner') +  '\'';
        
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper results = 
            CRAN_VAS_KER_LCUtil_CLS.getResults('Account', clause, 'Name, LastActivityDate, AnnualRevenue, Type, FinServ__PrimaryContact__c, FinServ__PrimaryContact__r.CreatedDate, Owner.Name', false);
        
        system.debug(results.size > 0);
        
      	results = 
            CRAN_VAS_KER_LCUtil_CLS.getResults('Account', clause, 'Name, LastActivityDate, AnnualRevenue, Type, FinServ__PrimaryContact__c, FinServ__PrimaryContact__r.CreatedDate, Owner.Name');
        
        system.debug(results.size > 0);        
        
    }
    
    @isTest
    static void getPickListValues() {
        system.debug(CRAN_VAS_KER_LCUtil_CLS.getPicklistFieldValues('Account', 'Type'));
    }
    
}