public class CRAS_ICA_ASS_SFField_OBJ {
	@AuraEnabled public Boolean Disabled {get; Set;}
    @AuraEnabled public String Label {get; Set;}
    @AuraEnabled public String Name {get; Set;}
    
    public CRAS_ICA_ASS_SFField_OBJ(){
        this.Disabled = false;
    }
    
    public CRAS_ICA_ASS_SFField_OBJ(String Name, String Label, Boolean Disabled){
        this.Name = Name;
        this.Label = Label;
        this.Disabled = Disabled;
    }
}