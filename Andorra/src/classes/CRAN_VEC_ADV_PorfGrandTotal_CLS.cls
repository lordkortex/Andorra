public with sharing class CRAN_VEC_ADV_PorfGrandTotal_CLS {
	
	private Double currValNoAccr;
    private Double currVal;
    private Double allocParent;
    private List<CRAN_VEC_ADV_Portfolio_BpRS_CLS> bp;

    public Double getCurrValNoAccr() {
        return currValNoAccr;
    }

    public void setCurrValNoAccr(Double currValNoAccr) {
        this.currValNoAccr = currValNoAccr;
    }

    public Double getCurrVal() {
        return currVal;
    }

    public void setCurrVal(Double currVal) {
        this.currVal = currVal;
    }

    public Double getAllocParent() {
        return allocParent;
    }

    public void setAllocParent(Double allocParent) {
        this.allocParent = allocParent;
    }


    public List<CRAN_VEC_ADV_Portfolio_BpRS_CLS> getBp(){
        return bp;
    }
    
    public void setBp(List<CRAN_VEC_ADV_Portfolio_BpRS_CLS> bp){
        this.bp = bp;
    }

}