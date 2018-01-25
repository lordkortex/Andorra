/**
* Clase: CRAN_VAS_KER_OppTriggerHelper_CLS
* Fecha: Marzo 2017
* Descripcion: Esta clase contiene todos los metodos a ejecutar en algun evento del
* trigger de Oportunidad.
* */
public without sharing class CRAN_VAS_KER_OppTriggerHelper_CLS {
    
    private static CampaignInfluenceModel cim;
    
    /**
* Metodo deleteVentaObjetivoRelationship
* Fecha: Marzo 2017
* Descripcion: Este metodo borra todas las relaciones con objetivos 
* que tienen las ventas que se quieren borrar.
* */
    public static void deleteVentaObjetivoRelationship(List<Opportunity> oldSales) {        
        delete [select Id FROM CRAN_VAS_MAQ_VentasObjetivos__c WHERE CRAN_VAS_MAQ_L_Venta__c IN : oldSales];        
    }
    
    /**
* Metodo searchSaleGoals
* Fecha: Marzo 2017
* 
* Descripcion: Este metodo busca los objetivos que pueden cubrir las oportunidades de venta incluidas
* en la lista recibida como parametro.
* 
* */
    public static void executeTasks(List<Opportunity> sales, Set<Id> salesOwnerId, Map<Id, Boolean> updateCpInfluenceBySale,Map<Id, Id> primaryContactByAccount, 
                                    Boolean isUpdate,Set<Id> bpIds, Set<Id> salesValidated) {
        
        Set<CampaignMember> 							campaignMembersToUpsert		= new Set<CampaignMember>();
        Set<Opportunity>								goalsToUpdateOwner			= new Set<Opportunity>();
        List<CampaignInfluence>							cpInfluenceToUpdate			= new List<CampaignInfluence>();
        List<CRAN_VAS_MAQ_VentasObjetivos__c> 			saleGoalJunctionToUpsert 	= new List<CRAN_VAS_MAQ_VentasObjetivos__c>();
        List<CRAN_VAS_MAQ_VentasObjetivos__c> 			saleGoalJunctionToDelete 	= new List<CRAN_VAS_MAQ_VentasObjetivos__c>();
        Map<String, CRAN_VAS_MAQ_VentasObjetivos__c> 	saleGoalJunctionsByKey		= new Map<String, CRAN_VAS_MAQ_VentasObjetivos__c>();
        Map<String, List<Opportunity>> 					goalsByKey 					= new Map<String,List<Opportunity>>();
        Map<Id, Set<Id>> 								campaignIdsBySales			= new Map<Id, Set<Id>>();
        Map<Id,Map<String, CampaignMember>>				campaignMembersByCampaign 	= new Map<Id,Map<String, CampaignMember>>();
        List<CRAN_VAS_MAQ_VentasObjetivos__c> 			actualVOs					= new List<CRAN_VAS_MAQ_VentasObjetivos__c>();
		Map<Id,Id>										mapBPsManagers				= new Map<Id,Id>();
        Id mktGoalRecTypeId	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_MKT_RT);
        Id sysGoalRecTypeId	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_SIST_RT);        		
        
		User 	dummyManager 	= [SELECT Id FROM User WHERE alias = 'dummy' LIMIT 1];
		User 	rrhhManager 	= [SELECT Id, CRAN_ICA_KER_P_Oficina__c FROM User WHERE alias = 'rrhh' LIMIT 1];
        /**
        * Recuperamos un mapa con la influencia de cada venta en las campañas,
        * para posteriormente recuperar los objetivos asociados a dichas campañas.
        * */
        
        Set<Id> campaignIdsFullSet = new Set<Id>();
		
		/** Construccion de mapas con las el gestor por BP. Es necesario realizar este calculo 
			para que en caso de que el cliente/BP no este incluido como miembro de la campaña, se asigne como gestro del miembro el gestor de la cuenta*/                                                                	
		for (Account bpTmp : [Select Id, CRAN_VEC_ADV_L_RMOMngr__c from Account where ID IN :bpIds])
        {
            if(bpTmp.CRAN_VEC_ADV_L_RMOMngr__c != null){
            	mapBPsManagers.put(bpTmp.Id,bpTmp.CRAN_VEC_ADV_L_RMOMngr__c);
            }            
		}
		
        /** Creacion de mapa con las campañas cuyos miembros hay que actualizar y de las influencias a actualizar */
        for (CampaignInfluence cpInfluence: [SELECT Id, CampaignId, OpportunityId, CRAN_VAS_MAQ_B_ControlField__c FROM CampaignInfluence 
                                             WHERE (OpportunityId IN :sales OR OpportunityId IN :salesValidated) and Campaign.isActive = true]) {
            
            Set<Id> campaignIds = campaignIdsBySales.get(cpInfluence.OpportunityId);
            
            if (campaignIds == null) {
                campaignIds= new Set<Id>();
                campaignIdsBySales.put(cpInfluence.OpportunityId, campaignIds);				
            }
            
            campaignIds.add(cpInfluence.CampaignId);
            campaignIdsFullSet.add(cpInfluence.CampaignId);
            
            if (	(updateCpInfluenceBySale != null
                &&	updateCpInfluenceBySale.get(cpInfluence.OpportunityId) != null
                &&  updateCpInfluenceBySale.get(cpInfluence.OpportunityId))
               || (salesValidated != null
                &&	salesValidated.contains(cpInfluence.OpportunityId)!= null))  {                  
                    cpInfluence.CRAN_VAS_MAQ_B_ControlField__c = !cpInfluence.CRAN_VAS_MAQ_B_ControlField__c;
                    cpInfluenceToUpdate.add(cpInfluence);
                }
            
        }               
        
        for (CampaignMember cpMember: [	SELECT 	CampaignId, ContactId, Status, CRAN_VAS_MAQ_L_BP__c, CRAN_VAS_MAQ_L_GestorMiembroCampana__c
                                       FROM CampaignMember WHERE CampaignId IN :campaignIdsFullSet AND 	ContactId  IN :primaryContactByAccount.values()]) {
            Map<String, CampaignMember> cpMembers = campaignMembersByCampaign.get(cpMember.CampaignId);
            
            if (cpMembers == null) {
                cpMembers = new Map<String, CampaignMember>();
                campaignMembersByCampaign.put(cpMember.CampaignId, cpMembers);
            }
            
            cpMembers.put(cpMember.ContactId, cpMember);
            
        }		
        
        Set<Id> goalRecordTypes = new Set<Id>();
        goalRecordTypes.add(mktGoalRecTypeId);
        goalRecordTypes.add(sysGoalRecTypeId);
        
		if(isUpdate && !sales.isEmpty()){
            
            actualVOs = [	SELECT 	Id,
                         CRAN_VAS_MAQ_F_B_Ganada__c,
                         CRAN_VAS_MAQ_F_C_Importe__c,
                         CRAN_VAS_MAQ_F_C_Volumen__c,
                         CRAN_VAS_MAQ_F_B_SaleValidated__c,
                         CRAN_VAS_MAQ_B_VentaGanada__c,
                         CRAN_VAS_MAQ_C_VentaImporte__c,
                         CRAN_VAS_MAQ_N_VentaVolumen__c,
                         CRAN_VAS_MAQ_B_SaleValidated__c,
                         CRAN_VAS_MAQ_B_CoveredByOther__c,
                         CRAN_VAS_MAQ_L_Venta__c,
                         CRAN_VAS_MAQ_MD_Objetivo__c,
                         CRAN_VAS_MAQ_B_ManuallyCreated__c
                         FROM 	CRAN_VAS_MAQ_VentasObjetivos__c
                         WHERE 	CRAN_VAS_MAQ_L_Venta__c IN :sales
                        ];
        }
		if (isUpdate && !salesValidated.isEmpty()){ 
            
            saleGoalJunctionToUpsert.addAll([	SELECT 	Id,
                                   CRAN_VAS_MAQ_F_B_Ganada__c,
                                   CRAN_VAS_MAQ_F_C_Importe__c,
                                   CRAN_VAS_MAQ_F_C_Volumen__c,
                                   CRAN_VAS_MAQ_F_B_SaleValidated__c,
                                   CRAN_VAS_MAQ_B_VentaGanada__c,
                                   CRAN_VAS_MAQ_C_VentaImporte__c,
                                   CRAN_VAS_MAQ_N_VentaVolumen__c,
                                   CRAN_VAS_MAQ_B_SaleValidated__c,
                                   CRAN_VAS_MAQ_B_CoveredByOther__c,
                                   CRAN_VAS_MAQ_L_Venta__c,
                                   CRAN_VAS_MAQ_MD_Objetivo__c,
                                   CRAN_VAS_MAQ_B_ManuallyCreated__c
                                   FROM 	CRAN_VAS_MAQ_VentasObjetivos__c
                                   WHERE CRAN_VAS_MAQ_L_Venta__c IN :salesValidated
                                  ]);
		}
                                        
       	if(!sales.isEmpty()){   
            for (Opportunity goal: [SELECT 	Id,
                                    OwnerId,
                                    CampaignId,
                                    CRAN_ICA_KER_P_Oficina__c,
                                    CRAN_VAS_MAQ_L_BP__c,
                                    CRAN_VAS_MAQ_P_Ramo__c,
                                    CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c,
                                    AccountId,
                                    RecordTypeId,
                                    CRAN_VAS_MAQ_L_InitialAdvisor__c,
									CRAN_VAS_MAQ_P_InitialOffice__c,
                                    CRAN_VAS_MAQ_L_FinalAdvisor__c
                                    FROM 	Opportunity 
                                    WHERE 	RecordTypeId IN :goalRecordTypes                                
                                    AND		(AccountId IN :primaryContactByAccount.keySet() 
                                             OR CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c = true
                                             OR	AccountId = null)
                                    AND		(CRAN_VAS_MAQ_L_BP__c = null 
                                             OR CRAN_VAS_MAQ_L_BP__c IN :bpIds)
                                    AND 	CloseDate >= TODAY
                                    AND 	CRAN_VAS_MAQ_D_FechaInicio__c <= TODAY
                                    AND 	CampaignId IN :campaignIdsFullSet
                                    AND		Campaign.isActive = true]) {
                                        
                                        String key;
                                        if (!goal.CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c &&
                                            (goal.AccountId == null || goal.CRAN_VAS_MAQ_L_BP__c == null)){
                                                key = goal.OwnerId;   
                                            }
                                        else if (!goal.CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c) {
                                            key = 'Client';                        
                                        }
                                        
                                        else{
                                            key = 'Global';                                        
                                        }
                                        
                                        List<Opportunity> goals = goalsByKey.get(key);
                                        
                                        if (goals == null) {
                                            goals = new List<Opportunity>();
                                            goalsByKey.put(key, goals);
                                        }
                                        goals.add(goal);
                                        
                                    }
            
            List<Opportunity> clientGlobalGoals = goalsByKey.get('Client');            
            
            List<Opportunity> globalGoals = goalsByKey.get('Global');
            
            if (clientGlobalGoals == null){
                clientGlobalGoals = globalGoals;
            } else if (globalGoals != null) {
                clientGlobalGoals.addAll(globalGoals); 
            }
            
            for (Opportunity sale : sales) {
                
                Set<Id> campaignIds = new Set<Id>();
                if (campaignIdsBySales.containsKey(sale.Id)){
                    campaignIds = campaignIdsBySales.get(sale.Id);
                }                      
                
                
                List<Opportunity> goals = goalsByKey.get(sale.OwnerId);
                
                if(goals==null){
                    goals  = clientGlobalGoals;                
                } else if (clientGlobalGoals != null) {
                    goals.addAll(clientGlobalGoals);
                }
                
                
                if (goals != null) {
                    for (Opportunity goal : goals) {
                        
                        if (goal.CampaignId == NULL || (campaignIds != null && campaignIds.contains(goal.CampaignId))) { 
                            
                            if (!goal.CRAN_VAS_MAQ_B_Objetivo_de_Oficina__c) {
                                
                                if (goal.CRAN_VAS_MAQ_L_BP__c != null && goal.AccountId != null) {
                                    //globalCustomerGoals
                                    /*
                                    * Busqueda de objetivos asociados a BP que puedan
                                    * ser cubiertos por la venta.
                                    * */
                                    if ((sale.CRAN_VAS_MAQ_L_BP__c == goal.CRAN_VAS_MAQ_L_BP__c)
                                        && 	(goal.CRAN_VAS_MAQ_P_Ramo__c == null || goal.CRAN_VAS_MAQ_P_Ramo__c == sale.CRAN_VAS_MAQ_P_Ramo__c)
                                        && 	(goal.AccountId == sale.AccountId)) {
                                            if(sale.CRAN_VAS_MAQ_L_FinalAdvisor__c != null 
                                               && goal.OwnerId != sale.CRAN_VAS_MAQ_L_FinalAdvisor__c
                                               && goal.OwnerId == dummyManager.Id) {
                                                   if(goal.CRAN_VAS_MAQ_L_InitialAdvisor__c == null){
                                                       goal.CRAN_VAS_MAQ_L_InitialAdvisor__c = goal.OwnerId;
                                                       goal.CRAN_VAS_MAQ_P_InitialOffice__c = goal.CRAN_ICA_KER_P_Oficina__c;
                                                   }
                                                   goal.CRAN_ICA_KER_P_Oficina__c = sale.CRAN_ICA_KER_P_Oficina__c;
                                                   goal.OwnerId = sale.CRAN_VAS_MAQ_L_FinalAdvisor__c;														                                                                                                                    
                                                   goal.CRAN_VAS_MAQ_L_FinalAdvisor__c = sale.CRAN_VAS_MAQ_L_FinalAdvisor__c;                                                        
                                                   goalsToUpdateOwner.add(goal);
                                                   if(sale.IsWon || !sale.IsClosed){
                                                       saleGoalJunctionsByKey.putAll(createSaleGoalJunction(sale, goal,true));
                                                   }                                                       
                                               } else {
                                                   if(sale.IsWon || !sale.IsClosed){
														saleGoalJunctionsByKey.putAll(createSaleGoalJunction(sale, goal));
                                                   }    
                                               }                                            
                                        } 	                                    
                                } else if (sale.IsWon || !sale.IsClosed) {
                                    // globalPersonalGoals
                                    /**
									* Busqueda de objetivos personales que puedan ser cubiertos por la venta* */								
                                    saleGoalJunctionsByKey.putAll(createSaleGoalJunction(sale, goal));                                   
                                }
                            } else if (goal.RecordTypeId == mktGoalRecTypeId
                                       && String.isNotBlank(goal.CRAN_ICA_KER_P_Oficina__c)
                                       && goal.CRAN_ICA_KER_P_Oficina__c.equals(sale.CRAN_ICA_KER_P_Oficina__c)
                                       && (sale.IsWon || !sale.IsClosed)) {
                                           //globalCompanyGoals                           
                                           saleGoalJunctionsByKey.putAll(createSaleGoalJunction(sale, goal));
                                       }
                        } 
                    }
                }                            
                // Creates or updates Campaign Member based on the Sale and Campaign information
                if (!campaignIds.isEmpty()) {
                    
                    for (Id campaignId : campaignIds) {
                        
                        Map<String, CampaignMember> cpMembers 				= campaignMembersByCampaign.get(campaignId);
                        Id 							saleContactId 			= primaryContactByAccount.get(sale.AccountId);
                        Boolean 					createCampaignMember 	= false;
                        
                        if (cpMembers != null) {
                            CampaignMember cpMember = cpMembers.get(saleContactId);
                            
                            if (cpMember != null) {
                                if(cpMember.Status != CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WON){
                                	cpMember.Status = sale.StageName == 'Closed Won' ? CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WON :								CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WORKED;					    								
                                }   
								if(cpMember.CRAN_VAS_MAQ_L_GestorMiembroCampana__c == dummyManager.Id){
									cpMember.CRAN_VAS_MAQ_L_GestorMiembroCampana__c = sale.OwnerId;
								}								
                                campaignMembersToUpsert.add(cpMember);
                                cpMembers.put(saleContactId, cpMember);
                                campaignMembersByCampaign.put(campaignId,cpMembers);
                            } else {
                                createCampaignMember = true;
                            }
                            
                        } else {
                            createCampaignMember = true;
                        }
                        
                        if (createCampaignMember && saleContactId != null){
						
                            CampaignMember newCpMember = createCampaignMember(campaignMembersToUpsert, campaignId, sale, saleContactId, mapBPsManagers.get(sale.CRAN_VAS_MAQ_L_BP__c));
							
                            if(cpMembers==null){
                                cpMembers = new Map<String, CampaignMember> ();
                            }
                            cpMembers.put(saleContactId,newCpMember);
                            campaignMembersByCampaign.put(campaignId,cpMembers);
                        }
                        
                    }
                    
                }			
            }
            
            if (!saleGoalJunctionsByKey.isEmpty()) {
                
                if (isUpdate) {
                    for (CRAN_VAS_MAQ_VentasObjetivos__c actualGoalJunction : actualVOs) {
                                                                                  
                        String key = actualGoalJunction.CRAN_VAS_MAQ_MD_Objetivo__c + '' + actualGoalJunction.CRAN_VAS_MAQ_L_Venta__c;
                        
                        CRAN_VAS_MAQ_VentasObjetivos__c foundGoalJunction = saleGoalJunctionsByKey.get(key);
                        
                        if (foundGoalJunction != null) {					
                            saleGoalJunctionToUpsert.add(actualGoalJunction);
                            saleGoalJunctionsByKey.remove(key);
                        } else {
                            if(!actualGoalJunction.CRAN_VAS_MAQ_B_ManuallyCreated__c){
                                saleGoalJunctionToDelete.add(actualGoalJunction);
                            }						
                        }
                    }
                    
                    if (!saleGoalJunctionsByKey.isEmpty())
                        saleGoalJunctionToUpsert.addAll(saleGoalJunctionsByKey.values());                                                            
                    if(!saleGoalJunctionToDelete.isEmpty())
                        delete saleGoalJunctionToDelete;
                    
                } else {
                    insert saleGoalJunctionsByKey.values();
                }
                
            }
            if (!campaignMembersToUpsert.isEmpty())
                upsert new List<CampaignMember>(campaignMembersToUpsert);
      	}
                                        
		if (!goalsToUpdateOwner.isEmpty()){
            update new List<Opportunity>(goalsToUpdateOwner);                                                                        
        }	
                                        
		if (!saleGoalJunctionToUpsert.isEmpty()){
			Set<CRAN_VAS_MAQ_VentasObjetivos__c> tmpVOs = new Set<CRAN_VAS_MAQ_VentasObjetivos__c>();
            tmpVOs.addAll(saleGoalJunctionToUpsert);            
			upsert new List<CRAN_VAS_MAQ_VentasObjetivos__c> (tmpVOs);
		}
		if (!cpInfluenceToUpdate.isEmpty()){
			update cpInfluenceToUpdate;
		}
            
        
    }
    
    public static CampaignMember createCampaignMember(Set<CampaignMember> campaignMembersToUpsert, Id campaignId, Opportunity sale, Id saleContactId, Id ownerId) {
        
        
        String status;
        if (sale.StageName != 'Closed Won')
            status = CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WORKED;
        else 
            status = CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WON;
        
        CampaignMember	newCm 											= new CampaignMember();
		User 	dummyManager 	= [SELECT Id FROM User WHERE alias = 'dummy' LIMIT 1];
        User 	rrhhManager 	= [SELECT Id, CRAN_ICA_KER_P_Oficina__c FROM User WHERE alias = 'rrhh' LIMIT 1];
		
		
        newCm.Status 									= status;
        newCm.ContactId 								= saleContactId;
        newCm.CampaignId 								= campaignId;
        newCm.CRAN_VAS_MAQ_Origen__c					= CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_ORIGEN_NEW;
		newCm.CRAN_VAS_MAQ_L_BP__c 	= sale.CRAN_VAS_MAQ_L_BP__c;
		
		if(ownerId == dummyManager.Id){
			newCm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c	= sale.OwnerId;
		} else if (ownerId == rrhhManager.Id){
			newCm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c	= rrhhManager.Id;
		} else {
			newCm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c	= ownerId;
		}		
        
        campaignMembersToUpsert.add(newCm);
        return newCm;
    }
    
    public static Map<String, CRAN_VAS_MAQ_VentasObjetivos__c> createSaleGoalJunction(Opportunity sale, Opportunity goal) {
        return createSaleGoalJunction(sale, goal, false);
    }
    
    public static Map<String, CRAN_VAS_MAQ_VentasObjetivos__c> createSaleGoalJunction(Opportunity sale, Opportunity goal, boolean differentOwner) {
        
        Id goalId;
        if (goal == null)
            goalId = sale.CRAN_VAS_MAQ_L_Objetivo_Asociado__c;
        else
            goalId = goal.Id;
        
        Map<String, CRAN_VAS_MAQ_VentasObjetivos__c> saleGoalJunctionByKey = new Map<String, CRAN_VAS_MAQ_VentasObjetivos__c>();
        
        CRAN_VAS_MAQ_VentasObjetivos__c junction 	= new CRAN_VAS_MAQ_VentasObjetivos__c();
        junction.CRAN_VAS_MAQ_L_Venta__c 			= sale.Id;
        junction.CRAN_VAS_MAQ_MD_Objetivo__c 		= goalId;
        junction.CRAN_VAS_MAQ_B_ManuallyCreated__c	= false;
        junction.CRAN_VAS_MAQ_B_CoveredByOther__c	= differentOwner;
        
        saleGoalJunctionByKey.put(junction.CRAN_VAS_MAQ_MD_Objetivo__c + '' + junction.CRAN_VAS_MAQ_L_Venta__c,  junction);	
        
        return saleGoalJunctionByKey;
        
    }
    
    /**
* Metodo insertCampaignInfluence
* Fecha: Marzo 2017
* Descripcion: Genera un registro de influencia de campaña por cada venta creada.
* Utiliza para ello la campaña informada en el campo CampaignId de la venta.
* */
    public static CampaignInfluence insertCampaignInfluence(Opportunity sale) {
        
        CampaignInfluence cpInfluence = new CampaignInfluence();
        
        if (cim == null) {
            cim = [SELECT Id FROM CampaignInfluenceModel where IsDefaultModel = true];
        }
        
        cpInfluence.CampaignId 		= sale.CampaignId;
        cpInfluence.Influence		= 100;
        cpInfluence.OpportunityId	= sale.Id;
        cpInfluence.ModelId			= cim.Id;
        
        return cpInfluence;
    }
    /***
     * Acciones previas a la insercion/actualizacion sobre ventas/objetivos
     * */
    public static void beforeUpsertTasksVentasObjetivosMKT (List<Opportunity> sales, List<Opportunity> goals, Set<Id> salesOwnerId, 
                                                            Set<Id> relatedGoals, Set<Id> relatedClients, Boolean isUpdate, Set<Id> relatedBPs,
                                                           Map<String,Set<Id>> relatedOppsByClientBP, Set<Id> relatedCampaigns) {
        
        Map<Id, String>         		mapOpportunityOffice    = new Map<Id, String>();
        Map<Id, String>         		mapGoalFamilyProduct 	= new Map<Id, String>();
		Map<String,Id>					memberAdvisorByCampaign	= new Map<String,Id>();
        List<Opportunity> 				oppsAccountBP 			= null;
        Map<String,List<Opportunity>>	accountBPRelationships	= new Map<String,List<Opportunity>>();                                                               
		Map<Id,Id> 						mapBPsManagers			= new Map<Id,Id>();
		Map<Id,String> 						mapBPsOffices			= new Map<Id,String>();
		Id	recordTypeVenta	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT);
        Id	recordTypeVentaGanada = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT);
        Id 	recordTypeVentaPerdida = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_PERDIDA_RT);
        Id	recordTypeVentaCancelada = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_CANCELADA_RT);   
       	User 	dummyManager 	= [SELECT Id FROM User WHERE alias = 'dummy' LIMIT 1];
        User 	rrhhManager 	= [SELECT Id, CRAN_ICA_KER_P_Oficina__c FROM User WHERE alias = 'rrhh' LIMIT 1];
		Boolean cancelledOperation	= false;
		Set<Id> inactiveUsers = new Set<Id>();                                                               
                                                               
        /** Construccion de mapas con el gestor por miembro de campaña.*/  
 		for(CampaignMember cm :[SELECT Id, CampaignId,Contact.AccountId, 
                                CRAN_VAS_MAQ_L_BP__c, CRAN_VAS_MAQ_L_GestorMiembroCampana__c,
                                CRAN_VAS_MAQ_L_GestorAnterior__c
                                FROM CampaignMember
                                WHERE CampaignId IN : relatedCampaigns
                                AND Contact.AccountId IN :relatedClients
                                AND CRAN_VAS_MAQ_L_BP__c IN :relatedBPs]){			 
            memberAdvisorByCampaign.put(cm.Contact.AccountId +'-'+cm.CRAN_VAS_MAQ_L_BP__c +'-'+cm.CampaignId,cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c);                        
			salesOwnerId.add(cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c);                                    
		}
         
		/** Construccion de mapas con las el gestor por BP. Es necesario realizar este calculo 
			para que en caso de que el cliente/BP no este incluido como miembro de la campaña, se asigne
			como gestor final de la venta el gestor del BP*/                                                                	
		for (Account bpTmp : [Select Id, CRAN_VEC_ADV_L_RMOMngr__c, CRAN_ICA_KER_P_Oficina__c from Account where ID IN :relatedBPs])
        {
            if(bpTmp.CRAN_VEC_ADV_L_RMOMngr__c != null){
            	if(!salesOwnerId.contains(bpTmp.CRAN_VEC_ADV_L_RMOMngr__c)){
                	salesOwnerId.add(bpTmp.CRAN_VEC_ADV_L_RMOMngr__c);
            	}
            	mapBPsManagers.put(bpTmp.Id,bpTmp.CRAN_VEC_ADV_L_RMOMngr__c);
                mapBPsOffices.put(bpTmp.Id,bpTmp.CRAN_ICA_KER_P_Oficina__c);
            }            
		}
		/** Construccion de un mapa con la oficina por usuario */                                                                
        for(User userTmp : [Select Id, CRAN_ICA_KER_P_Oficina__c, IsActive From User Where Id IN :salesOwnerId])
        {
            if(!userTmp.isActive){
                inactiveUsers.add(userTmp.Id);                
            }
            mapOpportunityOffice.put(userTmp.Id, userTmp.CRAN_ICA_KER_P_Oficina__c);
        }
		/** Creacion de mapa con el ramo por objetivo */                
        if(!isUpdate){
            for(Opportunity goal : [Select Id, CRAN_VAS_MAQ_P_Ramo__c From Opportunity Where Id IN :relatedGoals]){
                mapGoalFamilyProduct.put(goal.Id,goal.CRAN_VAS_MAQ_P_Ramo__c);
            }
        }                                                                       
                              

        for (Opportunity opp: sales) {
            cancelledOperation = false;
            /** Validar que el gestor del miembro de campaña este activo */
            if(memberAdvisorByCampaign.get(opp.AccountId +'-'+opp.CRAN_VAS_MAQ_L_BP__c +'-'+opp.CampaignId) != null
              && inactiveUsers.contains(memberAdvisorByCampaign.get(opp.AccountId +'-'+opp.CRAN_VAS_MAQ_L_BP__c +'-'+opp.CampaignId))){
                  opp.addError(Label.CRAN_VAS_MAQ_InactiveMemberAdvisor);
                  break;
			} else if(memberAdvisorByCampaign.get(opp.AccountId +'-'+opp.CRAN_VAS_MAQ_L_BP__c +'-'+opp.CampaignId) == null
              && inactiveUsers.contains(mapBPsManagers.get(opp.CRAN_VAS_MAQ_L_BP__c))) {
                  opp.addError(Label.CRAN_VAS_MAQ_InactiveBPAdvisor);
                  break;
			}
            
            if(opp.IsClosed && opp.RecordTypeId == recordTypeVenta){
            	if(opp.IsWon){                        	
                	opp.RecordTypeId = recordTypeVentaGanada;                                                              
                } else if (opp.StageName.equals('Closed Lost')){
                    /**
    				* En otro caso, si no cambia ni a ClosedWon, está cambiando a Closed Lost.
    				* */
                    opp.RecordTypeId = recordTypeVentaPerdida;
                } else if (opp.StageName.equals('Cancelled')){
                    opp.RecordTypeId = recordTypeVentaCancelada;
                }                                       
            } else if (!opp.IsWon && opp.IsClosed && opp.RecordTypeId == recordTypeVentaGanada){                
                opp.RecordTypeId = recordTypeVentaCancelada;
                opp.CRAN_VAS_MAQ_B_Validation__c = false;
                cancelledOperation = true;
            } else if (opp.IsClosed && opp.RecordTypeId == recordTypeVentaPerdida && opp.StageName.equals('Cancelled')){
                opp.RecordTypeId = recordTypeVentaCancelada;
                opp.CRAN_VAS_MAQ_B_Validation__c = false;                
				cancelledOperation = true;
            }
            
            if(cancelledOperation) {
                //Si es cancelada y CRAN_VAS_MAQ_T_IdOperacionAxis__c o CRAN_VAS_MAQ_T_IdOperacionComercial__c 
            	//vienen informados, entonces, concatenamos '-yyMMddHHmmss' por detras
            	//Asi, si creamos una nueva venta con ese idOperacion, no nos saltará la validacion de ya existe
                String canceladaCodigo = Datetime.now().format('yyMMddHHmmss');
                if (opp.CRAN_VAS_MAQ_T_IdOperacionAxis__c  != null && opp.CRAN_VAS_MAQ_T_IdOperacionAxis__c != ''){
                    Integer ind = opp.CRAN_VAS_MAQ_T_IdOperacionAxis__c.indexOf('-');
					if(ind != -1){opp.CRAN_VAS_MAQ_T_IdOperacionAxis__c = opp.CRAN_VAS_MAQ_T_IdOperacionAxis__c.substring(0,ind);}
                    opp.CRAN_VAS_MAQ_T_IdOperacionAxis__c =  opp.CRAN_VAS_MAQ_T_IdOperacionAxis__c + '-' + canceladaCodigo;
                }
                
                if(opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c  != null && opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c != ''){
                    Integer ind = opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c.indexOf('-');
					if(ind != -1){opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c = opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c.substring(0,ind);}
                    opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c =  opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c + '-' + canceladaCodigo;
                }
            }
                                    
            if(!isUpdate){
                /** Asignacion oficina y usuario inicial*/
                opp.CRAN_ICA_KER_P_Oficina__c = mapOpportunityOffice.get(opp.OwnerId);
                opp.CRAN_VAS_MAQ_L_InitialAdvisor__c = opp.OwnerId;
                opp.CRAN_VAS_MAQ_P_InitialOffice__c = opp.CRAN_ICA_KER_P_Oficina__c;
                /** Inicializacion automatica del ramo a partir del indicado en el objetivo desde
                 * cuya pagina se crea la venta a traves de la quick action**/
                if(opp.CRAN_VAS_MAQ_L_Objetivo_Asociado__c != null){                    
                    opp.CRAN_VAS_MAQ_P_Ramo__c = mapGoalFamilyProduct.get(opp.CRAN_VAS_MAQ_L_Objetivo_Asociado__c);
                }
				/** Formacion del mapa para validar en las ventas la relacion BP-Cliente posteriormente**/                
                oppsAccountBP = accountBPRelationships.get(opp.AccountId+'-'+opp.CRAN_VAS_MAQ_L_BP__c);
                if(oppsAccountBP == null){
                    oppsAccountBP = new List<Opportunity>();
                }
                oppsAccountBP.add(opp);
                accountBPRelationships.put(opp.AccountId+'-'+opp.CRAN_VAS_MAQ_L_BP__c,oppsAccountBP);
            }
            if(opp.IsClosed){
            	if(relatedBPs.contains(opp.CRAN_VAS_MAQ_L_BP__c) && 
                   mapBPsManagers.get(opp.CRAN_VAS_MAQ_L_BP__c) != null){
                       /** Caso de BP gestionado por RRHH: RRHH y su oficina se apuntan la venta**/
                       if(mapBPsManagers.get(opp.CRAN_VAS_MAQ_L_BP__c) == rrhhManager.Id){
                           opp.CRAN_ICA_KER_P_Oficina__c = rrhhManager.CRAN_ICA_KER_P_Oficina__c;
                           opp.CRAN_VAS_MAQ_L_FinalAdvisor__c = rrhhManager.Id;
                       } else if(mapBPsManagers.get(opp.CRAN_VAS_MAQ_L_BP__c) == dummyManager.Id){                          
                           /** Caso de BP gestionado por Dummy Manager: el gestor que inicia la venta se la queda
                            * a menos que el miembro haya sido reasignado a otro gestor */
                           opp.CRAN_ICA_MAQ_B_isDummyManager__c = true;
                           opp.CRAN_ICA_MAQ_P_DummyManagerOffice__c = mapBPsOffices.get(opp.CRAN_VAS_MAQ_L_BP__c);
                           if(memberAdvisorByCampaign.get(opp.AccountId+'-'+opp.CRAN_VAS_MAQ_L_BP__c+'-'+opp.CampaignId)!=null
                              && (memberAdvisorByCampaign.get(opp.AccountId+'-'+opp.CRAN_VAS_MAQ_L_BP__c+'-'+opp.CampaignId)!=dummyManager.Id)){
                               opp.CRAN_VAS_MAQ_L_FinalAdvisor__c = memberAdvisorByCampaign.get(opp.AccountId+'-'+opp.CRAN_VAS_MAQ_L_BP__c+'-'+opp.CampaignId);
                               if (mapOpportunityOffice.containsKey(opp.CRAN_VAS_MAQ_L_FinalAdvisor__c)) {
                                   opp.CRAN_ICA_KER_P_Oficina__c = mapOpportunityOffice.get(opp.CRAN_VAS_MAQ_L_FinalAdvisor__c);
                               }
                          	}else {
                                opp.CRAN_VAS_MAQ_L_FinalAdvisor__c = opp.OwnerId;	      
                           	}
                       } else {               
                           if(memberAdvisorByCampaign.get(opp.AccountId+'-'+opp.CRAN_VAS_MAQ_L_BP__c+'-'+opp.CampaignId)!=null){
                               opp.CRAN_VAS_MAQ_L_FinalAdvisor__c = memberAdvisorByCampaign.get(opp.AccountId+'-'+opp.CRAN_VAS_MAQ_L_BP__c+'-'+opp.CampaignId);                           
                           } else {
                               opp.CRAN_VAS_MAQ_L_FinalAdvisor__c = mapBPsManagers.get(opp.CRAN_VAS_MAQ_L_BP__c);      
                           }                                                      
                           if (mapOpportunityOffice.containsKey(opp.CRAN_VAS_MAQ_L_FinalAdvisor__c)) {
                               opp.CRAN_ICA_KER_P_Oficina__c = mapOpportunityOffice.get(opp.CRAN_VAS_MAQ_L_FinalAdvisor__c);
                           }                           
                       }    
                }
                if(opp.CRAN_VAS_MAQ_L_FinalAdvisor__c == null){
					opp.CRAN_VAS_MAQ_L_FinalAdvisor__c = opp.OwnerId;
				}
				
            }
        }
        
        if(!isUpdate){
            for(Opportunity goal: goals){                
                /** Asignacion oficina y usuario inicial*/
                goal.CRAN_ICA_KER_P_Oficina__c = mapOpportunityOffice.get(goal.OwnerId);                                                                           
            }                                                              
		}
		/** Validar relacion BP-Cliente*/                                                                
        validateAccountBPRelationship(accountBPRelationships);
    }
    
    public static void validateAccountBPRelationship (Map<String,List<Opportunity>> accountBPRelationships) {
        
        
        for (CRAN_VAS_KER_LCUtil_CLS.relAccountBp badRel : CRAN_VAS_KER_LCUtil_CLS.getBadRelation(new List<String>(accountBPRelationships.keySet()))){
            
            for (Opportunity opp : accountBPRelationships.get(badRel.key)) {
                if(String.isNotBlank(badRel.correctNameBp)){
                	opp.addError(Label.CRAN_VAS_MAQ_InvalidAccountBP + ': '+badRel.correctNameBp);    
                } else {
                    opp.addError(Label.CRAN_VAS_MAQ_InvalidAccountBP);    
                }
                
            }                
        }
    }
    
    /**
     * Autor: VASS
     * Fecha: 27/07/2017
     * Descripcion: Metodo que elimina las siguientes relaciones con oportunidades de venta.
     * - Influencia de Campaña
     * - VentasObjetivos
     * 
     * Tambien devuelve al estado correcto al miembro de campaña.
     * 
     * */
    public static void deleteRelationshipsWithSales (Set<Id> sales, Set<Id> contactIds, Set<Id> lostSales) {
        
        
        
        Map<Id,Set<Id>> campaignsByContact 			= new Map<Id,Set<Id>>();        
        Map<Id,Map<Id,Set<Id>>> ventasByContact 		= new Map<Id,Map<Id,Set<Id>>>();
        Map<Id,Map<Id,Set<Id>>> ventasGanadasByContact 	= new Map<Id,Map<Id,Set<Id>>>();
        Set<Id> campaigns;
		Set<Id> campaignIds 						= new Set<Id>();
        Set<Id> rtCampaign 							= new Set<Id>();
        Set<Id> rtVentas							= new Set<Id>();
        Map<Id,Set<Id>> ventasGanadasByCampaign 	= new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> ventasByCampaign 	= new Map<Id,Set<Id>>();        
        User 	dummyManager 	= [SELECT Id FROM User WHERE alias = 'dummy' LIMIT 1];
		Id rtVentaGanada 		= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT);
        Id rtVentaPerdida 		= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_PERDIDA_RT);
        Id rtVenta 				= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT);
        Set<Id> ventas			= new Set<Id>();
        Set<Id> ventasGanadas	= new Set<Id>();
        Boolean miembroGanado = false;
		Boolean miembroTrabajado = false; 
		String originalStatus = '';
        List<CampaignMember> cmToUpdate = new List<CampaignMember>();
        
        rtCampaign.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Campaign', CRAN_VAS_KER_Constants_CLS.CAMPAIGN_MKT_RT));
        rtCampaign.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Campaign', CRAN_VAS_KER_Constants_CLS.CAMPAIGN_SIST_RT));
  		rtVentas.add(rtVentaGanada);
        rtVentas.add(rtVenta);
        rtVentas.add(rtVentaPerdida);

        if(sales != null && !sales.isEmpty()) {                    
            for(CampaignInfluence ciSale : [select CampaignId, OpportunityId,
                                            Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c
                                        from CampaignInfluence 
                                        where OpportunityId in :sales
                                        and Campaign.RecordTypeId in :rtCampaign]){
                campaigns = campaignsByContact.get(ciSale.Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c);
                if(campaigns == null) {
                    campaigns = new Set<Id>();                                
                }
                campaigns.add(ciSale.CampaignId);                                        
                campaignsByContact.put(ciSale.Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c,campaigns);
                    
                if(!campaignIds.contains(ciSale.CampaignId)){
                    campaignIds.add(ciSale.CampaignId);
                }		
            }

            for(CampaignInfluence ciContact: [select CampaignId, OpportunityId,
                                              Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c,
                                              Opportunity.RecordTypeId
                                             from CampaignInfluence
                                             where CampaignId in :campaignIds
                                              and Opportunity.RecordTypeId in :rtVentas
                                              and Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c in :contactIds]){                                
                if (campaignsByContact.get(ciContact.Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c) != null
                   && campaignsByContact.get(ciContact.Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c).contains(ciContact.CampaignId)){
                    if(ciContact.Opportunity.RecordTypeId == rtVentaGanada){
                        ventasGanadasByCampaign = ventasGanadasByContact.get(
                            ciContact.Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c);
                
                        if (ventasGanadasByCampaign == null){
                            ventasGanadasByCampaign = new Map<Id,Set<Id>>();
                        }
                        ventasGanadas = ventasGanadasByCampaign.get(ciContact.CampaignId);
                        if (ventasGanadas == null){
                            ventasGanadas = new Set<Id>();
                        }
                        ventasGanadas.add(ciContact.OpportunityId);
                        ventasGanadasByCampaign.put(ciContact.CampaignId,ventasGanadas);
                        ventasGanadasByContact.put(ciContact.Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c,
                                                   ventasGanadasByCampaign);
                    }
                       
                    if(ciContact.Opportunity.RecordTypeId == rtVenta || ciContact.Opportunity.RecordTypeId == rtVentaPerdida){
                        ventasByCampaign = ventasByContact.get(
                            ciContact.Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c);
                        if (ventasByCampaign == null){
                            ventasByCampaign = new Map<Id,Set<Id>>();
                        }
                        ventas = ventasByCampaign.get(ciContact.CampaignId);
                        if (ventas == null){
                            ventas = new Set<Id>();
                        }
                        ventas.add(ciContact.OpportunityId);
                        ventasByCampaign.put(ciContact.CampaignId,ventas);
                        ventasByContact.put(ciContact.Opportunity.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c,
                                                   ventasByCampaign);
                    }               	
                }
            }
            
            /**
             * Calculo de los miembros de campaña que hay que actualizar
             * */
            for(CampaignMember cm : [select Id, CampaignId, ContactId, Status 
                                     from CampaignMember 
                                     where CampaignId in :campaignIds
                                     and ContactId in :contactIds]){
                miembroGanado = false;
                miembroTrabajado = false;                                     
                /**
                 * El contacto esta afectado en esta campaña
                 * */ 
                if(campaignsByContact.get(cm.ContactId) != null &&
                   campaignsByContact.get(cm.ContactId).contains(cm.CampaignId)){
                       if(ventasByContact.get(cm.ContactId)!=null
                          && ventasByContact.get(cm.ContactId).get(cm.CampaignId)!=null
                          && ventasByContact.get(cm.ContactId).get(cm.CampaignId).size()>0){
                              miembroTrabajado = true;                                                      
                          }
                    if(ventasGanadasByContact.get(cm.ContactId)!=null
                       && ventasGanadasByContact.get(cm.ContactId).get(cm.CampaignId)!=null
                      && ventasGanadasByContact.get(cm.ContactId).get(cm.CampaignId).size()>0){
                          miembroGanado = true;
                       }
                                       
                   }
                
                originalStatus = cm.Status;                    
                if (miembroGanado){
                    cm.Status = CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WON;
                } else if (miembroTrabajado) {
                    cm.Status = CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WORKED;
                } else {
                    cm.Status = CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_NOTWORKED;
                }                                   
                if(!originalStatus.equals(cm.Status)){
                    cmToUpdate.add(cm);
                }
            }    
            update cmToUpdate;
        }
        if(!lostSales.isEmpty()){
            if(sales==null){
                sales = new Set<Id>();
            }
            sales.addAll(lostSales);
            
           List<CRAN_VAS_MAQ_VentasObjetivos__c> vos =[SELECT CRAN_VAS_MAQ_MD_Objetivo__c, 
                CRAN_VAS_MAQ_MD_Objetivo__r.AccountId,
				CRAN_VAS_MAQ_L_Venta__r.CRAN_VAS_MAQ_L_FinalAdvisor__c
           FROM CRAN_VAS_MAQ_VentasObjetivos__c 
           WHERE CRAN_VAS_MAQ_L_Venta__c IN :lostSales AND CRAN_VAS_MAQ_MD_Objetivo__r.OwnerId = :dummyManager.Id                                                       
               AND CRAN_VAS_MAQ_MD_Objetivo__r.AccountId != NULL
               AND CRAN_VAS_MAQ_MD_Objetivo__r.CRAN_VAS_MAQ_L_BP__c != NULL];
            
            Opportunity goalToUpdate = null;
            List<Opportunity> goalsToReassign = new List<Opportunity>();
            for (CRAN_VAS_MAQ_VentasObjetivos__c vo :vos){
                goalToUpdate = new Opportunity(Id= vo.CRAN_VAS_MAQ_MD_Objetivo__c, OwnerId = vo.CRAN_VAS_MAQ_L_Venta__r.CRAN_VAS_MAQ_L_FinalAdvisor__c);
                
                goalsToReassign.add(goalToUpdate);
            }
            update goalsToReassign;
            
        }
        
        delete [SELECT Id FROM CRAN_VAS_MAQ_VentasObjetivos__c where CRAN_VAS_MAQ_L_Venta__c in :sales];
		update [SELECT Id FROM CampaignInfluence where OpportunityId in :sales];        
    }    
}