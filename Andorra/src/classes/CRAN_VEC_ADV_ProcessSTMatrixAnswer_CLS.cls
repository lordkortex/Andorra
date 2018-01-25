/**
 * CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS POJO for avaloq Rest services
 *
 * Fecha: 07/12/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS {

	//Row name
	private String groupId;
	private List<CRAN_VEC_ADV_ProcessSTSection_CLS> sectionList;

	public CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS(String groupId, List<CRAN_VEC_ADV_ProcessSTSection_CLS> sectionList) {
		this.groupId = groupId;
		this.sectionList = sectionList;
	}

	/**
	* 
	* @return
	* The row name
	*/
	public String getGroupID() {
	return groupId;
	}

	/**
	* 
	* @param groupId
	* The groupId
	*/
	public void setGroupID(String groupId) {
	this.groupId = groupId;
	}

	/**
	* 
	* @return
	* The sections
	*/
	public List<CRAN_VEC_ADV_ProcessSTSection_CLS> getSections() {
	return sectionList;
	}

	/**
	* 
	* @param sections
	* The sections
	*/
	public void setSections(List<CRAN_VEC_ADV_ProcessSTSection_CLS> sections) {
	this.sectionList = sectionList;
	}

}