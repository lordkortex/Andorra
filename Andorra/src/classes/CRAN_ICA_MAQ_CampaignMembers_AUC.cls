public class CRAN_ICA_MAQ_CampaignMembers_AUC {

    @AuraEnabled
	public static String getRecords(Id recordId,  String userIdForTST) {
        
		CRAN_ICA_KER_ExportCampaigns_Batch exeBatch = new CRAN_ICA_KER_ExportCampaigns_Batch(recordId, 1, userIdForTST);
        Database.executeBatch(exeBatch, 2000);
        
     
        return '';
	}
}