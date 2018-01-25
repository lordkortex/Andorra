/****
* 
* Update 02/06/2017
* fjdiaz@creditandorra.ad ICA
* 
* 
****/


trigger CRAN_VAS_KER_AccountTrigger on Account (before insert, 
                                                before update, 
                                                before delete, 
                                                after insert, 
                                                after update, 
                                                after delete, 
                                                after undelete) 
{
    new CRAS_ICA_ASS_AccountTrgHandler_CLS(Account.getSObjectType()).run();      
    
}