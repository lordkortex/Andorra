/**
 * CRAN_VEC_ADV_ArchiveService_TST  POJO Archive Print Avaloq service test
 *
 * Fecha: 22/05/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
@isTest
public class CRAN_VEC_ADV_ArchiveService_TST {
    
    @isTest 
    static void CRAN_VEC_ADV_ArchiveRQ() {
        CRAN_VEC_ADV_ArchiveRQ request = new CRAN_VEC_ADV_ArchiveRQ();
        CRAN_VEC_ADV_ArchiveRS response = new CRAN_VEC_ADV_ArchiveRS();
        
        request.bpId = 'StringBP';
        request.referenceLine = '1231231323';
        
        String jsonRequest = JSON.serialize(request);
        System.debug('jsonRequest :'+ jsonRequest);
        
        CRAN_VEC_ADV_ArchiveRQ reqDese = (CRAN_VEC_ADV_ArchiveRQ) JSON.deserialize(jsonRequest, CRAN_VEC_ADV_ArchiveRQ.class);
        System.debug('ClassRequest :'+ reqDese);
        
        response.pdfContent = 'pdfContentsdifhsidfhsihdfi';
        
        String jsonResponse = JSON.serialize(response);
        System.debug('jsonResponse :'+ jsonRequest);
        
        CRAN_VEC_ADV_ArchiveRS resDese = (CRAN_VEC_ADV_ArchiveRS) JSON.deserialize(jsonResponse, CRAN_VEC_ADV_ArchiveRS.class);
        System.debug('ClassResponse :'+ resDese);
     
	}
    
}