public class CRAN_ICA_KER_ExportCampaigns_Batch implements Database.Batchable<sObject>, Database.Stateful{
	
    private Integer currentChain = 0;
    private List<String> csvRowValues = new List<String>();
    private Id recordId = null;
    private Integer contador = 1;
    List<String> usersIds = new List<String>();
    Set<Id>	salesRecTypeId= new Set<Id>();
    private String codigoCampanaExterno = '';
    
    
    public CRAN_ICA_KER_ExportCampaigns_Batch(Id recordId, Integer currentChain, String usersId_TST	){
        this.recordId = recordId;
        this.currentChain = currentChain;
        
        List<String> usersIds	= new List<String>();
        for (Id userId : CRAN_VAS_KER_RoleUtils_CLS.getRoleSubordinateUsersFromCurrentUser()) {
            usersIds.add(userId);
        } 
        //Para CRAN_ICA_MAQ_CampaignSales_TST y CRAN_ICA_MAQ_CampaignMembers_TST
        if ( usersId_TST != null){ 
            usersIds.add(usersId_TST); 
        }
        
        this.usersIds = usersIds; 
        
        Set<Id>	 salesRecTypeId	= new Set<Id>();
        salesRecTypeId.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT));
        salesRecTypeId.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT));
        salesRecTypeId.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_PERDIDA_RT));
		salesRecTypeId.add(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_CANCELADA_RT));         

        this.salesRecTypeId = salesRecTypeId;
        
        List<campaigninfluence> lci = [select Campaign.CRAN_VAS_MAQ_T_CodigoCampanaExterno__c 
            from campaigninfluence 
            where CampaignId = :recordId limit 1];
        
        if(lci != null && lci.Size() > 0 && lci.get(0) != null && lci.get(0).Campaign != null 
        	&& lci.get(0).Campaign.CRAN_VAS_MAQ_T_CodigoCampanaExterno__c != null)
        { 
        	this.codigoCampanaExterno = '_' + lci.get(0).Campaign.CRAN_VAS_MAQ_T_CodigoCampanaExterno__c ;
        }

        
    }    
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        String qry = '';
        
        if (currentChain == 1){
            qry = 'Select '+
                  'campaign.id, ' + 
                  'campaign.name, ' +
                   'Contact.CRAN_VEC_ADV_N_NumericSort__c, ' + 	
                  'status, ' +
                  'CRAN_VAS_MAQ_L_BP__r.CRAN_VEC_ADV_N_Number__c, ' + //id bp
                  'CRAN_VAS_MAQ_F_T_Advisor__c, ' + 	
                  'CRAN_ICA_MKT_F_D_CreatedDateFormat__c ' +
                  'FROM campaignMember ' +
                  'WHERE campaignId =:recordId ' + 
 				  'AND  CRAN_VAS_MAQ_L_GestorMiembroCampana__c IN : usersIds ';	
        }
        else if (currentChain == 2){
            qry = 'SELECT id, ' +
                					'name, ' +
            						'StageName, ' +
									'Campaign.Name,  ' +
                					'CRAN_VAS_MAQ_P_RamoCopy__c, ' +	
									'toLabel(CRAN_VAS_MAQ_P_Ramo__c), ' +
									'Owner.Name, ' +
									'TotalOpportunityQuantity, ' +
									'Amount, ' +
									'CRAN_VAS_MAQ_T_IdOperacionComercial__c, ' +
									'CloseDate, ' +
									'CRAN_VAS_MAQ_T_IdOperacionAxis__c, ' +
                					'CRAN_VAS_MAQ_L_BP__r.CRAN_VEC_ADV_N_Number__c, ' +
                                    'Loss_Reason__c, ' +
                                    'CRAN_VAS_MAQ_TA_ReasonLost__c, ' +
                                    'CRAN_VAS_MAQ_B_Validation__c, ' +
                					'CRAN_ICA_KER_P_OficinaCopy__c, ' +
                                    'tolabel(CRAN_ICA_KER_P_Oficina__c), ' +
                					'Description, ' +
                					'CampaignId, ' + 
                                    'Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_N_NumericSort__c, ' + //CRAN_VEC_ADV_L_PersonId__r.id 
                					'CRAN_VAS_MAQ_T_Productos__c, '	+
                					'Owner.FederationIdentifier ' + 
                                    
								'FROM Opportunity  ' +
            					'WHERE id in (SELECT 	OpportunityId '  +
                                    'FROM 	CampaignInfluence  '  +
                                    'WHERE 	CampaignId = :recordId AND '  + 
                                            'Opportunity.OwnerId IN : usersIds AND ' +					
                                            'Opportunity.RecordTypeId in :salesRecTypeId ) '; 

            
                
	
        }
        
        return Database.getQueryLocator(qry);
    }
     
    
    
    
    
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        

        if (currentChain == 1){
            if (csvRowValues.size() >= 10000){//con 25000 envia el archivo con _html en mail por tamaño
                enviarMailCurrentChain1(csvRowValues);
            }

            
            
            for (CampaignMember cm: (List<CampaignMember>)scope){
                	String regTmp =  '"';
                                
                	//Id campaña
                	regTmp = regTmp + cm.campaign.id + '","'; 
                
                	//Nombre campaña
                    regTmp = regTmp + cm.campaign.name + '","';
                
                	//Id miembro
                    if(cm.Contact != null && cm.Contact.CRAN_VEC_ADV_N_NumericSort__c != null){ regTmp = regTmp + cm.Contact.CRAN_VEC_ADV_N_NumericSort__c + '","'; }else{ regTmp = regTmp + '","'; }

                	//Estado
                    regTmp = regTmp + cm.status + '","';
                
                	//Id BP
                    if(cm.CRAN_VAS_MAQ_L_BP__c == null || (cm.CRAN_VAS_MAQ_L_BP__c != null && cm.CRAN_VAS_MAQ_L_BP__r.CRAN_VEC_ADV_N_Number__c == null)){regTmp = regTmp + '","'; }else{ regTmp = regTmp + cm.CRAN_VAS_MAQ_L_BP__r.CRAN_VEC_ADV_N_Number__c + '","';}
                
                	//Advisor
                    if(cm.CRAN_VAS_MAQ_F_T_Advisor__c == null ){regTmp = regTmp + '","'; }else{regTmp = regTmp + cm.CRAN_VAS_MAQ_F_T_Advisor__c + '","'; }                
                    
                	//Fecha creacion       
                    regTmp = regTmp + String.valueOf(cm.CRAN_ICA_MKT_F_D_CreatedDateFormat__c) + '"';
                                   
                csvRowValues.add(regTmp);
            }

            
        }
        else if (currentChain == 2){
            if (csvRowValues.size() >= 10000){//con 25000 envia el archivo con _html en mail por tamaño
                enviarMailCurrentChain2(csvRowValues);
            }
            
            for (Opportunity opp: (List<Opportunity>)scope){

    				String regTmp =  '"';             
    				
                	//Id venta
                	regTmp = regTmp + opp.id + '","'; 	
                
                	//Campaña id
        			regTmp = regTmp + opp.CampaignId + '","'; 					
                     
                	//Nombre campaña			
                	if (opp.Campaign.Name == null){regTmp = regTmp + '","';  }else{regTmp = regTmp + opp.Campaign.Name + '","';  }	 
                
        		    //Nombre oportunidad
                	if ( opp.name == null){regTmp = regTmp +  '","';}else{regTmp = regTmp + opp.name + '","';}	 
                 	
                	//Estado
                	if (opp.StageName == null){regTmp = regTmp + '","';}else{regTmp = regTmp + opp.StageName + '","';}	 
                 	
                	//Id person
        		    if (opp.Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_N_NumericSort__c == null){regTmp = regTmp + '","';}else{regTmp = regTmp + opp.Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_N_NumericSort__c + '","';}	

                	//ID BP
					if (opp.CRAN_VAS_MAQ_L_BP__r.CRAN_VEC_ADV_N_Number__c == null){regTmp = regTmp + '","';  }else{regTmp = regTmp + opp.CRAN_VAS_MAQ_L_BP__r.CRAN_VEC_ADV_N_Number__c + '","';  }
                
        			//ID gestor
                    if (opp.Owner.FederationIdentifier == null){regTmp = regTmp + '","'; }else{regTmp = regTmp + opp.Owner.FederationIdentifier + '","';}
                    
                    //Nombre gestor-advisor
                	if (opp.Owner.Name == null){regTmp = regTmp + '","';}else{regTmp = regTmp + opp.Owner.Name + '","';	}

                    //id Oficina
                	if ( opp.CRAN_ICA_KER_P_OficinaCopy__c  == null){regTmp = regTmp + '","'; }else{regTmp = regTmp + opp.CRAN_ICA_KER_P_OficinaCopy__c + '","'; }
                
        			//nombre oficina		
                    if (opp.CRAN_ICA_KER_P_Oficina__c == null){regTmp = regTmp + '","'; }else{regTmp = regTmp + opp.CRAN_ICA_KER_P_Oficina__c + '","'; }
        
        			//Ramo
                    if (opp.CRAN_VAS_MAQ_P_RamoCopy__c == null ){regTmp = regTmp + '","';}else{regTmp = regTmp + opp.CRAN_VAS_MAQ_P_RamoCopy__c  + '","';}
                
                    //Descripción ramo 					
                	if (opp.CRAN_VAS_MAQ_P_Ramo__c == null){regTmp = regTmp + '","';}else{regTmp = regTmp + opp.CRAN_VAS_MAQ_P_Ramo__c + '","';}
                
        			//Producto
                    if (opp.CRAN_VAS_MAQ_T_Productos__c == null){regTmp = regTmp + '","' ;}else{regTmp = regTmp + opp.CRAN_VAS_MAQ_T_Productos__c + '","' ;				}
                
        			//Importe 					
                	if (opp.Amount == null){regTmp = regTmp + '","'; }else{regTmp = regTmp + String.valueOf(opp.Amount) + '","'; }
                     
                    //Cantidad
                	if (opp.TotalOpportunityQuantity == null){regTmp = regTmp + '","'; }else{regTmp = regTmp + String.valueOf(opp.TotalOpportunityQuantity) + '","'; }
                
                    //ID Avaloq	
                	if (opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c == null){regTmp = regTmp + '","'; }else{regTmp = regTmp + opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c + '","' ; }

                	//ID Axis
                	if (opp.CRAN_VAS_MAQ_T_IdOperacionAxis__c == null ){regTmp = regTmp + '","'; 	}else{regTmp = regTmp + opp.CRAN_VAS_MAQ_T_IdOperacionAxis__c + '","'; 		}

                	//Descripción
                    if (opp.Description == null){regTmp = regTmp + '","';}else{regTmp = regTmp + opp.Description  + '","';} 

                	//Venta validada  
        			regTmp = regTmp + opp.CRAN_VAS_MAQ_B_Validation__c + '","'; 
                    
                	//Motivo perdida
                    if(opp.Loss_Reason__c == null){regTmp = regTmp +  '","';}else{regTmp = regTmp + opp.Loss_Reason__c + '","';} 
        
        			//Otro motivo perdida,
                    if(opp.CRAN_VAS_MAQ_TA_ReasonLost__c  == null){regTmp = regTmp + '","'; }else{regTmp = regTmp + opp.CRAN_VAS_MAQ_TA_ReasonLost__c  + '","';}
                
                    //Fecha cierre
                    if(opp.CloseDate == null){regTmp = regTmp + '"'; }else{regTmp = regTmp + String.valueOf(opp.CloseDate)  +  '"'; }

                 
                  csvRowValues.add(regTmp);
            }
        }
        
    }
     
    public void finish(Database.BatchableContext BC)
    {
		if (currentChain == 1){
              enviarMailCurrentChain1(csvRowValues);
        }
        else if (currentChain == 2){
              enviarMailCurrentChain2(csvRowValues);
        }
    }
    
    
    public void enviarMailCurrentChain1(List<String> csvRowValues){ //ddMMM
        
        		quitarSaltoPagina(csvRowValues);
                String documentName = 'CampaignMembers-'+ Datetime.now().format('yyyyMMddHHmmss');
                documentName =  documentName + codigoCampanaExterno;
        		String csvFileTitle = 'Id campaña,Nombre campaña,Id miembro,Estado,Id BP,'+
                    'Advisor,Fecha creación\n';
                String stringMail = csvFileTitle + String.join(csvRowValues,'\n');
                CRAN_VAS_KER_EmailHelper.sendEmailCSVAttach(stringMail, documentName + '_' + contador + '.csv', 'Campaign Members CSV ' + contador, 'File att.' );
                csvRowValues.clear();
        		contador++;
    }

    public void enviarMailCurrentChain2(List<String> csvRowValues){
        		
        		quitarSaltoPagina(csvRowValues);
                String documentName = 'CampaignSales-'+ Datetime.now().format('yyyyMMddHHmmss');
        		documentName =  documentName + codigoCampanaExterno;
        		String csvFileTitle = 'Id venta,Id campaña,Nombre campaña,Nombre oportunidad,Estado,Id person,Id BP,Id gestor,Nombre gestor,'+
                       'Id oficina,Nombre oficina,Ramo,Descripción ramo,Producto,Importe,Cantidad,' +
                    'Id Avaloq,Id AXIS,Descripción,Venta validada,Motivo perdida,Otro motivo perdida,Fecha cierre' +
                    '\n';

        
        		String stringMail = csvFileTitle + String.join(csvRowValues,'\n');
                CRAN_VAS_KER_EmailHelper.sendEmailCSVAttach(stringMail, documentName + '_' + contador + '.csv', 'Campaign Sales CSV ' + contador, 'File att.' );
                csvRowValues.clear();
        		contador++;
    }
    
    public void quitarSaltoPagina(List<String> lString){
       
        if(lString != null && lString.size() > 0){
            for(Integer i=0; i < lString.size(); i++){
                if( lString.get(i) != null){
                     lString[i] = lString.get(i).replace('\r\n',''); 
                }
            }    
        }
    }
    
}