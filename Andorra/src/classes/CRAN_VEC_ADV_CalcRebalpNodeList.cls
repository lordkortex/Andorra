/**
 * CRAN_VEC_ADV_CalcRebalpNodeList  POJO generic request Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_CalcRebalpNodeList {

	private List<CRAN_VEC_ADV_CalcRebalpNode> node;

	/**
	 * @return the node
	 */
	public List<CRAN_VEC_ADV_CalcRebalpNode> getNode() {
		return node;
	}

	/**
	 * @param node the node to set
	 */
	public void setNode(List<CRAN_VEC_ADV_CalcRebalpNode> node) {
		this.node = node;
	}
}