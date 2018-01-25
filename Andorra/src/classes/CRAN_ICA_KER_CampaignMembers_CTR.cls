public class CRAN_ICA_KER_CampaignMembers_CTR {

    /*public static List<CRAN_ICA_KER_CampaignMembers_DTO> getCampaignMembers(String campaignId){    
      
        
        List<CRAN_ICA_KER_CampaignMembers_DTO> lRegistrosDTO = new List<CRAN_ICA_KER_CampaignMembers_DTO>();
        
        //Obtener CampaignMember
        List<CampaignMember> lCampaignMember = [
            select name,
            campaign.name,  
            status, 
            CRAN_VAS_MAQ_L_BP__r.name, 
            CRAN_ICA_MKT_F_D_CreatedDateFormat__c, 
            CRAN_VAS_MAQ_F_T_Advisor__c
            from campaignMember
            where campaignId = :campaignId
        ];

        
        //Devolvemos un DTO a partir de CampaignMember
        for (CampaignMember cm : lCampaignMember){
                 CRAN_ICA_KER_CampaignMembers_DTO dto = new CRAN_ICA_KER_CampaignMembers_DTO();
                 dto.nameMember =  cm.name;
                 dto.nameCampaign = cm.campaign.name;
                 dto.status = cm.status;
                 dto.bp = cm.CRAN_VAS_MAQ_L_BP__r.name;
                 dto.createdDate =  String.valueOf(cm.CRAN_ICA_MKT_F_D_CreatedDateFormat__c);  
                 dto.advisor =  cm.CRAN_VAS_MAQ_F_T_Advisor__c;
            
                 lRegistrosDTO.add(dto);
        }
        
        
        return lRegistrosDTO;
    }    */
}