/**
 * CRAN_VEC_ADV_RenewCustomFormRQ_CLS POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_RenewCustomFormRQ_CLS {
	
    private String lang;
    private List<CRAN_VEC_ADV_ObjList_CLS> objList;


    public String getLang(){
        return lang;
    }

    public void setLang(String lang){
        this.lang = lang;
    }
    
    public List<CRAN_VEC_ADV_ObjList_CLS> getObjList() {
        return objList;
    }

    public void setObjList(List<CRAN_VEC_ADV_ObjList_CLS> objList) {
        this.objList = objList;
    }

}