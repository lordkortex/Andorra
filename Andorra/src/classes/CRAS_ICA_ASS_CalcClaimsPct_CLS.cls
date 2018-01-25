public class CRAS_ICA_ASS_CalcClaimsPct_CLS {
    
    public static Boolean calcHistory (Id idAccount)
    {
        try
        {
            List<Account> accountSearch = [SELECT CRAS_ICA_ASS_F_AxisPersonID__c, OwnerId FROM Account WHERE Id = :idAccount]; 
            
            if(accountSearch.size() > 0 && accountSearch[0].CRAS_ICA_ASS_F_AxisPersonID__c != null)
            {
                List<FinServ__FinancialAccountRole__c> lstFASearch = 
                    [SELECT FinServ__FinancialAccount__c 
                     FROM FinServ__FinancialAccountRole__c 
                     WHERE FinServ__RelatedContact__c IN 
                     (Select Id FROM Contact WHERE CRAS_ICA_ASS_T_AxisPersonID__c = :accountSearch[0].CRAS_ICA_ASS_F_AxisPersonID__c) 
                     AND FinServ__Role__c = '101ASS' AND FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode];
                
                List<Id> lstFASearchId = new List<Id>();
                for (FinServ__FinancialAccountRole__c fA : lstFASearch)
                {
                    lstFASearchId.add(fA.FinServ__FinancialAccount__c);
                }
                
                List<FinServ__FinancialAccountRole__c> lstFARolSearch = 
                    [SELECT Id, FinServ__FinancialAccount__c
                     FROM FinServ__FinancialAccountRole__c 
                     WHERE FinServ__FinancialAccount__c IN :lstFASearchId
                     AND FinServ__Role__c = '102ASS'];
                
                List<Id> lstFA = new List<Id> ();
                List<Id> lstFAR = new List<Id> ();
                
                for (FinServ__FinancialAccountRole__c fARol : lstFARolSearch)
                {
                    lstFA.add(fARol.FinServ__FinancialAccount__c);
                    lstFAR.add(fARol.Id);
                }
                
                List<CRAS_ICA_ASS_ClaimsPctHistory__c> exits = [SELECT Id FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_Account__c = :idAccount];	 
                if(exits.size() == 0)
                {
                    List<CRAS_ICA_ASS_ClaimsPctHistory__c> lstClaimsPctH = new List<CRAS_ICA_ASS_ClaimsPctHistory__c> ();
                    List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT CRAS_ICA_ASS_D_StartDate__c, CRAS_ICA_ASS_C_Premium__c, CurrencyIsoCode, CRAS_ICA_ASS_L_FinancialAccount__c FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :lstFA];
                    
                    for (CRAS_ICA_ASS_FA_PremiumHistory__c fAPH : lstFAPH) 
                    {        
                        List<AggregateResult> lstTotal = [SELECT SUM(CRAS_ICA_ASS_C_TotalAmount__c) FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__c = :fAPH.CRAS_ICA_ASS_L_FinancialAccount__c AND CRAS_ICA_ASS_D_StartDate__c = :fAPH.CRAS_ICA_ASS_D_StartDate__c];
                        
                        if(lstTotal.size() != 0)
                        {
                            CRAS_ICA_ASS_ClaimsPctHistory__c claimPctH = new CRAS_ICA_ASS_ClaimsPctHistory__c();
                            claimPctH.OwnerId = accountSearch[0].OwnerId;
                            claimPctH.CRAS_ICA_ASS_L_Account__c = idAccount;
                            claimPctH.CurrencyIsoCode = fAPH.CurrencyIsoCode;
                            claimPctH.CRAS_ICA_ASS_L_FinancialAccount__c = fAPH.CRAS_ICA_ASS_L_FinancialAccount__c;
                            
                            Decimal sumTotal = (Decimal)lstTotal[0].get('expr0');
                            if(fAPH.CRAS_ICA_ASS_C_Premium__c == 0 || sumTotal == null)
                            {
                                claimPctH.CRAS_ICA_ASS_PE_ClaimPct__c = 0;
                            }
                            else
                            {
                                claimPctH.CRAS_ICA_ASS_PE_ClaimPct__c = (sumTotal / fAPH.CRAS_ICA_ASS_C_Premium__c) * 100;
                            }
                            
                            claimPctH.CRAS_ICA_ASS_N_Year__c = fAPH.CRAS_ICA_ASS_D_StartDate__c.year();
                            
                            lstClaimsPctH.add(claimPctH);
                        }
                    }
                    
                    if(lstClaimsPctH.size() != 0)
                    {
                        insert lstClaimsPctH;
                        return true;
                    }
                    return false;
                }
                return true;
            }
            return false; 
        }
        catch (Exception ex)
        {
            return null;
        }
    }
}