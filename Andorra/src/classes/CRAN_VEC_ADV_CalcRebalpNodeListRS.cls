/**
 * CRAN_VEC_ADV_CalcRebalpNodeListRS  POJO generic response Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_CalcRebalpNodeListRS {
	
	private CRAN_VEC_ADV_CalcRebalpNodeDet nodeDet;
	private List<CRAN_VEC_ADV_CalcRebalpNodeListRS> nodeList;
	/**
	 * @return the node
	 */
	public CRAN_VEC_ADV_CalcRebalpNodeDet getNodeDet() {
		return nodeDet;
	}

	/**
	 * @param node the node to set
	 */
	public void setNodeDet(CRAN_VEC_ADV_CalcRebalpNodeDet nodeDet) {
		this.nodeDet = nodeDet;
	}


	/**
	 * @return the node
	 */
	public List<CRAN_VEC_ADV_CalcRebalpNodeListRS> getNodeList() {
		return nodeList;
	}

	/**
	 * @param node the node to set
	 */
	public void setNodeList(List<CRAN_VEC_ADV_CalcRebalpNodeListRS> nodeList) {
		this.nodeList = nodeList;
	}
}