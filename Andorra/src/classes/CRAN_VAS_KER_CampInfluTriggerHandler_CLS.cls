/**
* @author 			VASS
* Project:			Credit Andorra
* Description:		Class which manages CRAN_VAS_KER_CampaignInfluence trigger functionalities related to CampaignInfluence object.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		2017-04-20		VASS					Initial version
*********************************************************************************************************/
public with sharing class CRAN_VAS_KER_CampInfluTriggerHandler_CLS extends TriggerHandler {
	
	private List<CampaignInfluence> lstCampInflu;
	private Map<Id, CampaignInfluence> oldMap;
	private Map<Id, CampaignInfluence>  newMap;

    public CRAN_VAS_KER_CampInfluTriggerHandler_CLS(SObjectType objectType) {
        super(objectType);
        this.lstCampInflu = (List<CampaignInfluence>) Trigger.new;
        this.oldMap  = (Map<Id, CampaignInfluence>) Trigger.oldMap;
        this.newMap  = (Map<Id, CampaignInfluence>) Trigger.newMap;    
    }
	
    /*public override void beforeUpdate() {
    }*/
  
    /*public override void beforeInsert() {
    }*/
  
    public override void afterDelete() {
        //Update campaign Amount and Quantity validated and not validated fields
        CRAN_VAS_KER_CampInfluTriggerHelper_CLS.updateCampaignAmountAndQuantity(lstCampInflu, oldMap, newMap);
    }
  
    public override void afterInsert() {
        //Update campaign Amount and Quantity validated and not validated fields
        CRAN_VAS_KER_CampInfluTriggerHelper_CLS.updateCampaignAmountAndQuantity(lstCampInflu, oldMap, newMap);
    }
  
    public override void afterUpdate() {
        
        //Update campaign Amount and Quantity validated and not validated fields
        CRAN_VAS_KER_CampInfluTriggerHelper_CLS.updateCampaignAmountAndQuantity(lstCampInflu, oldMap, newMap);
    }
  
    /*public override void afterDelete() {}*/
}