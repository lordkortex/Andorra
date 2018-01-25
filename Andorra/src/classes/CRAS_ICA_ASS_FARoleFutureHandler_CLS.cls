public class CRAS_ICA_ASS_FARoleFutureHandler_CLS {
        
    @future
    public static void updateRecordsRelationships(List<Id> RolIdsList){
        List<FinServ__FinancialAccountRole__c> listFARUpdated = [SELECT Id, CRAS_ICA_ASS_T_AxisFARoleID__c FROM FinServ__FinancialAccountRole__c WHERE Id IN :RolIdsList];
        
        List<String> axisIdsUpdated = new List<String>();
        for(FinServ__FinancialAccountRole__c role : listFARUpdated){
            axisIdsUpdated.add(role.CRAS_ICA_ASS_T_AxisFARoleID__c);
        }
        
        List<FinServ__FinancialAccountRole__c> listFARNew = [SELECT Id, CRAS_ICA_ASS_T_AxisFARoleID__c FROM FinServ__FinancialAccountRole__c WHERE Id NOT IN :RolIdsList AND CRAS_ICA_ASS_T_AxisFARoleID__c IN :axisIdsUpdated];
        
        Map<String, String> newFARIdsMap = new Map<String, String>();
        for (FinServ__FinancialAccountRole__c roleNew: listFARNew){
            newFARIdsMap.put(roleNew.CRAS_ICA_ASS_T_AxisFARoleID__c, roleNew.Id);
        }
        
		List<FinServ__FinancialHolding__c> listFHToUpdate = [SELECT Id, CRAS_ICA_ASS_MD_FinancialAccountRole__c, CRAS_ICA_ASS_MD_FinancialAccountRole__r.CRAS_ICA_ASS_T_AxisFARoleID__c FROM FinServ__FinancialHolding__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__c IN :RolIdsList AND CRAS_ICA_ASS_T_AxisGuaranteeID__c != ''];
		List<CRAS_ICA_ASS_ClaimAmountHistory__c> listCAHToUpdate = [SELECT Id, CRAS_ICA_ASS_L_Role__c, CRAS_ICA_ASS_L_Role__r.CRAS_ICA_ASS_T_AxisFARoleID__c FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__c IN :RolIdsList];
		List<CRAS_ICA_ASS_Invoice__c> listInvoicesToUpdate = [SELECT Id, CRAS_ICA_ASS_MD_FinancialAccountRole__c, CRAS_ICA_ASS_MD_FinancialAccountRole__r.CRAS_ICA_ASS_T_AxisFARoleID__c FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__c IN :RolIdsList];
        
        for (FinServ__FinancialHolding__c fh: listFHToUpdate){
            if (newFARIdsMap.keySet().contains(fh.CRAS_ICA_ASS_MD_FinancialAccountRole__r.CRAS_ICA_ASS_T_AxisFARoleID__c)){
            	fh.CRAS_ICA_ASS_MD_FinancialAccountRole__c = newFARIdsMap.get(fh.CRAS_ICA_ASS_MD_FinancialAccountRole__r.CRAS_ICA_ASS_T_AxisFARoleID__c);    
            }
        }
        
        update listFHToUpdate;
        
        for (CRAS_ICA_ASS_ClaimAmountHistory__c cah: listCAHToUpdate){
            if (newFARIdsMap.keySet().contains(cah.CRAS_ICA_ASS_L_Role__r.CRAS_ICA_ASS_T_AxisFARoleID__c)){
            	cah.CRAS_ICA_ASS_L_Role__c = newFARIdsMap.get(cah.CRAS_ICA_ASS_L_Role__r.CRAS_ICA_ASS_T_AxisFARoleID__c);    
            }
        }
        
        update listCAHToUpdate;
        
        for (CRAS_ICA_ASS_Invoice__c inv: listInvoicesToUpdate){
            if (newFARIdsMap.keySet().contains(inv.CRAS_ICA_ASS_MD_FinancialAccountRole__r.CRAS_ICA_ASS_T_AxisFARoleID__c)){
            	inv.CRAS_ICA_ASS_MD_FinancialAccountRole__c = newFARIdsMap.get(inv.CRAS_ICA_ASS_MD_FinancialAccountRole__r.CRAS_ICA_ASS_T_AxisFARoleID__c);    
            }
        }
        
        update listInvoicesToUpdate;
        
        //FIN
        delete listFARUpdated;
    }

    public static void cloneBeforeUpdateFinancialAccountRole(List<FinServ__FinancialAccountRole__c> newList, List<FinServ__FinancialAccountRole__c> oldList)
    {
        Map<Id, FinServ__FinancialAccountRole__c> farInsertMap = new Map<Id, FinServ__FinancialAccountRole__c>();

        for(Integer i = 0; i < newList.size(); i++)
        {
            FinServ__FinancialAccountRole__c newFar = newList[i];
            FinServ__FinancialAccountRole__c oldFar = oldList[i];

            FinServ__FinancialAccountRole__c farTmp = newFar.clone(false,true,false,false);  

            if(newFar.FinServ__RelatedAccount__c != oldFar.FinServ__RelatedAccount__c
                || newFar.FinServ__RelatedContact__c != oldFar.FinServ__RelatedContact__c
                || newFar.FinServ__Role__c != oldFar.FinServ__Role__c)
            {
                farInsertMap.put(oldList[i].Id, farTmp); 
                
                newFar.Finserv__RelatedContact__c = oldFar.Finserv__RelatedContact__c;
                newFar.FinServ__RelatedAccount__c = oldFar.FinServ__RelatedAccount__c;
                newFar.FinServ__Role__c = oldFar.FinServ__Role__c;
                newFar.CRAS_ICA_ASS_T_AxisFARoleID__c += '-Inactive'; 
            }
        }

        System.debug(farInsertMap.values());

        if(farInsertMap.size() > 0)
        {
            insert farInsertMap.values();
        }
        
    }

    public static void disableAfterUpdateFinancialAccountRole(List<FinServ__FinancialAccountRole__c> newList)
    {
        delete [Select Id FROM FinServ__FinancialAccountRole__c WHERE CRAS_ICA_ASS_T_AxisFARoleID__c Like '%-Inactive'];

    }
    
    
}