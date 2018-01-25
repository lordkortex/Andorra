public with sharing class CRAN_VAS_MAQ_CampaignMembersProvider_CLS implements CRAN_VAS_KER_DatatableProvider_CLS {
    
    public String getRecords(Map<String, Object> params) {
        
        String query;
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper 	results;          
        
        String 	recordId 		= (String)params.get('recordId');
        String 	fieldNames 		= (String)params.get('fieldNames');
        String 	displayType  	= (String)params.get('displayType');
        String 	displayLimit	= (String)params.get('displayLimit');
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
        

        if (displayType == 'userRecords' && !isGlobal) {

            query = String.format('FROM CampaignMember WHERE CampaignId = \'\'{0}\'\' AND CRAN_VAS_MAQ_L_GestorMiembroCampana__c = \'\'{1}\'\'', 
								new String[]{ recordId, UserInfo.getUserId()});

            
        } else if(displayType == 'advisorRecords' && (isDirector || isGlobal)) {
            
                List<String> usersIds	= new List<String>();
            	if(ownerId != null){
                    usersIds.add('\'' + ownerId + '\'');
                } else {
                	for (Id userId : CRAN_VAS_KER_RoleUtils_CLS.getRoleSubordinateUsersFromCurrentUser()) {
                    	usersIds.add('\'' + userId + '\'');
                    }
                }

                if (usersIds.size() > 0) {            
                    
                    query = String.format('FROM CampaignMember WHERE CampaignId = \'\'{0}\'\' AND CRAN_VAS_MAQ_L_GestorMiembroCampana__c IN ({1})',
                                          new String[]{ recordId,  String.join(usersIds, ',')});
                    
                }
        }

        if (String.isNotBlank(query)) {

            if (String.isNotBlank(displayLimit))
                query += ' LIMIT ' + displayLimit;            
   
            results = CRAN_VAS_KER_LCUtil_CLS.getResults('CampaignMember', query, fieldNames);           
            
        }
        
        if (results != null && !isDirector) {
            results.isUpdateable = false;
            results.isCreateable = false;
            results.isDeletable = false;
        }
        
        return JSON.serialize(results);        
    }
}