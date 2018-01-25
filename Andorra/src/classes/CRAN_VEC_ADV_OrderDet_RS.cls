public with sharing class CRAN_VEC_ADV_OrderDet_RS {
	private String orderNr;
	private Boolean isNew = false;
	public String personId {get; set;}
	public String rolId {get; set;}	
	public String expiryDate {get; set;}
	public String expired {get; set;}

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