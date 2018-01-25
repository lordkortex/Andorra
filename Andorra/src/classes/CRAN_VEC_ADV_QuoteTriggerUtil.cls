public with sharing class CRAN_VEC_ADV_QuoteTriggerUtil {

	public static void finalVersionUpdate(Map<Id, Quote> mapOld, List<Quote> listNew, String operation) {
		Map<Id, Id> quoteOppMap = new Map<Id, Id>();
		for (Quote q : listNew) {
			if ( operation.equals('insert') && q.CRAN_VEC_ADV_B_Final__c || operation.equals('update') &&
			        q.CRAN_VEC_ADV_B_Final__c != mapOld.get(q.Id).CRAN_VEC_ADV_B_Final__c ) {
				quoteOppMap.put(q.Id, q.OpportunityId);
			}
		}

		if (quoteOppMap.size() > 0) {

			List<CRAN_VEC_ADV_Investment_Proposition_Line__c> lstIPLs;
			lstIPLs = [SELECT Id, Name
			           FROM CRAN_VEC_ADV_Investment_Proposition_Line__c
			           WHERE CRAN_VEC_ADV_L_Proposition__c IN :quoteOppMap.values()];
			if (lstIPLs.size() > 0) {
				for (CRAN_VEC_ADV_Investment_Proposition_Line__c ipl : lstIPLs) {
					ipl.CRAN_VEC_ADV_L_Proposition__c = null;
				}
				update lstIPLs;
			}

			List<Quote> listQuoteOldFinal;
			listQuoteOldFinal = [SELECT CRAN_VEC_ADV_B_Final__c, CRAN_VEC_ADV_B_FinalBK__c
			                     FROM Quote WHERE CRAN_VEC_ADV_B_Final__c = True AND
			                             Id NOT IN: listNew AND
			                             OpportunityId = : quoteOppMap.values()];

			if (listQuoteOldFinal.size() > 0) {
				for (Quote q : listQuoteOldFinal ) {
					q.CRAN_VEC_ADV_B_Final__c = false;
					q.CRAN_VEC_ADV_B_FinalBK__c = false;
				}
				update listQuoteOldFinal;
			}

			List<CRAN_VEC_ADV_Investment_Proposition_Line__c> newIPLS;
			newIPLS = [SELECT Id, CRAN_VEC_ADV_L_Proposition__c, CRAN_VEC_ADV_L_Version__c
			           FROM CRAN_VEC_ADV_Investment_Proposition_Line__c
			           WHERE CRAN_VEC_ADV_L_Version__c IN : listNew];
			if (newIPLS.size() > 0) {
				for (CRAN_VEC_ADV_Investment_Proposition_Line__c ipl : newIPLS ) {
					ipl.CRAN_VEC_ADV_L_Proposition__c = quoteOppMap.get(ipl.CRAN_VEC_ADV_L_Version__c);
				}
				update newIPLS;
			}
		}
	}

	public static void overrideAllRestrictions(Map<Id, Quote> mapOld, List<Quote> listNew) {
		Set<Id> selQuotes = new Set<Id>();
		for (Quote q : listNew) {
			if (q.CRAN_VEC_ADV_B_OverrideAll__c != mapOld.get(q.Id).CRAN_VEC_ADV_B_OverrideAll__c) {
				selQuotes.add(q.Id);
			}
		}

		if (selQuotes.size() > 0) {
			List<CRAN_VEC_ADV_IPL_Restriction__c> newRestr;
			newRestr = [SELECT Id, CRAN_VEC_ADV_B_Override__c
			            FROM CRAN_VEC_ADV_IPL_Restriction__c
			            WHERE CRAN_VEC_ADV_L_Version__c IN : selQuotes];
			if (newRestr.size() >  0) {
				for (CRAN_VEC_ADV_IPL_Restriction__c restr : newRestr ) {
					restr.CRAN_VEC_ADV_B_Override__c = true;
				}
				update newRestr;
			}
		}
	}
}