@isTest
private class CRAN_VEC_ADV_New_Proposition_TST {


	@testSetup 
	static void loadTestData() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrue();
	}
 
    @isTest 
    static void CRAN_VEC_ADV_PropositionCheck_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		List<FinServ__FinancialAccount__c> listFaccount = [SELECT Id,Name,CRAN_VEC_ADV_P_Bunit__c,CRAN_VEC_DEV_T_ContainerID__c,RecordTypeId,FinServ__PrimaryOwner__c FROM FinServ__FinancialAccount__c];

		Test.startTest();
		CRAN_VEC_ADV_New_Proposition_AUC.checkValidation(listFaccount[0].Id+'');
		Test.stopTest();

    }

    @isTest 
    static void CRAN_VEC_ADV_Proposition_New_TST() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		List<FinServ__FinancialAccount__c> listFaccount = [SELECT Id,Name,CRAN_VEC_ADV_P_Bunit__c,CRAN_VEC_DEV_T_ContainerID__c,RecordTypeId,FinServ__PrimaryOwner__c FROM FinServ__FinancialAccount__c];

		dataFactory.createSecurities();

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_NUEVA_OPORTUNIDAD));
		Test.startTest();
		CRAN_VEC_ADV_New_Proposition_AUC.nuevaProposition(listFaccount[0].Id+'','NameOpportunity','IPS','AED','NameAmount');
		Test.stopTest();

    }    


    @isTest 
    static void CRAN_VEC_ADV_Proposition_RArbol_TST() {

		List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myMap = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
		List<CRAN_VEC_ADV_CalcRebalpNodeListRS> nodeList = new List<CRAN_VEC_ADV_CalcRebalpNodeListRS>();
		CRAN_VEC_ADV_CalcRebalpNodeListRS node = new CRAN_VEC_ADV_CalcRebalpNodeListRS();
		CRAN_VEC_ADV_CalcRebalpNodeDet nodeDet = new CRAN_VEC_ADV_CalcRebalpNodeDet();

		CRAN_VEC_ADV_CalcRebalpNodeId nodeId = new CRAN_VEC_ADV_CalcRebalpNodeId();
		nodeId.setNodeType('pos');
		nodeId.setValue('3');

		nodeDet.setNodeId(nodeId);
		nodeDet.setassetId('');
		nodeDet.setAssetBuId('');
		nodeDet.setCranCode('');
		nodeDet.setName('');	
		nodeDet.setRestrInfo('');
		nodeDet.setRestrIcon('');	
		nodeDet.setRat('');
		nodeDet.setPrice(12);	
		nodeDet.setCurry('');
		nodeDet.setCpfQty(12);
		nodeDet.setSpfQty(12);	
		nodeDet.setCpfAccr(12);	
		nodeDet.setSpfAccr(12);	
		nodeDet.setCpfMktVal(12);	
		nodeDet.setSpfMktVal(12);
		nodeDet.setCpfPerc(12);	
		nodeDet.setSpfPerc(12);	
		nodeDet.setMpfPerc(12);	
		nodeDet.setExtl(true);	
		nodeDet.setAggrPos(true);	
		nodeDet.setRemark('');
		nodeDet.setIsEdit(true);

		node.setNodeDet(nodeDet);			
		nodeList.add(node);
		Test.startTest();
		CRAN_VEC_ADV_New_Proposition_AUC.recorreArbol(nodeList,1,myMap,'EUR');
		Test.stopTest();

    }    
    
	@isTest 
    static void CRAN_VEC_ADV_Proposition_ErrorResp_TST() {
    	CRAN_VEC_ADV_New_Proposition_AUC.randomWithLimit(122);
    }
    
    @isTest 
    static void CRAN_VEC_ADV_Proposition_Success_TST() {
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
    	new CRAN_VEC_ADV_New_Proposition_AUC.SuccessResponseNewOpportunity(myOpportunity);
    }


    @isTest 
    static void CRAN_VEC_ADV_Proposition_New2_TST() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		List<FinServ__FinancialAccount__c> listFaccount = [SELECT Id,Name,CRAN_VEC_ADV_P_Bunit__c,CRAN_VEC_DEV_T_ContainerID__c,RecordTypeId,FinServ__PrimaryOwner__c FROM FinServ__FinancialAccount__c];

		dataFactory.createSecurities();

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_NUEVA_OPORTUNIDAD));
		Test.startTest();
		CRAN_VEC_ADV_New_Proposition_AUC.nuevaProposition(listFaccount[0].Id+'','NameOpportunity','IPS','AED','123');
		Test.stopTest();
    } 


    @isTest 
    static void CRAN_VEC_ADV_Proposition_NewError_TST() {

		Test.startTest();
		CRAN_VEC_ADV_New_Proposition_AUC.nuevaProposition('','NameOpportunity','IPS','AED','NameAmount');
		Test.stopTest();

    } 
    
}