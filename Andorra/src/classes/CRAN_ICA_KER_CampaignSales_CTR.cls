public class CRAN_ICA_KER_CampaignSales_CTR {


   /* public static List<CRAN_ICA_KER_CampaignSales_DTO> getCampaignSales(String campaignId){    
       
        
        List<CRAN_ICA_KER_CampaignSales_DTO> lRegistrosDTO = new List<CRAN_ICA_KER_CampaignSales_DTO>();
        
        //Obtener Opportunity
        List<Opportunity> lopportunity = [
            					SELECT name,
            						CRAN_VAS_MAQ_L_BP__r.name, 
            						StageName,
									Campaign.Name, 
									CRAN_VAS_MAQ_P_Ramo__c, 
									Owner.Name, 
									TotalOpportunityQuantity, 
									Amount, 
									CRAN_VAS_MAQ_T_IdOperacionComercial__c,
									Account.Name, 
									CloseDate, 
									RecordType.Name 
								FROM Opportunity  
                				WHERE CampaignId = :campaignId AND
                					  //StageName = 'Closed Won' AND 
                					  Campaign.RecordType.DeveloperName != 'CRAN_VAS_MAQ_SistComRecordType' AND
            						  //RecordType.Name = 'Venta' AND 	
            						  ( RecordType.DeveloperName = 'CRAN_VAS_MAQ_Venta' OR 
                                        RecordType.DeveloperName = 'CRAN_VAS_MAQ_VentaCancelada' OR 
                                        RecordType.DeveloperName = 'CRAN_VAS_MAQ_VentaGanada' OR
                                        RecordType.DeveloperName = 'CRAN_VAS_MAQ_VentaPerdida' )
        ];
        
        //Los metemos en DTO
        for (Opportunity opp : lopportunity){
                 CRAN_ICA_KER_CampaignSales_DTO cs = new CRAN_ICA_KER_CampaignSales_DTO();
                 cs.campaignName = opp.Campaign.Name;
            	 cs.name =  opp.name; 		
                 cs.bp =  opp.CRAN_VAS_MAQ_L_BP__r.name;
                 cs.status = opp.StageName;
                 cs.ramo = opp.CRAN_VAS_MAQ_P_Ramo__c;
                 cs.advisor = opp.Owner.Name;
                 cs.totalOpportunity = String.valueOf(opp.TotalOpportunityQuantity);
                 cs.amount = String.valueOf(opp.Amount);
                 cs.idOperacionComercial = opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c;
                 cs.accountName = opp.Account.Name;
                 cs.closeDate = String.valueOf(opp.CloseDate);
                 cs.recordTypeName = opp.RecordType.Name;
                 
                 lRegistrosDTO.add(cs);
             }
        

        
        return lRegistrosDTO;

        
    }*/

    
}