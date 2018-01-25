@isTest
private class CRAN_VEC_ADV_OrderConfirm_TST {

    @testSetup 
    static void loadTestData() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrueExec();
		List<Order> listaOrdenes = new List<Order>();		
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = dataFactory.createFS_FinancialAccount(accBP);
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		Order orden = dataFactory.createrOrderSimulated();
		orden.OpportunityId = opp.Id;
		orden.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden.CRAN_VEC_ADV_B_Signed__c = true;
		orden.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		listaOrdenes.add(orden);
		Order orden2 = dataFactory.createrOrderSimulated();
		orden2.OpportunityId = opp.Id;
		orden2.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden2.CRAN_VEC_ADV_B_Signed__c = true;
		orden2.CRAN_VEC_ADV_T_OrderId__c = '583493389';
		listaOrdenes.add(orden2);
		update listaOrdenes;
    }	

	@isTest 
	static void successResponse_test999() {
		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_CONFIRM));
		List<Order> mylistaOrdenes = [SELECT Id, OpportunityId, CRAN_VEC_ADV_T_AvaloqStatusId__c,CRAN_VEC_ADV_B_Signed__c,CRAN_VEC_ADV_T_OrderId__c FROM Order WHERE CRAN_VEC_ADV_F_WaitSign__c = true AND CRAN_VEC_ADV_B_Execute__c = true AND RecordType.DeveloperName = :CRAN_VEC_ADV_Constants_CLS.CRAN_VEC_ADV_ORDER_INVT_PROP];		
		


	}


	@isTest 
	static void successResponse_test9991() {

		List<Order> mylistaOrdenes = [SELECT Id, OpportunityId, CRAN_VEC_ADV_T_AvaloqStatusId__c,CRAN_VEC_ADV_B_Signed__c,CRAN_VEC_ADV_T_OrderId__c FROM Order];		
		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_CONFIRM));


	}	



}