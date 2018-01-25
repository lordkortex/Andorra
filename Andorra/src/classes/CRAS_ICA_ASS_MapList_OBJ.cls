public class CRAS_ICA_ASS_MapList_OBJ {
	@AuraEnabled public String Label {get; Set;}
    @AuraEnabled public Integer Index {get; Set;}
    @AuraEnabled public List<SObject> RelList {get; Set;}
    
    public CRAS_ICA_ASS_MapList_OBJ(){
        this.RelList = new List<SObject>();
    }
}