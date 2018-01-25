/**
 * CRAN_VEC_ADV_GenericAvaloqRequest POJO for avaloq Rest services
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public with sharing class CRAN_VEC_ADV_GenericAvaloqRequest {
	
	private String service;
    private String content;
    private String codAppOrigin;
    private String codModAppOrigin;
    private String codEnv;

    /**
     *
     * @return
     * The service
     */
    public String getService() {
        return service;
    }

    /**
     *
     * @param service
     * The service
     */
    public void setService(String service) {
        this.service = service;
    }

    /**
     *
     * @return
     * The content
     */
    public String getContent() {
        return content;
    }

    /**
     *
     * @param content
     * The content
     */
    public void setContent(String content) {
        this.content = content;
    }

    /**
     *
     * @return
     * The codAppOrigin
     */
    public String getCodAppOrigin() {
        return codAppOrigin;
    }

    /**
     *
     * @param codAppOrigin
     * The codAppOrigin
     */
    public void setCodAppOrigin(String codAppOrigin) {
        this.codAppOrigin = codAppOrigin;
    }

    /**
     *
     * @return
     * The codModAppOrigin
     */
    public String getCodModAppOrigin() {
        return codModAppOrigin;
    }

    /**
     *
     * @param codModAppOrigin
     * The codModAppOrigin
     */
    public void setCodModAppOrigin(String codModAppOrigin) {
        this.codModAppOrigin = codModAppOrigin;
    }

    /**
     *
     * @return
     * The codEnv
     */
    public String getCodEnv() {
        return codEnv;
    }

    /**
     *
     * @param codEnv
     * The codEnv
     */
    public void setCodEnv(String codEnv) {
        this.codEnv = codEnv;
    }
}