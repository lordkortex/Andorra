public class CRAN_ICA_MAQ_CampaignSales_AUC {

    @AuraEnabled
	public static String getRecords(Id recordId, String userIdForTST) {

        
		 
        CRAN_ICA_KER_ExportCampaigns_Batch exeBatch = new CRAN_ICA_KER_ExportCampaigns_Batch(recordId, 2, userIdForTST);

       	
        Database.executeBatch(exeBatch, 2000);
        return '';
        
	}
    
    
    @AuraEnabled
	public static Boolean isSistematicaComercialRecordType(Id recordId) {
     	   
		Campaign cm = [select name, recordtype.developername from campaign where id =:recordId];
 
        if(cm != null && cm.recordtype != null && cm.recordtype.developername  == 'CRAN_VAS_MAQ_SistComRecordType'){
            return true;
        }else{
            return false;
        }

     }       
    
}