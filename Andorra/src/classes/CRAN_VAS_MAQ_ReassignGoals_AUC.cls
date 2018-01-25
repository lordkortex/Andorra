public with sharing class CRAN_VAS_MAQ_ReassignGoals_AUC {
	
    @AuraEnabled
    public static String getFilteredData(Map<String,Object> filters, String strFieldApiNames) {
		
    	List<String>	recordTypeIds	= new List<String>();
    	recordTypeIds.add('\'' + CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_MKT_RT) + '\'');
    	recordTypeIds.add('\'' + CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_SIST_RT) + '\'');
    	
        //Boolean workedByOther 	= (Boolean)filters.get('workedByOther');
        /*if(!workedByOther){*/
        String queryGoals = String.format('FROM Opportunity WHERE OwnerId = \'\'{0}\'\' '+
                                   ' AND RecordTypeId IN ({1})',new String[]{ String.valueOf(filters.get('user')), String.join(recordTypeIds, ',')} );
                                         
		
        String closeDate = String.valueOf(filters.get('closeDate'));
        if (String.isNotBlank(closeDate))
            queryGoals = queryGoals + String.format(' AND CRAN_VAS_MAQ_D_FechaInicio__c <= {0}', new String[]{ closeDate });
        
		String startDate = String.valueOf(filters.get('startDate'));
        if (String.isNotBlank(startDate))
            queryGoals = queryGoals + String.format(' AND CloseDate >= {0}', new String[]{ startDate });

		String bp = String.valueOf(filters.get('bp'));
        if (String.isNotBlank(bp))
            queryGoals = queryGoals + String.format(' AND CRAN_VAS_MAQ_L_BP__c = \'\'{0}\'\'',new String[]{ bp });
		
		String client = String.valueOf(filters.get('client'));
        if (String.isNotBlank(client))
            queryGoals = queryGoals + String.format(' AND AccountId = \'\'{0}\'\'',new String[]{ client });
           
		String campaign = String.valueOf(filters.get('campaign')); 
        if (String.isNotBlank(campaign))
            queryGoals = queryGoals + String.format(' AND CampaignId = \'\'{0}\'\'',new String[]{ campaign });
        
        String officeBP = String.valueOf(filters.get('office_bp'));
        if(String.isNotBlank(officeBP))
            queryGoals = queryGoals + String.format(' AND CRAN_VAS_MAQ_L_BP__c != null AND CRAN_VAS_MAQ_L_BP__r.CRAN_ICA_KER_P_Oficina__c = \'\'{0}\'\'',
                                                    new String []{officeBP});
        try {
            System.debug('qUERY: '+queryGoals);
        	return JSON.serialize(CRAN_VAS_KER_LCUtil_CLS.getResults('Opportunity', queryGoals, strFieldApiNames));                	                                       
        } catch (AuraHandledException aex){
            throw aex;
        }		
        return '';
    }
    
    @AuraEnabled
    public static String getOfficesAndUsers (String officeSelected) {

       	
        Map<String, Object> 					mappedResults 	= new Map<String, Object>();
		CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper 	results 		= new CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper();
        
        if (String.isNotBlank(officeSelected)) {
        	String queryUsers = String.format('FROM User WHERE CRAN_ICA_KER_P_Oficina__c = \'\'{0}\'\'',new String[]{ officeSelected });
			results = CRAN_VAS_KER_LCUtil_CLS.getResults('User', queryUsers, 'Name,CRAN_ICA_KER_P_Oficina__c');
			mappedResults.put('users', results);
        } else {        	
       		results = CRAN_VAS_KER_LCUtil_CLS.getPicklistFieldValues('User','CRAN_ICA_KER_P_Oficina__c');
       		mappedResults.put('offices', results);
        }

        return JSON.serialize(mappedResults);
    }
    
    @AuraEnabled
    public static Boolean reassignGoalsToUser (List<String> goalsIds, Id userId) {
        
        try {

            if (String.isBlank(userId))
                userId = UserInfo.getUserId();
            
            User u = [Select Id, CRAN_ICA_KER_P_Oficina__c from User where Id = : userId];
            
            List<Opportunity> goalsSelected = [Select OwnerId, Id, CRAN_VAS_MAQ_L_BP__c, CampaignId
            									FROM Opportunity WHERE Id in :goalsIds];           
            Set<Id> bps = new Set<Id>();
            Map<Id,Set<Id>> campaigns = new Map<Id,Set<Id>>();
            for(Opportunity o: goalsSelected){
            	o.OwnerId = userId;
                o.CRAN_ICA_KER_P_Oficina__c = u.CRAN_ICA_KER_P_Oficina__c;
                if(campaigns.get(o.CampaignId)==null){
                    bps = new Set<Id>();
                }
            	if(!bps.contains(o.CRAN_VAS_MAQ_L_BP__c)){
            		bps.add(o.CRAN_VAS_MAQ_L_BP__c);
            	}
                campaigns.put(o.CampaignId,bps);
            }
            
            //Update Campaign Member Advisor            
            List<CampaignMember> cmToUpdate = new List<CampaignMember>();
            List<CampaignMember> cmFound = [Select Id,CRAN_VAS_MAQ_L_GestorMiembroCampana__c,
            									CampaignId,
            									CRAN_VAS_MAQ_L_BP__c
            									FROM CampaignMember
            									WHERE CampaignId =: campaigns.keySet() and CRAN_VAS_MAQ_L_BP__c in :bps];
            
            for (CampaignMember cm: cmFound){
                bps = campaigns.get(cm.CampaignId);
                if(bps.contains(cm.CRAN_VAS_MAQ_L_BP__c)){
                	cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c = userId;    
                    cmToUpdate.add(cm);
                }
                
            }
            
            update goalsSelected;
            update cmToUpdate;
        } catch (Exception ex) {
            System.debug('Error assigning goals: '+ ex.getMessage());
            return false;
        }
        return true;
    } 
    
}