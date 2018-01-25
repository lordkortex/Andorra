/**
 * CRAN_VEC_ADV_CalcRebalpRestrictionRS  POJO generic request Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

/** Alias("restr") */
public with sharing class CRAN_VEC_ADV_CalcRebalpRestrictionRS {
	
	private String id;
	
	/** Nombre de restriccion */
	private String name;
	
	/** Nombre del tipo de la restriccion */
	private String typeName;
	
	/** Restriccion Top */
	private String topRestr;
	
	/** Resultado de la evaluacion */
	private String evalResult;
	
	/** Comentarios*/
	private String remark;
	
	/** Objeto disparador*/
	private String violObj;
	
	/** Clase de Violacion */
	private String violClass;
	
	/** Valor violado */
	private String violValue;
	
	/** Valor desde */
	private String valueFrom;
	
	/** Valor hasta */
	private String valueTo;
	
	/** Prioridad */
	private String prio;
	
	/** Invalidar */
	private Boolean overrideRestr;
	
	/** Justificacion */
	private String justif;

	/** orderNr */
	private String orderNr;	


	// -------------------------------------------------------------------------
	// Getters / Setters
	// -------------------------------------------------------------------------

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}
	
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the typeName
	 */
	public String getTypeName() {
		return typeName;
	}

	/**
	 * @param typeName the typeName to set
	 */
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}

	/**
	 * @return the topRestr
	 */
	public String getTopRestr() {
		return topRestr;
	}

	/**
	 * @param topRestr the topRestr to set
	 */
	public void setTopRestr(String topRestr) {
		this.topRestr = topRestr;
	}

	/**
	 * @return the evalResult
	 */
	public String getEvalResult() {
		return evalResult;
	}

	/**
	 * @param evalResult the evalResult to set
	 */
	public void setEvalResult(String evalResult) {
		this.evalResult = evalResult;
	}

	/**
	 * @return the remark
	 */
	public String getRemark() {
		return remark;
	}

	/**
	 * @param remark the remark to set
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}

	/**
	 * @return the violObj
	 */
	public String getViolObj() {
		return violObj;
	}

	/**
	 * @param violObj the violObj to set
	 */
	public void setViolObj(String violObj) {
		this.violObj = violObj;
	}

	/**
	 * @return the violClass
	 */
	public String getViolClass() {
		return violClass;
	}

	/**
	 * @param violClass the violClass to set
	 */
	public void setViolClass(String violClass) {
		this.violClass = violClass;
	}

	/**
	 * @return the violValue
	 */
	public String getViolValue() {
		return violValue;
	}

	/**
	 * @param violValue the violValue to set
	 */
	public void setViolValue(String violValue) {
		this.violValue = violValue;
	}

	/**
	 * @return the valueFrom
	 */
	public String getValueFrom() {
		return valueFrom;
	}

	/**
	 * @param valueFrom the valueFrom to set
	 */
	public void setValueFrom(String valueFrom) {
		this.valueFrom = valueFrom;
	}

	/**
	 * @return the valueTo
	 */
	public String getValueTo() {
		return valueTo;
	}

	/**
	 * @param valueTo the valueTo to set
	 */
	public void setValueTo(String valueTo) {
		this.valueTo = valueTo;
	}

	/**
	 * @return the prio
	 */
	public String getPrio() {
		return prio;
	}

	/**
	 * @param prio the prio to set
	 */
	public void setPrio(String prio) {
		this.prio = prio;
	}

	/**
	 * @return the overrideRestr
	 */
	public Boolean getOverrideRestr() {
		return overrideRestr;
	}

	/**
	 * @param overrideRestr the overrideRestr to set
	 */
	public void setOverrideRestr(Boolean overrideRestr) {
		this.overrideRestr = overrideRestr;
	}

	/**
	 * @return the justif
	 */
	public String getJustif() {
		return justif;
	}

	/**
	 * @param justif the justif to set
	 */
	public void setJustif(String justif) {
		this.justif = justif;
	}
	
	/**
	 * @return the orderNr
	 */
	public String getOrderNr() {
		return orderNr;
	}

	/**
	 * @param orderNr the orderNr to set
	 */
	public void setOrderNr(String orderNr) {
		this.orderNr = orderNr;
	}

}