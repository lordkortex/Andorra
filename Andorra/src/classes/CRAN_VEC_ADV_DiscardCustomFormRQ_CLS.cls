/**
 * CRAN_VEC_ADV_DiscardCustomFormRQ_CLS POJO for Rest services
 *
 * Request descartarFormularios
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_DiscardCustomFormRQ_CLS {
    private String lang;
    private List<CRAN_VEC_ADV_Order_CLS> orderList;

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

    public List<CRAN_VEC_ADV_Order_CLS> getOrderList() {
        return orderList;
    }
    public void setOrderList(List<CRAN_VEC_ADV_Order_CLS> orderList) {
        this.orderList = orderList;
    }
}