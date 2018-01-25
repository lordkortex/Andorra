@isTest
private class CRAN_VEC_ADV_RetrOppList_TST {

    /**
    * Action que carga los datos de la tabla de Lightning.
    * 
    */
   	@isTest 
    static void CRAN_VEC_ADV_IP_queryDataInvestment_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		myAccount.CRAN_VEC_ADV_T_BPId__c = '9_8212919';
		upsert myAccount;
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		CRAN_VEC_ADV_RetrOppList_AUC.queryDataInvestment(myFaccouunt.Id,'FinServ__FinancialAccount__c','','Opportunity',false);
    }

       /**
    * test para el Invocable Method que cierra la opportunity desde un process builder.
    * 
    */
   	@isTest 
    static void CRAN_VEC_ADV_IP_updateRecordData_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		// Bad Status
		CRAN_VEC_ADV_RetrOppList_AUC.updateRecordData(myOpportunity.Id);

		// Status Simulated
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED;
		update myOpportunity;
		CRAN_VEC_ADV_RetrOppList_AUC.updateRecordData(myOpportunity.Id);

		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PEND_SIGN;
		update myOpportunity;
		CRAN_VEC_ADV_RetrOppList_AUC.updateRecordData(myOpportunity.Id);		

    }

    @isTest 
    static void CRAN_VEC_ADV_FieldChanged_TST() {    	

    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

    	Test.startTest();
    	CRAN_VEC_ADV_RetrOppList_AUC.FieldChanged temp = new CRAN_VEC_ADV_RetrOppList_AUC.FieldChanged(Opportunity.Fields.StageName,myOpportunity,'');

		Test.stopTest();
    } 


    @isTest 
    static void CRAN_VEC_ADV_ChangeOpp_TST() {
    	
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

    	Test.startTest();
    	CRAN_VEC_ADV_RetrOppList_AUC.ChangedOpportunity temp = new CRAN_VEC_ADV_RetrOppList_AUC.ChangedOpportunity(myOpportunity);

		Test.stopTest();
    }

    @isTest 
    static void CRAN_VEC_ADV_Success_TST() {
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		Quote myQuote = [SELECT Id FROM Quote LIMIT 1];
    	Test.startTest();
    	CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponse temp = new CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponse(myOpportunity);
    	CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponse temp1 = new CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponse(myQuote);

		Test.stopTest();
    }

    @isTest 
    static void CRAN_VEC_ADV_Error_TST() {
    	Test.startTest();
    	CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse temp = new CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse('');
    	CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse temp1 = new CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse('',true);
    	//CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse temp2 = new CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse(new Exception());

		Test.stopTest();
    }
    
    @isTest 
    static void CRAN_VEC_ADV_showHeader_TST() {
    	
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

    	Test.startTest();
    	String temp = CRAN_VEC_ADV_RetrOppList_AUC.showHeader(myOpportunity.Id);

		Test.stopTest();
    }

    @isTest 
    static void CRAN_VEC_ADV_updateDataResponse_TST() {

    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();
		CRAN_VEC_ADV_RebalpList_RS response = new CRAN_VEC_ADV_RebalpList_RS();
		List<CRAN_VEC_ADV_RebalpList_RS.OrderItem> listOI = new List<CRAN_VEC_ADV_RebalpList_RS.OrderItem>();
		CRAN_VEC_ADV_RebalpList_RS.AssetItem assetItem = new CRAN_VEC_ADV_RebalpList_RS.AssetItem();
		assetItem.assetName='BOLSAS Y MERCADOS ESPA�OLES';
		assetItem.isin='ES0115056139';
		assetItem.assetType='Equities';
		assetItem.assetRefCurry='EUR';
		CRAN_VEC_ADV_RebalpList_RS.OrderItem orderItem = new CRAN_VEC_ADV_RebalpList_RS.OrderItem();		
		orderItem.orderNr='562777976';
		orderItem.metaType='STEX';
		orderItem.orderType='Compra';
		orderItem.type='At Market';
		orderItem.orderStatusId='90';
		orderItem.orderStatus='BO: Done';
		orderItem.orderPrcEstim=29.6;
		orderItem.orderQty=1013.0;
		orderItem.orderTrxDate='09-03-2017 00:00:00';
		orderItem.apprAmount=30220.36;
		orderItem.omsId=null;
		orderItem.assetItem=assetItem;
		listOI.add(orderItem);
		List<CRAN_VEC_ADV_RebalpList_RS.Proposal> listPro = new List<CRAN_VEC_ADV_RebalpList_RS.Proposal>();
		CRAN_VEC_ADV_RebalpList_RS.Proposal pro = new CRAN_VEC_ADV_RebalpList_RS.Proposal();
		pro.bpId='8212919';
		pro.contId='6845786';
		pro.propStatusId='50';
		pro.propDate='19-04-2017 00:00:00';
		pro.propOrderNr='569496631';
		pro.propDesc=null;
		pro.propInvMeth='manual';
		pro.propCurry='EUR';
		pro.propAmount='100.0';
		pro.refOrderList=listOI;
		listPro.add(pro);
		response.rebalPropList=listPro;
		response.errors=null;

    	Test.startTest();
    	CRAN_VEC_ADV_RetrOppList_AUC.updateDataResponse(response, myFaccouunt, null, myFaccouunt.Id);
		Test.stopTest();

    }

    @isTest 
    static void CRAN_VEC_ADV_stringToDateTime_TST() {

    	Test.startTest();
    	CRAN_VEC_ADV_RetrOppList_AUC.stringToDateTime('2012-12-21 12:12:12');
		Test.stopTest();

    }

    @isTest 
    static void CRAN_VEC_ADV_fillAndAuditExistingOpportunityFields_TST() {

        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
    	Schema.DescribeSObjectResult describeOpp = Opportunity.sObjectType.getDescribe();
		Map<String, Schema.SObjectField> fieldsOppMap = describeOpp.fields.getMap();

        List<CRAN_VEC_ADV_RebalpList_RS.OrderItem> listOI = new List<CRAN_VEC_ADV_RebalpList_RS.OrderItem>();
		CRAN_VEC_ADV_RebalpList_RS.OrderItem orderItem = new CRAN_VEC_ADV_RebalpList_RS.OrderItem();		
		orderItem.orderNr='562777976';
		orderItem.metaType='STEX';
		orderItem.orderType='Compra';
		orderItem.type='At Market';
		orderItem.orderStatusId='90';
		orderItem.orderStatus='BO: Done';
		orderItem.orderPrcEstim=29.6;
		orderItem.orderQty=1013.0;
		orderItem.orderTrxDate='09-03-2017 00:00:00';
		orderItem.apprAmount=30220.36;
		orderItem.omsId=null;
		//orderItem.assetItem=assetItem;
		listOI.add(orderItem);

		CRAN_VEC_ADV_RebalpList_RS.Proposal pro = new CRAN_VEC_ADV_RebalpList_RS.Proposal();
		pro.bpId='8212919';
		pro.contId='6845786';
		pro.propStatusId='50';
		pro.propDate='19-04-2017 00:00:00';
		pro.propOrderNr='569496631';
		pro.propDesc='Arrrrr';
		pro.propInvMeth='manual';
		pro.propCurry='EUR';
		pro.propAmount='100.0';
		pro.refOrderList=listOI;

		Test.startTest();
    	CRAN_VEC_ADV_RetrOppList_AUC.fillAndAuditExistingOpportunityFields(myOpportunity, pro, null, fieldsOppMap);
		Test.stopTest();
    }

    @isTest 
    static void CRAN_VEC_ADV_successError_TST() {

    	Test.startTest();
    	CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponseDataInvestment sr1 = new CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponseDataInvestment(new List<List<CRAN_VEC_ADV_FieldData_CLS>>());
    	CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponseDataInvestment sr2 = new CRAN_VEC_ADV_RetrOppList_AUC.SuccessResponseDataInvestment(new List<List<CRAN_VEC_ADV_FieldData_CLS>>(),new List<CRAN_VEC_ADV_RetrOppList_AUC.ChangedOpportunity>());
    	CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse error1 = new CRAN_VEC_ADV_RetrOppList_AUC.ErrorResponse('Error');
    	error1.lineNumber = 1;
    	error1.typeError = 'Tipo';
    	error1.stackTrace = 'stackTrace';
		Test.stopTest();

    }

}