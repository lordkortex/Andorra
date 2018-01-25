public with sharing class CRAN_VAS_MAQ_ReassignMembers_AUC {
    

    @AuraEnabled
    public static String getFilteredData(Map<String,Object> filters, String strFieldApiNames) {
        
        
        Map<String, Object>                     mappedResults   = new Map<String, Object>();
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper  results         = new CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper();
        
        String userId = String.valueOf(filters.get('user'));
        User    currentUser;
        User    selectedUser;
        Set<Id> users = new Set<Id>();
        
        users.add(UserInfo.getUserId());
        if(String.isNotEmpty(userId)){
          users.add(userId);  
        } 
           
        for(User u: [SELECT Id, Profile.Name, CRAN_ICA_KER_P_Oficina__c,alias FROM User WHERE Id in : users]){
            if(u.Id == UserInfo.getUserId()){
                currentUser = u;
            } else {
                selectedUser = u;
            }
        }
        
        if(selectedUser == null){
            selectedUser = currentUser;
        }        
		
        String queryMembers = String.format('FROM CampaignMember WHERE CRAN_VAS_MAQ_L_GestorMiembroCampana__c = \'\'{0}\'\'',
                                          new String[]{ selectedUser.Id } );        
        /**
         * Comprobar si el gestor seleccionado pertenece a la oficina del usuario de ejecución 
         * en caso de que este último sea un director de oficina. Se añade una excepción para que 
         * cuando el gestor seleccionado sea Dummy Manager sí lo permita.
         */
        if (CRAN_VAS_KER_Constants_CLS.USER_PROFILE_DIRECTOR_OFICINA.equals(currentUser.Profile.Name) 
            || CRAN_VAS_KER_Constants_CLS.USER_PROFILE_DIRECTOR_OFICINA_PRIVADO.equals(currentUser.Profile.Name)) {                
                if('rrhh'.equals(selectedUser.Alias)){
                    AuraHandledException e = new AuraHandledException(System.Label.CRAN_VAS_MAQ_RM_UserRRHH);
                	e.setMessage(System.Label.CRAN_VAS_MAQ_RM_FilterTitle);
                	throw e;    
                } else if(!'dummy'.equals(selectedUser.Alias) && currentUser.CRAN_ICA_KER_P_Oficina__c != selectedUser.CRAN_ICA_KER_P_Oficina__c){
                    AuraHandledException e = new AuraHandledException(System.Label.CRAN_VAS_MAQ_RM_UserOffice);
                    e.setMessage(System.Label.CRAN_VAS_MAQ_RM_FilterTitle);
                    throw e;
                } else if ('dummy'.equals(selectedUser.Alias)){
                    queryMembers = queryMembers + String.format(' AND CRAN_VAS_MAQ_L_BP__r.CRAN_ICA_KER_P_Oficina__c = \'\'{0}\'\'',
                                                        new String[]{ currentUser.CRAN_ICA_KER_P_Oficina__c });
                }
            } else if ('rrhh'.equals(selectedUser.Alias)){
            	AuraHandledException e = new AuraHandledException(System.Label.CRAN_VAS_MAQ_RM_UserRRHH);
                e.setMessage(System.Label.CRAN_VAS_MAQ_RM_FilterTitle);
                throw e;    
            }                       
        
        String bp = String.valueOf(filters.get('bp'));
        if (String.isNotBlank(bp))
            queryMembers = queryMembers + String.format(' AND CRAN_VAS_MAQ_L_BP__c = \'\'{0}\'\'',new String[]{ bp });
        
        String client = String.valueOf(filters.get('client'));
        if (String.isNotBlank(client))
            queryMembers = queryMembers + String.format(' AND Contact.AccountId = \'\'{0}\'\'',new String[]{ client });
           
        String campaign = String.valueOf(filters.get('campaign')); 
        if (String.isNotBlank(campaign))
            queryMembers = queryMembers + String.format(' AND CampaignId = \'\'{0}\'\'',new String[]{ campaign });
     
        
        return JSON.serialize(CRAN_VAS_KER_LCUtil_CLS.getResults('CampaignMember', queryMembers, strFieldApiNames));                                                
    }
    
    @AuraEnabled
    public static String getOfficesAndUsers (String officeSelected, String selectedUser) {

        Map<String, Object>                     mappedResults   = new Map<String, Object>();
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper  results         = new CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper();
        User    currentUser = [SELECT Profile.Name, CRAN_ICA_KER_P_Oficina__c FROM User WHERE Id =: UserInfo.getUserId()];
        Boolean showOnlyCurrentOffice = false;
        
        if (CRAN_VAS_KER_Constants_CLS.USER_PROFILE_GESTOR.equals(currentUser.Profile.Name) 
            || CRAN_VAS_KER_Constants_CLS.USER_PROFILE_GESTOR_PRIVADO.equals(currentUser.Profile.Name)) {
             mappedResults.put('showUserFilter',false);
             showOnlyCurrentOffice = true;
        } else if (CRAN_VAS_KER_Constants_CLS.USER_PROFILE_DIRECTOR_OFICINA.equals(currentUser.Profile.Name) 
            || CRAN_VAS_KER_Constants_CLS.USER_PROFILE_DIRECTOR_OFICINA_PRIVADO.equals(currentUser.Profile.Name)) {
            showOnlyCurrentOffice = true;   
        }
                        
        if (String.isNotBlank(officeSelected)) {
            String queryUsers = String.format('FROM User WHERE ID != \'\''+ selectedUser +'\'\' AND CRAN_ICA_KER_P_Oficina__c = \'\'{0}\'\'',new String[]{ officeSelected });
            results = CRAN_VAS_KER_LCUtil_CLS.getResults('User', queryUsers, 'Name,CRAN_ICA_KER_P_Oficina__c');
            mappedResults.put('users', results);
        } else {            
            results = CRAN_VAS_KER_LCUtil_CLS.getPicklistFieldValues('User','CRAN_ICA_KER_P_Oficina__c');
            
            if (showOnlyCurrentOffice 
                &&!results.picklistFields.isEmpty() 
                && String.isNotBlank(currentUser.CRAN_ICA_KER_P_Oficina__c)) {
                    
                    CRAN_VAS_KER_LCUtil_CLS.PicklistFieldModel pickListModel = results.picklistFields[0];
                    String userOfficeValue;
                    String userOfficeLabel;

                    
                    for (Integer i=0; i < pickListModel.values.size(); i++) {
                        if (pickListModel.values[i] == currentUser.CRAN_ICA_KER_P_Oficina__c) {
                            userOfficeValue = pickListModel.values[i];
                            userOfficeLabel = pickListModel.labels[i];
                            break;   
                        } 
                    }

                    pickListModel.values.clear();
                    pickListModel.labels.clear();
                    pickListModel.values.add(userOfficeValue);
                    pickListModel.labels.add(userOfficeLabel);                                             
                    
                }
                mappedResults.put('offices', results);            
            
        }
        return JSON.serialize(mappedResults);
    }
    
    @AuraEnabled
    public static Boolean reassignMembersToUser (List<String> memberIds, Id userId) {
        
        try {
            Map<String,Set<Id>> mapCampaignsByContactBP = new Map<String,Set<Id>>();
            Set<Id> contacts = new Set<Id>();
            Set<Id> bps = new Set<Id>();
            Set<Id> campaigns = new Set<Id>();
            Set<Id> recordTypesGoal = new Set<Id>();
            Set<Id> campaignList = null;
            List<Opportunity> goalsToUpdate = new List<Opportunity>();
            
            Id	recordTypeObjetivoSist	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_SIST_RT);
        	Id	recordTypeObjetivoMkt 	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_MKT_RT);
            recordTypesGoal.add(recordTypeObjetivoSist);
            recordTypesGoal.add(recordTypeObjetivoMkt);
            
            List<CampaignMember> cmToUpdate = [SELECT Id, CRAN_VAS_MAQ_L_GestorAnterior__c, CRAN_VAS_MAQ_L_GestorMiembroCampana__c,
                                               	ContactId, CRAN_VAS_MAQ_L_BP__c, CampaignId
                                                FROM CampaignMember
                                                WHERE Id IN :memberIds];
            if (String.isBlank(userId))
                userId = UserInfo.getUserId();
            
            User u = [SELECT Id, CRAN_ICA_KER_P_Oficina__c FROM User WHERE Id = :userId];
            
            for (CampaignMember cm : cmToUpdate){           	
                cm.CRAN_VAS_MAQ_L_GestorAnterior__c = cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c;
                cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c = userId;
                if(!contacts.contains(cm.ContactId)){
                    contacts.add(cm.ContactId);
                }
                if(!bps.contains(cm.CRAN_VAS_MAQ_L_BP__c)){
                    bps.add(cm.CRAN_VAS_MAQ_L_BP__c);
                }
                if(!campaigns.contains(cm.CampaignId)){
                	campaigns.add(cm.CampaignId);    
                }                
                if(mapCampaignsByContactBP.get(cm.ContactId+'-'+cm.CRAN_VAS_MAQ_L_BP__c)==null){
                    campaignList = new Set<Id>();
                } else {
                    campaignList = mapCampaignsByContactBP.get(cm.ContactId+'-'+cm.CRAN_VAS_MAQ_L_BP__c);
                }                                
                if(!campaignList.contains(cm.CampaignId)){
                	campaignList.add(cm.CampaignId);    
                }                
                mapCampaignsByContactBP.put(cm.ContactId+'-'+cm.CRAN_VAS_MAQ_L_BP__c,campaignList);
            }
            
            List<Opportunity> goals = [SELECT Id,Account.FinServ__PrimaryContact__c,
                                       CRAN_VAS_MAQ_L_BP__c, CampaignId,
                                       CRAN_ICA_KER_P_Oficina__c,
                                       OwnerId,
                                       CRAN_VAS_MAQ_L_InitialAdvisor__c,
                                       CRAN_VAS_MAQ_P_InitialOffice__c
                                       FROM Opportunity
                                       WHERE RecordTypeId IN :recordTypesGoal
                                       AND Account.FinServ__PrimaryContact__c IN :contacts
                                       AND CRAN_VAS_MAQ_L_BP__c IN :bps
                                       AND CampaignId IN :campaigns];
            for(Opportunity goal: goals){
                if(mapCampaignsByContactBP.get(goal.Account.FinServ__PrimaryContact__c +'-'+ goal.CRAN_VAS_MAQ_L_BP__c) != null
                   && mapCampaignsByContactBP.get(goal.Account.FinServ__PrimaryContact__c +'-'+ goal.CRAN_VAS_MAQ_L_BP__c).contains(goal.CampaignId)){                       
                       goal.CRAN_VAS_MAQ_L_InitialAdvisor__c = goal.OwnerId;
                       goal.CRAN_VAS_MAQ_P_InitialOffice__c = goal.CRAN_ICA_KER_P_Oficina__c;
                       goal.OwnerId = userId;
                       goal.CRAN_ICA_KER_P_Oficina__c = u.CRAN_ICA_KER_P_Oficina__c;
                       goalsToUpdate.add(goal);
                   }
            }
            
            update cmToUpdate;
            update goalsToUpdate;
        } catch (Exception ex) {                        
            
            AuraHandledException e = new AuraHandledException(System.Label.CRAN_VAS_MAQ_AG_AssignKO);
            e.setMessage(System.Label.CRAN_VAS_MAQ_AG_AssignKO);
            System.debug('Error assigning members: '+ ex.getMessage());
            throw e;  
        }
        return true;
    } 
    
}