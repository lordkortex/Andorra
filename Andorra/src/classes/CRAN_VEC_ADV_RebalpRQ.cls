/**
 * CRAN_VEC_ADV_RebalpRQ  POJO generic request Rebalp Avaloq services
 *
 * Fecha: 14/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_RebalpRQ {

	private String lang;
	private CRAN_VEC_ADV_Order_CLS order;

	public String getLang() {
	return lang;
	}

	public void setLang(String lang) {
	this.lang = lang;
	}

	
	public CRAN_VEC_ADV_Order_CLS getOrder() {
	return order;
	}

	public void setOrder(CRAN_VEC_ADV_Order_CLS order) {
	this.order = order;
	}
}