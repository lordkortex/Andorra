/**
 * CRAN_VEC_ADV_ProcessSTResponse_CLS POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_ProcessSTResponse_CLS {

	private String profileType;
	private String profileText;
	private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;
	private List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> question;

	/**
	* 
	* @return
	* The profile
	*/
	public String getProfileType() {
	return profileType;
	}

	/**
	* 
	* @param profile
	* The profile
	*/
	public void setProfileType(String profileType) {
	this.profileType = profileType;
	}

		/**
	* 
	* @return
	* The profileText
	*/
	public String getProfileText() {
	return profileText;
	}

	/**
	* 
	* @param profile
	* The profileText
	*/
	public void setProfileText(String profileText) {
	this.profileText = profileText;
	}

	/**
	* 
	* @return
	* The error
	*/
	public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
	return errors;
	}

	/**
	* 
	* @param error
	* The error
	*/
	public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors) {
	this.errors = errors;
	}

	/**
	* 
	* @return
	* The question
	*/
	public List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> getQuestion() {
	return question;
	}

	/**
	* 
	* @param question
	* The question
	*/
	public void setQuestion(List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> question) {
	this.question = question;
	}

}