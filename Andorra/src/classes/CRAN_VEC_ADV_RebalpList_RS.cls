/**
 * CRAN_VEC_ADV_RebalpList_RS  POJO RebalqList Avaloq service
 *
 * Fecha: 25/04/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_RebalpList_RS {
	public List<Proposal> rebalPropList{get; set;}
	public List<CRAN_VEC_ADV_ProcessSTError_CLS> errors{get; set;}

	public class OrderItem {
		public String orderNr{get; set;} // No es seguro: Avaloq Id o Key
		public String hasRestr {get;set;}
		public String metaType{get; set;}
		public String type{get; set;}
		public String orderStatusId{get; set;}
		public String orderStatus{get; set;}
		public Decimal orderPrcEstim{get; set;}
		public Decimal orderQty{get; set;}
		public String orderTrxDate{get; set;}
		public Decimal apprAmount{get; set;}
		public Double realPrice {get;set;}
		public String omsId{get; set;}
		public AssetItem assetItem{get; set;}
		public String orderType {get;set;}

	}

	public class Proposal {
		public String bpId{get; set;}
        public String contId{get; set;}
		public String propStatusId{get; set;}
		public String propDate{get; set;}
		public String propOrderNr{get; set;}  // Avaloq Id o Key
		public String propDesc{get; set;}
		public String propInvMeth{get; set;}
		public String propCurry{get; set;}
		public String propAmount{get; set;}
		public List<OrderItem> refOrderList{get; set;}
	}

	public class AssetItem {
		public String assetName{get; set;}
		public String isin{get; set;}
		public String assetType{get; set;}
		public String assetRefCurry{get; set;}
		public String assetCatId{get; set;}
		public String instrGroupId{get; set;}
	}

}