/**
 * FinancialAccountRole Trigger Test Class
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

@isTest
private class CRAN_VEC_ADV_FinancialAccountRole_TST {
	
	/**
	 * Crate BP + Container and FAR with MD relationship empty for testing Bulk data API
	*/
	@isTest static void createCloneFinancialAccountRoles_TST() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact c = dataFactory.createBusinessContactWithTwoBpsNullContainers();
		List<FinServ__FinancialAccountRole__c> lstFars = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE FinServ__SourceSystemId__c!=null AND FinServ__SourceSystemId__c=null];
	}

	@isTest static void updateCloneFinancialAccountRoles_TST() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact c = dataFactory.createBusinessContactWithTwoBpsNullContainers();

		List<FinServ__FinancialAccountRole__c> lstFars = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE FinServ__SourceSystemId__c!=null AND FinServ__SourceSystemId__c!='' AND FinServ__Active__c = true];
		System.debug('lstFars: ' + lstFars);

		if(!lstFars.isEmpty()){
			System.debug('Actualiza FAR');
			for(FinServ__FinancialAccountRole__c far : lstFars){
				far.FinServ__EndDate__c = Date.today() - 1;
			}
			update lstFars;
		}

		List<FinServ__FinancialAccountRole__c> lstFarsAfter = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE FinServ__SourceSystemId__c!=null AND FinServ__SourceSystemId__c = '' AND FinServ__EndDate__c = TODAY];

	}

	@isTest static void updateCloneFinancialAccountRoles_TST2() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact c = dataFactory.createBusinessContactWithTwoBpsNullContainers();

		List<FinServ__FinancialAccountRole__c> lstFars = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE FinServ__SourceSystemId__c!=null AND FinServ__SourceSystemId__c!='' AND FinServ__Active__c = true];
		System.debug('lstFars: ' + lstFars);

		if(!lstFars.isEmpty()){
			System.debug('Actualiza FAR');
			for(FinServ__FinancialAccountRole__c far : lstFars){
				far.FinServ__EndDate__c = Date.today();
			}
			update lstFars;
		}

		List<FinServ__FinancialAccountRole__c> lstFarsAfter = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE FinServ__SourceSystemId__c!=null AND FinServ__SourceSystemId__c = '' AND FinServ__EndDate__c = TODAY];

	}
	
	@isTest static void deleteCloneFinancialAccountRoles_TST() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact c = dataFactory.createBusinessContactWithTwoBpsNullContainers();

		List<FinServ__FinancialAccountRole__c> lstFars = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE FinServ__SourceSystemId__c!=null AND FinServ__SourceSystemId__c!=''];
		System.debug('lstFars: ' + lstFars);

		if(!lstFars.isEmpty()){
			System.debug('Actualiza FAR');
			for(FinServ__FinancialAccountRole__c far : lstFars){
				far.FinServ__EndDate__c = Date.today();
			}
			delete lstFars;
			undelete lstFars;
		}
	}
}