public class CRAS_ICA_ASS_OppTrgHandler_CLS extends TriggerHandler 
{
    private static CRAS_ICA_ASS_InsuranceGlobal_CS__c relCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
    private static CampaignInfluenceModel cim;
    
    private Map<Id, Opportunity> newMap;
    private Map<Id, Opportunity> oldMap;
    private List<Opportunity> newList;
    private List<Opportunity> oldList;
    
    public CRAS_ICA_ASS_OppTrgHandler_CLS(SObjectType objectType) 
    {
        super(objectType);
        this.newMap = (Map<id, Opportunity>) Trigger.newMap;
        this.oldMap = (Map<id, Opportunity>) Trigger.oldMap;
        this.newList  = (List<Opportunity>) Trigger.new;
        this.oldList  = (List<Opportunity>) Trigger.old;
    }
    
    public override void beforeInsert() 
    {
        if(isInsurance())
        {
            Campaign campaignNow = campaignSearch();
            
            for(Opportunity opp : this.newList)
            {
                opp.CampaignId = campaignNow.Id;
                
                if(relCS.CRAS_ICA_ASS_OppVentas_RT__c == opp.RecordTypeId)
                {
                    if(opp.StageName.equals('Baja') && opp.Amount > 0)
                    {
                        opp.Amount *= -1;
                    }
                }
            }
        }
    }
    
    public override void afterInsert() 
    {
        if(isInsurance())
        {
            if(relCS.CRAS_ICA_ASS_OppVentas_RT__c == this.newList[0].RecordTypeId)
            {
                List<CampaignInfluence> newCI = new List<CampaignInfluence> ();
                for(Opportunity opp : this.newList)
                {
                    if (opp.CampaignId != null) 
                    {
                        newCI.add(campaignInfluenceSearch(opp));
                    }
                    
                }
                insert newCI;
            } 
        }
    }
    
    private Campaign campaignSearch()
    {
        Date dAct = this.newList[0].CloseDate;
        
        List<Campaign> campSearch = [SELECT Id, EndDate, StartDate FROM Campaign WHERE RecordTypeId = :relCS.CRAS_ICA_ASS_CampaignRT_ID__c AND StartDate <= :dAct AND EndDate >= :dAct];
        
        if(campSearch.size() == 0)
        {
            Campaign campNew = new Campaign();
            campNew.RecordTypeId = relCS.CRAS_ICA_ASS_CampaignRT_ID__c;
            campNew.EndDate = Date.newInstance(dAct.year(), 12, 31);
            campNew.StartDate = Date.newInstance(dAct.year(), 1, 1);
            campNew.CRAS_ICA_ASS_C_RealTargetHealth__c = 0;
            campNew.CRAS_ICA_ASS_C_RealTargetLife__c = 0;
            campNew.CRAS_ICA_ASS_C_RealTargetSaving__c = 0;
            campNew.Name = 'Seguros ' + dAct.year();
            campNew.Status = 'In progress';
            
            insert campNew;
            
            Date lastYear = dAct.addYears(-1);
            
            List<Campaign> lastCamp = [SELECT Id, EndDate, StartDate FROM Campaign WHERE RecordTypeId = :relCS.CRAS_ICA_ASS_CampaignRT_ID__c AND StartDate <= :lastYear AND EndDate >= :lastYear AND Status = 'In progress'];
            
            if(lastCamp.size() > 0)
            {
                lastCamp[0].Status = 'Completed';
                update lastCamp;
            }            
            return campNew;
        }
        else
        {
            return campSearch[0];
        }
    }
    
    private Boolean isInsurance(){
        for (Opportunity opp : this.newList){
            if (relCS.CRAS_ICA_ASS_OppVentas_RT__c == opp.RecordTypeId || relCS.CRAS_ICA_ASS_OppObjetivos_RT__c == opp.RecordTypeId){
                return true; 
            }
        }  
        return false;
    }
    
    private CampaignInfluence campaignInfluenceSearch (Opportunity opp)
    {
        CampaignInfluence cI = new CampaignInfluence();
        
        if (cim == null) 
        {
            cim = [SELECT Id FROM CampaignInfluenceModel where IsDefaultModel = true];
            
            if(cim == null)
            {
                cI.CampaignId = opp.CampaignId;
                cI.Influence = 100;
                cI.OpportunityId = opp.Id;
                
                return cI;
            }
        }
        
        cI.CampaignId = opp.CampaignId;
        cI.Influence = 100;
        cI.OpportunityId = opp.Id;
        cI.ModelId = cim.Id;
        
        return cI;
        
    }
}