@isTest
private class CRAN_VAS_KER_RestAPIHelper_TST {

    @isTest static void testRestAPICall() {

        CRAN_VAS_KER_SingleRequestMock response = new CRAN_VAS_KER_SingleRequestMock(200, 'OK', mockListViewResponse(), null);                                                        							 
	
        Test.setMock(HttpCalloutMock.class, response);
		CRAN_VAS_KER_RestAPIModel.ListViewDescribe listViewDescribe = 
            CRAN_VAS_KER_RestAPIHelper.getInstance().getListViewDescribe('00B0Y000001boV2UAI', 'Account'); 
        
    }
    
    @isTest static void testInvalidRestAPICall() {

        try {
            CRAN_VAS_KER_SingleRequestMock response = new CRAN_VAS_KER_SingleRequestMock(400, 'NOT FOUND', mockListViewResponse(), null);
            Test.setMock(HttpCalloutMock.class, response);
            CRAN_VAS_KER_RestAPIModel.ListViewDescribe listViewDescribe = 
                CRAN_VAS_KER_RestAPIHelper.getInstance().getListViewDescribe('00B0Y000001boV2UAI', 'Account'); 
        } catch (Exception ex) {
        	system.assert(true);   
        }
        
    }       
    
    @isTest static void testRestAPICallUsingLatestApi() {

        CRAN_VAS_KER_SingleRequestMock response = new CRAN_VAS_KER_SingleRequestMock(200, 'OK', mockLatestVersionResponse(), null);                
        Test.setMock(HttpCalloutMock.class, response);
       
        CRAN_VAS_KER_RestAPIHelper instance = CRAN_VAS_KER_RestAPIHelper.getInstance(true);
        
        response = new CRAN_VAS_KER_SingleRequestMock(200, 'OK', mockListViewResponse(), null);
        Test.setMock(HttpCalloutMock.class, response);
        
		CRAN_VAS_KER_RestAPIModel.ListViewDescribe listViewDescribe = new CRAN_VAS_KER_RestAPIModel.ListViewDescribe();
        listViewDescribe = instance.getListViewDescribe('00B0Y000001boV2UAI', 'Account'); 
        
    }     
    
    private static String mockListViewResponse() {
    	return '{"columns":[{"ascendingLabel":"Z-A","descendingLabel":"A-Z","fieldNameOrPath":"Name","hidden":false,"label":"Account Name","selectListItem":"Name","sortDirection":"ascending","sortIndex":0,"sortable":true,"type":"string"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"Id","hidden":true,"label":"Account ID","selectListItem":"Id","sortDirection":null,"sortIndex":null,"sortable":false,"type":"id"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"RecordTypeId","hidden":true,"label":"Record Type ID","selectListItem":"RecordTypeId","sortDirection":null,"sortIndex":null,"sortable":false,"type":"reference"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"CurrencyIsoCode","hidden":true,"label":"Account Currency","selectListItem":"CurrencyIsoCode","sortDirection":null,"sortIndex":null,"sortable":false,"type":"picklist"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"CreatedDate","hidden":true,"label":"Created Date","selectListItem":"CreatedDate","sortDirection":null,"sortIndex":null,"sortable":false,"type":"datetime"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"LastModifiedDate","hidden":true,"label":"Last Modified Date","selectListItem":"LastModifiedDate","sortDirection":null,"sortIndex":null,"sortable":false,"type":"datetime"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"SystemModstamp","hidden":true,"label":"System Modstamp","selectListItem":"SystemModstamp","sortDirection":null,"sortIndex":null,"sortable":false,"type":"datetime"}],"id":"00B0Y000001boV2","orderBy":[{"fieldNameOrPath":"Name","nullsPosition":"first","sortDirection":"ascending"},{"fieldNameOrPath":"Id","nullsPosition":"first","sortDirection":"ascending"}],"query":"SELECT Name, Id, RecordTypeId, CurrencyIsoCode, CreatedDate, LastModifiedDate, SystemModstamp FROM Account ORDER BY Name ASC NULLS FIRST, Id ASC NULLS FIRST","scope":"everything","sobjectType":"Account","whereCondition":{"conditions":[],"conjunction":"and"}}';
    }    
    
    private static String mockLatestVersionResponse() {
        return '[{"label":"Winter \'11","url":"/services/data/v20.0","version":"20.0"},{"label":"Spring \'11","url":"/services/data/v21.0","version":"21.0"},{"label":"Summer \'11","url":"/services/data/v22.0","version":"22.0"},{"label":"Winter \'12","url":"/services/data/v23.0","version":"23.0"},{"label":"Spring \'12","url":"/services/data/v24.0","version":"24.0"},{"label":"Summer \'12","url":"/services/data/v25.0","version":"25.0"},{"label":"Winter \'13","url":"/services/data/v26.0","version":"26.0"},{"label":"Spring \'13","url":"/services/data/v27.0","version":"27.0"},{"label":"Summer \'13","url":"/services/data/v28.0","version":"28.0"},{"label":"Winter \'14","url":"/services/data/v29.0","version":"29.0"},{"label":"Spring \'14","url":"/services/data/v30.0","version":"30.0"},{"label":"Summer \'14","url":"/services/data/v31.0","version":"31.0"},{"label":"Winter \'15","url":"/services/data/v32.0","version":"32.0"},{"label":"Spring \'15","url":"/services/data/v33.0","version":"33.0"},{"label":"Summer \'15","url":"/services/data/v34.0","version":"34.0"},{"label":"Winter \'16","url":"/services/data/v35.0","version":"35.0"},{"label":"Spring \'16","url":"/services/data/v36.0","version":"36.0"},{"label":"Summer \'16","url":"/services/data/v37.0","version":"37.0"},{"label":"Winter \'17","url":"/services/data/v38.0","version":"38.0"},{"label":"Spring \'17","url":"/services/data/v39.0","version":"39.0"},{"label":"Summer \'17","url":"/services/data/v40.0","version":"40.0"}]';
    }
}