public class CRAS_ICA_ASS_InvoicesFutureHandler_CLS {
	@future
    public static void calculateInvoicesStatus(List<Id> FARecordsIds){
        
        AggregateResult[] aResults = [SELECT CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c, count(Id) Num, sum(CRAS_ICA_ASS_C_TotalPremium__c) DebtAmount 
                                      FROM CRAS_ICA_ASS_Invoice__c 
                                      WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c IN :FARecordsIds 
                                      		AND CRAS_ICA_ASS_P_InvoiceStatus__c IN ('101ASS', '102ASS') 
                                      GROUP BY CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c 
                                      LIMIT 3000];

        Set<Id> faFilteredSet = new Set<Id>();
        for (AggregateResult ar : aResults) {
        	faFilteredSet.add(Id.valueOf((String)ar.get('FinServ__FinancialAccount__c')));
    	}
        if (faFilteredSet.size() > 0){
            
           	FinServ__FinancialAccount__c[] finAccList = [SELECT Id, CRAS_ICA_ASS_N_NumUnpaidInvoices__c 
                                                         FROM FinServ__FinancialAccount__c 
                                                         WHERE Id in :faFilteredSet];
            for (AggregateResult ar : aResults) {
                Id CurrentFAID = Id.valueOf((String)ar.get('FinServ__FinancialAccount__c'));
                for (FinServ__FinancialAccount__c finAcc : finAccList) {
                    if (finAcc.Id == CurrentFAID){
                        finAcc.CRAS_ICA_ASS_N_NumUnpaidInvoices__c = (Integer)ar.get('Num');
                        finAcc.CRAS_ICA_ASS_C_DebtAmount__c = (Decimal)ar.get('DebtAmount');
                    }
                }
            }
            try {
            	update finAccList;
            }
            catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
    }
}