public with sharing class CRAN_VAS_KER_OppTriggerHandler_CLS extends TriggerHandler {

    private Map<Id, Opportunity> 	newOpportunityMap;
    private Map<Id, Opportunity> 	oldOpportunityMap;
    private List<Opportunity> 		newOpportunityList;
    private List<Opportunity> 		oldOpportunityList;

    public CRAN_VAS_KER_OppTriggerHandler_CLS(SObjectType objectType) {
        super(objectType);
        this.newOpportunityMap 	= (Map<id, Opportunity>) 	Trigger.newMap;
        this.oldOpportunityMap 	= (Map<id, Opportunity>) 	Trigger.oldMap;
        this.newOpportunityList = (List<Opportunity>) 		Trigger.new;
        this.oldOpportunityList = (List<Opportunity>) 		Trigger.old;    
    }
  
    public override void beforeDelete() {
        CRAN_VAS_KER_OppTriggerHelper_CLS.deleteVentaObjetivoRelationship(oldOpportunityList);
    }
  
    public override void afterInsert() {

		Id 							recordTypeVenta 		= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT);
        Id 							recordTypeVentaGanada 	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT);
        Id 							recordTypeVentaPerdida	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_PERDIDA_RT);
        Id							recordTypeVentaCancelada 	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_CANCELADA_RT);
		Set<Id>						accountIds				= new Set<Id>();
        Set<Id>						bpIds					= new Set<Id>();
		Set<Id> 					salesOwnerId			= new Set<Id>();
		List<Opportunity>			sales					= new List<Opportunity>();
		List<CampaignInfluence> 	cpInfluenceToInsert 	= new List<CampaignInfluence>();
		Map<Id, Id>					primaryContactByAccount = new Map<Id, Id>();
         
		 for (Opportunity opp: newOpportunityList) {

            if (opp.RecordTypeId == recordTypeVenta
               || opp.RecordTypeId == recordTypeVentaGanada
               || opp.RecordTypeId == recordTypeVentaPerdida 
               || opp.RecordTypeId == recordTypeVentaCancelada) {

                    if (opp.CampaignId != null) {
                        cpInfluenceToInsert.add(CRAN_VAS_KER_OppTriggerHelper_CLS.insertCampaignInfluence(opp));
                    }
                    sales.add(opp);
                    salesOwnerId.add(opp.OwnerId);
                    if(opp.AccountId!=null){
                        accountIds.add(opp.AccountId);    
                    }
                    if(opp.CRAN_VAS_MAQ_L_BP__c!=null){
                        bpIds.add(opp.CRAN_VAS_MAQ_L_BP__c);    
                    }                   
               }
        }        
		if (!cpInfluenceToInsert.isEmpty())
			insert cpInfluenceToInsert;
		
		if (!sales.isEmpty()) {
			
			for (Account acc : [SELECT FinServ__PrimaryContact__c FROM Account WHERE Id IN: accountIds])
				primaryContactByAccount.put(acc.Id, acc.FinServ__PrimaryContact__c);
			
			CRAN_VAS_KER_OppTriggerHelper_CLS.executeTasks(sales, salesOwnerId, null, primaryContactByAccount, false,bpIds,null);
		}
    }
  
    public override void afterUpdate() {
		
		Id 						recordTypeVenta			= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT);
        Id						recordTypeVentaGanada	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT);
        Id						recordTypeVentaPerdida	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_PERDIDA_RT);
        Id						recordTypeVentaCancelada = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_CANCELADA_RT);
        Set<Id> 				salesOwnerId			= new Set<Id>();
        Set<Id> 				bpIds					= new Set<Id>();
		List<Opportunity>		sales					= new List<Opportunity>();		
		Map<Id, Boolean>		updateCpInfluenceBySale = new Map<Id, Boolean>();
		Map<Id, Id>				primaryContactByAccount = new Map<Id, Id>();
        Set<Id>					salesValidated			= new Set<Id>();
		Set<Id>					contactsCancelled			= new Set<Id>();
		Set<Id>					cancelledSales				= new Set<Id>();
        Set<Id>					lostSales					= new Set<Id>();
            for (Opportunity opp: newOpportunityList) {
                Opportunity oldOpp = oldOpportunityMap.get(opp.Id);
                /**
                 * Si es una venta abierta o una venta recién rotada a Ganada.
                 * */
                if (opp.RecordTypeId == recordTypeVenta || 
                   (opp.RecordTypeId == recordTypeVentaGanada && oldOpp.RecordTypeId == recordTypeVenta)) {
    
                    if (//If opportunity has changed in fields wich affect
                            opp.CampaignId != null
                        &&	(opp.Amount 						!= oldOpp.Amount)				    
                        || 	(opp.TotalOpportunityQuantity 		!= oldOpp.TotalOpportunityQuantity)  
                        || 	(opp.StageName 						!= oldOpp.StageName)) {					
                        updateCpInfluenceBySale.put(opp.Id, true);
                    }
    
                    sales.add(opp);
                    salesOwnerId.add(opp.OwnerId);
                    if(opp.CRAN_VAS_MAQ_L_BP__c!=null){
                        bpIds.add(opp.CRAN_VAS_MAQ_L_BP__c);
                    }
                    if (String.isNotBlank(opp.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c))
                        primaryContactByAccount.put(opp.AccountId, opp.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c);
                
                } else if(opp.RecordTypeId == recordTypeVentaCancelada){
                    cancelledSales.add(opp.Id);
                    contactsCancelled.add(opp.CRAN_VAS_MAQ_F_T_AccountPrimaryContact__c);
                } else if(opp.RecordTypeId == recordTypeVentaPerdida){
                    lostSales.add(opp.Id);
                }
                if(opp.RecordTypeId == recordTypeVentaGanada && opp.CRAN_VAS_MAQ_B_Validation__c != oldOpp.CRAN_VAS_MAQ_B_Validation__c){
                    salesValidated.add(opp.Id);
                }                         		   
        	}
            if (!sales.isEmpty() || !salesValidated.isEmpty())
                CRAN_VAS_KER_OppTriggerHelper_CLS.executeTasks(sales, salesOwnerId, updateCpInfluenceBySale, primaryContactByAccount, true,bpIds, salesValidated);
			 /**
             * Tareas de limpieza de ventas canceladas/perdidas
             * */
            if(!cancelledSales.isEmpty() || !lostSales.isEmpty()){
                CRAN_VAS_KER_OppTriggerHelper_CLS.deleteRelationshipsWithSales(cancelledSales,contactsCancelled, lostSales);
            } 
    }

    public override void beforeInsert()
    {	
    	Id 						recordTypeVenta			= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT);
    	Id 						recordTypeObjSys		= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_SIST_RT);
    	Id 						recordTypeObjMkt		= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_MKT_RT);
		Set<Id> 				salesOwnerId			= new Set<Id>();
        Set<Id> 				relatedGoals			= new Set<Id>();
        Set<Id> 				relatedClients			= new Set<Id>();
        Set<Id>			 		relatedBPs				= new Set<Id>();
        Set<Id>					relatedCampaigns		= new Set<Id>();
        Map<String,Set<Id>>		relatedOppsByClientBP	= new Map<String,Set<Id>>();
        Set<Id> 				relatedOpps				= new Set<Id>();
		List<Opportunity>		sales					= new List<Opportunity>();
        List<Opportunity>		goals					= new List<Opportunity>();		
        Set<Id>					tmpSet;
        
		for (Opportunity opp: newOpportunityList) {
     		if (opp.RecordTypeId == recordTypeVenta
                || opp.RecordTypeId == recordTypeObjSys 
                || opp.RecordTypeId == recordTypeObjMkt) {
             	salesOwnerId.add(opp.OwnerId);
                if(opp.RecordTypeId == recordTypeVenta){
                    sales.add(opp);
                	if(opp.CRAN_VAS_MAQ_L_Objetivo_Asociado__c != null){
                    	relatedGoals.add(opp.CRAN_VAS_MAQ_L_Objetivo_Asociado__c);
                	}
                    if(opp.AccountId != null && opp.CRAN_VAS_MAQ_L_BP__c != null){
						relatedClients.add(opp.AccountId);
                    }
                    /**
					* Si una venta está cambiando a cerrada, hay que reasignar gestor
					* */
                    if(opp.IsClosed){
                        /**
                        * Almaceno el BP para reasignar la venta al gestor del BP
                        * */
                        relatedOpps = relatedOppsByClientBP.get(opp.AccountId +'-'+ opp.CRAN_VAS_MAQ_L_BP__c);
                        if(relatedOpps == null){
                            relatedOpps = new Set<Id>();
                        }
                        relatedOpps.add(opp.Id);
                        relatedOppsByClientBP.put(opp.AccountId +'-'+ opp.CRAN_VAS_MAQ_L_BP__c,relatedOpps);
						relatedBPs.add(opp.CRAN_VAS_MAQ_L_BP__c);
                        if(opp.CampaignId != null){
                        	relatedCampaigns.add(opp.CampaignId);    
                        }                        
                    }                     
				}
        		        
                if(opp.RecordTypeId == recordTypeObjSys || opp.RecordTypeId == recordTypeObjMkt){
                    if(opp.CRAN_ICA_KER_P_Oficina__c == null){
                    	goals.add(opp);
                   	}
                }                                
             }
        }
        
        if(!sales.isEmpty() || !goals.isEmpty()){
            CRAN_VAS_KER_OppTriggerHelper_CLS.beforeUpsertTasksVentasObjetivosMKT(sales, goals, 
				salesOwnerId,relatedGoals,relatedClients,false,relatedBPs,relatedOppsByClientBP,relatedCampaigns);
        }        
    }

    public override void beforeUpdate()
    {	
        Id 						recordTypeVenta				= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT);
        Id						recordTypeVentaGanada 		= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT);
        Id 						recordTypeVentaPerdida 		= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_PERDIDA_RT);
        Id 						recordTypeObjSys			= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_SIST_RT);
        Id 						recordTypeObjMkt			= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_OBJETIVO_MKT_RT);
        Set<Id> 				salesOwnerId				= new Set<Id>();
        List<Opportunity>		sales						= new List<Opportunity>();
        List<Opportunity>		goals						= new List<Opportunity>();
        Set<Id>			 		relatedBPs					= new Set<Id>();
        Set<Id>			 		relatedClients				= new Set<Id>();
        Set<Id>					relatedCampaigns			= new Set<Id>();
        Map<String,Set<Id>>		relatedOppsByClientBP	= new Map<String,Set<Id>>();
        Set<Id> 				relatedOpps				= new Set<Id>();
        
		for (Opportunity opp: newOpportunityList) {
			if ((opp.RecordTypeId == recordTypeVenta 
                 || opp.RecordTypeId == recordTypeVentaGanada 
                 || opp.RecordTypeId == recordTypeVentaPerdida)
                && opp.isClosed
                && oldOpportunityMap.get(opp.id).StageName != opp.StageName){
                    salesOwnerId.add(opp.OwnerId);
                	sales.add(opp);
                    /**
                    * Almaceno el BP y cliente para reasignar la venta al gestor del BP
                    * */
                    relatedClients.add(opp.AccountId);
                    relatedBPs.add(opp.CRAN_VAS_MAQ_L_BP__c);
                    /**
					* Almaceno el BP para reasignar la venta al gestor del BP
					* */
                    relatedOpps = relatedOppsByClientBP.get(opp.AccountId +'-'+ opp.CRAN_VAS_MAQ_L_BP__c);
                    if(relatedOpps == null){
                        relatedOpps = new Set<Id>();
                    }
                    relatedOpps.add(opp.Id);
                    relatedOppsByClientBP.put(opp.AccountId +'-'+ opp.CRAN_VAS_MAQ_L_BP__c,relatedOpps);
                    relatedBPs.add(opp.CRAN_VAS_MAQ_L_BP__c); 
                    if(opp.CampaignId != null){
                    	relatedCampaigns.add(opp.CampaignId);    
                    }                    
     		}

            if(opp.RecordTypeId == recordTypeObjSys || opp.RecordTypeId == recordTypeObjMkt){
                if(opp.CRAN_ICA_KER_P_Oficina__c == null){
                    salesOwnerId.add(opp.OwnerId);
                	goals.add(opp);
            	}
			}
		}
		/**
		 * Tareas de actualizacion de ventas recien ganadas u objetivos
		 * */
        if(!sales.isEmpty() || !goals.isEmpty()){
        	CRAN_VAS_KER_OppTriggerHelper_CLS.beforeUpsertTasksVentasObjetivosMKT(sales, 
				goals,salesOwnerId, null, relatedClients,true,relatedBPs,relatedOppsByClientBP,relatedCampaigns);                  
        }     
    }

}