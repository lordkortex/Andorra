/**
 * CRAN_VEC_ADV_ProcessSTRequest_CLS POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_ProcessSTRequest_CLS {

	private CRAN_VEC_ADV_Order_CLS order;
    private String lang;
	private List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> questionary = new List<CRAN_VEC_ADV_ProcessSTQuestion_CLS>();

	/**
	* 
	* @return
	* The language
	*/
	public String getLang() {
	return lang;
	}

	/**
	* 
	* @param language
	* The language
	*/
	public void setLang(String lang) {
	this.lang = lang;
	}

	/**
	* 
	* @return
	* The question
	*/
	public List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> getQuestionary() {
	return questionary;
	}
	/**
	* 
	* @param question
	* The question
	*/
	public void setQuestionary(List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> questionary) {
	this.questionary = questionary;
	}

	public CRAN_VEC_ADV_Order_CLS getOrder() {
        return order;
    }

    public void setOrder(CRAN_VEC_ADV_Order_CLS order) {
        this.order = order;
    }

}