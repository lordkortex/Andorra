/**
 * CRAN_VEC_ADV_ProcessSTAnswer_CLS POJO for avaloq Rest services
 *
 * Fecha: 07/12/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_ProcessSTAnswer_CLS {
	private String value;
	private String type;
	private String text;

	public CRAN_VEC_ADV_ProcessSTAnswer_CLS (String value, String type, String text){
		this.value = value;
		this.type = type;
		this.text = text;
	}

	public CRAN_VEC_ADV_ProcessSTAnswer_CLS (String value, String type){
		this.value = value;
		this.type = type;
		this.text = null;
	}

	/**
	* 
	* @return
	* The value
	*/
	public String getValue() {
	return value;
	}

	/**
	* 
	* @param value
	* The value
	*/
	public void setValue(String value) {
	this.value = value;
	}

	/**
	* 
	* @return
	* The type
	*/
	public String getType() {
	return type;
	}

	/**
	* 
	* @param type
	* The type
	*/
	public void setType(String type) {
	this.type = type;
	}

	/**
	* 
	* @return
	* The text
	*/
	public String getText() {
	return text;
	}

	/**
	* 
	* @param text
	* The text
	*/
	public void setText(String text) {
	this.text = text;
	}

}