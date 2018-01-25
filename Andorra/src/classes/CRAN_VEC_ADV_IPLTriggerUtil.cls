public with sharing class CRAN_VEC_ADV_IPLTriggerUtil {
	public static void assignFieldtoEvaluate(Map<Id, CRAN_VEC_ADV_Investment_Proposition_Line__c> mapOld,
	        List<CRAN_VEC_ADV_Investment_Proposition_Line__c> listNew, String operation) {
		if (Trigger.isExecuting) {
			for (CRAN_VEC_ADV_Investment_Proposition_Line__c ipl : listNew) {
				if (operation.equals('insert')) {
					boolean newQuantity = ipl.CRAN_VEC_ADV_N_PropQtty__c != null ? true : false;
					boolean newMktValue = ipl.CRAN_VEC_ADV_N_PropMktValue__c != null ? true : false;
					boolean newPerce = ipl.CRAN_VEC_ADV_N_PercentQtty__c != null ? true : false;
					Integer sumValues = (newQuantity ? 1 : 0) + (newMktValue ? 1 : 0) + (newPerce ? 1 : 0);
					if (ipl.CRAN_VEC_ADV_FieldChangedbyUser__c == null && sumValues > 1 ) {
						ipl.adderror(Label.CRAN_VEC_ADV_IP_Select_Field +' : ' + ipl.Name);
					} else if (sumValues == 1) {
						ipl.CRAN_VEC_ADV_P_ChangedField__c = (newQuantity ? 'CRAN_VEC_ADV_N_PropQtty__c': (newMktValue ? 'CRAN_VEC_ADV_N_PropMktValue__c' :(newPerce ? 'CRAN_VEC_ADV_N_PercentQtty__c' :'Null')));
					}
				} else if (operation.equals('update')) {
					boolean newQuantity = ipl.CRAN_VEC_ADV_N_PropQtty__c !=
					                      mapOld.get(ipl.Id).CRAN_VEC_ADV_N_PropQtty__c ? true : false;
					boolean newMktValue = ipl.CRAN_VEC_ADV_N_PropMktValue__c !=
					                      mapOld.get(ipl.Id).CRAN_VEC_ADV_N_PropMktValue__c ? true : false;
					boolean newPerce = ipl.CRAN_VEC_ADV_N_PercentQtty__c !=
					                   mapOld.get(ipl.Id).CRAN_VEC_ADV_N_PercentQtty__c ? true : false;
					if (newQuantity || newMktValue || newPerce) {
						ipl.CRAN_VEC_ADV_P_ChangedField__c = (newQuantity ? 'CRAN_VEC_ADV_N_PropQtty__c': (newMktValue ? 'CRAN_VEC_ADV_N_PropMktValue__c' :(newPerce ? 'CRAN_VEC_ADV_N_PercentQtty__c' :'Null')));
					}
				}
			}
		}
	}
}