/**
 * CRAN_VEC_ADV_CalcRebalpVersionRS  POJO generic response Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

/** Alias("version") */
public with sharing class CRAN_VEC_ADV_CalcRebalpVersionRS {
/** Indica si es la version final (si guardamos los datos en Avaloq o no)*/
	private String isFinal;
	
	/** Nombre de la version */
	private String name;
	
	/** Avaloq no hara nada con este campo */
	private String id;
	
	/** Cantidad a invertir */
	private Double invstAmount;
	
	/** Moneda de la cantidad a invertir */
	private String invstCurry;
	
	/** Listado de líneas de la propuesta de inversión que se quieren añadir/borrar/modificar de la propuesta existente */
	private CRAN_VEC_ADV_CalcRebalpNodeRS node;

	/** Id OMS */
	private String omsId;

	/** Listado de restricciones actualizadas */	
	private List<CRAN_VEC_ADV_CalcRebalpRestrictionRS> restrList;

	// -------------------------------------------------------------------------
	// Getters / Setters
	// -------------------------------------------------------------------------

	/**
	 * @return the isFinal
	 */
	public String getIsFinal() {
		return isFinal;
	}


	/**
	 * @param isFinal the isFinal to set
	 */
	public void setIsFinal(String isFinal) {
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
	public CRAN_VEC_ADV_CalcRebalpNodeRS getNode() {
		return node;
	}


	/**
	 * @param nodeList the nodeList to set
	 */
	public void setNode(CRAN_VEC_ADV_CalcRebalpNodeRS node) {
		this.node = node;
	}


	/**
	 * @return the restrList
	 */
	public List<CRAN_VEC_ADV_CalcRebalpRestrictionRS> getRestrList() {
		return restrList;
	}


	/**
	 * @param restrList the restrList to set
	 */
	public void setRestrList(List<CRAN_VEC_ADV_CalcRebalpRestrictionRS> restrList) {
		this.restrList = restrList;
	}

	/**
	 * @return the omsId
	 */
	public String getOmsId() {
		return omsId;
	}

	/**
	 * @param omsId the omsId to set
	 */
	public void setOmsId(String omsId) {
		this.omsId = omsId;
	}
}