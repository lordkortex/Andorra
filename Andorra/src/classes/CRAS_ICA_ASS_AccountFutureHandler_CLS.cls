public class CRAS_ICA_ASS_AccountFutureHandler_CLS {
    
    @future
    public static void changeOffice(List<Id> accIdLst)
    {	
        //Actualizacion de oficina en el Financial Account de Banca con la carga de Bp de Banca
        List<FinServ__FinancialAccount__c> fALst = [SELECT Id, CRAN_ICA_KER_P_Oficina__c, FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_Oficina__c FROM FinServ__FinancialAccount__c WHERE FinServ__PrimaryOwner__c IN :accIdLst];
        List<Id> faLstId = new List<Id>();
        
        for(FinServ__FinancialAccount__c fA : fALst)
        {
            fA.CRAN_ICA_KER_P_Oficina__c = fA.FinServ__PrimaryOwner__r.CRAN_ICA_KER_P_Oficina__c;
        	faLstId.add(fA.Id);
        }
        
        update fALst;
        
        //Ahora se procede a buscar todas las personas que son AccountOwner de esos Bp 
        //y actualizamos todas sus oficinas en los bp y Financial Account de seguros si hubiese
        List<FinServ__FinancialAccountRole__c> fARLst = [SELECT FinServ__RelatedContact__r.AccountId, FinServ__FinancialAccount__r.CRAN_ICA_KER_P_Oficina__c FROM FinServ__FinancialAccountRole__c WHERE FinServ__FinancialAccount__c IN :faLstId AND FinServ__RelatedContact__r.CRAS_ICA_ASS_T_AxisPersonID__c != '' AND FinServ__Role__c = :CRAS_ICA_ASS_Helpers_CLS.AccountOwner];
        
		List<Id> accLstId = new List<Id>();
        Map<Id, String> ofiPerson = new Map<Id, String>();
        
        for(FinServ__FinancialAccountRole__c fAR : fARLst)
        {
            accLstId.add(fAR.FinServ__RelatedContact__r.AccountId);
            ofiPerson.put(fAR.FinServ__RelatedContact__r.AccountId, fAR.FinServ__FinancialAccount__r.CRAN_ICA_KER_P_Oficina__c);
        }
        
        List<FinServ__FinancialAccountRole__c> fARLstAxis = [Select FinServ__FinancialAccount__c, FinServ__RelatedContact__r.AccountId FROM FinServ__FinancialAccountRole__c WHERE FinServ__RelatedContact__r.AccountId IN :accLstId AND FinServ__Role__c = :CRAS_ICA_ASS_Helpers_CLS.SEGUROS_ROL_TOMADOR];
        
		List<Id> fAListIdAxis = new List<Id>();
        
        Map<Id, Id> personFA = new Map<Id, Id>();
        
        for(FinServ__FinancialAccountRole__c fAR : fARLstAxis)
        {
            fAListIdAxis.add(fAR.FinServ__FinancialAccount__c);
            personFA.put(fAR.FinServ__FinancialAccount__c, fAR.FinServ__RelatedContact__r.AccountId);
        }
        
        List<FinServ__FinancialAccount__c> fAListAxis = [Select Id, FinServ__PrimaryOwner__c, CRAN_ICA_KER_P_Oficina__c FROM FinServ__FinancialAccount__c WHERE Id IN :fAListIdAxis];
        
        List<Id> bpLstId = new List<Id>();
        Map<Id, String> fABp = new Map<Id, String>();
        for(FinServ__FinancialAccount__c fA : fAListAxis)
        {
            fA.CRAN_ICA_KER_P_Oficina__c = ofiPerson.get(personFA.get(fA.Id));
            
            bpLstId.add(fA.FinServ__PrimaryOwner__c);
            fABp.put(fA.FinServ__PrimaryOwner__c, ofiPerson.get(personFA.get(fA.Id)));
        }
        
        update fAListAxis;
        
        List<Account> bpLst = [Select Id, CRAN_ICA_KER_P_Oficina__c FROM Account WHERE Id IN :bpLstId];
        
        for(Account bp : bpLst)
        {
            bp.CRAN_ICA_KER_P_Oficina__c = fABp.get(bp.Id);
        }
        
        update bpLst;
        
    }
}