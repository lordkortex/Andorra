/**
 * CRAN_VEC_ADV_TemplateLoader_TST
 *
 * Fecha: 24/02/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
@isTest
private class CRAN_VEC_ADV_TemplateLoader_TST {
	
	@isTest static void TemplateUpload_OK() {
		CRAN_VEC_ADV_TemplateLoader_CTR controller = new CRAN_VEC_ADV_TemplateLoader_CTR();
		Boolean testOk = controller.automatedDataLoad();
		System.assert(testOk);
	}
	
}