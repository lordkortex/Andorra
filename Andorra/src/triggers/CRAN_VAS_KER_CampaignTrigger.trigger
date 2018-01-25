trigger CRAN_VAS_KER_CampaignTrigger on Campaign (after insert, before delete) {
    new CRAN_VAS_KER_CampaignHandler_CLS(Campaign.getSObjectType()).run();
}