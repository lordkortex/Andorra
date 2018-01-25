public class CRAS_ICA_ASS_FHFutureHandler_CLS 
{
    @future
    public static void updateInsurancePolicyProduct(List<Id> fhIdsList) 
    {
        List<FinServ__FinancialHolding__c> holdings = [SELECT FinServ__FinancialAccount__c, FinServ__Securities__r.FinServ__SecuritiesName__c, FinServ__Securities__r.CRAS_ICA_ASS_T_AxisProductID__c, FinServ__Securities__r.CRAN_VEC_ADV_P_PFMMktClass__c, FinServ__Securities__r.CRAN_VEC_ADV_P_PFMMkt__c, FinServ__Securities__r.CRAS_ICA_ASS_T_Family__c FROM FinServ__FinancialHolding__c WHERE Id in :fhIdsList];
        Set<Id> faIds = new Set<Id>();
        for(FinServ__FinancialHolding__c holding : holdings)
        {
            faIds.add(holding.FinServ__FinancialAccount__c);
        }
        List<FinServ__FinancialAccount__c> faList = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Id in :faIds];
        
        for(FinServ__FinancialHolding__c holding : holdings)
        {
            for(FinServ__FinancialAccount__c facc : faList)
            {
                if (holding.FinServ__FinancialAccount__c == facc.Id)
                {
                    facc.CRAN_VEC_ADV_P_PFMMktClass__c = holding.FinServ__Securities__r.CRAN_VEC_ADV_P_PFMMktClass__c;
                    facc.CRAN_VEC_ADV_P_PFMMkt__c = holding.FinServ__Securities__r.CRAN_VEC_ADV_P_PFMMkt__c;
                    facc.CRAS_ICA_ASS_T_ProductoPoliza__c = holding.FinServ__Securities__r.FinServ__SecuritiesName__c;
                    facc.CRAS_ICA_ASS_T_FamilyProduct__c = holding.FinServ__Securities__r.CRAS_ICA_ASS_T_Family__c;
                    facc.CRAS_ICA_ASS_T_ProductId__c = holding.FinServ__Securities__r.CRAS_ICA_ASS_T_AxisProductID__c;
                }
            }
        }
        
        try 
        {
            update faList;
        }
        catch(DmlException e) 
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}