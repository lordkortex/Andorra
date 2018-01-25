/**
 * CRAN_VEC_ADV_SignContractKeyValue  POJO generic request Sign contract Avaloq services
 *
 * Fecha: 23/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_SignContractKeyValue {

	private String keyType;
	/** Valor del nodo nodeId*/
	private String value;

	/**
	 * @return the keyType
	 */
	public String getKeyType() {
		return keyType;
	}

	/**
	 * @param keyType the keyType to set
	 */
	public void setKeyType(String keyType) {
		this.keyType = keyType;
	}	
	
	/**
	 * @return the value
	 */
	public String getValue() {
		return value;
	}	

	/**
	 * @param value the value to set
	 */
	public void setValue(String value) {
		this.value = value;
	}
}