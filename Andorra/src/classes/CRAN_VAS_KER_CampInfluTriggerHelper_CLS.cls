/**
* @author 			VASS
* Project:			Credit Andorra
* Description:		Provide all methods to execute in events of CampaignInfluence trigger
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		2017-10-04		VASS					Initial version 
*********************************************************************************************************/ 
public without sharing class CRAN_VAS_KER_CampInfluTriggerHelper_CLS {

    /**
     * Date: 2017 April
     * Description: Update these Campaign fields: Campaign Number of sales validated, Total Amount Validated, Total Quantity Validated and Total Quantity (Validated and Not).
     * 				taking only in consideration records affected by Campaign Influences changed
     *
     * @param	lstCampInflu
     * @param	oldMap
     * @param	newMap
     * */
    public static void updateCampaignAmountAndQuantity(List<CampaignInfluence> lstCampInflu, Map<Id, CampaignInfluence> oldMap,  Map<Id, CampaignInfluence>  newMap){
       //Get campaigns affected for campaignInfluence changed exactly in fields affect to amount and quantity values
       Map<Id, Campaign> 	campaigns		 		= new Map<Id, Campaign>();
       Id 					recordTypeVentaGanada	= CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT);
       for ( CampaignInfluence campaignInfluence : (lstCampInflu != null ? lstCampInflu : oldMap.values())) {
           if( String.isNotBlank(campaignInfluence.CampaignId) && 
				//If campaignInfluence has changed
			    ((oldMap!=null && newMap !=null) 
				  || //Or if it was not oldValues in this campaignInfluence
					(( campaignInfluence.RevenueShare!=null || campaignInfluence.CRAN_VAS_MAQ_F_N_QuantityShare__c!=null || campaignInfluence.CRAN_VAS_MAQ_F_B_SaleValidated__c!=null))
                 || (oldMap!=null && newMap==null)
                )) {
                    Campaign campaign = new Campaign();
                    campaign.Id = campaignInfluence.CampaignId;
                    campaign.CRAN_VAS_MAQ_C_AmountSalesValidated__c = 0;
                    campaign.CRAN_VAS_MAQ_N_SalesValidated__c = 0;
                    campaign.CRAN_VAS_MAQ_N_QuantitySalesValidated__c = 0;
                    campaign.CRAN_VAS_MAQ_N_QuantitySalesWon__c = 0;                    
                    campaigns.put( campaignInfluence.CampaignId, campaign );
			}					
		}				
		if (!campaigns.isEmpty()){	
	       for (CampaignInfluence cInflu : [SELECT CampaignId, RevenueShare, CRAN_VAS_MAQ_F_N_QuantityShare__c, CRAN_VAS_MAQ_F_B_SaleValidated__c  
	       										   FROM CampaignInfluence WHERE CampaignId =: campaigns.keySet() and Opportunity.RecordTypeId = :recordTypeVentaGanada]) {	

				Campaign campaign = campaigns.get(cInflu.CampaignId);
                                                                                 
                //Number of sales validated
       			if (cInflu.CRAN_VAS_MAQ_F_B_SaleValidated__c){  
					campaign.CRAN_VAS_MAQ_N_SalesValidated__c = campaign.CRAN_VAS_MAQ_N_SalesValidated__c+1;                                                       
                }
       			if (cInflu.RevenueShare!=null){

       				//Total Amount Validated
	       			if (cInflu.CRAN_VAS_MAQ_F_B_SaleValidated__c){
	       				campaign.CRAN_VAS_MAQ_C_AmountSalesValidated__c+=cInflu.RevenueShare;
	       			}
       			}
       			
       			if (cInflu.CRAN_VAS_MAQ_F_N_QuantityShare__c!=null){
       				//Total Quantity (Validated and Not)
       				campaign.CRAN_VAS_MAQ_N_QuantitySalesWon__c+=cInflu.CRAN_VAS_MAQ_F_N_QuantityShare__c;
       				
       				//Total Quantity Validated
	       			if (cInflu.CRAN_VAS_MAQ_F_B_SaleValidated__c){
	       				campaign.CRAN_VAS_MAQ_N_QuantitySalesValidated__c+=cInflu.CRAN_VAS_MAQ_F_N_QuantityShare__c;
	       			}
       			}
	       }
	       
	       //Update Campaigns with changes
           update campaigns.values();    
       }
    } 
}