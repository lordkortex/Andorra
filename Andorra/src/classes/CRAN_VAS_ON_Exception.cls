/**
* VASS
* @author           VASS
* Project:          Credit Andorra
* Description:      
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     24-01-2018      Jhon Cortes             Generic Exception for credit Andorra.
*********************************************************************************************************/
public class CRAN_VAS_ON_Exception extends Exception{

	/** The exception code. */
	public final Integer exceptionCode;
	
	/** The exception description. */
	public final String exceptionDescription;
	
	/**
	 * Instantiates a new CRAN_VAS_ON_Exception_CLS exception CLS.
	 *
	 * @param code
	 *            the numericcode
	 * @param description
	 *            the description message for exception
	 */
	public CRAN_VAS_ON_Exception( final Integer code, final String description) {
		exceptionCode = code;
		exceptionDescription = description;
		
	}
}