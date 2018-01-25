public with sharing class CRAN_VEC_ADV_Order_CLS {
	private String orderNr;
	private Boolean isNew = false;

	public String getOrderNr(){
		return orderNr;
	}

	public void setOrderNr(String orderNr){
		this.orderNr = orderNr;
	}

	public Boolean getIsNew(){
		return isNew;
	}

	public void setIsNew(Boolean isNew){
		this.isNew = isNew;
	}
}