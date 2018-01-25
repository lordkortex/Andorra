public class CRAS_ICA_ASS_Propuestas_CTR {

    public static List<List<String>> getPropuestasPendientes() {
        List<List<String>> result = new List<List<String>>();
        
        //Obtener rol
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        //query
        List<AggregateResult> aResult = null;
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult = [select count(id) cnt, toLabel(CRAN_VEC_ADV_P_PFMMkt__c) mkt
                                             from FinServ__FinancialAccount__c
                                             where OwnerId in :owners
                                                AND (FinServ__Status__c = '105ASS'
                                                     OR CRAS_ICA_ASS_T_SolicitudAxisID__c != '')
                                             group by CRAN_VEC_ADV_P_PFMMkt__c];
        }
        else  if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
            aResult = [select count(id) cnt, toLabel(CRAN_VEC_ADV_P_PFMMkt__c) mkt
                                             from FinServ__FinancialAccount__c
                                             where CRAN_ICA_KER_P_Oficina__c = :CRAS_ICA_ASS_Helpers_CLS.getUserOffice()
                                                AND (FinServ__Status__c = '105ASS'
                                                     OR CRAS_ICA_ASS_T_SolicitudAxisID__c != '')
                                             group by CRAN_VEC_ADV_P_PFMMkt__c];
        } else {
            aResult = [select count(id) cnt, toLabel(CRAN_VEC_ADV_P_PFMMkt__c) mkt
                       from FinServ__FinancialAccount__c
                       where FinServ__Status__c = '105ASS'
                       		 OR CRAS_ICA_ASS_T_SolicitudAxisID__c != ''
                       group by CRAN_VEC_ADV_P_PFMMkt__c];
        }
        
        //devolver lista de listas en formato <[market][count]>
        for(AggregateResult ar:aResult){
            
            List<String> toadd = new List<String>(); 
            
            String market = String.valueof(ar.get('mkt'));
			String count = String.valueof(ar.get('cnt'));
            
            if (String.isNotBlank(count)){
                if (String.isNotBlank(market)){
                	toadd.add(market);
                    toadd.add(count);
                    result.add(toadd);   
                } else {	
                    toadd.add(Label.CRAS_ICA_ASS_T_Others);
                    toadd.add(count);
                    result.add(toadd);  
                }             
            }
            
            
        }
        
        return result;
    } 
    
}