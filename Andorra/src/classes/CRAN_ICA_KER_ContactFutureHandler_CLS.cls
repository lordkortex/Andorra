public class CRAN_ICA_KER_ContactFutureHandler_CLS {
    @future
    public static void setIdentity(List<Id> contactsList){
        
        List<Account> cuentas = [SELECT Id, CRAN_ICA_KER_P_Identity__c, FinServ__PrimaryContact__c, 
                                 FinServ__PrimaryContact__r.CRAN_ICA_KER_P_Identity__c,
                                 FinServ__PrimaryContact__r.CRAN_ICA_KER_P_Oficina__c
                                 FROM Account 
                                 WHERE FinServ__PrimaryContact__c IN :contactsList];
        
        for (Account acc: cuentas){
            acc.CRAN_ICA_KER_P_Identity__c = acc.FinServ__PrimaryContact__r.CRAN_ICA_KER_P_Identity__c;
            acc.CRAN_ICA_KER_P_Oficina__c = acc.FinServ__PrimaryContact__r.CRAN_ICA_KER_P_Oficina__c;
        }
        
        update cuentas;
    }
    
    /*
*
*fjdiaz@creditandorra.ad 14/07/2017
*
*/
    @future
    public static void squashContact (List<Id> conctListId)
    {
        List<String> conctListAxisId = new List<String> ();
        List<Id> accListId = new List<Id>();
        List<Id> accListTwinId = new List<Id>();
        
        List<Contact> conctList = [Select Id, CRAS_ICA_ASS_T_AxisPersonID__c, AccountId
                                       FROM Contact 
                                       WHERE Id IN :conctListId];
        
        for(Contact conct : conctList)
        {
            conctListAxisId.add(conct.CRAS_ICA_ASS_T_AxisPersonID__c);
            accListId.add(conct.AccountId);
        }
        
        List<Contact> conctListTwin = [Select Id, CRAS_ICA_ASS_T_AxisPersonID__c, AccountId
                                       FROM Contact 
                                       WHERE Id NOT IN :conctListId AND 
                                       CRAS_ICA_ASS_T_AxisPersonID__c IN :conctListAxisId];
        
        if(conctListTwin.Size() > 0)
        {
            for(Contact conct : conctListTwin)
            {
                accListTwinId.add(conct.Id);
            }
            
            
            List<Account> accList = [SELECT Id, CRAS_ICA_ASS_F_AxisPersonID__c
                                     FROM Account
                                     WHERE Id IN :accListId];
            
            List<Account> accListTwin = [SELECT Id, CRAS_ICA_ASS_F_AxisPersonID__c
                                         FROM Account
                                         WHERE Id IN :accListTwinId];
            
            for(Account acc : accList)
            {
                Account duplicateAccount = searchAccount(acc.CRAS_ICA_ASS_F_AxisPersonID__c, accListTwin);
                
                if(duplicateAccount != null)
                {
                    try
                    {
                        merge acc duplicateAccount;
                    }
                    catch (DmlException e)
                    {
                        System.debug('An unexpected error has ocurred: ' + e.getMessage());
                    }
                }
            }
            
            
            for(Contact conct : conctList)
            {  
                Contact duplicateContact = searchContact(conct.CRAS_ICA_ASS_T_AxisPersonID__c, conctListTwin);
                
                if(duplicateContact != null)
                {
                    try
                    {
                        merge conct duplicateContact;
                    }
                    catch (DmlException e)
                    {
                        System.debug('An unexpected error has occurred: ' + e.getMessage()); 
                    }
                }
            }
            
        }
    }
    
    private static Contact searchContact (String axisPersonId, List<Contact> conctList)
    {
        for(Contact conct : conctList)
        {
            if(axisPersonId.equals(conct.CRAS_ICA_ASS_T_AxisPersonID__c))
            {
                return conct;
            }
        }
        
        return new Contact();
    }
    
    private static Account searchAccount (String axisPersonId, List<Account> accList)
    {
        for(Account acc : accList)
        {
            if(axisPersonId.equals(acc.CRAS_ICA_ASS_F_AxisPersonID__c))
            {
                return acc;
            }
        }
        
        return new Account();
    }
}