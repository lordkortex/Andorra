@isTest
public class CRAN_VAS_KER_SignatureHandlerBase_TST extends CRAN_VAS_KER_SignatureHandlerBase {
    
    @isTest
    static void testVirtualClass() {
        CRAN_VAS_KER_SignatureHandlerBase hndlr = new CRAN_VAS_KER_SignatureHandlerBase();
        hndlr.getSignatureUrl('XYZ');
    }

}