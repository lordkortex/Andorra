public with sharing class CRAN_VEC_ADV_PortfolioRS_CLS {
    private CRAN_VEC_ADV_PorfGrandTotal_CLS porfGrandTotal;
    private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;

    public CRAN_VEC_ADV_PorfGrandTotal_CLS getPorfGrandTotal() {
        return porfGrandTotal;
    }

    public void setPorfGrandTotal(CRAN_VEC_ADV_PorfGrandTotal_CLS porfGrandTotal) {
        this.porfGrandTotal = porfGrandTotal;
    }

    
    public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
        return errors;
    }

    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> error) {
        this.errors = errors;
    }
    
}