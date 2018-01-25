@isTest
global class CRAN_VAS_KER_pdfContenidoCallout_tst implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('"pdfContent": " +PgpzdGFydHhyZWYKNjY0CiUlRU8=…"');
        response.setStatusCode(200);
        return response; 
    }
    
}