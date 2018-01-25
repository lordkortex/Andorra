/**
 * CRAN_VEC_ADV_OmsDocument_RS  POJO response Get OMS document Avaloq services
 *
 * Fecha: 08/05/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_OmsDocument_RS {
	public String pdfContent {get;set;}
	public List<CRAN_VEC_ADV_ProcessSTError_CLS> errors{get; set;}
}