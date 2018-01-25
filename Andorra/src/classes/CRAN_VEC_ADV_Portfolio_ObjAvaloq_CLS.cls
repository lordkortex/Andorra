public with sharing class CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS {
	private List<CRAN_VEC_ADV_Portfolio_id_CLS> obj;
	private String objType;
    
    public void setObjLst(List<CRAN_VEC_ADV_Portfolio_id_CLS> obj){
        this.obj = obj;
    }

    public List<CRAN_VEC_ADV_Portfolio_id_CLS> getObjLst() {
        return obj;
    }

    public void setObjType(String objType){
        this.objType = objType;
    }

    public String getObjType() {
        return objType;
    }

}