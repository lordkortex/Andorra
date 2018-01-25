/**
 * CRAN_VEC_ADV_DiscardCustomFormRS_CLS POJO for Rest services
 *
 * Response descartarFormularios
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_DiscardCustomFormRS_CLS {
	private List<CRAN_VEC_ADV_Order_CLS> orderList;
	private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;

	public List<CRAN_VEC_ADV_Order_CLS> getOrderList(){
		return orderList;
	}

	public void setOrderList(List<CRAN_VEC_ADV_Order_CLS> orderList){
		this.orderList = orderList;
	}


    public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
        return errors;
    }

    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors) {
        this.errors = errors;
    }
}