@isTest
private class CRAN_VEC_ADV_RenovateForm_TST {

	static final SObject accSo = Schema.getGlobalDescribe().get('Account').newSObject();
	static final CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

	@testSetup 
	static void loadTestData() {
		Contact c = dataFactory.createIndividualContactWithTwoBps();
		CRAN_VEC_ADV_CustomForm__c cf = dataFactory.create_CustomForm_TemplatePF();
		dataFactory.addCustomFormResponse(cf.Id,c.Id);
		dataFactory.createAvaloqSetting();
	}
	
	@isTest 
	static void CRAN_VEC_ADV_RenovateForm_TST_getForms() {
		Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
		ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(accSo,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
		Account bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
		List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

		CRAN_VEC_ADV_RenovateForm_AUC.initApex(c.AccountId);
		dataFactory.createAvaloqSettingMockTrue();

		Test.startTest();
		CRAN_VEC_ADV_RenovateForm_AUC.recuperarCuestionariosRespond(bp.Id);
		Test.stopTest();
	}

	@isTest 
	static void CRAN_VEC_ADV_RenovateForm_TST_test_renovateForm() {
		Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
		ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(accSo,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
		Account bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
		List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

		CRAN_VEC_ADV_RenovateForm_AUC.initApex(c.AccountId);

		dataFactory.createAvaloqSettingMockTrue();
		Test.startTest();
		CRAN_VEC_ADV_RenovateForm_AUC.crearOrdenModificacionCuestionarioRespond('9_9000001','B00001',c.Id,'C00002');
		Test.stopTest();
		
	}

	@isTest 
	static void CRAN_VEC_ADV_RenovateForm_TST_test_Error() {
		CRAN_VEC_ADV_RenovateForm_AUC.ErrorResponse er = new CRAN_VEC_ADV_RenovateForm_AUC.ErrorResponse('Error');
	}

	@isTest 
	static void CRAN_VEC_ADV_RenovateForm_TST_getFormsEmpty() {
		Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
		ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(accSo,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
		Account bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
		List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

		CRAN_VEC_ADV_RenovateForm_AUC.initApex(c.AccountId);

		dataFactory.createAvaloqSettingMockTrue();
		Test.startTest();
		CRAN_VEC_ADV_RenovateForm_AUC.recuperarCuestionariosRespond(bp.Id);
		Test.stopTest();
		
	}

		@isTest 
	static void CRAN_VEC_ADV_RenovateForm_TST_getFormsOnlyErrors() {
		Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
		ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(accSo,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
		Account bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
		List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

		CRAN_VEC_ADV_RenovateForm_AUC.initApex(c.AccountId);

		dataFactory.createAvaloqSettingMockTrue();
		Test.startTest();
		CRAN_VEC_ADV_RenovateForm_AUC.recuperarCuestionariosRespond(bp.Id);
		Test.stopTest();
		
	}

	@isTest 
	static void CRAN_VEC_ADV_RenovateForm_TST_renovateFormEmpty() {
		Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
		ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(accSo,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
		Account bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
		List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

		CRAN_VEC_ADV_RenovateForm_AUC.initApex(c.AccountId);

		dataFactory.createAvaloqSettingMockTrue();
		Test.startTest();
		CRAN_VEC_ADV_RenovateForm_AUC.crearOrdenModificacionCuestionarioRespond('9_9000001','B00001',c.Id,'C00002');
		Test.stopTest();
		
	}

	@isTest 
	static void CRAN_VEC_ADV_RenovateForm_TST_renovateFormFull() {
		Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
		ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(accSo,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
		Account bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
		List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

		CRAN_VEC_ADV_RenovateForm_AUC.initApex(c.AccountId);
		dataFactory.createAvaloqSettingMockTrue();
		Test.startTest();
		CRAN_VEC_ADV_RenovateForm_AUC.crearOrdenModificacionCuestionarioRespond('9_9000001','B00001',c.Id,'C00002');
		Test.stopTest();
		
	}

	@isTest 
	static void CRAN_VEC_ADV_RenovateForm_TST_renovateOnlyErrors() {
		Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
		ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(accSo,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
		Account bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
		List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

		CRAN_VEC_ADV_RenovateForm_AUC.initApex(c.AccountId);
		dataFactory.createAvaloqSettingMockTrue();
		//Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST('renovateOnlyErrors'));
		Test.startTest();
		CRAN_VEC_ADV_RenovateForm_AUC.crearOrdenModificacionCuestionarioRespond('9_9000001','B00001',c.Id,'C00002');
		Test.stopTest();
	}


}