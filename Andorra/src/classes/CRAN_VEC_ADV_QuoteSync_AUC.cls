public with sharing class CRAN_VEC_ADV_QuoteSync_AUC {
    
	@AuraEnabled
    public static List<Boolean> QuoteMessage(Id recordId) {
    	List<Boolean> values = new List<Boolean>();
        Boolean fStatus;
        Boolean fInvAChgd;
        Boolean fCurrChgd;
        Boolean fIPLChgd = false;

        Quote quote = [SELECT Id, Name, Status,
                        		CRAN_VEC_ADV_N_InvAmount__c, CRAN_VEC_ADV_N_InvAmountBKK__c,
            					CRAN_VEC_ADV_P_Currency__c, CRAN_VEC_ADV_P_CurrencyBKK__c
            			FROM Quote
            			WHERE Id = :RecordId ];
        
        List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myIpl = [SELECT CRAN_VEC_ADV_F_IPLMod__c
            			FROM CRAN_VEC_ADV_Investment_Proposition_Line__c
            			WHERE CRAN_VEC_ADV_L_Version__c = :RecordId ];
        
        fStatus   = (quote.Status=='Modified');
        fInvAChgd = (quote.CRAN_VEC_ADV_N_InvAmount__c <> quote.CRAN_VEC_ADV_N_InvAmountBKK__c);
        fCurrChgd = (quote.CRAN_VEC_ADV_P_Currency__c <> quote.CRAN_VEC_ADV_P_CurrencyBKK__c);
        
        if ( myIpl != null && myIpl.size() > 0 ) {
            for (CRAN_VEC_ADV_Investment_Proposition_Line__c ipl : myIpl) {
                if (ipl.CRAN_VEC_ADV_F_IPLMod__c) {
                    fIPLChgd = ipl.CRAN_VEC_ADV_F_IPLMod__c;
                    break;
                }                
            }        	    
        }
        
        values.add(fStatus);  
        values.add(fInvAChgd);
        values.add(fCurrChgd);
        values.add(fIPLChgd);
        return values;
    }

}