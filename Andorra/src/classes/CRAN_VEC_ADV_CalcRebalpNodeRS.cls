/**
 * CRAN_VEC_ADV_CalcRebalpNodeRS  POJO generic response Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_CalcRebalpNodeRS {
	
	private CRAN_VEC_ADV_CalcRebalpNodeDet nodeDet;
	
	private List<CRAN_VEC_ADV_CalcRebalpNodeListRS> nodeList;

	/**
	 * @return the nodeDet
	 */
	public CRAN_VEC_ADV_CalcRebalpNodeDet getNodeDet() {
		return nodeDet;
	}

	/**
	 * @param nodeDet the nodeDet to set
	 */
	public void setNodeDet(CRAN_VEC_ADV_CalcRebalpNodeDet nodeDet) {
		this.nodeDet = nodeDet;
	}

	/**
	 * @return the nodeList
	 */
	public List<CRAN_VEC_ADV_CalcRebalpNodeListRS> getNodeList() {
		return nodeList;
	}

	/**
	 * @param nodeList the nodeList to set
	 */
	public void setNodeList(List<CRAN_VEC_ADV_CalcRebalpNodeListRS> nodeList) {
		this.nodeList = nodeList;
	}

}