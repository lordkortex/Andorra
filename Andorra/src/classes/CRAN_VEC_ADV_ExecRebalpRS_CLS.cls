public with sharing class CRAN_VEC_ADV_ExecRebalpRS_CLS {
	
	public String orderNr {get;set;}
    public CRAN_VEC_ADV_ListOrderItem_CLS refOrderList {get;set;}
	public List<CRAN_VEC_ADV_ProcessSTError_CLS> errors {get;set;}

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