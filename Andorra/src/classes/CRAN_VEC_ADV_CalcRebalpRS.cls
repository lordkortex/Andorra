/**
 * CRAN_VEC_ADV_CalcRebalpRS  POJO generic response Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_CalcRebalpRS {
	private CRAN_VEC_ADV_Order_CLS order;
	private List<CRAN_VEC_ADV_CalcRebalpVersionRS> versionList;
	private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;

	public CRAN_VEC_ADV_Order_CLS getOrder() {
		return order;
	}

	public void setOrder(CRAN_VEC_ADV_Order_CLS order) {
		this.order = order;
	}

	/**
	 * @return the versionList
	 */
	public List<CRAN_VEC_ADV_CalcRebalpVersionRS> getVersionList() {
		return versionList;
	}

	/**
	 * @param versionList the versionList to set
	 */
	public void setVersionList(List<CRAN_VEC_ADV_CalcRebalpVersionRS> versionList) {
		this.versionList = versionList;
	}

	public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
        return errors;
    }

    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors) {
        this.errors = errors;
    }
}