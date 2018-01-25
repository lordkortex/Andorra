/**
 * CRAN_VEC_ADV_CalcRebalpRS  POJO generic response Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Miguel Aguado Miinero (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_DetOrderRS {
	private CRAN_VEC_ADV_OrderDet_RS order;
	private List<CRAN_VEC_ADV_DetRebalpVersionRS> versionList;
	private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;
	private String statusId;

	public CRAN_VEC_ADV_OrderDet_RS getOrder() {
		return order;
	}

	public void setOrder(CRAN_VEC_ADV_OrderDet_RS order) {
		this.order = order;
	}

	/**
	 * @return the versionList
	 */
	public List<CRAN_VEC_ADV_DetRebalpVersionRS> getVersionList() {
		return versionList;
	}

	/**
	 * @param versionList the versionList to set
	 */
	public void setVersionList(List<CRAN_VEC_ADV_DetRebalpVersionRS> versionList) {
		this.versionList = versionList;
	}

	public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
        return errors;
    }

    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors) {
        this.errors = errors;
    }

	public String getStatusId() {
		return statusId;
	}

	public void setStatusId(String statusId) {
		this.statusId = statusId;
	}

}