/**
 * CRAN_VEC_ADV_CalcRebalpVersion  POJO generic request Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

/** Alias("version") */
public with sharing class CRAN_VEC_ADV_CalcRebalpVersion {
/** Indica si es la version final (si guardamos los datos en Avaloq o no)*/
	private Boolean isFinal;
	
	/** Nombre de la version */
	private String name;
	
	/** Avaloq no hara nada con este campo */
	private String id;
	
	/** Cantidad a invertir */
	private Double invstAmount;
	
	/** Moneda de la cantidad a invertir */
	private String invstCurry;
	
	/** Listado de líneas de la propuesta de inversión que se quieren añadir/borrar/modificar de la propuesta existente */
	//private CRAN_VEC_ADV_CalcRebalpNodeList nodeList;
	private List<CRAN_VEC_ADV_CalcRebalpNodeList> nodeList;

	/** Listado de restricciones actualizadas */	
	//private CRAN_VEC_ADV_CalcRebalpRestrictionList restrList;
	private List<CRAN_VEC_ADV_CalcRebalpRestriction> restrList;

	// -------------------------------------------------------------------------
	// Getters / Setters
	// -------------------------------------------------------------------------

	/**
	 * @return the isFinal
	 */
	public Boolean getIsFinal() {
		return isFinal;
	}


	/**
	 * @param isFinal the isFinal to set
	 */
	public void setIsFinal(Boolean isFinal) {
		this.isFinal = isFinal;
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
	 * @return the invstAmount
	 */
	public Double getInvstAmount() {
		return invstAmount;
	}


	/**
	 * @param invstAmount the invstAmount to set
	 */
	public void setInvstAmount(Double invstAmount) {
		this.invstAmount = invstAmount;
	}


	/**
	 * @return the invstCurry
	 */
	public String getInvstCurry() {
		return invstCurry;
	}


	/**
	 * @param invstCurry the invstCurry to set
	 */
	public void setInvstCurry(String invstCurry) {
		this.invstCurry = invstCurry;
	}


	/**
	 * @return the nodeList
	 */
	public List<CRAN_VEC_ADV_CalcRebalpNodeList> getNodeList() {
		return nodeList;
	}


	/**
	 * @param nodeList the nodeList to set
	 */
	public void setNodeList(List<CRAN_VEC_ADV_CalcRebalpNodeList> nodeList) {
		this.nodeList = nodeList;
	}


	/**
	 * @return the restrList
	 */
	public List<CRAN_VEC_ADV_CalcRebalpRestriction> getRestrList() {
		return restrList;
	}


	/**
	 * @param restrList the restrList to set
	 */
	public void setRestrList(List<CRAN_VEC_ADV_CalcRebalpRestriction> restrList) {
		this.restrList = restrList;
	}
}