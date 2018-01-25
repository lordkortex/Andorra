/**
 * CRAN_VEC_ADV_CalcRebalpNodeDet  POJO generic response Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_CalcRebalpNodeDet {
	/** Id del nodo a modificar/eliminar, si este tag va vacio, posicion a añadir es nueva */
	private CRAN_VEC_ADV_CalcRebalpNodeId nodeId;
	
	/** Id interno del asset */
	private String assetId;
	
	/** BU id del asset */
	private String assetBuId;
	
	/** Clave CRANCode del asset */
	private  String cranCode;

	private String name;
	
	/** Texto descriptivo de las restricciones incumplidas por el nodo o por sus nodos "hijos"*/
	private String restrInfo;
	
	/**
	 * Identificacionn alfanumerica (intl_id avaloq) del tipo de icono a utilizar 
	 * para marcar el nodo respecto a las restricciones incumplidas
	 * (por el nodo o por sus nodos "hijos"). 
	 * Posibles valores son: 
		*cran$pfm$cran$restr_viol_aa_max	AA Max. Restriction Violation
		*cran$pfm$cran$restr_viol_aa_min	AA Min. Restriction Violation
		*cran$pfm$cran$restr_viol_hold	Customised Restriction Violation
		*cran$pfm$cran$restr_viol_multi	Multi Restriction Violation
		*cran$pfm$cran$restr_viol_single	Single Restriction Violation
		*cran$pfm$cran$restr_viol_surr	Surrogate Restriction Violation
	 * */
	private String restrIcon;
	
	/** Clasificacion*/
	private String rat;
	
	/** Precio */
	private Double price;
		
	private String curry;
	
	private Double cpfQty;
	
	private Double spfQty;
	
	private Double cpfAccr;
	
	private Double spfAccr;
	
	private Double cpfMktVal;
	
	private Double spfMktVal;

	private Double cpfPerc;
	
	private Double spfPerc;
	
	private Double mpfPerc;
	
	private Boolean extl;
	
	private Boolean aggrPos;
	
	private String remark;

	private Boolean isEdit;

	private String pfmMarketCatId;


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
	 * @return the restrInfo
	 */
	public String getRestrInfo() {
        return restrInfo;        		
	}

	/**
	 * @param restrInfo the restrInfo to set
	 */
	public void setRestrInfo(String restrInfo) {
		this.restrInfo = restrInfo;
	}
	
	/**
	 * @return the restrIcon
	 */
	public String getRestrIcon() {
		return restrIcon;
	}

	/**
	 * @param restrIcon the restrIcon to set
	 */
	public void setRestrIcon(String restrIcon) {
		this.restrIcon = restrIcon;
	}

	/**
	 * @return the rat
	 */
	public String getRat() {
		return rat;
	}

	/**
	 * @param rat the rat to set
	 */
	public void setRat(String rat) {
		this.rat = rat;
	}

	/**
	 * @return the cpfAccr
	 */
	public Double getCpfAccr() {
		return cpfAccr;
	}

	/**
	 * @param cpfAccr the cpfAccr to set
	 */
	public void setCpfAccr(Double cpfAccr) {
		this.cpfAccr = cpfAccr;
	}

	/**
	 * @return the cpfMktVal
	 */
	public Double getCpfMktVal() {
		return cpfMktVal;
	}

	/**
	 * @param cpfMktVal the cpfMktVal to set
	 */
	public void setCpfMktVal(Double cpfMktVal) {
		this.cpfMktVal = cpfMktVal;
	}

	/**
	 * @return the cpfPerc
	 */
	public Double getCpfPerc() {
		return cpfPerc;
	}

	/**
	 * @param cpfPerc the cpfPerc to set
	 */
	public void setCpfPerc(Double cpfPerc) {
		this.cpfPerc = cpfPerc;
	}

	/**
	 * @return the mpfPerc
	 */
	public Double getMpfPerc() {
		return mpfPerc;
	}

	/**
	 * @param mpfPerc the mpfPerc to set
	 */
	public void setMpfPerc(Double mpfPerc) {
		this.mpfPerc = mpfPerc;
	}

	/**
	 * @return the price
	 */
	public Double getPrice() {
		return price;
	}

	/**
	 * @param price the price to set
	 */
	public void setPrice(Double price) {
		this.price = price;
	}

	/**
	 * @return the curry
	 */
	public String getCurry() {
		return curry;
	}

	/**
	 * @param curry the curry to set
	 */
	public void setCurry(String curry) {
		this.curry = curry;
	}

	/**
	 * @return the cpfQty
	 */
	public Double getCpfQty() {
		return cpfQty;
	}

	/**
	 * @param cpfQty the cpfQty to set
	 */
	public void setCpfQty(Double cpfQty) {
		this.cpfQty = cpfQty;
	}

	/**
	 * @return the spfQty
	 */
	public Double getSpfQty() {
		return spfQty;
	}

	/**
	 * @param spfQty the spfQty to set
	 */
	public void setSpfQty(Double spfQty) {
		this.spfQty = spfQty;
	}

	/**
	 * @return the spfAccr
	 */
	public Double getSpfAccr() {
		return spfAccr;
	}

	/**
	 * @param spfAccr the spfAccr to set
	 */
	public void setSpfAccr(Double spfAccr) {
		this.spfAccr = spfAccr;
	}

	/**
	 * @return the spfMktVal
	 */
	public Double getSpfMktVal() {
		return spfMktVal;
	}

	/**
	 * @param spfMktVal the spfMktVal to set
	 */
	public void setSpfMktVal(Double spfMktVal) {
		this.spfMktVal = spfMktVal;
	}

	/**
	 * @return the spfPerc
	 */
	public Double getSpfPerc() {
		return spfPerc;
	}

	/**
	 * @param spfPerc the spfPerc to set
	 */
	public void setSpfPerc(Double spfPerc) {
		this.spfPerc = spfPerc;
	}

	/**
	 * @return the extl
	 */
	public Boolean getExtl() {
		return extl;
	}

	/**
	 * @param extl the extl to set
	 */
	public void setExtl(Boolean extl) {
		this.extl = extl;
	}

	/**
	 * @return the aggrPos
	 */
	public Boolean getAggrPos() {
		return aggrPos;
	}

	/**
	 * @param aggrPos the aggrPos to set
	 */
	public void setAggrPos(Boolean aggrPos) {
		this.aggrPos = aggrPos;
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
	 * @return the remark
	 */
	public Boolean getIsEdit() {
		return isEdit;
	}

	/**
	 * @param remark the isEdit to set
	 */
	public void setIsEdit(Boolean isEdit) {
		this.isEdit = isEdit;
	}	

	/**
	 * @return the pfmMarketCatId
	 */
	public String getPfmMarketCatId() {
		return pfmMarketCatId;
	}

	/**
	 * @param cpfMktVal the pfmMarketCatId to set
	 */
	public void setPfmMarketCatId(String pfmMarketCatId) {
		this.pfmMarketCatId = pfmMarketCatId;
	}
}