/**
 * CRAN_VEC_ADV_PrintDocumentPdfRS_CLS POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_PrintDocumentPdfRS_CLS {
 	private String blobPDF;
    private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;

    public String getBlobPDF() {
        return blobPDF;
    }

    public void setBlobPDF(String blobPDF) {
        this.blobPDF = blobPDF;
    }

    public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
        return errors;
    }

    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors) {
        this.errors = errors;
    }
}