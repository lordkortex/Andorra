@isTest
private class CRAN_VEC_ADV_GenTrx_TST{

	@testSetup 
	static void loadTestData() 
	{
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		List<Order> listaOrdenes = new List<Order>();
		dataFactory.createAvaloqSettingMockTrueExec();		
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = dataFactory.createFS_FinancialAccount(accBP);
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);


	}

	@isTest
	static void genTrxNoSuccess()
	{
		Test.startTest();
		Opportunity myOppId = [SELECT Id FROM Opportunity LIMIT 1];
		CRAN_VEC_ADV_GenTrx_AUC.genTRX(myOppId.Id);
		Test.stopTest();
	}

	@isTest
	static void genTrxSuccess(){
		
  		Test.startTest();
		Opportunity myOppId = [SELECT Id,StageName FROM Opportunity LIMIT 1];
		myOppId.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PROPGEN;
		update myOppId;
		CRAN_VEC_ADV_GenTrx_AUC.genTRX(myOppId.Id);
		Test.stopTest();

	}

	@isTest
	static void genTrxError()
	{
		Test.startTest();
		CRAN_VEC_ADV_GenTrx_AUC.genTRX('');
		Test.stopTest();
	}

	@isTest
	static void genTrxSuccessClass()
	{
		Test.startTest();
		CRAN_VEC_ADV_GenTrx_AUC.SuccessResponse temp = new CRAN_VEC_ADV_GenTrx_AUC.SuccessResponse('');
		Test.stopTest();
	}

	@isTest
	static void updateMediumNoSuccess()
	{
		Test.startTest();
		Opportunity myOppId = [SELECT Id FROM Opportunity LIMIT 1];
		CRAN_VEC_ADV_GenTrx_AUC.updateMedium(myOppId.Id);
		Test.stopTest();
	}

	@isTest
	static void updateMediumSuccess()
	{	
  		Test.startTest();
		Opportunity myOppId = [SELECT Id,StageName,CRAN_VEC_ADV_B_Expired__c,CRAN_VEC_ADV_L_PersonId__c FROM Opportunity LIMIT 1];
        Contact cont = [SELECT Id FROM Contact LIMIT 1];
		myOppId.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PROPGEN;
        myOppId.CRAN_VEC_ADV_B_Expired__c = false;
        myOppId.CRAN_VEC_ADV_L_PersonId__c = cont.Id;
		update myOppId;
		CRAN_VEC_ADV_GenTrx_AUC.updateMedium(myOppId.Id);
		Test.stopTest();

	}

	@isTest
	static void updateMediumError()
	{
		Test.startTest();
		CRAN_VEC_ADV_GenTrx_AUC.updateMedium('');
		Test.stopTest();
	}	

	@isTest
	static void updateMediumException()
	{
		Test.startTest();
		CRAN_VEC_ADV_GenTrx_AUC.ErrorResponse  aux = new CRAN_VEC_ADV_GenTrx_AUC.ErrorResponse(new CalloutException());
		Test.stopTest();
	}	
}