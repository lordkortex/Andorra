/**
 * CRAN_VEC_ADV_RebalpDetRS_CLS  POJO generic request Rebalp detail Avaloq services
 *
 * Fecha: 03/05/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_RebalpDetRS_CLS {
	public CRAN_VEC_ADV_Order_CLS order{get;set;}
	private List<CRAN_VEC_ADV_CalcRebalpVersionRS> versionList;
	public String status{get;set;}
	public Long statusId{get;set;}
	public List<CRAN_VEC_ADV_ProcessSTError_CLS> errors{get;set;}

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

}