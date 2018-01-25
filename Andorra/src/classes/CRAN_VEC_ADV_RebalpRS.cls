/**
 * CRAN_VEC_ADV_RebalpRS  POJO generic response Rebalq Avaloq services
 *
 * Fecha: 14/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_RebalpRS {
	private String status;
	private CRAN_VEC_ADV_Order_CLS order;
	private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;

	public String getStatus() {
	return status;
	}

	public void setStatus(String status) {
	this.status = status;
	}

	
	public CRAN_VEC_ADV_Order_CLS getOrder() {
	return order;
	}

	public void setOrder(CRAN_VEC_ADV_Order_CLS order) {
	this.order = order;
	}

	public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors(){
		return errors;
	}

	
    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors) {
        this.errors = errors;
    }

}