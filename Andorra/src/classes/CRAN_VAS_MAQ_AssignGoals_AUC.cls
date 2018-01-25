/**
 * Class: CRAN_VAS_MAQ_AssignGoals_AUC
 * Date: Abril 2017
 * Description: Aura Controller for the assign goals lighning component.
 * */
public with sharing class CRAN_VAS_MAQ_AssignGoals_AUC {
    
    @AuraEnabled
    public static String getGoalsAssignedToDummy(Id campaignId, String fieldNames,String vision) {
        
		return getGoalsAssignedToDummyByOffice (campaignId,'',fieldNames,vision);
    }
    
    @AuraEnabled
    public static String getGoalsAssignedToDummyByOffice(Id campaignId, String officeCode, String fieldNames, String vision) {
            
		User 	dummyUser = [SELECT Id FROM User WHERE Name =: 'Dummy Manager'];
        User 	currentUser = [SELECT UserRoleId, UserRole.DeveloperName, Profile.Name, CRAN_ICA_KER_P_Oficina__c FROM User WHERE Id =: UserInfo.getUserId()];
		
        Boolean isDirectorArea 	= false;
        Boolean isDirectorOficina = false;  						
        Boolean isAdvisor = false;

        if (vision.equals('Global')) {
            isDirectorArea = true;
        } else if (vision.equals('Office')) {
            isDirectorOficina = true;
        } else if (vision.equals('User')) {
            isAdvisor = true;
        }     
        
        String queryGoals;
        String queryUsers;
        String officeName;
        List<Campaign> campaignName = [Select Name FROM Campaign WHERE Id =: campaignId];
        
        Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper> 	mappedResults 	= new Map<String, CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper>();
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper goalsResults = new CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper();
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper usersResults = new CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper();
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper officesResults = new CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper();
        
        if (isDirectorArea && !String.isNotBlank(officeCode)) {
            officesResults = CRAN_VAS_KER_LCUtil_CLS.getPicklistFieldValues('User','CRAN_ICA_KER_P_Oficina__c');                       
			mappedResults.put('offices',officesResults);
        }
        
        if (!isDirectorArea) {
        	officeCode = currentUser.CRAN_ICA_KER_P_Oficina__c;        
        }
        
        if (String.isNotBlank(officeCode)) {
        	List<String>	recordTypeIds	= new List<String>();
        	recordTypeIds.add('\'' + CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_MKT_RT) + '\'');
        	recordTypeIds.add('\'' + CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_SIST_RT) + '\'');
        
        	queryGoals = String.format('FROM Opportunity WHERE CampaignId = \'\'{0}\'\' AND OwnerId = \'\'{1}\'\' '+
                        ' AND RecordTypeId IN ({3})'+
        				' AND CRAN_VAS_MAQ_L_BP__r.CRAN_ICA_KER_P_Oficina__c = \'\'{2}\'\' AND CRAN_VAS_MAQ_L_BP__r.OwnerId = \'\'{1}\'\' '+
        				' AND CRAN_VAS_MAQ_D_FechaInicio__c <= TODAY AND CloseDate >= TODAY AND CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c = false', 
                              new String[]{ campaignId, dummyUser.Id, officeCode,String.join(recordTypeIds, ',')});
			goalsResults = CRAN_VAS_KER_LCUtil_CLS.getResults('Opportunity', queryGoals, fieldNames); 
            mappedResults.put('goals', goalsResults);
        }
        
        if ((isDirectorOficina || isDirectorArea) && String.isNotBlank(officeCode)) {
        	queryUsers = String.format('FROM User WHERE CRAN_ICA_KER_P_Oficina__c = \'\'{0}\'\'', 
                              new String[]{officeCode});
			usersResults = CRAN_VAS_KER_LCUtil_CLS.getResults('User', queryUsers, 'Name');
            mappedResults.put('users', usersResults);
        }
        
		List<Object> result = new List<Object>();

        result.add(mappedResults);
        result.add(campaignName[0].Name);

        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static String getGoalDetailsController (Id goalId, String fieldNames){
    	String queryGoals;
    	CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper goalsResults = new CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper();
    	
    	queryGoals = String.format('FROM Opportunity WHERE Id = \'\'{0}\'\'', 
                              new String[]{ goalId});
    	goalsResults = CRAN_VAS_KER_LCUtil_CLS.getResults('Opportunity', queryGoals, fieldNames);
    	
    	return JSON.serialize(goalsResults);
    }
    
    @AuraEnabled
    public static Boolean assignGoalsToUser(Id campaignId, List<String> goalsIds){
        return assignGoalsToUser(campaignId,goalsIds,UserInfo.getUserId());
    }
    
    @AuraEnabled
    public static Boolean assignGoalsToUser (Id campaignId, List<String> goalsIds, Id userId){
        
        try {
  
            if (userId==null) {
                userId=UserInfo.getUserId();
            }

            Set<Id> goals = new Set<Id>();
            
            for (String g: goalsIds) {
            	goals.add(Id.valueOf(g));
            }
            
            User u = [Select Id, CRAN_ICA_KER_P_Oficina__c from User where Id = : userId];
            
            List<Opportunity> goalsSelected = [Select OwnerId, Id, CRAN_VAS_MAQ_L_BP__c
            									FROM Opportunity WHERE Id in :goals];            
            
            Set<Id> bps = new Set<Id>();
            for (Opportunity o: goalsSelected) {
            	o.OwnerId = userId;
                o.CRAN_ICA_KER_P_Oficina__c = u.CRAN_ICA_KER_P_Oficina__c;
            	if (!bps.contains(o.CRAN_VAS_MAQ_L_BP__c)) {
            		bps.add(o.CRAN_VAS_MAQ_L_BP__c);
            	}
            }
            
            //
            //Update Campaign Member Advisor            
            List<CampaignMember> cmSelected = [Select Id,CRAN_VAS_MAQ_L_GestorMiembroCampana__c,
            									CRAN_VAS_MAQ_L_BP__c
            									FROM CampaignMember
            									WHERE CampaignId =: campaignId and CRAN_VAS_MAQ_L_BP__c in :bps];
            
            for (CampaignMember cm: cmSelected) {
            	cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c = userId;
            }
            
            update goalsSelected;
            update cmSelected;
        } catch (Exception ex) {
            System.debug('Error assigning goals: '+ex.getMessage());
            return false;
        }
        return true;
    } 
    
}