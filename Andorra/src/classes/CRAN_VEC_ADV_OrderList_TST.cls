@isTest
private class CRAN_VEC_ADV_OrderList_TST {


	@testSetup 
	static void loadTestData() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact c = dataFactory.createIndividualContactWithTwoBps();
		CRAN_VEC_ADV_CustomForm__c cf = dataFactory.create_CustomForm_TemplatePF();
		dataFactory.addCustomFormResponse(cf.Id,c.Id);		
		dataFactory.createAvaloqSettingMockTrueExec();
	}

	@isTest 
	static void dataList_test1() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		List<Order> listaOrdenes = new List<Order>();		
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = dataFactory.createFS_FinancialAccount(accBP);
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);

  		Test.startTest();
		CRAN_VEC_ADV_OrderList_AUC.DataList(opp.Id, 'OpportunityId', 'CRAN_VEC_ADV_P_MetaType__c=\'STEX\'', 'Order');
		Test.stopTest();

	}


	@isTest 
	static void dataList_test2() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
        Opportunity opp = dataFactory.createOppForRelatedLists(finAcc.Id, accBP.Id);
		Quote qte = [SELECT Id, OpportunityId FROM Quote WHERE OpportunityId =: opp.Id];


  		Test.startTest();
		CRAN_VEC_ADV_OrderList_AUC.DataList(opp.Id, 'OpportunityId', 'CRAN_VEC_ADV_P_MetaType__c=\'FXTR\'', 'Order');
		Test.stopTest();

	}


	@isTest
    static void dataList_test3() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
        Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
        Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
        FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
        Opportunity opp = dataFactory.createOppForRelatedLists(finAcc.Id, accBP.Id);
        Order orden = dataFactory.createrOrderSimulated();
        List<Order> listaOrdenes = new List<Order>();       
		orden.OpportunityId = opp.Id;
		orden.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden.CRAN_VEC_ADV_B_Signed__c = true;
		orden.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden.CRAN_VEC_ADV_T_AvaloqStatus__c = '1500';
		orden.CRAN_VEC_ADV_P_Type__c = 'A mercado';
		orden.CRAN_VEC_ADV_N_Limit__c = 111111;
		orden.CRAN_VEC_ADV_D_TRXDate__c = System.today();
		orden.CRAN_VEC_ADV_T_HasRestr__c = 'errrrrrr';
		listaOrdenes.add(orden);
		Order orden2 = dataFactory.createrOrderSimulated();
		orden2.OpportunityId = opp.Id;
		orden2.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden2.CRAN_VEC_ADV_B_Signed__c = true;
		orden2.CRAN_VEC_ADV_T_OrderId__c = '583493389';
		orden2.CRAN_VEC_ADV_T_AvaloqStatus__c = '1500';
		orden2.CRAN_VEC_ADV_P_Type__c = 'A mercado';
		orden2.CRAN_VEC_ADV_N_Limit__c = 222222;
		orden2.CRAN_VEC_ADV_D_TRXDate__c = System.today();
		orden2.CRAN_VEC_ADV_T_HasRestr__c = 'orrrrrr';		listaOrdenes.add(orden2);
		update listaOrdenes;
        String recordId = opp.Id;
        String nKey = 'OpportunityId';
        String objectName = 'Order';
        String aFilter = '';
        dataFactory.createrOrder();
        CRAN_VEC_ADV_OrderList_AUC.DataList(recordId, nKey, aFilter,objectName);
    }


	@isTest 
	static void execServiceOrderConfirm_test1() {

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
		orden.CRAN_VEC_ADV_B_Signed__c = true;
		orden.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden.CRAN_VEC_ADV_B_ManualConfirm__c = true;
		listaOrdenes.add(orden);
		Order orden2 = dataFactory.createrOrderSimulated();
		orden2.OpportunityId = opp.Id;
		orden2.CRAN_VEC_ADV_B_Signed__c = true;
		orden2.CRAN_VEC_ADV_T_OrderId__c = '583493389';
		orden2.CRAN_VEC_ADV_B_ManualConfirm__c = true;
		listaOrdenes.add(orden2);
		update listaOrdenes;

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_CONFIRM));
  		Test.startTest();
		CRAN_VEC_ADV_OrderList_AUC.execServiceOrderConfirm(opp.Id);
		Test.stopTest();

	}


	@isTest 
	static void execServiceOrderConfirm_test2() {

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
		orden.CRAN_VEC_ADV_B_Signed__c = true;
		orden.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden.CRAN_VEC_ADV_B_ManualConfirm__c = false;
		listaOrdenes.add(orden);
		Order orden2 = dataFactory.createrOrderSimulated();
		orden2.OpportunityId = opp.Id;
		orden2.CRAN_VEC_ADV_B_Signed__c = true;
		orden2.CRAN_VEC_ADV_T_OrderId__c = '583493389';
		orden2.CRAN_VEC_ADV_B_ManualConfirm__c = false;
		listaOrdenes.add(orden2);
		update listaOrdenes;

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_CONFIRM));
  		Test.startTest();
		CRAN_VEC_ADV_OrderList_AUC.execServiceOrderConfirm(opp.Id);
		Test.stopTest();

	}
	

	@isTest 
	static void CRAN_VEC_ADV_OrderListGet() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createSetting_AvaloqOppInvestProposal();

		CRAN_VEC_ADV_OrderList_AUC.execServiceModeGet(myOpportunity.Id);

	}
	
	@isTest 
	static void CRAN_VEC_ADV_OrderListGetErr() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createSetting_AvaloqOppInvestProposal();

		CRAN_VEC_ADV_OrderList_AUC.execServiceModeGet('');

	}

	@isTest 
	static void CRAN_VEC_ADV_OrderListFinal() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
		mainContact.Email = 'Pepe@gmail.com';
		mainContact.CRAN_VEC_ADV_P_Language__c = 'es';
		mainContact.MobilePhone = '111111';
		update mainContact;	
		FinServ__FinancialAccountRole__c role = dataFactory.createFS_FinancialAccountRole(myFaccouunt, mainContact);
		role.CRAN_VEC_ADV_T_BPId__c = '9_9000001';
		update role;


		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		myOpportunity.stageName ='advDone';
		myOpportunity.CRAN_VEC_ADV_L_PersonId__c = mainContact.Id;
		myOpportunity.CRAN_VEC_ADV_B_Expired__c = false;
		update myOpportunity;

		Order myOrder = dataFactory.createrOrder2();

		myOrder.OpportunityId = myOpportunity.Id;
		myOrder.CRAN_VEC_ADV_B_isService__c = true;
		myOrder.CRAN_VEC_ADV_B_Execute__c = true;
		myOrder.CRAN_VEC_ADV_P_SFStatus__c = 'advSimulated';
		myOrder.CRAN_VEC_ADV_T_OrderId__c = '582772470';

		update myOrder;

		dataFactory.createSetting_AvaloqOppInvestProposal();

		CRAN_VEC_ADV_OrderList_AUC.execServiceModeFinal(myOpportunity.Id);
	}	

	@isTest 
	static void CRAN_VEC_ADV_OrderListFinalError() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createSetting_AvaloqOppInvestProposal();

		CRAN_VEC_ADV_OrderList_AUC.execServiceModeFinal('');

	}


	@isTest 
	static void CRAN_VEC_ADV_OrderListFinalSimulat() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		System.debug('myOpportunity '+myOpportunity);

		Order myOrder = dataFactory.createrOrderSimulated();
		myOrder.OpportunityId = myOpportunity.Id;
		myOrder.CRAN_VEC_ADV_B_isService__c = true;
		myOrder.CRAN_VEC_ADV_B_Execute__c = true;
		update myOrder;

		Order muyorder2 = [SELECT id,CRAN_VEC_ADV_B_isService__c,OpportunityId,Status FROM Order];

		dataFactory.createSetting_AvaloqOppInvestProposal();

		CRAN_VEC_ADV_OrderList_AUC.execServiceModeFinal(myOpportunity.Id);

	}

	@isTest 
	static void isOpportunityStageOpenTrue(){
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE;
		update myOpportunity;
		Boolean result = CRAN_VEC_ADV_OrderList_AUC.isOpportunityStageOpen(myOpportunity.Id);
		System.assertEquals(true, result);
	}

	@isTest 
	static void isOpportunityStageOpenFalse(){
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		Boolean result = CRAN_VEC_ADV_OrderList_AUC.isOpportunityStageOpen(myOpportunity.Id);
		System.assertEquals(false, result);
	}

	
	@isTest 
	static void selectAllTest(){
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		myOpportunity.stageName ='advDone';
		update myOpportunity;

		Order myOrder = dataFactory.createrOrder2();

		myOrder.OpportunityId = myOpportunity.Id;
		myOrder.CRAN_VEC_ADV_B_isService__c = true;
		update myOrder;

		dataFactory.createSetting_AvaloqOppInvestProposal();

		CRAN_VEC_ADV_OrderList_AUC.selectAll(myOpportunity.Id, true, false, false);
		CRAN_VEC_ADV_OrderList_AUC.selectAll(myOpportunity.Id, true, true, false);
		CRAN_VEC_ADV_OrderList_AUC.selectAll(myOpportunity.Id, true, false, true);		
	}

	@isTest 
	static void infoToSendArchive_TST(){
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		myAccount.CRAN_VEC_ADV_N_Number__c = '2222';
		update myAccount;

		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		myOpportunity.stageName ='advDone';
		update myOpportunity;

		Order myOrder = dataFactory.createrOrder2();

		myOrder.OpportunityId = myOpportunity.Id;
		myOrder.CRAN_VEC_ADV_B_isService__c = true;
		myOrder.CRAN_VEC_ADV_ReferenceLine__c = 'aa';
		update myOrder;

		CRAN_VAS_KER_ESignature__c eSignature = new CRAN_VAS_KER_ESignature__c();
		eSignature.CRAN_VAS_KER_Reference_Line__c = '1111';
		eSignature.CRAN_VAS_KER_Account__c = myAccount.Id;
		eSignature.CRAN_VAS_KER_Order__c = myOrder.Id;
		insert eSignature;

		dataFactory.createSetting_AvaloqOppInvestProposal();

		CRAN_VEC_ADV_OrderList_AUC.infoToSendArchive(myOrder.Id, myOpportunity.Id,'');
	}

	/*@isTest 
	static void CRAN_VEC_ADV_OrderBtnActivation() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		myOpportunity.stageName ='advSimulated';
		update myOpportunity;        
        CRAN_VEC_ADV_OrderList_AUC.activeBtnOrders(myOpportunity.Id);
        
        myOpportunity.stageName ='advDone';
        update myOpportunity;
		CRAN_VEC_ADV_OrderList_AUC.activeBtnOrders(myOpportunity.Id);


	}*/	


	@isTest 
    static void CRAN_VEC_ADV_showHeader_TST() {        
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Account myAccount = dataFactory.createBPAccount();
        FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
        Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
        Test.startTest();
        String temp =  CRAN_VEC_ADV_OrderList_AUC.showHeader(myOpportunity.Id);
        Test.stopTest();
    }

    
    @isTest 
	static void updateStatusOrderExec_test1() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();	
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = dataFactory.createFS_FinancialAccount(accBP);
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		opp.StageName = 'advDone';
		update opp;
		Order orden = dataFactory.createrOrderSimulated();
		orden.OpportunityId = opp.Id;
		orden.CRAN_VEC_ADV_B_Execute__c = true;
		orden.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden.CRAN_VEC_ADV_B_Signed__c = true;
		orden.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden.CRAN_VEC_ADV_P_SFStatus__c = 'advSimulated';
		update orden;

  		Test.startTest();
		CRAN_VEC_ADV_OrderList_AUC.updateStatusOrderExec(opp.Id, orden.Id, true);
		Test.stopTest();

	}

	
	@isTest 
	static void callOmsPrint_test1() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrue();
		List<Order> listaOrdenes = new List<Order>();		
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = dataFactory.createFS_FinancialAccount(accBP);
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		Order orden = dataFactory.createrOrderSimulated();
		orden.OpportunityId = opp.Id;
		orden.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden.CRAN_VEC_ADV_B_Signed__c = false;
		orden.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden.CRAN_VEC_ADV_B_Execute__c = true;
		//orden.RecordType.DeveloperName = CRAN_VEC_ADV_Constants_CLS.CRAN_VEC_ADV_ORDER_INVT_PROP;

		listaOrdenes.add(orden);
		Order orden2 = dataFactory.createrOrderSimulated();
		orden2.OpportunityId = opp.Id;
		orden2.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden2.CRAN_VEC_ADV_B_Signed__c = false;
		orden2.CRAN_VEC_ADV_T_OrderId__c = '583493389';
		orden2.CRAN_VEC_ADV_B_Execute__c = true;
		//orden.RecordType.DeveloperName = CRAN_VEC_ADV_Constants_CLS.CRAN_VEC_ADV_ORDER_INVT_PROP;
		listaOrdenes.add(orden2);
		update listaOrdenes;

  		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_LIST_PRINT));
  		Test.startTest();
		CRAN_VEC_ADV_OrderList_AUC.callOmsPrint(opp.Id);
		Test.stopTest();

	}

	@isTest 
	static void printPreviewOrders_test1() {

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
		orden.CRAN_VEC_ADV_B_Signed__c = false;
		orden.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden.CRAN_VEC_ADV_B_Execute__c = true;
		listaOrdenes.add(orden);
		Order orden2 = dataFactory.createrOrderSimulated();
		orden2.OpportunityId = opp.Id;
		orden2.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden2.CRAN_VEC_ADV_B_Signed__c = false;
		orden2.CRAN_VEC_ADV_T_OrderId__c = '583493389';
		orden2.CRAN_VEC_ADV_B_Execute__c = true;
		listaOrdenes.add(orden2);
		update listaOrdenes;

  		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_LIST_PRINT));
  		Test.startTest();
		CRAN_VEC_ADV_OrderList_AUC.printPreviewOrders(opp.Id);
		Test.stopTest();

	}

	
	@isTest 
	static void printPreviewOrders_test2() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		List<Order> listaOrdenes = new List<Order>();		
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = dataFactory.createFS_FinancialAccount(accBP);
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);


  		Test.startTest();
		CRAN_VEC_ADV_OrderList_AUC.printPreviewOrders(opp.Id);
		Test.stopTest();

	}


	@isTest 
	static void successResponse_test1() {

		Test.startTest();
		CRAN_VEC_ADV_OrderList_AUC.SuccessResponse sr = new CRAN_VEC_ADV_OrderList_AUC.SuccessResponse('1111', '222222');
		sr.callExecRebalp = true;

		CRAN_VEC_ADV_OrderList_AUC.SuccessResponse sr2 = new CRAN_VEC_ADV_OrderList_AUC.SuccessResponse('', true,'');
		Test.stopTest();

	}

	@isTest 
	static void successResponse_discard() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrueExec();
		List<Order> listaOrdenes = new List<Order>();		
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = dataFactory.createFS_FinancialAccount(accBP);
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		opp.StageName = 'advDone';
		update opp;
		Opportunity temp = [SELECT Id,StageName FROM Opportunity];
		System.debug('MYOPP '+temp);
		Order orden = dataFactory.createrOrderSimulated();
		orden.OpportunityId = opp.Id;
		orden.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden.CRAN_VEC_ADV_B_Signed__c = false;
		orden.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden.CRAN_VEC_ADV_B_Execute__c = true;
		orden.CRAN_VEC_ADV_P_SFStatus__c = 'advSimulated';

		listaOrdenes.add(orden);
		Order orden2 = dataFactory.createrOrderSimulated();
		orden2.OpportunityId = opp.Id;
		orden2.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden2.CRAN_VEC_ADV_B_Signed__c = false;
		orden2.CRAN_VEC_ADV_T_OrderId__c = '583493389';
		orden2.CRAN_VEC_ADV_B_Execute__c = true;
		orden2.CRAN_VEC_ADV_P_SFStatus__c = 'advSimulated';
		listaOrdenes.add(orden2);
		update listaOrdenes;

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_DISCARD));
  		Test.startTest();
  		CRAN_VEC_ADV_OrderList_AUC.execServiceModeFinalDiscard(opp.Id);
		Test.stopTest();
	}

	@isTest 
	static void ErrorResponse_discard() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrueExec();
		List<Order> listaOrdenes = new List<Order>();		
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();		
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = dataFactory.createFS_FinancialAccount(accBP);
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
		opp.StageName = 'advDone';
		update opp;
		Opportunity temp = [SELECT Id,StageName FROM Opportunity];
		System.debug('MYOPP '+temp);
		Order orden = dataFactory.createrOrderSimulated();
		orden.OpportunityId = opp.Id;
		orden.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden.CRAN_VEC_ADV_B_Signed__c = true;
		orden.CRAN_VEC_ADV_T_OrderId__c = '59485433';
		orden.CRAN_VEC_ADV_B_Execute__c = true;
		orden.CRAN_VEC_ADV_P_SFStatus__c = 'advSimulated';

		listaOrdenes.add(orden);
		Order orden2 = dataFactory.createrOrderSimulated();
		orden2.OpportunityId = opp.Id;
		orden2.CRAN_VEC_ADV_T_AvaloqStatusId__c = '1500';
		orden2.CRAN_VEC_ADV_B_Execute__c = true;
		orden2.CRAN_VEC_ADV_B_Signed__c = true;
		orden2.CRAN_VEC_ADV_T_OrderId__c = '583493389';
		orden2.CRAN_VEC_ADV_P_SFStatus__c = 'advSimulated';
		listaOrdenes.add(orden2);
		update listaOrdenes;

  		Test.startTest();
  		CRAN_VEC_ADV_OrderList_AUC.execServiceModeFinalDiscard('');
		Test.stopTest();
	}

	@isTest 
	static void ErrorResponse() {
	Test.startTest();
  	CRAN_VEC_ADV_OrderList_AUC.ErrorResponse sr = new CRAN_VEC_ADV_OrderList_AUC.ErrorResponse();
  	CRAN_VEC_ADV_OrderList_AUC.ErrorResponse sr1 = new CRAN_VEC_ADV_OrderList_AUC.ErrorResponse('',true);

	Test.stopTest();
	}


}