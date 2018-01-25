/**
 * CRAN_VEC_ADV_VerifyCustomFormRS_CLS POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_VerifyCustomFormRS_CLS {
	private List<CRAN_VEC_ADV_ObjList_CLS> objList;
    private String avisos;
    private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;

    public List<CRAN_VEC_ADV_ObjList_CLS> getObjList() {
        return objList;
    }

    public void setObjList(List<CRAN_VEC_ADV_ObjList_CLS> objList) {
        this.objList = objList;
    }

    public String getAvisos() {
        return avisos;
    }

    public void setAvisos(String avisos) {
        this.avisos = avisos;
    }

    /**
    * 
    * @return
    * The error
    */
    public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
    return errors;
    }

    /**
    * 
    * @param error
    * The error
    */
    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors) {
    this.errors = errors;
    }
}