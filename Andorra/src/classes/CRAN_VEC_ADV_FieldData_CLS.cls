public class CRAN_VEC_ADV_FieldData_CLS {
    
    @AuraEnabled public String  fieldLabel  {get; set;}
    @AuraEnabled public String  fieldValue  {get; set;}
    @AuraEnabled public String  dataType    {get; set;}
    @AuraEnabled public Boolean isVisible   {get; set;}
    @AuraEnabled public Boolean isEdit      {get; set;}
    @AuraEnabled public Boolean isHyperLink {get; set;}	
   
    public CRAN_VEC_ADV_FieldData_CLS(){
        isEdit      = false;
        isVisible   = true;
        isHyperLink = false;
    }
   
}