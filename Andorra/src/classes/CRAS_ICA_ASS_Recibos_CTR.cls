public class CRAS_ICA_ASS_Recibos_CTR {
    public static List<List<String>> getRecibosDevueltos() {
        List<List<String>> result = new List<List<String>>();
        
        //Obtener rol
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        //obtener idioma
        String lang = UserInfo.getLanguage();
        
        //query
        List<AggregateResult> aResult = null;
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult = [select count(id) cnt, sum(CRAS_ICA_ASS_C_TotalPremium__c) amount, calendar_year(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) year, calendar_month(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) month
                       from CRAS_ICA_ASS_Invoice__c
                       where CRAS_ICA_ASS_MD_FinancialAccountRole__r.finserv__financialaccount__r.OwnerId in :owners
                       group by calendar_year(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c), calendar_month(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c)
                       order by calendar_year(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) asc, calendar_month(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) asc];
        } 
        else if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
            aResult = [select count(id) cnt, sum(CRAS_ICA_ASS_C_TotalPremium__c) amount, calendar_year(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) year, calendar_month(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) month
                       from CRAS_ICA_ASS_Invoice__c
                       where CRAS_ICA_ASS_MD_FinancialAccountRole__r.finserv__financialaccount__r.CRAN_ICA_KER_P_Oficina__c = :CRAS_ICA_ASS_Helpers_CLS.getUserOffice()
                       group by calendar_year(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c), calendar_month(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c)
                       order by calendar_year(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) asc, calendar_month(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) asc];
        }
        else {
            aResult = [select count(id) cnt, sum(CRAS_ICA_ASS_C_TotalPremium__c) amount, calendar_year(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) year, calendar_month(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) month
                       from CRAS_ICA_ASS_Invoice__c
                       group by calendar_year(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c), calendar_month(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c)
                       order by calendar_year(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) asc, calendar_month(CRAS_ICA_ASS_D_InvoiceEffectiveDate__c) asc];            
        }    
        //devolver lista de listas en formato <[año-mes][count][amount]>
        for(AggregateResult ar:aResult){
            
            List<String> toadd = new List<String>(); 
            
            Map<String,String> ENGMonths = new Map<String,String>();
            
            ENGMonths.put('1','January');
            ENGMonths.put('2','February');
            ENGMonths.put('3','March');
            ENGMonths.put('4','April');
            ENGMonths.put('5','May');
            ENGMonths.put('6','June');
            ENGMonths.put('7','July');
            ENGMonths.put('8','August');
            ENGMonths.put('9','September');
            ENGMonths.put('10','October');
            ENGMonths.put('11','November');
            ENGMonths.put('12','December');
            
            Map<String,String> ESPMonths = new Map<String,String>();
            
            ESPMonths.put('1','Enero');
            ESPMonths.put('2','Febrero');
            ESPMonths.put('3','Marzo');
            ESPMonths.put('4','Abril');
            ESPMonths.put('5','Mayo');
            ESPMonths.put('6','Junio');
            ESPMonths.put('7','Julio');
            ESPMonths.put('8','Agosto');
            ESPMonths.put('9','Septiembre');
            ESPMonths.put('10','Octubre');
            ESPMonths.put('11','Noviembre');
            ESPMonths.put('12','Diciembre');
            
            
            
            String yearmonth; 
            
            if (lang=='en_US'){
                yearmonth = ENGMonths.get(String.valueof(ar.get('month'))) + ' ' + ar.get('year');
            } else {
                yearmonth = ESPMonths.get(String.valueof(ar.get('month'))) + ' ' + ar.get('year');
            }
            
            String count = String.valueof(ar.get('cnt'));
            String amount = String.valueof(ar.get('amount'));
            
            toadd.add(yearmonth);
            toadd.add(count);
            toadd.add(amount);
            
            result.add(toadd);
        }
        
        return result;
    } 
}