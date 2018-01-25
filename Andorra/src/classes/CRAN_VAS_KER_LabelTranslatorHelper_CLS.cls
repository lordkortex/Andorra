public with sharing class CRAN_VAS_KER_LabelTranslatorHelper_CLS {
    
    /** Singleton approach */
    private static final CRAN_VAS_KER_LabelTranslatorHelper_CLS instance = new CRAN_VAS_KER_LabelTranslatorHelper_CLS();
    
    /** Private constructor to prevent the creation of instances of this class.*/
    private CRAN_VAS_KER_LabelTranslatorHelper_CLS() {}    
    
    /**
    * Method responsible for providing the instance of this class.
    * @return CRAN_VAS_KER_LabelTranslatorHelper_CLS instance.
    */
    public static CRAN_VAS_KER_LabelTranslatorHelper_CLS getInstance() {
        return instance;
    }    
    
    public String translate(String labelName, String language) {
            Pagereference r = Page.CRAN_VAS_KER_LabelTranslator;
            r.getParameters().put('label_lang', language);
            r.getParameters().put('label', labelName);  
            String labelValue = r.getContent().toString();
            return labelValue;
    }
}