/**
 * CRAN_VEC_ADV_OmsPrintList_RS  POJO OmsPrint Avaloq service
 *
 * Fecha: 19/06/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_OmsPrintList_RS {
	public List<Oms> omsIdList{get; set;}
	public List<CRAN_VEC_ADV_ProcessSTError_CLS> errors{get; set;}

	public class Oms {
		public String omsId{get; set;}
		public String orderNr{get; set;}
	}
}