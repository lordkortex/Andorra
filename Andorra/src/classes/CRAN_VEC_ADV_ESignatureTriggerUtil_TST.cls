/**
 * Clase de test de la clase CRAN_VEC_ADV_ESignatureTriggerUtil y sus servicios closeOportunity y orderconfirm.
 *
 * Fecha: 15/06/2017
 * @author  Javier Touchard Vicente (Vector ITC)
 * @version 1.0
 *
*/


@isTest
private class CRAN_VEC_ADV_ESignatureTriggerUtil_TST {
	
	@isTest 
	static void gestionObjetosRelacionadosProposal_Test() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrue();
		List<CRAN_VAS_KER_ESignature__c> listaESignature = new List<CRAN_VAS_KER_ESignature__c>();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		CRAN_VAS_KER_ESignature__c eSignature1 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope1', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature1);
		CRAN_VAS_KER_ESignature__c eSignature2 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope2', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature2);
		CRAN_VAS_KER_ESignature__c eSignature3 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope3', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature3);
		CRAN_VAS_KER_ESignature__c eSignature4 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope4', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature4);
		CRAN_VAS_KER_ESignature__c eSignature5 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope5', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature5);
		CRAN_VAS_KER_ESignature__c eSignature6 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope6', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature6);
		CRAN_VAS_KER_ESignature__c eSignature7 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope7', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature7);
		CRAN_VAS_KER_ESignature__c eSignature8 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope8', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature8);
		CRAN_VAS_KER_ESignature__c eSignature9 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope9', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature9);
		CRAN_VAS_KER_ESignature__c eSignature10 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope10', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature10);
		CRAN_VAS_KER_ESignature__c eSignature11 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope11', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature11);
		CRAN_VAS_KER_ESignature__c eSignature12 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope12', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature12);
		insert listaESignature;	

