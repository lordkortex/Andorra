/**
 * CRAN_VEC_ADV_CalcRebalpRestriction  POJO generic request Calculate Rebalp Avaloq services
 *
 * Fecha: 20/03/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

/** Alias("restr") */
public with sharing class CRAN_VEC_ADV_CalcRebalpRestriction {
	
	private String id;
	private Boolean overrideRestr;
	private String justif;

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the override
	 */
	public Boolean getOverride() {
		return overrideRestr;
	}

	/**
	 * @param override the override to set
	 */
	public void setOverride(Boolean overrideRestr) {
		this.overrideRestr = overrideRestr;
	}

	/**
	 * @return the justif
	 */
	public String getJustif() {
		return justif;
	}

	/**
	 * @param justif the justif to set
	 */
	public void setJustif(String justif) {
		this.justif = justif;
	}

}