public with sharing class CRAN_VAS_KER_SignatureRegister_CLS {
	
	public Integer codOperacion { get; set; }
	public Integer codFirma { get; set; }
	public List<Error> errors { get; set; }

	public class Error {

		public String code { get; set; }
		public String descError { get; set; }

	}

}