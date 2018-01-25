public with sharing class CRAN_VEC_ADV_PortfolioRQ_CLS {

    private String dateTo;
    private String lang;
    private List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS> objList;
    
    public void setDateTo(String dateTo){
        this.dateTo = dateTo;
    }

    public String getDateTo() {
        return dateTo;
    }

    public String getLang(){
        return lang;
    }

    public void setLang(String lang){
        this.lang = lang;
    }

    public void setObjList(List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS> objList){
        this.objList = objList;
    }

    public List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS> getObjList() {
        return objList;
    }

}