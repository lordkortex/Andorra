/**
 * CRAN_VEC_ADV_CalcRebalpVersionRS  POJO generic response Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Miguel Aguado Minero (Vector ITC)
 * @version 1.0
 *
*/

/** Alias("version") */
public with sharing class CRAN_VEC_ADV_DetRebalpVersionRS {
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

	//public CRAN_VEC_ADV_ListOrderItem_CLS refOrderList {get;set;}

	public	List<CRAN_VEC_ADV_OrderItem_CLS> refOrderList {get;set;}

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

	public with sharing class CRAN_VEC_ADV_ListOrderItem_CLS {	
		 public	List<CRAN_VEC_ADV_OrderItem_CLS> orderItem {get;set;}
	}

    public with sharing class CRAN_VEC_ADV_OrderItem_CLS{
		public String orderNr {get;set;}
		public String hasRestr {get;set;}
		public String metaType {get;set;}
		public String metaTypeId {get;set;}
		public String type {get;set;}
		public String typeId {get;set;}
		public String orderType {get;set;}
		public String orderTypeId {get;set;}
		public String orderStatus {get;set;}
		public String orderStatusId {get;set;}
		public Double orderPrcEstim {get;set;}
		public Double orderLimit {get;set;}
		public Double orderQty {get;set;}
		public Double apprxAmount {get;set;}
		public Double realPrice {get;set;}
		public Double sellAmount {get;set;}
		public String sellCurry {get;set;}
		public Double buyAmount {get;set;}
		public String buyCurry {get;set;}
		public Double xrateType {get;set;}
		public String orderTrxDate {get;set;}
		public String omsId {get;set;}
		public CRAN_VEC_ADV_AssetItem assetItem {get;set;}	
    }

    public with sharing class CRAN_VEC_ADV_AssetItem{
		public String assetName {get;set;}
		public String assetId {get;set;}
		public String assetBuId {get;set;}
		public String isin {get;set;}
		public String assetType {get;set;}
		public String assetTypeId {get;set;}
		public String assetRefCurry {get;set;}
		public String assetCatId {get;set;}
		public String instrGroupId {get;set;}
	}
}