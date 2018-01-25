@isTest
public with sharing class CRAN_VEC_ADV_SignContract_TST {

	@testSetup 
	static void loadTestData() {
		System.debug('loadTestData CRAN_VEC_ADV_SignContract_TST');

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Account acc = dataFactory.createBPAccount();
		dataFactory.createAvaloqSettingMockTrue();
	}
	
	@isTest
	static void CRAN_VEC_ADV_SignContract_TST_signContract() {
		Account acc = [SELECT Id FROM Account];
		CRAN_VEC_ADV_SignContract_AUC.SuccessResponse auxInitResp = (CRAN_VEC_ADV_SignContract_AUC.SuccessResponse)CRAN_VEC_ADV_SignContract_AUC.queryAccountApex(acc.Id);
		System.assertEquals(true,auxInitResp.success);

		Account accResp = auxInitResp.account;
		System.assertEquals(acc.Id,accResp.Id);
		
		Date signDate = Date.today();
		accResp.CRAN_VEC_ADV_D_SignDate__c = signDate;
		CRAN_VEC_ADV_SignContract_AUC.signContractApex(accResp);
		Account accResp2 = auxInitResp.account;
	}

	@isTest 
	static void CRAN_VEC_ADV_SignContract_TST_signContractError() {
		CRAN_VEC_ADV_SignContract_AUC.queryAccountApex('');
		CRAN_VEC_ADV_SignContract_AUC.ErrorResponse auxInitResp = (CRAN_VEC_ADV_SignContract_AUC.ErrorResponse)CRAN_VEC_ADV_SignContract_AUC.queryAccountApex('');
		System.assertEquals(false,auxInitResp.success);
	}
}