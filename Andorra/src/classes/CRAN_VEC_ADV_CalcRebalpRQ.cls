/**
 * CRAN_VEC_ADV_CalcRebalpRQ  POJO generic request Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_CalcRebalpRQ {
	private String lang;
	private String printMode;
	private CRAN_VEC_ADV_Order_CLS order;
	private List<CRAN_VEC_ADV_CalcRebalpVersion> versionList;

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public void setPrintMode(String printMode) {
		this.printMode = printMode;
	}

	public String getPrintMode() {
		return printMode;
	}

	public CRAN_VEC_ADV_Order_CLS getOrder() {
		return order;
	}

	public void setOrder(CRAN_VEC_ADV_Order_CLS order) {
		this.order = order;
	}

	/**
	 * @return the versionList
	 */
	public List<CRAN_VEC_ADV_CalcRebalpVersion> getVersionList() {
		return versionList;
	}

	/**
	 * @param versionList the versionList to set
	 */
	public void setVersionList(List<CRAN_VEC_ADV_CalcRebalpVersion> versionList) {
		this.versionList = versionList;
	}
}