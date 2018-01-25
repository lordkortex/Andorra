public with sharing class CRAN_VEC_ADV_Portfolio_BpRS_CLS {

	private Long id;
	private String name;
	private Double currValNoAccr;
	private Double currVal;
	private Double allocParent;
	private List<CRAN_VEC_ADV_Portfolio_Container_CLS> containers;

	public Long getId(){
		return id;
	}

	public void setId(Long id){
		this.id = id;
	}

	public String getName(){
		return Name;
	}

	public void setName(String Name){
		this.Name = Name;
	}

	public Double getCurrValNoAccr(){
		return currValNoAccr;
	}

	public void setCurrValNoAccr(Double currValNoAccr){
		this.currValNoAccr = currValNoAccr;
	}

	public Double getCurrVal(){
		return currVal;
	}

	public void setCurrVal(Double currVal){
		this.currVal = currVal;
	}

	public Double getAllocParent(){
		return allocParent;
	}

	public void setAllocParent(Double allocParent){
		this.allocParent = allocParent;
	}

	public List<CRAN_VEC_ADV_Portfolio_Container_CLS> getContainers(){
		return containers;
	}

	public void setContainers(List<CRAN_VEC_ADV_Portfolio_Container_CLS> containers){
		this.containers = this.containers;
	}

}