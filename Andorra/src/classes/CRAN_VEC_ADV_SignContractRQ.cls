/**
 * CRAN_VEC_ADV_SignContractRQ  POJO generic request Sign contract Avaloq services
 *
 * Fecha: 23/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_SignContractRQ {

	private String lang;
	private CRAN_VEC_ADV_ObjList_CLS objList;
	/** Identificador del documento (tipo de clave y valor) */
	private CRAN_VEC_ADV_SignContractKeyValue keyValue;
	/** Fecha de firma del documento */
    private String signtDate;
    
	/**
	 * @return the lang
	 */
	public String getLang() {
		return lang;
	}

	/**
	 * @param lang
	 *            the lang to set
	 */
	public void setLang(String lang) {
		this.lang = lang;
	}

	
	/**
	 * @return the objList
	 */
	public CRAN_VEC_ADV_ObjList_CLS getObjList() {
		return objList;
	}

	/**
	 * @param objList the objList to set
	 */
	public void setObjList(CRAN_VEC_ADV_ObjList_CLS objList) {
		this.objList = objList;
	}

	/**
	 * @return the keyValue
	 */
	public CRAN_VEC_ADV_SignContractKeyValue getKeyValue() {
		return keyValue;
	}

	/**
	 * @param keyValue the keyValue to set
	 */
	public void setKeyValue(CRAN_VEC_ADV_SignContractKeyValue keyValue) {
		this.keyValue = keyValue;
	}

	/**
	 * @return the signtDate
	 */
	public String getSigntDate() {
		return signtDate;
	}

	/**
	 * @param signtDate the signtDate to set
	 */
	public void setSigntDate(String signtDate) {
		this.signtDate = signtDate;
	}
}