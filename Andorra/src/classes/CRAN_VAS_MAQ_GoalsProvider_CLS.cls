public with sharing class CRAN_VAS_MAQ_GoalsProvider_CLS implements CRAN_VAS_KER_DatatableProvider_CLS {
    
    public String getRecords(Map<String, Object> params) {
        
        Id campaignId;
        Id bpId;
        Id clientId;
        String query;
		CampaignMember cpMember;        
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper results;     
        
        Id 		recordId 		= (Id)params.get('recordId');
        String 	fieldNames 		= (String)params.get('fieldNames');
        String 	displayType 	= (String)params.get('displayType');
        String 	displayLimit 	= (String)params.get('displayLimit');               
        String 	vision 			= (String)params.get('vision');
        Boolean isDirector 		= vision.equals('Office');  						
        Boolean isAdvisor 		= vision.equals('User');
		Boolean isGlobal 		= vision.equals('Global');
        
        Id ownerId;  
        try {
        	ownerId = (Id)params.get('ownerId');
        } catch (Exception ex) {
            ownerId = null;
        }     

        List<String>	recordTypeIds	= new List<String>();
        recordTypeIds.add('\'' + CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_MKT_RT) + '\'');
        recordTypeIds.add('\'' + CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_SIST_RT) + '\'');           
        
        if (recordId.getSObjectType() == Campaign.sObjectType) {
            campaignId = recordId;
        } else {
            cpMember 	= [SELECT CampaignId, Contact.AccountId, CRAN_VAS_MAQ_L_BP__c FROM CampaignMember WHERE Id =: recordId];
            campaignId 	= cpMember.CampaignId;
            bpId		= cpMember.CRAN_VAS_MAQ_L_BP__c;
            clientId	= cpMember.Contact.AccountId;
        }

        if (displayType == 'userRecords' && !isGlobal) {

            query = String.format('FROM Opportunity WHERE CampaignId =\'\'{0}\'\' AND CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c = false AND OwnerId = \'\'{1}\'\' AND Opportunity.RecordTypeId IN ({2}){3}{4}', 
                                  new String[]{ 
                                      campaignId,
                                      UserInfo.getUserId(),
                                      String.join(recordTypeIds, ','),
                                      (String.isNotBlank(bpId) ? ' AND CRAN_VAS_MAQ_L_BP__c=\'' + bpId + '\'' : '' ),
                                      (String.isNotBlank(clientId) ? ' AND AccountId=\'' + clientId + '\'' : '' )});
            
        } else if (displayType == 'advisorRecords' && (isDirector || isGlobal)) {        

            List<String> usersIds = new List<String>();
            
            if (ownerId == null) {
                for (Id userId : CRAN_VAS_KER_RoleUtils_CLS.getRoleSubordinateUsersFromCurrentUser()) {
                    usersIds.add('\'' + userId + '\'');
                } 
            } else {
                usersIds.add('\'' + ownerId + '\'');
            }
            
            if (!usersIds.isEmpty()) {            
                
                query = String.format('FROM Opportunity WHERE CampaignId =\'\'{0}\'\' AND CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c = false AND OwnerId IN ({1}) AND Opportunity.RecordTypeId IN ({2}){3}{4}', 
                                      new String[] { 
                                          campaignId,
                                          String.join(usersIds, ','),
                                          String.join(recordTypeIds, ','),
                                          (String.isNotBlank(bpId) ? ' AND CRAN_VAS_MAQ_L_BP__c=\'' + bpId + '\'' : '' ),
                                          (String.isNotBlank(clientId) ? ' AND AccountId=\'' + clientId + '\'' : '' )});
                
            }
            
        } else if (displayType == 'officeRecords' && String.isBlank(bpId) && String.isBlank(clientId)) {
            
            String ownerClauseStr = '';
            if (ownerId != null) {
                ownerClauseStr = ' AND OwnerId =\'' + ownerId + '\'';
            }                      
    
            query = String.format('FROM Opportunity WHERE CampaignId =\'\'{0}\'\' AND CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c = true AND Opportunity.RecordTypeId IN ({1}){2}{3}', 
                                      new String[] { 
                                          	campaignId,
                                            String.join(recordTypeIds, ','),
                                            (!isGlobal ? ' AND CRAN_VAS_MAQ_F_B_SameOffice__c= true' : '' ),
                                            ownerClauseStr});
        }
        
        if (String.isNotBlank(query)) {
            
            if (String.isNotBlank(displayLimit))
                query += ' LIMIT ' + displayLimit;            
 
            results = CRAN_VAS_KER_LCUtil_CLS.getResults('Opportunity', query, fieldNames);           
            
        }        
        
        return JSON.serialize(results); 
    }
    
}