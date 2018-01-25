/**
 * CRAN_VEC_ADV_NewRebalpRQ  POJO New Rebalq Avaloq service
 *
 * Fecha: 14/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_NewRebalpRQ {
	private String lang;
	private String rebalMethod;
	private String invstAmount;
	private String invstCurry;
	private List<CRAN_VEC_ADV_ObjList_CLS> objList;

	public List<CRAN_VEC_ADV_ObjList_CLS> getObjList() {
        return objList;
    }

    public void setObjList(List<CRAN_VEC_ADV_ObjList_CLS> objList) {
        this.objList = objList;
    }

    public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public String getRebalMethod() {
		return rebalMethod;
	}

	public void setRebalMethod(String rebalMethod) {
		this.rebalMethod = rebalMethod;
	}

	public String getInvstAmount() {
		return invstAmount;
	}

	public void setInvstAmount(String invstAmount) {
		this.invstAmount = invstAmount;
	}

	public String getInvstCurry() {
		return invstCurry;
	}

	public void setInvstCurry(String invstCurry) {
		this.invstCurry = invstCurry;
	}
}