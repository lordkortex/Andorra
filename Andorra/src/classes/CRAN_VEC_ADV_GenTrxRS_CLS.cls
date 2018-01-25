public with sharing class CRAN_VEC_ADV_GenTrxRS_CLS {
	public CRAN_VEC_ADV_Order_CLS order {get; set;}
	public String status {get; set;}
	public String statusId {get; set;}
	public List<CRAN_VEC_ADV_ProcessSTError_CLS> errors{get;set;}	
}