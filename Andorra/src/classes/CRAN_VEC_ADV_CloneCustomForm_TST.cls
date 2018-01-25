/**
 * CRAN_VEC_ADV_RestClient_CLS generic Rest client manager
 *
 * Fecha: 18/01/2017
 * @author  Iñaki Hernando Urcullu (Cloud Coachers)
 * @version 1.0
 *
*/
@isTest
private class CRAN_VEC_ADV_CloneCustomForm_TST
{
	@testSetup 
	static void loadTestData() {
		System.debug('loadTestData CRAN_VEC_ADV_CustomForm_TST');
        
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact c = dataFactory.createIndividualContactWithTwoBps();
        
        CRAN_VEC_ADV_CustomForm__c cf= dataFactory.create_CustomForm_TemplatePF();
        CRAN_VEC_ADV_CustomForm_Response__c cfr = dataFactory.addCustomFormResponse(cf.Id,c.Id);

        dataFactory.createAvaloqSetting();
	}

	@isTest
	static void itShould()
	{
		// Given
		CRAN_VEC_ADV_CustomForm__c cf = [SELECT ID FROM CRAN_VEC_ADV_CustomForm__c];
		CRAN_VEC_ADV_CloneCustomForm_AUC.cloneCustomForm(cf.Id);
	}

	@isTest
	static void ErrorCloneCustomForm_test(){
		CRAN_VEC_ADV_CloneCustomForm_AUC.ErrorCloneCustomForm error = new CRAN_VEC_ADV_CloneCustomForm_AUC.ErrorCloneCustomForm('Error');

	}
}