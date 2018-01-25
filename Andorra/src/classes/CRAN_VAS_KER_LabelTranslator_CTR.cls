public with sharing class CRAN_VAS_KER_LabelTranslator_CTR {
    
    public String label_lang {get;set;}
    public String label {get;set;}
     
    public  CRAN_VAS_KER_LabelTranslator_CTR(){
       Map<String, String> reqParams = ApexPages.currentPage().getParameters(); 
       label_lang = reqParams.get('label_lang');
       label = reqParams.get('label');
    }
}