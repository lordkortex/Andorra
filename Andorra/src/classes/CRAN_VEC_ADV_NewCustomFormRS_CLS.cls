/**
 * CRAN_VEC_ADV_NewCustomFormRS_CLS POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_NewCustomFormRS_CLS {
    private CRAN_VEC_ADV_Order_CLS order;
    private List<CRAN_VEC_ADV_ObjListRS_CLS> objList;
    private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;

    public CRAN_VEC_ADV_Order_CLS getOrder() {
        return order;
    }

    public void setOrder(CRAN_VEC_ADV_Order_CLS order) {
        this.order = order;
    }

    public List<CRAN_VEC_ADV_ObjListRS_CLS> getObjList(){
        return objList;
    }

    public void setObjList(List<CRAN_VEC_ADV_ObjListRS_CLS> objList){
        this.objList = objList;
    }    

    public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
        return errors;
    }

    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors) {
        this.errors = errors;
    }
}