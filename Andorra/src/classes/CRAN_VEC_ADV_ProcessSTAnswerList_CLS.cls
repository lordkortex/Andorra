/**
 * CRAN_VEC_ADV_ProcessSTAnswerList_CLS POJO for avaloq Rest services
 *
 * Fecha: 1/02/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_ProcessSTAnswerList_CLS {

	private List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> answers;
	private List<CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS> matrixAnswers;

	/**
	* 
	* @return
	* The answers
	*/
	public List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> getAnswers() {
	return answers;
	}

	/**
	* 
	* @param answers
	* The answers
	*/
	public void setAnswers(List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> answers) {
	this.answers = answers;
	}

	/**
	* 
	* @return
	* The matrix answers
	*/
	public List<CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS> getMatrixAnswers() {
	return matrixAnswers;
	}

	/**
	* 
	* @param matrixAnswers
	* The matrixAnswers
	*/
	public void setMatrixAnswers(List<CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS> matrixAnswers) {
	this.matrixAnswers = matrixAnswers;
	}
}