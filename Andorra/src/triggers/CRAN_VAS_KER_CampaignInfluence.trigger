/** 
* @author 			VASS
* Project:			Credit Andorra
* Description:		Trigger to CampaignInfluence object.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		2017-04-20		VASS					Initial version
*********************************************************************************************************/
trigger CRAN_VAS_KER_CampaignInfluence on CampaignInfluence (after insert, after update, after delete) {
	new CRAN_VAS_KER_CampInfluTriggerHandler_CLS(CampaignInfluence.getSObjectType()).run();
}