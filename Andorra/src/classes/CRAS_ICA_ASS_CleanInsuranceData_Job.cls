public class CRAS_ICA_ASS_CleanInsuranceData_Job implements Queueable {
	
	private Set<Id> idsFA { get; Set; }
	private Integer numTotalReg { get; Set; }
	private Integer numResFA { get; Set; }
	private Integer numResFH { get; Set; }
	private Integer numResFAR { get; Set; }
	private Integer numResINV { get; Set; }
    private Integer numResCAH { get; Set; }
    private Integer numResCPH { get; Set; }
    private Integer numResFAPH { get; Set; }
    private Integer numResOPV { get; Set; }
    private Integer numLimit { get; Set; }
	private Integer callNumber { get; Set; }
	
	public CRAS_ICA_ASS_CleanInsuranceData_Job(Set<Id> idsFA, Integer numTotalReg, Integer numResFA, 
                                               Integer numResFH, Integer numResFAR, Integer numResINV, 
                                               Integer numResCAH, Integer numResCPH, Integer numResFAPH, 
                                               Integer numResOPV, Integer numLimit, Integer callNumber){
		this.idsFA = idsFA;
		this.numTotalReg = numTotalReg;
		this.numResFA = numResFA;
		this.numResFH = numResFH;
		this.numResFAR = numResFAR;
		this.numResINV = numResINV;
        this.numResCAH = numResCAH; 
        this.numResCPH = numResCPH; 
        this.numResFAPH = numResFAPH;
        this.numResOPV = numResOPV;
		this.numLimit = numLimit;
		this.callNumber = callNumber;
	}
	
	private void recall(){
        if (Test.isRunningTest()){
            System.debug('Test - Limit reached');
        }else {
            Integer auxCallNumber = this.callNumber + 1;
            ID jobID = System.enqueueJob(new CRAS_ICA_ASS_CleanInsuranceData_Job(this.idsFA, this.numTotalReg, this.numResFA, 
                                                                                 this.numResFH, this.numResFAR, this.numResINV, 
                                                                                 this.numResCAH, this.numResCPH, this.numResFAPH, 
                                                                                 this.numResOPV, this.numLimit, auxCallNumber));
            System.debug('Llamada ' + auxCallNumber + ' - JOB ID: ' + jobID);
        }
	}
	
	public void execute(QueueableContext context) {
		Id FAInsuranceRT = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(FinServ__FinancialAccount__c.SObjectType,'CRAS_ICA_ASS_FAInsuranceRecordType');
		Id FHInsuranceProductRT = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(FinServ__FinancialHolding__c.SObjectType,'CRAS_ICA_ASS_FHInsuranceRecordType');
		Id FARInsuranceRT = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(FinServ__FinancialAccountRole__c.SObjectType, 'CRAS_ICA_ASS_FARInsuranceRecordType');
		Id FHInsuranceGuaranteeRT = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(FinServ__FinancialHolding__c.SObjectType,'CRAS_ICA_ASS_GarantiaPolizaRecordType');
        Id OPVInsuranceRT = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Opportunity.SObjectType, 'CRAS_ICA_ASS_VentaSeguros_RT');
		
		if (this.numTotalReg > this.numLimit){
            if (this.numResFAPH >= this.numLimit){
				List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT Id FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA LIMIT :this.numLimit];
				delete lstFAPH;
				this.numResFAPH = this.numResFAPH - this.numLimit;
				this.numTotalReg = this.numTotalReg - this.numLimit;
				this.recall();
			}
            else if (this.numResCPH + this.numResFAPH >= this.numLimit){
				Integer numLimitCPH = this.numLimit;
				if (this.numResFAPH > 0){
					List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT Id FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstFAPH;
					this.numTotalReg = this.numTotalReg - this.numResFAPH;
					numLimitCPH = numLimitCPH - this.numResFAPH;
					this.numResFAPH = 0;
				}
				List<CRAS_ICA_ASS_ClaimsPctHistory__c> lstCPH = [SELECT Id FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA LIMIT :numLimitCPH];
				delete lstCPH;
				
				this.numResCPH = this.numResCPH - numLimitCPH;
				this.numTotalReg = this.numTotalReg - numLimitCPH;
				this.recall();
			}
            else if (this.numResCAH + this.numResCPH + this.numResFAPH >= this.numLimit){
				Integer numLimitCAH = this.numLimit;
				if (this.numResFAPH > 0){
					List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT Id FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstFAPH;
					this.numTotalReg = this.numTotalReg - this.numResFAPH;
					numLimitCAH = numLimitCAH - this.numResFAPH;
					this.numResFAPH = 0;
				}
                if (this.numResCPH > 0){
					List<CRAS_ICA_ASS_ClaimsPctHistory__c> lstCPH = [SELECT Id FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstCPH;
					this.numTotalReg = this.numTotalReg - this.numResCPH;
					numLimitCAH = numLimitCAH - this.numResCPH;
					this.numResCPH = 0;
				}
				List<CRAS_ICA_ASS_ClaimAmountHistory__c> lstCAH = [SELECT Id FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__c IN :this.idsFA LIMIT :numLimitCAH];
				delete lstCAH;
				
				this.numResCPH = this.numResCPH - numLimitCAH;
				this.numTotalReg = this.numTotalReg - numLimitCAH;
				this.recall();
			}
            else if (this.numResINV + this.numResCAH + this.numResCPH + this.numResFAPH >= this.numLimit){
				Integer numLimitINV = this.numLimit;
				if (this.numResFAPH > 0){
					List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT Id FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstFAPH;
					this.numTotalReg = this.numTotalReg - this.numResFAPH;
					numLimitINV = numLimitINV - this.numResFAPH;
					this.numResFAPH = 0;
				}
                if (this.numResCPH > 0){
					List<CRAS_ICA_ASS_ClaimsPctHistory__c> lstCPH = [SELECT Id FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstCPH;
					this.numTotalReg = this.numTotalReg - this.numResCPH;
					numLimitINV = numLimitINV - this.numResCPH;
					this.numResCPH = 0;
				}
                if (this.numResCAH > 0){
					List<CRAS_ICA_ASS_ClaimAmountHistory__c> lstCAH = [SELECT Id FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstCAH;
					this.numTotalReg = this.numTotalReg - this.numResCAH;
					numLimitINV = numLimitINV - this.numResCAH;
					this.numResCAH = 0;
				}
				List<CRAS_ICA_ASS_Invoice__c> lstInvoices = [SELECT Id FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c IN :this.idsFA LIMIT :numLimitINV];
				delete lstInvoices;
				
				this.numResINV = this.numResINV - numLimitINV;
				this.numTotalReg = this.numTotalReg - numLimitINV;
				this.recall();
			}
            else if (this.numResFH + this.numResINV + this.numResCAH + this.numResCPH + this.numResFAPH >= this.numLimit){
				Integer numLimitFHG = this.numLimit;
				if (this.numResFAPH > 0){
					List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT Id FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstFAPH;
					this.numTotalReg = this.numTotalReg - this.numResFAPH;
					numLimitFHG = numLimitFHG - this.numResFAPH;
					this.numResFAPH = 0;
				}
                if (this.numResCPH > 0){
					List<CRAS_ICA_ASS_ClaimsPctHistory__c> lstCPH = [SELECT Id FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstCPH;
					this.numTotalReg = this.numTotalReg - this.numResCPH;
					numLimitFHG = numLimitFHG - this.numResCPH;
					this.numResCPH = 0;
				}
                if (this.numResCAH > 0){
					List<CRAS_ICA_ASS_ClaimAmountHistory__c> lstCAH = [SELECT Id FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstCAH;
					this.numTotalReg = this.numTotalReg - this.numResCAH;
					numLimitFHG = numLimitFHG - this.numResCAH;
					this.numResCAH = 0;
				}
                if (this.numResINV > 0){
					List<CRAS_ICA_ASS_Invoice__c> lstInvoices = [SELECT Id FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstInvoices;
					this.numTotalReg = this.numTotalReg - this.numResINV;
					numLimitFHG = numLimitFHG - this.numResINV;
					this.numResINV = 0;
				}
				List<FinServ__FinancialHolding__c> lstHoldings = [SELECT Id FROM FinServ__FinancialHolding__c WHERE (RecordTypeId = :FHInsuranceGuaranteeRT OR RecordTypeId = :FHInsuranceProductRT) AND FinServ__FinancialAccount__c IN :this.idsFA LIMIT :numLimitFHG];
				delete lstHoldings;
				
				this.numResFH = this.numResFH - numLimitFHG;
				this.numTotalReg = this.numTotalReg - numLimitFHG;
				this.recall();
			}
            else if (this.numResFAR + this.numResFH + this.numResINV + this.numResCAH + this.numResCPH + this.numResFAPH >= this.numLimit){
				Integer numLimitFAR = this.numLimit;
				if (this.numResFAPH > 0){
					List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT Id FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstFAPH;
					this.numTotalReg = this.numTotalReg - this.numResFAPH;
					numLimitFAR = numLimitFAR - this.numResFAPH;
					this.numResFAPH = 0;
				}
                if (this.numResCPH > 0){
					List<CRAS_ICA_ASS_ClaimsPctHistory__c> lstCPH = [SELECT Id FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstCPH;
					this.numTotalReg = this.numTotalReg - this.numResCPH;
					numLimitFAR = numLimitFAR - this.numResCPH;
					this.numResCPH = 0;
				}
                if (this.numResCAH > 0){
					List<CRAS_ICA_ASS_ClaimAmountHistory__c> lstCAH = [SELECT Id FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstCAH;
					this.numTotalReg = this.numTotalReg - this.numResCAH;
					numLimitFAR = numLimitFAR - this.numResCAH;
					this.numResCAH = 0;
				}
                if (this.numResINV > 0){
					List<CRAS_ICA_ASS_Invoice__c> lstInvoices = [SELECT Id FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstInvoices;
					this.numTotalReg = this.numTotalReg - this.numResINV;
					numLimitFAR = numLimitFAR - this.numResINV;
					this.numResINV = 0;
				}
                if (this.numResFH > 0){
					List<FinServ__FinancialHolding__c> lstHoldings = [SELECT Id FROM FinServ__FinancialHolding__c WHERE (RecordTypeId = :FHInsuranceGuaranteeRT OR RecordTypeId = :FHInsuranceProductRT) AND FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstHoldings;
					this.numTotalReg = this.numTotalReg - this.numResFH;
					numLimitFAR = numLimitFAR - this.numResFH;
					this.numResFH = 0;
				}
				List<FinServ__FinancialAccountRole__c> lstRoles = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE RecordTypeId = :FARInsuranceRT AND FinServ__FinancialAccount__c IN :this.idsFA LIMIT :numLimitFAR];
				delete lstRoles;
				
				this.numResFAR = this.numResFAR - numLimitFAR;
				this.numTotalReg = this.numTotalReg - numLimitFAR;
				this.recall();
			}
            else if (this.numResOPV + this.numResFAR + this.numResFH + this.numResINV + this.numResCAH + this.numResCPH + this.numResFAPH >= this.numLimit){
				Integer numLimitOPV = this.numLimit;
				if (this.numResFAPH > 0){
					List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT Id FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstFAPH;
					this.numTotalReg = this.numTotalReg - this.numResFAPH;
					numLimitOPV = numLimitOPV - this.numResFAPH;
					this.numResFAPH = 0;
				}
                if (this.numResCPH > 0){
					List<CRAS_ICA_ASS_ClaimsPctHistory__c> lstCPH = [SELECT Id FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstCPH;
					this.numTotalReg = this.numTotalReg - this.numResCPH;
					numLimitOPV = numLimitOPV - this.numResCPH;
					this.numResCPH = 0;
				}
                if (this.numResCAH > 0){
					List<CRAS_ICA_ASS_ClaimAmountHistory__c> lstCAH = [SELECT Id FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstCAH;
					this.numTotalReg = this.numTotalReg - this.numResCAH;
					numLimitOPV = numLimitOPV - this.numResCAH;
					this.numResCAH = 0;
				}
                if (this.numResINV > 0){
					List<CRAS_ICA_ASS_Invoice__c> lstInvoices = [SELECT Id FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstInvoices;
					this.numTotalReg = this.numTotalReg - this.numResINV;
					numLimitOPV = numLimitOPV - this.numResINV;
					this.numResINV = 0;
				}
                if (this.numResFH > 0){
					List<FinServ__FinancialHolding__c> lstHoldings = [SELECT Id FROM FinServ__FinancialHolding__c WHERE (RecordTypeId = :FHInsuranceGuaranteeRT OR RecordTypeId = :FHInsuranceProductRT) AND FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstHoldings;
					this.numTotalReg = this.numTotalReg - this.numResFH;
					numLimitOPV = numLimitOPV - this.numResFH;
					this.numResFH = 0;
				}
                if (this.numResFAR > 0){
					List<FinServ__FinancialAccountRole__c> lstRoles = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE RecordTypeId = :FARInsuranceRT AND FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstRoles;
					this.numTotalReg = this.numTotalReg - this.numResFAR;
					numLimitOPV = numLimitOPV - this.numResFAR;
					this.numResFAR = 0;
				}
				List<Opportunity> lst = [SELECT Id FROM Opportunity WHERE RecordTypeId = :OPVInsuranceRT AND FinServ__FinancialAccount__c IN :this.idsFA LIMIT :numLimitOPV];
				delete lst;
				
				this.numResOPV = this.numResOPV - numLimitOPV;
				this.numTotalReg = this.numTotalReg - numLimitOPV;
				this.recall();
			}
            else if (this.numResFA + this.numResOPV + this.numResFAR + this.numResFH + this.numResINV + this.numResCAH + this.numResCPH + this.numResFAPH >= this.numLimit){
				Integer numLimitFA = this.numLimit;
				if (this.numResFAPH > 0){
					List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT Id FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstFAPH;
					this.numTotalReg = this.numTotalReg - this.numResFAPH;
					numLimitFA = numLimitFA - this.numResFAPH;
					this.numResFAPH = 0;
				}
                if (this.numResCPH > 0){
					List<CRAS_ICA_ASS_ClaimsPctHistory__c> lstCPH = [SELECT Id FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
					delete lstCPH;
					this.numTotalReg = this.numTotalReg - this.numResCPH;
					numLimitFA = numLimitFA - this.numResCPH;
					this.numResCPH = 0;
				}
                if (this.numResCAH > 0){
					List<CRAS_ICA_ASS_ClaimAmountHistory__c> lstCAH = [SELECT Id FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstCAH;
					this.numTotalReg = this.numTotalReg - this.numResCAH;
					numLimitFA = numLimitFA - this.numResCAH;
					this.numResCAH = 0;
				}
                if (this.numResINV > 0){
					List<CRAS_ICA_ASS_Invoice__c> lstInvoices = [SELECT Id FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstInvoices;
					this.numTotalReg = this.numTotalReg - this.numResINV;
					numLimitFA = numLimitFA - this.numResINV;
					this.numResINV = 0;
				}
                if (this.numResFH > 0){
					List<FinServ__FinancialHolding__c> lstHoldings = [SELECT Id FROM FinServ__FinancialHolding__c WHERE (RecordTypeId = :FHInsuranceGuaranteeRT OR RecordTypeId = :FHInsuranceProductRT) AND FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstHoldings;
					this.numTotalReg = this.numTotalReg - this.numResFH;
					numLimitFA = numLimitFA - this.numResFH;
					this.numResFH = 0;
				}
                if (this.numResFAR > 0){
					List<FinServ__FinancialAccountRole__c> lstRoles = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE RecordTypeId = :FARInsuranceRT AND FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstRoles;
					this.numTotalReg = this.numTotalReg - this.numResFAR;
					numLimitFA = numLimitFA - this.numResFAR;
					this.numResFAR = 0;
				}
                if (this.numResOPV > 0){
					List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE RecordTypeId = :OPVInsuranceRT AND FinServ__FinancialAccount__c IN :this.idsFA];
					delete lstOpp;
					this.numTotalReg = this.numTotalReg - this.numResOPV;
					numLimitFA = numLimitFA - this.numResOPV;
					this.numResOPV = 0;
				}
				List<FinServ__FinancialAccount__c> lstFA = [SELECT Id FROM FinServ__FinancialAccount__c WHERE RecordTypeId = :FARInsuranceRT AND Id IN :this.idsFA LIMIT :numLimitFA];
				delete lstFA;
				
				this.numResFA = this.numResFA - numLimitFA;
				this.numTotalReg = this.numTotalReg - numLimitFA;
				this.recall();
			}
            
            
            
            
            
            
            
		}
		else{
            List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE RecordTypeId = :OPVInsuranceRT AND FinServ__FinancialAccount__c IN :this.idsFA];
            List<CRAS_ICA_ASS_FA_PremiumHistory__c> lstFAPH = [SELECT Id FROM CRAS_ICA_ASS_FA_PremiumHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
        	List<CRAS_ICA_ASS_ClaimsPctHistory__c> lstCPH = [SELECT Id FROM CRAS_ICA_ASS_ClaimsPctHistory__c WHERE CRAS_ICA_ASS_L_FinancialAccount__c IN :this.idsFA];
            List<CRAS_ICA_ASS_ClaimAmountHistory__c> lstCAH = [SELECT Id FROM CRAS_ICA_ASS_ClaimAmountHistory__c WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__c IN :this.idsFA];
			List<CRAS_ICA_ASS_Invoice__c> lstInvoices = [SELECT Id FROM CRAS_ICA_ASS_Invoice__c WHERE CRAS_ICA_ASS_MD_FinancialAccountRole__r.FinServ__FinancialAccount__c IN :this.idsFA];
			List<FinServ__FinancialHolding__c> lstGuarantees = [SELECT Id FROM FinServ__FinancialHolding__c WHERE RecordTypeId = :FHInsuranceGuaranteeRT AND FinServ__FinancialAccount__c IN :this.idsFA];
			List<FinServ__FinancialAccountRole__c> lstRoles = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE RecordTypeId = :FARInsuranceRT AND FinServ__FinancialAccount__c IN :this.idsFA];
			List<FinServ__FinancialHolding__c> lstProducts = [SELECT Id FROM FinServ__FinancialHolding__c WHERE RecordTypeId = :FHInsuranceProductRT AND FinServ__FinancialAccount__c IN :this.idsFA];
			List<FinServ__FinancialAccount__c> lst = [SELECT Id FROM FinServ__FinancialAccount__c WHERE RecordTypeId = :FAInsuranceRT AND Id IN :this.idsFA];
			
            delete lstOpp;
            delete lstFAPH;
            delete lstCPH;
            delete lstCAH;
			delete lstInvoices;
			delete lstGuarantees;
			delete lstRoles;
			delete lstProducts;
			delete lst;
			
			System.debug('--- CRAS_ICA_ASS_CleanInsuranceData_Job (JOB ID: ' + context.getJobId() + '): Se ha completado satisfactoriamente. ---');
		}
	}
}