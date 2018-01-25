/**
 * CRAN_VEC_ADV_MergeOMS_RQ POJO for avaloq Rest services
 *
 * Fecha: 19/06/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public class CRAN_VEC_ADV_MergeOMS_RQ {

    public List<Oms> omsList{get; set;}
    public class Oms {
        public String omsId;
    }
}