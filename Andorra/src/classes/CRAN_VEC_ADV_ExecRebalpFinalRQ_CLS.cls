public with sharing class CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS {

	public String lang {get;set;}
    public String mode {get;set;}
    public CRAN_VEC_ADV_Order_CLS order {get;set;}
    public List<CRAN_VEC_ADV_transList_CLS> transList {get;set;}


    public with sharing class CRAN_VEC_ADV_transList_CLS{
		public String orderNr {get;set;}
		public Boolean action {get;set;}
    }

}