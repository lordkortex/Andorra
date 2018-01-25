public with sharing class CRAN_VEC_ADV_CategoriesLv1_CLS {
	private Long id;
    private String name;
    private Double currValNoAccr;
    private Double currVal;
    private Double allocParent;
    private List<CRAN_VEC_ADV_CategoriesLv2_CLS> categoriesLv2;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public List<CRAN_VEC_ADV_CategoriesLv2_CLS> getCategoriesLv2() {
        return categoriesLv2;
    }

    public void setCategoriesLv2(List<CRAN_VEC_ADV_CategoriesLv2_CLS> categoriesLv2) {
        this.categoriesLv2 = categoriesLv2;
    }

}