public class CRAS_ICA_ASS_Vecna_Batch implements Database.Batchable<sObject>, Database.Stateful 
{
    private String query; //The voice of Vecna
    
    public CRAS_ICA_ASS_Vecna_Batch(String query)
    {
        this.query = query;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(this.query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        delete scope;
    }
    
    public void finish(Database.BatchableContext BC)
    {
        System.debug('The end is just the beginning');
        
    }
}