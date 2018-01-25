@isTest
private class CRAN_VEC_ADV_newForm_TST {

	@testSetup 
	static void loadTestData() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact c = dataFactory.createIndividualContactWithTwoBps();
		CRAN_VEC_ADV_CustomForm__c cf = dataFactory.create_CustomForm_TemplatePF();
		dataFactory.addCustomFormResponse(cf.Id,c.Id);
		dataFactory.createAvaloqSetting();
	}
	
	@isTest 
	static void CRAN_VEC_ADV_newForm_TST_test() {
 		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
		Account bp = new Account();
		ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(bp,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
		bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
		List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

		CRAN_VEC_ADV_newForm_AUC.initApex(c.AccountId);

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST('newForm'));
		dataFactory.createAvaloqSettingMockTrue();
		Test.startTest();
		CRAN_VEC_ADV_newForm_AUC.callApexAvaloqNewForm(bp.Id,c.Id,lstCustomForms[0].Id,false);
		CRAN_VEC_ADV_newForm_AUC.callApexAvaloqNewForm(bp.Id,c.Id,lstCustomForms[0].Id,true);
		Test.stopTest();
		
		try{
			CRAN_VEC_ADV_newForm_AUC.callApexAvaloqNewForm('','','',true);
		}catch(Exception e){
			System.debug('OK test ErrorResponse');
		}
	}
}