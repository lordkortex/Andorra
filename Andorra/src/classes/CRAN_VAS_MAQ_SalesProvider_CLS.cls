/**
 * CRAN_VAS_MAQ_SalesProvider_CLS Class to display the advisor's sales list. 
 * If the user is an office director, it will display the director's sales and all the sales of his advisors.
 * 
 * Fecha: Abril 2017
 * @author VASS
 * @version 1.0
*/
public with sharing class CRAN_VAS_MAQ_SalesProvider_CLS implements CRAN_VAS_KER_DatatableProvider_CLS {
    
    public String getRecords(Map<String, Object> params) {
        
        Id campaignId;
        Id campaignMemberBP;
        Id campaignMemberClient;		
        String query;
        CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper results;
        
        Set<Id> salesRecTypeId	= new Set<Id>();        
        Set<String> userSalesIdSet = new Set<String>();
        Set<String> advisorSalesIdSet = new Set<String>();
        List<String> salesId = new List<String>();
        List<CampaignInfluence> ciRecords = new List<CampaignInfluence>();        
        
        Id	 	recordId 		= (Id)params.get('recordId');
        String 	fieldNames 	 	= (String)params.get('fieldNames');
        String 	displayType  	= (String)params.get('displayType');
        String 	displayLimit	= (String)params.get('displayLimit');
        String 	vision 			= (String)params.get('vision');     
        Boolean isDirector 		= vision.equals('Office');  						
        Boolean isAdvisor 		= vision.equals('User');
		Boolean isGlobal 		= vision.equals('Global');
                        
        SObjectType sObjectType  = recordId.getSObjectType();
        Boolean 	isCampaign 	 = sObjectType == Campaign.sObjectType;
        String		sObjectName	 = sObjectType.getDescribe().getName();
        
        salesRecTypeId.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT));
        salesRecTypeId.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT));
        salesRecTypeId.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_PERDIDA_RT));
		salesRecTypeId.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_CANCELADA_RT));
		
        Id ownerId;  
        try {
        	ownerId = (Id)params.get('ownerId');
        } catch (Exception ex) {
            ownerId = null;
        }             
        
        String ownerClauseStr = '';
        if (ownerId != null) {
            ownerClauseStr = ' AND OwnerId =\'' + ownerId + '\'';
        }            
    
        
        if (displayType == 'userRecords' && !isGlobal) {
            
            if (isCampaign) {
				
                campaignId 	= recordId;
                ciRecords 	= [SELECT 	OpportunityId 
                               FROM 	CampaignInfluence
                               WHERE 	CampaignId =: campaignId
                               AND 		Opportunity.OwnerId =: UserInfo.getUserId()
                               AND		Opportunity.RecordTypeId in : salesRecTypeId];
            } else {
                
                CampaignMember 	cpMember 				= [SELECT 	CampaignId, 
                                                           			Contact.AccountId, 
                                                           			CRAN_VAS_MAQ_L_BP__c 
                                                           FROM 	CampaignMember 
                                                           WHERE Id =: recordId];
                
								campaignId 				= cpMember.CampaignId;
								campaignMemberBP 		= cpMember.CRAN_VAS_MAQ_L_BP__c;
								campaignMemberClient 	= cpMember.Contact.AccountId;
								
								ciRecords 				= [	SELECT 	OpportunityId 
															FROM 	CampaignInfluence
															WHERE 	CampaignId =: campaignId
															AND 	Opportunity.OwnerId =: UserInfo.getUserId()
															AND		Opportunity.CRAN_VAS_MAQ_L_BP__c =: campaignMemberBP
															AND		Opportunity.RecordTypeId in :salesRecTypeId];
            }
                                    
            for (CampaignInfluence cpInfluence : ciRecords) {
                userSalesIdSet.add('\'' + cpInfluence.OpportunityId + '\'');                                          
            }
            
            for (OpportunityTeamMember opp:  [SELECT Id, 
													Name, 
													OpportunityAccessLevel, 
													OpportunityId, 
													Title, 
													UserId 
											FROM 	OpportunityTeamMember 
											WHERE	UserId = :UserInfo.getUserId()]) {
                userSalesIdSet.add('\'' + opp.OpportunityId + '\'');
            }
            
            salesId.add('\'\'');
            salesId.addAll(userSalesIdSet);
            query = String.format('FROM Opportunity WHERE Id IN ({0}){1}', 
                                  new String[]{ String.join(salesId, ','),
                                         ownerClauseStr
                                      });			
			
        } else if (displayType == 'advisorRecords' && (isDirector || isGlobal)) {

            List<String> usersIds	= new List<String>();
            for (Id userId : CRAN_VAS_KER_RoleUtils_CLS.getRoleSubordinateUsersFromCurrentUser()) {
                usersIds.add(userId);
            } 

            if (isCampaign) {
                
                campaignId 	= recordId;
            	ciRecords 	= [SELECT 	OpportunityId 
                               FROM 	CampaignInfluence
                               WHERE 	CampaignId =: campaignId
                               AND 		Opportunity.OwnerId IN : usersIds
                               AND		Opportunity.RecordTypeId  in :salesRecTypeId];
                
            } else {
                
                CampaignMember 	cpMember 				= [SELECT 	CampaignId, 
                                                           			Contact.AccountId, 
                                                           			CRAN_VAS_MAQ_L_BP__c 
                                                           FROM 	CampaignMember 
                                                           WHERE Id =: recordId];
                
								campaignId 				= cpMember.CampaignId;
								campaignMemberBP 		= cpMember.CRAN_VAS_MAQ_L_BP__c;
								campaignMemberClient 	= cpMember.Contact.AccountId;                
                
            	ciRecords = [	SELECT 	OpportunityId 
								FROM 	CampaignInfluence
								WHERE 	CampaignId =: campaignId
								AND 	Opportunity.OwnerId IN : usersIds
								AND		Opportunity.CRAN_VAS_MAQ_L_BP__c =: campaignMemberBP
                                AND		Opportunity.AccountId =: campaignMemberClient
                                AND		Opportunity.RecordTypeId in : salesRecTypeId];
            }
            
            if (usersIds.size() > 0) {     
                for (CampaignInfluence cpInfluence : ciRecords) {
					advisorSalesIdSet.add('\'' + cpInfluence.OpportunityId + '\'');                                          
				}                
            }
			
            if (!advisorSalesIdSet.isEmpty()) {
                
                salesId = new List<String>();
                salesId.add('\'\'');
                salesId.addAll(advisorSalesIdSet);
                query = String.format('FROM Opportunity WHERE Id IN ({0}){1}', 
                                      new String[]{ String.join(salesId, ','),
                                          ownerClauseStr
                                          });			

            }			
        }
        
        if (String.isNotBlank(query)) {
            
            if (String.isNotBlank(displayLimit))
                query+= ' LIMIT ' + displayLimit;            
            
            results = CRAN_VAS_KER_LCUtil_CLS.getResults('Opportunity', query, fieldNames);           
            
        }        
        
        return JSON.serialize(results); 
    }
    
}