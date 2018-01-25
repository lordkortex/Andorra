public with sharing class CRAS_ICA_ASS_Sinistrality_CLS {
    
    public static Map<Id,Decimal> siniestralityByPolicy(Id accountId){
        
        Map<Id,Decimal> result = new Map<Id,Decimal>();
        
        List<Account> accountSearch = [SELECT CRAS_ICA_ASS_F_AxisPersonID__c, OwnerId FROM Account WHERE Id = :accountId];
        
        if(accountSearch.Size() > 0)
        {
            if(accountSearch[0].CRAS_ICA_ASS_F_AxisPersonID__c != null) {
                
                List<FinServ__FinancialAccountRole__c> lstFASearch = 
                    [SELECT FinServ__FinancialAccount__c, FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c 
                     FROM FinServ__FinancialAccountRole__c 
                     WHERE FinServ__RelatedContact__c IN 
                     (Select Id FROM Contact WHERE CRAS_ICA_ASS_T_AxisPersonID__c = :accountSearch[0].CRAS_ICA_ASS_F_AxisPersonID__c) 
                     AND FinServ__Role__c = '101ASS'];
                
                //Para cada póliza de la que el cliente es tomador cogemos la suma total de sus primas y siniestros
                for(FinServ__FinancialAccountRole__c currentRole : lstFASearch){
                    
                    //buscamos el id del financial account asociado al rol
                    Id currentFAId = currentRole.FinServ__FinancialAccount__c;

                    List<FinServ__FinancialAccount__c> pctSinistralityList = [SELECT CRAS_ICA_ASS_PE_PctSiniestralidad__c 
                                                                              from  FinServ__FinancialAccount__c
                                                                              where id=:currentFAId
                                                                             ];
                    
                    if(pctSinistralityList[0].CRAS_ICA_ASS_PE_PctSiniestralidad__c != null)
                    {
                        Decimal pctSinistrality = pctSinistralityList[0].CRAS_ICA_ASS_PE_PctSiniestralidad__c;
                    	result.put(currentRole.id,pctSinistrality.setScale(2));
                    }
                    else
                    {
                        
                    	result.put(currentRole.id, 0);
                    }
                }
                
            }   
        }
        
        return result;
        
    }
    
}