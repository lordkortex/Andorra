/**
 * CRAN_VEC_ADV_ProcessSTQuestion_CLS POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_ProcessSTQuestion_CLS {

	private String id;
	private List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answers;

	/**
	* 
	* @return
	* The questionId
	*/
	public String getId() {
	return id;
	}

	/**
	* 
	* @param questionId
	* The questionId
	*/
	public void setId(String id) {
	this.id = id;
	}

	/**
	* 
	* @return
	* The answers
	*/
	public List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> getAnswers() {
	return answers;
	}

	/**
	* 
	* @param answers
	* The answers
	*/
	public void setAnswers(List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answers) {
	this.answers = answers;
	}
}