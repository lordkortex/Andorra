/**
 * CRAN_VEC_ADV_RebalpList_RQ  POJO RebalqList Avaloq service
 *
 * Fecha: 25/04/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_RebalpList_RQ {
	public String lang{get; set;}
	public String dateFrom{get; set;}
	public String dateTo{get; set;}
	
	public CRAN_VEC_ADV_RebalpListObjList objList{get; set;}
	public CRAN_VEC_ADV_StatusList_CLS statusList{get; set;}
	
}