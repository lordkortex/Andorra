public with sharing class CRAN_VEC_ADV_Portfolio_Container_CLS {
	
	private Long id;
	private String type;
	private String name;
    private Double currValNoAccr;
    private Double currVal;
    private Double allocParent;
	private List<CRAN_VEC_ADV_CategoriesLv1_CLS> categoriesLv1;

	public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

	public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }    

	public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public List<CRAN_VEC_ADV_CategoriesLv1_CLS> getCategoriesLv1() {
        return categoriesLv1;
    }

    public void setCategoriesLv1(List<CRAN_VEC_ADV_CategoriesLv1_CLS> categoriesLv1) {
        this.categoriesLv1 = categoriesLv1;
    }

}