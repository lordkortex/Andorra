/**
 * CRAN_VEC_ADV_CalcRebalpNode  POJO generic request Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_CalcRebalpNode {

	/** Id del nodo a modificar/eliminar, si este tag va vacio, posicion a añadir es nueva */
	private CRAN_VEC_ADV_CalcRebalpNodeId nodeId;
//	private String nodeId;

	/** Clave CRANCode del asset */
	private String cranCode;
	
	/** Avaloq (internal) id del asset */
	private String assetId;
	
	/** BU id del asset */	
	private String assetBuId;

	private String cpfQty;
	
	private String cpfMktVal;
	
	private String cpfPerc;
	
	private String remark;

	// -------------------------------------------------------------------------
	// Getters / Setters
	// -------------------------------------------------------------------------

	/**
	* @return the nodeId
	*/
	public CRAN_VEC_ADV_CalcRebalpNodeId getNodeId() {
		return nodeId;
	}

	/**
	 * @param nodeId the nodeId to set
	 */
	public void setNodeId(CRAN_VEC_ADV_CalcRebalpNodeId nodeId) {
		this.nodeId = nodeId;
	}
	
//	/**
//	 * @return the nodeId
//	 */
//	public String getNodeId() {
//		return nodeId;
//	}
//
//	/**
//	 * @param nodeId the nodeId to set
//	 */
//	public void setNodeId(String nodeId) {
//		this.nodeId = nodeId;
//	}
	
	
	/**
	 * @return the cranCode
	 */
	public String getCranCode() {
		return cranCode;
	}

	/**
	 * @param cranCode the cranCode to set
	 */
	public void setCranCode(String cranCode) {
		this.cranCode = cranCode;
	}

	/**
	 * @return the assetId
	 */
	public String getAssetId() {
		return assetId;
	}

	/**
	 * @param assetId the assetId to set
	 */
	public void setAssetId(String assetId) {
		this.assetId = assetId;
	}

	/**
	 * @return the assetBuId
	 */
	public String getAssetBuId() {
		return assetBuId;
	}

	/**
	 * @param assetBuId the assetBuId to set
	 */
	public void setAssetBuId(String assetBuId) {
		this.assetBuId = assetBuId;
	}

	/**
	 * @return the cpfQty
	 */
	public String getCpfQty() {
		return cpfQty;
	}

	/**
	 * @param cpfQty the cpfQty to set
	 */
	public void setCpfQty(String cpfQty) {
		this.cpfQty = cpfQty;
	}

	/**
	 * @return the cpfMktVal
	 */
	public String getCpfMktVal() {
		return cpfMktVal;
	}

	/**
	 * @param cpfMktVal the cpfMktVal to set
	 */
	public void setCpfMktVal(String cpfMktVal) {
		this.cpfMktVal = cpfMktVal;
	}

	/**
	 * @return the cpfPerc
	 */
	public String getCpfPerc() {
		return cpfPerc;
	}

	/**
	 * @param cpfPerc the cpfPerc to set
	 */
	public void setCpfPerc(String cpfPerc) {
		this.cpfPerc = cpfPerc;
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
}