		for(CRAN_VAS_KER_ESignature__c es : listaESignature){
			es.CRAN_VAS_KER_Status__c = 'Sent to Archive';
		}

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_CLOSE_OPORTUNIDAD));
  		Test.startTest();
		update listaESignature;
		Test.stopTest();
		
	}

	@isTest 
	static void gestionObjetosRelacionadosProposal_Test2() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrueExec();
		List<CRAN_VAS_KER_ESignature__c> listaESignature = new List<CRAN_VAS_KER_ESignature__c>();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		CRAN_VAS_KER_ESignature__c eSignature1 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope1', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature1);
		CRAN_VAS_KER_ESignature__c eSignature2 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope2', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature2);
		CRAN_VAS_KER_ESignature__c eSignature3 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope3', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature3);
		CRAN_VAS_KER_ESignature__c eSignature4 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope4', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature4);
		CRAN_VAS_KER_ESignature__c eSignature5 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope5', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature5);
		CRAN_VAS_KER_ESignature__c eSignature6 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope6', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature6);
		CRAN_VAS_KER_ESignature__c eSignature7 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope7', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature7);
		CRAN_VAS_KER_ESignature__c eSignature8 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope8', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature8);
		CRAN_VAS_KER_ESignature__c eSignature9 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope9', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature9);
		CRAN_VAS_KER_ESignature__c eSignature10 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope10', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature10);
		CRAN_VAS_KER_ESignature__c eSignature11 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope11', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature11);
		CRAN_VAS_KER_ESignature__c eSignature12 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope12', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature12);
		insert listaESignature;	

		for(CRAN_VAS_KER_ESignature__c es : listaESignature){
			es.CRAN_VAS_KER_Status__c = 'Sent to Archive';
		}

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_CLOSE_OPORTUNIDAD));
  		Test.startTest();
		update listaESignature;
		Test.stopTest();
		
	}


	@isTest 
	static void gestionObjetosRelacionadosProposal_Test3() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		List<CRAN_VAS_KER_ESignature__c> listaESignature = new List<CRAN_VAS_KER_ESignature__c>();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		CRAN_VAS_KER_ESignature__c eSignature1 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope1', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature1);
		CRAN_VAS_KER_ESignature__c eSignature2 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope2', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature2);
		CRAN_VAS_KER_ESignature__c eSignature3 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope3', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature3);
		CRAN_VAS_KER_ESignature__c eSignature4 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope4', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature4);
		CRAN_VAS_KER_ESignature__c eSignature5 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope5', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature5);
		CRAN_VAS_KER_ESignature__c eSignature6 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope6', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature6);
		CRAN_VAS_KER_ESignature__c eSignature7 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope7', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature7);
		CRAN_VAS_KER_ESignature__c eSignature8 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope8', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature8);
		CRAN_VAS_KER_ESignature__c eSignature9 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope9', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature9);
		CRAN_VAS_KER_ESignature__c eSignature10 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope10', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature10);
		CRAN_VAS_KER_ESignature__c eSignature11 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope11', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature11);
		CRAN_VAS_KER_ESignature__c eSignature12 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Opportunity__c = opp.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope12', CRAN_VAS_KER_Signature_Type__c = 'Proposal');
		listaESignature.add(eSignature12);
		insert listaESignature;	

		for(CRAN_VAS_KER_ESignature__c es : listaESignature){
			es.CRAN_VAS_KER_Status__c = 'Sent to Archive';
		}

  		Test.startTest();
		update listaESignature;
		Test.stopTest();
		
	}


	@isTest 
	static void gestionObjetosRelacionadosUpdateOpportunityError_Test1() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrue();
		List<CRAN_VAS_KER_ESignature__c> listaESignature = new List<CRAN_VAS_KER_ESignature__c>();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);

  		Test.startTest();
		CRAN_VEC_ADV_ESignatureTriggerUtil.updateOpportunityError('Error', 'Code', opp, null);
		Test.stopTest();
		
	}


	@isTest 
	static void gestionObjetosRelacionadosUpdateOpportunityError_Test2() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrue();
		List<CRAN_VAS_KER_ESignature__c> listaESignature = new List<CRAN_VAS_KER_ESignature__c>();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		List<CRAN_VEC_ADV_ProcessSTError_CLS > errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS >();
		CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
		error.setCode('code');
		error.setDesc('descError');
		errors.add(error);

  		Test.startTest();
		CRAN_VEC_ADV_ESignatureTriggerUtil.updateOpportunityError(null, null, opp, errors);
		Test.stopTest();
		
	}

	
	@isTest 
	static void gestionObjetosRelacionadosOrder_Automatic_OK_Test() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrueExec();
		List<CRAN_VAS_KER_ESignature__c> listaESignature = new List<CRAN_VAS_KER_ESignature__c>();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		List<Order> orderList = new List<Order>();
		Order orden1 = dataFactory.createrOrderSimulated();
		orden1.OpportunityId = opp.Id;
		orden1.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden1.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden1.CRAN_VEC_ADV_B_ExecuteToConfirm__c = true;
		orderList.add(orden1);
		update orderList;
		CRAN_VAS_KER_ESignature__c eSignature1 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Order__c = orden1.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope13', CRAN_VAS_KER_Signature_Type__c = 'Order');

		insert eSignature1;
        eSignature1.CRAN_VAS_KER_Status__c = 'Sent to Archive';

  		Test.startTest();
		update eSignature1;
		Test.stopTest();
		
	}


	@isTest 
	static void gestionObjetosRelacionadosOrder_Automatic_Ok_Test2() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrue(); 
		List<CRAN_VAS_KER_ESignature__c> listaESignature = new List<CRAN_VAS_KER_ESignature__c>();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		List<Order> orderList = new List<Order>();
		Order orden1 = dataFactory.createrOrderSimulated();
		orden1.OpportunityId = opp.Id;
		orden1.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden1.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden1.CRAN_VEC_ADV_B_ExecuteToConfirm__c = true;
		orderList.add(orden1);
		update orderList;
		CRAN_VAS_KER_ESignature__c eSignature1 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Order__c = orden1.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope13', CRAN_VAS_KER_Signature_Type__c = 'Order');

		insert eSignature1;
        eSignature1.CRAN_VAS_KER_Status__c = 'Sent to Archive';

  		Test.startTest();
		update eSignature1;
		Test.stopTest();
		
	}


	@isTest 
	static void gestionObjetosRelacionadosOrder_Automatic_Ok_Test3() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrueExec();
		List<CRAN_VAS_KER_ESignature__c> listaESignature = new List<CRAN_VAS_KER_ESignature__c>();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		List<Order> orderList = new List<Order>();
		Order orden1 = dataFactory.createrOrderSimulated();
		orden1.OpportunityId = opp.Id;
		orden1.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden1.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden1.CRAN_VEC_ADV_B_ExecuteToConfirm__c = true;
		orderList.add(orden1);
		Order orden2 = dataFactory.createrOrderSimulated();
		orden2.OpportunityId = opp.Id;
		orden2.CRAN_VEC_ADV_T_OrderId__c = '1111';
		orden2.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden2.CRAN_VEC_ADV_B_ExecuteToConfirm__c = true;
		orderList.add(orden2);
		update orderList;
		CRAN_VAS_KER_ESignature__c eSignature1 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Order__c = orden1.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope13', CRAN_VAS_KER_Signature_Type__c = 'Order');

		insert eSignature1;
        eSignature1.CRAN_VAS_KER_Status__c = 'Sent to Archive';

  		Test.startTest();
		update eSignature1;
		Test.stopTest();
		
	}


	@isTest 
	static void gestionObjetosRelacionadosOrder_Manual_Test1() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrueExec();
		List<CRAN_VAS_KER_ESignature__c> listaESignature = new List<CRAN_VAS_KER_ESignature__c>();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		List<Order> orderList = new List<Order>();
		Order orden1 = dataFactory.createrOrderSimulated();
		orden1.OpportunityId = opp.Id;
		orden1.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden1.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden1.CRAN_VEC_ADV_B_ExecuteToConfirm__c = true;
		orden1.CRAN_VEC_ADV_B_ManualConfirm__c = true;
		orderList.add(orden1);
		update orderList;
		CRAN_VAS_KER_ESignature__c eSignature1 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Order__c = orden1.Id, 
			                                     CRAN_VAS_KER_Status__c = 'In Progress', CRAN_VAS_KER_File_Name__c = 'Envelope13', CRAN_VAS_KER_Signature_Type__c = 'Order');

		insert eSignature1;
        eSignature1.CRAN_VAS_KER_Status__c = 'Sent to Archive';

  		Test.startTest();
		update eSignature1;
		Test.stopTest();
		
	}


	@isTest 
	static void gestionObjetosRelacionadosForm_Test() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
        CRAN_VEC_ADV_CustomForm__c cf= dataFactory.create_CustomForm_TemplatePF();
        CRAN_VEC_ADV_CustomForm_Response__c cfr = dataFactory.addCustomFormResponse(cf.Id,mainContact.Id);
        cfr.CRAN_VEC_ADV_T_Avaloq_External_Id__c = '1111';
        update cfr;

		CRAN_VAS_KER_ESignature__c eSignature1 = new CRAN_VAS_KER_ESignature__c(CRAN_VAS_KER_Account__c = accBP.Id, CRAN_VAS_KER_Status__c = 'In Progress', 
			                                                                    CRAN_VAS_KER_File_Name__c = 'Envelope13', CRAN_VAS_KER_Signature_Type__c = 'Form', 
			                                                                    CRAN_VAS_KER_Core_Id__c = '1111');

		insert eSignature1;
        eSignature1.CRAN_VAS_KER_Status__c = 'Sent to Archive';

  		Test.startTest();
		update eSignature1;
		Test.stopTest();
		
	}


	@isTest 
	static void orderConfirm_Test1() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		finAcc.FinServ__FinancialAccountNumber__c = '1111';
		update finAcc;
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		Order order = dataFactory.createrOrderSimulated();
		order.CRAN_VEC_ADV_T_OrderId__c = '1111';
		order.OpportunityId = opp.Id;
		List<Order> listaOrdenes = new List<Order> (); 
 		listaOrdenes.add(order);
 		update listaOrdenes;
		Map<Id, Id> mapa = new Map<Id, Id>();
		mapa.put(mainContact.Id,mainContact.Id);

		listaOrdenes = [SELECT Id,	CRAN_VEC_ADV_T_OrderId__c, Opportunity.Name, Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c, OpportunityId, CRAN_VEC_ADV_B_ManualConfirm__c
		         FROM Order 
		         WHERE OpportunityId =: opp.Id 
		        ];

        CRAN_VEC_ADV_OrderConfirm_RS result = new CRAN_VEC_ADV_OrderConfirm_RS();
        CRAN_VEC_ADV_OrderPrintList_CLS order2 = new CRAN_VEC_ADV_OrderPrintList_CLS();
        order2.orderNr = '1111';
        List<CRAN_VEC_ADV_OrderPrintList_CLS> orderList = new List<CRAN_VEC_ADV_OrderPrintList_CLS>();
        orderList.add(order2);
        
        result.orderList = orderList;

		CRAN_VEC_ADV_OrderConfirm colas = new CRAN_VEC_ADV_OrderConfirm(listaOrdenes,mapa);
		colas.manageResultConfirm(result);
	}


	@isTest 
	static void orderConfirm_Test2() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		finAcc.FinServ__FinancialAccountNumber__c = '1111';
		update finAcc;
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		Order order = dataFactory.createrOrderSimulated();
		order.CRAN_VEC_ADV_T_OrderId__c = '1111';
		order.OpportunityId = opp.Id;
		List<Order> listaOrdenes = new List<Order> (); 
 		listaOrdenes.add(order);
 		update listaOrdenes;
		Map<Id, Id> mapa = new Map<Id, Id>();
		mapa.put(mainContact.Id,mainContact.Id);

		listaOrdenes = [SELECT Id,	CRAN_VEC_ADV_T_OrderId__c, Opportunity.Name, Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c, OpportunityId, CRAN_VEC_ADV_B_ManualConfirm__c
		         FROM Order 
		         WHERE OpportunityId =: opp.Id 
		        ];

		CRAN_VEC_ADV_OrderConfirm colas = new CRAN_VEC_ADV_OrderConfirm(listaOrdenes,mapa);
		colas.manageResultConfirm(null);
	}


	@isTest 
	static void orderConfirm_Test3() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		finAcc.FinServ__FinancialAccountNumber__c = '1111';
		update finAcc;
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		Order order = dataFactory.createrOrderSimulated();
		order.CRAN_VEC_ADV_T_OrderId__c = '1111';
		order.OpportunityId = opp.Id;
		List<Order> listaOrdenes = new List<Order> (); 
 		listaOrdenes.add(order);
 		update listaOrdenes;
		Map<Id, Id> mapa = new Map<Id, Id>();
		mapa.put(mainContact.Id,mainContact.Id);

		listaOrdenes = [SELECT Id,	CRAN_VEC_ADV_T_OrderId__c, Opportunity.Name, Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c, OpportunityId, CRAN_VEC_ADV_B_ManualConfirm__c
		         FROM Order 
		         WHERE OpportunityId =: opp.Id 
		        ];

        CRAN_VEC_ADV_OrderConfirm_RS result = new CRAN_VEC_ADV_OrderConfirm_RS();
        CRAN_VEC_ADV_OrderPrintList_CLS order2 = new CRAN_VEC_ADV_OrderPrintList_CLS();
        order2.orderNr = '1111';
        List<CRAN_VEC_ADV_OrderPrintList_CLS> orderList = new List<CRAN_VEC_ADV_OrderPrintList_CLS>();
        orderList.add(order2);        
        result.orderList = orderList;

        List<CRAN_VEC_ADV_ProcessSTError_CLS> errorList = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
        CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
        error.setDesc('Error');
        errorList.add(error);
        result.errors = errorList;


		CRAN_VEC_ADV_OrderConfirm colas = new CRAN_VEC_ADV_OrderConfirm(listaOrdenes,mapa);
		colas.manageResultChangeStatus(result);
	}


	@isTest 
	static void orderConfirm_Test4() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		finAcc.FinServ__FinancialAccountNumber__c = '1111';
		update finAcc;
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		Order order = dataFactory.createrOrderSimulated();
		order.CRAN_VEC_ADV_T_OrderId__c = '1111';
		order.OpportunityId = opp.Id;
		List<Order> listaOrdenes = new List<Order> (); 
 		listaOrdenes.add(order);
 		update listaOrdenes;
		Map<Id, Id> mapa = new Map<Id, Id>();
		mapa.put(mainContact.Id,mainContact.Id);

		listaOrdenes = [SELECT Id,	CRAN_VEC_ADV_T_OrderId__c, Opportunity.Name, Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c, OpportunityId, CRAN_VEC_ADV_B_ManualConfirm__c
		         FROM Order 
		         WHERE OpportunityId =: opp.Id 
		        ];

        CRAN_VEC_ADV_OrderConfirm_RS result = new CRAN_VEC_ADV_OrderConfirm_RS();
        CRAN_VEC_ADV_OrderPrintList_CLS order2 = new CRAN_VEC_ADV_OrderPrintList_CLS();
        order2.orderNr = '1111';
        List<CRAN_VEC_ADV_OrderPrintList_CLS> orderList = new List<CRAN_VEC_ADV_OrderPrintList_CLS>();
        orderList.add(order2);        
        result.orderList = orderList;

		CRAN_VEC_ADV_OrderConfirm colas = new CRAN_VEC_ADV_OrderConfirm(listaOrdenes,mapa);
		colas.manageResultChangeStatus(result);
	}


	@isTest 
	static void orderConfirm_Test5() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		finAcc.FinServ__FinancialAccountNumber__c = '1111';
		update finAcc;
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		Order order = dataFactory.createrOrderSimulated();
		order.CRAN_VEC_ADV_T_OrderId__c = '1111';
		order.OpportunityId = opp.Id;
		List<Order> listaOrdenes = new List<Order> (); 
 		listaOrdenes.add(order);
 		update listaOrdenes;
		Map<Id, Id> mapa = new Map<Id, Id>();
		mapa.put(mainContact.Id,mainContact.Id);

		listaOrdenes = [SELECT Id,	CRAN_VEC_ADV_T_OrderId__c, Opportunity.Name, Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c, OpportunityId, CRAN_VEC_ADV_B_ManualConfirm__c
		         FROM Order 
		         WHERE OpportunityId =: opp.Id 
		        ];

		CRAN_VEC_ADV_OrderConfirm colas = new CRAN_VEC_ADV_OrderConfirm(listaOrdenes,mapa);
		colas.manageResultChangeStatus(null);
	}


	@isTest 
	static void closeOpp_Test1() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		finAcc.FinServ__FinancialAccountNumber__c = '1111';
		update finAcc;
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		opp.CRAN_VEC_ADV_T_AvaloqPropId__c = '1111';
		update opp;	

		opp = [SELECT Id, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c, Name, FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c 
		                                        FROM Opportunity 
		                                        WHERE Id =: opp.Id 
		                                        ];	

		CRAN_VEC_ADV_CloseOpp colas = new CRAN_VEC_ADV_CloseOpp(opp,mainContact.Id);
		colas.manageResult(null);
	}


	@isTest 
	static void closeOpp_Test2() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		finAcc.FinServ__FinancialAccountNumber__c = '1111';
		update finAcc;
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		opp.CRAN_VEC_ADV_T_AvaloqPropId__c = '1111';
		update opp;

		opp = [SELECT Id, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c, Name, FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c 
		                                        FROM Opportunity 
		                                        WHERE Id =: opp.Id 
		                                        ];
		
        CRAN_VEC_ADV_RebalpRS result = new CRAN_VEC_ADV_RebalpRS();

		CRAN_VEC_ADV_CloseOpp colas = new CRAN_VEC_ADV_CloseOpp(opp,mainContact.Id);
		colas.manageResult(result);
	}


	@isTest 
	static void closeOpp_Test3() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		finAcc.FinServ__FinancialAccountNumber__c = '1111';
		update finAcc;
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		opp.CRAN_VEC_ADV_T_AvaloqPropId__c = '1111';
		update opp;

		opp = [SELECT Id, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c, Name, FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c 
		                                        FROM Opportunity 
		                                        WHERE Id =: opp.Id 
		                                        ];
		
        CRAN_VEC_ADV_RebalpRS result = new CRAN_VEC_ADV_RebalpRS();
        result.setStatus('x');
        CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
        order.setOrderNr('1111');
        result.setOrder(order);

		CRAN_VEC_ADV_CloseOpp colas = new CRAN_VEC_ADV_CloseOpp(opp,mainContact.Id);
		colas.manageResult(result);
	}


	@isTest 
	static void closeOpp_Test4() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		finAcc.FinServ__FinancialAccountNumber__c = '1234567.123';
		update finAcc;
		finAcc = [SELECT Id, CRAS_ICA_ASS_F_FullName__c FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		opp.CRAN_VEC_ADV_T_AvaloqPropId__c = '1122';
		update opp;
		opp = [SELECT Id, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c, Name, FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c 
		                                        FROM Opportunity 
		                                        WHERE Id =: opp.Id 
		                                        ];

		
        CRAN_VEC_ADV_RebalpRS resultado = new CRAN_VEC_ADV_RebalpRS();
        CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
        order.setOrderNr('1122');
        resultado.setOrder(order);       
        List<CRAN_VEC_ADV_ProcessSTError_CLS> listEr = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
        CRAN_VEC_ADV_ProcessSTError_CLS er = new CRAN_VEC_ADV_ProcessSTError_CLS();
        er.setDesc('Error');
        er.setCode('Code');
        listEr.add(er);
        System.debug('-------------------> '+ listEr);
        resultado.setErrors(listEr);
        System.debug('-------------------> '+ resultado);


		CRAN_VEC_ADV_CloseOpp colas = new CRAN_VEC_ADV_CloseOpp(opp,mainContact.Id);
		colas.manageResult(resultado);
	}
	

}