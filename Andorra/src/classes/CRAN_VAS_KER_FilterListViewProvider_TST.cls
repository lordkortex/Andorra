@isTest
private class CRAN_VAS_KER_FilterListViewProvider_TST {
    
    @testSetup
    static void testSetup() {
        CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount();
    }

    @isTest static void testGetListViewData() {

        Contact	con = [SELECT Id FROM Contact LIMIT 1];        
        
        Map<String, Object>	params = new Map<String, Object>();
        params.put('recordId', con.Id);
        params.put('sObjectApiName', 'Account');        
        params.put('listViewName', 'All');
        params.put('parentFieldApiName', 'AccountId');
        params.put('childFieldApiName', 'Id');
        params.put('displayLimit', '10'); 
        
        CRAN_VAS_KER_SingleRequestMock response = new CRAN_VAS_KER_SingleRequestMock(200, 'OK', mockResponse(), null);                                                        							 
	
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, response);

        CRAN_VAS_KER_FilterListViewProvider_CLS provider = new CRAN_VAS_KER_FilterListViewProvider_CLS();
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = 
            (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
        
        system.assert(result.records.size() > 0); 
        
        Test.stopTest();
    
    }       
    
    @isTest static void testGetSObjectData() {
        
        Account indClient = [SELECT Id FROM Account];
        
        Map<String, Object>	params = new Map<String, Object>();
        params.put('recordId'			, indClient.Id);
        params.put('sObjectApiName'		, 'Account');        
        params.put('strFieldApiNames'	, 'Name, Type');
        params.put('childFieldApiName'	, 'Id');
        params.put('displayLimit'		, '10'); 
        
        CRAN_VAS_KER_FilterListViewProvider_CLS provider = new CRAN_VAS_KER_FilterListViewProvider_CLS();

        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = 
            (CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper)JSON.deserialize(provider.getRecords(params), CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper.class);
        
        system.assert(result.records.size() > 0); 
    
    }   
    
    private static String mockResponse() {
		return '{"columns":[{"ascendingLabel":"Z-A","descendingLabel":"A-Z","fieldNameOrPath":"Name","hidden":false,"label":"Account Name","selectListItem":"Name","sortDirection":"ascending","sortIndex":0,"sortable":true,"type":"string"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"Id","hidden":true,"label":"Account ID","selectListItem":"Id","sortDirection":null,"sortIndex":null,"sortable":false,"type":"id"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"RecordTypeId","hidden":true,"label":"Record Type ID","selectListItem":"RecordTypeId","sortDirection":null,"sortIndex":null,"sortable":false,"type":"reference"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"CurrencyIsoCode","hidden":true,"label":"Account Currency","selectListItem":"CurrencyIsoCode","sortDirection":null,"sortIndex":null,"sortable":false,"type":"picklist"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"CreatedDate","hidden":true,"label":"Created Date","selectListItem":"CreatedDate","sortDirection":null,"sortIndex":null,"sortable":false,"type":"datetime"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"LastModifiedDate","hidden":true,"label":"Last Modified Date","selectListItem":"LastModifiedDate","sortDirection":null,"sortIndex":null,"sortable":false,"type":"datetime"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"SystemModstamp","hidden":true,"label":"System Modstamp","selectListItem":"SystemModstamp","sortDirection":null,"sortIndex":null,"sortable":false,"type":"datetime"}],"id":"00B0Y000001boV2","orderBy":[{"fieldNameOrPath":"Name","nullsPosition":"first","sortDirection":"ascending"},{"fieldNameOrPath":"Id","nullsPosition":"first","sortDirection":"ascending"}],"query":"SELECT Name, Id, RecordTypeId, CurrencyIsoCode, CreatedDate, LastModifiedDate, SystemModstamp FROM Account WHERE Id <> NULL ORDER BY Id ASC NULLS FIRST","scope":"everything","sobjectType":"Account","whereCondition":{"conditions":[],"conjunction":"and"}}';
    }    	
    
}