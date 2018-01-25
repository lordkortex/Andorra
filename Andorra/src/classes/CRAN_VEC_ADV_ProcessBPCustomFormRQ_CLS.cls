/**
 * CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS {

    private String lang;
    private List<CRAN_VEC_ADV_ObjList_CLS> objList;
    private String questType;
    private String questVersion;
    private String questStatus;


    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

    public List<CRAN_VEC_ADV_ObjList_CLS> getObjList() {
        return objList;
    }

    public void setObjList(List<CRAN_VEC_ADV_ObjList_CLS> objList) {
        this.objList = objList;
    }

    public String getQuestType() {
        return questType;
    }

    public void setQuestType(String questType) {
        this.questType = questType;
    }
    
    public String getQuestVersion() {
        return questVersion;
    }

    public void setQuestVersion(String questVersion) {
        this.questVersion = questVersion;
    }
    
    public String getQuestStatus() {
        return questStatus;
    }

    public void setQuestStatus(String questStatus) {
        this.questStatus = questStatus;
    }

}