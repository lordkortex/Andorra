public class CRAN_VEC_ADV_FieldDataIpl_CLS {
    
    @AuraEnabled public String  fieldLabel  {get; set;}
    @AuraEnabled public String  fieldValue  {get; set;}
    @AuraEnabled public String  dataType    {get; set;}
    @AuraEnabled public Boolean isVisible   {get; set;}
    @AuraEnabled public Boolean isEdit      {get; set;}
    @AuraEnabled public Boolean isHyperLink {get; set;}
    @AuraEnabled public String  iplIndent   {get; set;}
    @AuraEnabled public Boolean isNodeType  {get; set;}			
   
    public CRAN_VEC_ADV_FieldDataIpl_CLS(){
        isEdit      = false;
		iplIndent   = '0';
        isNodeType  = false;
        isVisible   = true;
        isHyperLink = false;
    }
   
}