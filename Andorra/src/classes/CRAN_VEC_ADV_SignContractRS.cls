/**
 * CRAN_VEC_ADV_SignContractRS  POJO generic response Sign contract Avaloq services
 *
 * Fecha: 23/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_SignContractRS {

	/** Identificador del bp advisory marcado como que tiene contrato de advisory firmado */
	private CRAN_VEC_ADV_ObjList_CLS objList;
	/** Estado de la orden de BP actualizada (intl_id) */
	private String status;
	private List<CRAN_VEC_ADV_ProcessSTError_CLS> errors;

	/**
	 * @return the objList
	 */
	public CRAN_VEC_ADV_ObjList_CLS getObjList() {
		return objList;
	}

	/**
	 * @param objList the objList to set
	 */
	public void setObjList(CRAN_VEC_ADV_ObjList_CLS objList) {
		this.objList = objList;
	}

	/**
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @param status the status to set
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	public List<CRAN_VEC_ADV_ProcessSTError_CLS> getErrors() {
        return errors;
    }

    public void setErrors(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors) {
        this.errors = errors;
    }
}