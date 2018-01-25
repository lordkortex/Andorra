public with sharing class CRAN_VEC_ADV_CategoriesLv3_CLS {
	private Long id;
	private String name;
    private Double currValNoAccr;
    private Double currVal;
    private Double allocParent;
	private List<CRAN_VEC_ADV_Portfolio_Positions_CLS> positions;

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

    public List<CRAN_VEC_ADV_Portfolio_Positions_CLS> getPositions() {
        return positions;
    }

    public void setPositions(List<CRAN_VEC_ADV_Portfolio_Positions_CLS> positions) {
        this.positions = positions;
    }

}