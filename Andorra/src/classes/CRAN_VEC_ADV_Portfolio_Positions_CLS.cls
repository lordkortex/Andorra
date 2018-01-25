public with sharing class CRAN_VEC_ADV_Portfolio_Positions_CLS {

    private Long id;
    private String name;
    private String percVar;
    private Double quantity;
    private String curry;
    private String pSafeKeep;
    private Double quantity2;
    private Double currPrice;
    private Double currValAssetCcy;
    private Double histPrice;
    private Double qtyHistPrice;
    private Double histXrate;
    private Double currXrate;
    private Double currValNoAccr;
    private Double ytm;
    private Double currVal;
    private Double allocParent;
    private List<CRAN_VEC_ADV_Asset_CLS> assets;
    private String iban;

    
    public String getPercVar() {
        return percVar;
    }

    public void setPercVar(String percVar) {
        this.percVar = percVar;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Double getHistPrice() {
        return histPrice;
    }

    public void setHistPrice(Double histPrice) {
        this.histPrice = histPrice;
    }

    public Double getQtyHistPrice() {
        return qtyHistPrice;
    }

    public void setQtyHistPrice(Double qtyHistPrice) {
        this.qtyHistPrice = qtyHistPrice;
    }

    public Double getHistXrate() {
        return histXrate;
    }

    public void setHistXrate(Double histXrate) {
        this.histXrate = histXrate;
    }

    public Double getCurrXrate() {
        return currXrate;
    }

    public void setCurrXrate(Double currXrate) {
        this.currXrate = currXrate;
    }

    public void setCurrValNoAccr(Double currValNoAccr) {
        this.currValNoAccr = currValNoAccr;
    }

    public Double getCurrValNoAccr() {
        return currValNoAccr;
    }

    public void setQuantity(Double quantity) {
        this.quantity = quantity;
    }


    public Double getQuantity() {
        return quantity;
    }
    public Double getQuantity2() {
        return quantity2;
    }

    public void setQuantity2(Double quantity2) {
        this.quantity2 = quantity2;
    }

    public Double getCurrValAssetCcy() {
        return currValAssetCcy;
    }

    public void setCurrValAssetCcy(Double currValAssetCcy) {
        this.currValAssetCcy = currValAssetCcy;
    }

    public Double getCurrPrice() {
        return currPrice;
    }

    public void setCurrPrice(Double currPrice) {
        this.currPrice = currPrice;
    }

	public String getCurry() {
        return curry;
    }

    public void setCurry(String curry) {
        this.curry = curry;
    }

	public Double getYtm() {
        return ytm;
    }

    public void setYtm(Double ytm) {
        this.ytm = ytm;
    }

    public Double getCurrVal() {
        return currVal;
    }

    public void setCurrVal(Double currVal) {
        this.currVal = currVal;
    }

    public String getPSafeKeep() {
        return pSafeKeep;
    }

    public void setPSafeKeep(String pSafeKeep) {
        this.pSafeKeep = pSafeKeep;
    }

    public List<CRAN_VEC_ADV_Asset_CLS> getAssets(){
        return assets;
    }

    public void setAssets(List<CRAN_VEC_ADV_Asset_CLS> assets){
        this.assets = assets;
    }

    public Double getAllocParent(){
        return allocParent;
    }

    public void setAllocParent(Double allocParent){
        this.allocParent = allocParent;
    }
    
    public String getIban(){
        return iban;
    }

    public void setIban(String iban){
        this.iban = iban;
    }
}