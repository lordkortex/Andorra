/**
 * CRAN_VEC_ADV_ProcessBPCustomFormRS_CLS POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_ProcessBPCustomFormRS_CLS {

    private List<CRAN_VEC_ADV_ObjList_getForms_CLS> objList;
    private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;


    public List<CRAN_VEC_ADV_ObjList_getForms_CLS> getObjList() {
        return objList;
    }

    public void setObjList(List<CRAN_VEC_ADV_ObjList_getForms_CLS> objList) {
        this.objList = objList;
    }


    public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
        return errors;
    }

    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> error) {
        this.errors = errors;
    }


}