/**
 * CRAN_VEC_ADV_OmsPrint_RS  POJO OmsPrint Avaloq service
 *
 * Fecha: 03/05/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_OmsPrint_RS {
	public List<Oms> omsIdList{get; set;}
	public List<CRAN_VEC_ADV_ProcessSTError_CLS> errors{get; set;}

	public class Oms {
		public String id{get; set;}
	}
}