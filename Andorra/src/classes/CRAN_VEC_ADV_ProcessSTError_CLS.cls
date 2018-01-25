/**
 * CRAN_VEC_ADV_ProcessSTError_CLS POJO for avaloq Rest services
 *
 * Error generic Class for all avaloq services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_ProcessSTError_CLS {
	
	private String code;
	private String descError;

	/**
	* 
	* @return
	* The codError
	*/
	public String getCode() {
	return code;
	}

	/**
	* 
	* @param code
	* The code
	*/
	public void setCode(String code) {
	this.code = code;
	}

	/**
	* 
	* @return
	* The desc
	*/
	public String getDesc() {
	return descError;
	}

	/**
	* 
	* @param desc
	* The desc
	*/
	public void setDesc(String descError) {
	this.descError = descError;
	}
}