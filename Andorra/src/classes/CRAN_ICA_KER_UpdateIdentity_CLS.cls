global class CRAN_ICA_KER_UpdateIdentity_CLS implements Schedulable {
    
    global void execute(SchedulableContext sc) 
    {
        updateContact();
    }
    
    public void updateContact()
    {
        Date dateNow = CRAS_ICA_ASS_Helpers_CLS.DateNow();
        
        List<FinServ__FinancialAccountRole__c> fARLst = [SELECT FinServ__RelatedContact__c
                                                         FROM FinServ__FinancialAccountRole__c 
                                                         WHERE (FinServ__EndDate__c = :dateNow OR FinServ__EndDate__c = :dateNow.addDays(-1))];
        
        Set<Id> rContactStId = new Set<Id>();
        
        for(FinServ__FinancialAccountRole__c fAR : fARLst)
        {
            rContactStId.add(fAR.FinServ__RelatedContact__c);
        }
        
        
        List<FinServ__FinancialAccountRole__c> fARLstClean = [SELECT FinServ__RelatedContact__c
                                                              FROM FinServ__FinancialAccountRole__c 
                                                              WHERE FinServ__RelatedContact__c IN :rContactStId AND
                                                              (FinServ__EndDate__c > :dateNow OR FinServ__EndDate__c = null) AND 
                                                              FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c = ''];
        
        Set<Id> fARContcStId = new Set<Id>();
        for(FinServ__FinancialAccountRole__c fAR : fARLst)
        {
            fARContcStId.add(fAR.FinServ__RelatedContact__c);
        }
        
        
        List<Contact> cleanContcLst = [SELECT Id, CRAN_ICA_KER_P_Identity__c, CRAS_ICA_ASS_T_AxisPersonID__c FROM Contact WHERE CRAN_VEC_ADV_N_NumericSort__c != '' AND Id NOT IN :fARContcStId AND Id IN :rContactStId];
        
        
        for(Contact contc : cleanContcLst)
        {
            if(String.isNotBlank(contc.CRAS_ICA_ASS_T_AxisPersonID__c))
            {
                contc.CRAN_ICA_KER_P_Identity__c = '102';
            }
            
        }
        
        update cleanContcLst;
    }
    
    
}