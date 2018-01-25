global class CRAN_ICA_KER_PostCopy_CLS implements SandboxPostCopy {
    //variables
    private static Map<Id, RecordType> recordTypeCache;
    static {
        recordTypeCache = new Map<Id, RecordType>([Select Id, DeveloperName from RecordType]);
    }

    global void runApexClass(SandboxContext context)
    {
        List<Contact> person = createContactBanking();
        List<Account> bp = createBPBanking();

        if(bp.Size() > 0)
        {
            createContainerBanking(bp);

            if(person.Size() > 0)
            {
                createRelBanking(bp, person);
            } 
        }

        createAssetBanking();
    }

    global static List<Contact> createContactBanking()
    {
        List<Contact> cntInsertLst = new List<Contact>();
        Date myDate = Date.newInstance(2016, 1, 1);
        Id recordTypeIndividual = recordTypeIdByDeveloperName(new Contact(), 'CRAN_VEC_ADV_Individual');
        Id recordTypeBusiness = recordTypeIdByDeveloperName(new Contact(), 'CRAN_VEC_ADV_Business');

        for(Integer i = 0; i < 200; i++)
        {
            Contact cntTemp = new Contact(
                CRAN_VEC_ADV_T_PersonId__c = '9_356' + i,
                CRAN_VEC_ADV_D_AvOpenDate__c = myDate.addDays(i),
                CRAN_VEC_ADV_N_NumericSort__c = String.valueOf(i),
                CRAN_VEC_ADV_P_PersonType__c = '120',
                FirstName = 'person-120_' + i,
                LastName = 'PostCopy_' + i,
                Birthdate = myDate.addYears(i * -1),
                CRAN_VEC_ADV_P_Nationality__c = 'AD',
                CRAN_VEC_ADV_P_Bunit__c = '9',
                MailingStreet = 'addr--1_550' + i,
                MailingCity = 'Andorra la Vella',
                MailingPostalCode = 'AD500',
                MailingCountryCode = 'AD',
                CRAN_VEC_ADV_P_EmpStatus__c = '7940',
                CRAN_VEC_ADV_B_Numbered__c = false,
                CRAN_VEC_ADV_B_IsEmployee__c = false,
                CRAN_VEC_ADV_B_IsProspect__c = false,
                CRAN_VEC_ADV_B_IsCondominium__c = false,
                CRAN_VEC_ADV_P_MIFIDCLASS__c = '5810',
                CRAN_ICA_ADV_B_EsComercio__c = true,
                CRAN_ICA_KER_P_Identity__c = '101',
                RecordTypeId = recordTypeIndividual
            );

            if(Math.mod(i, 5) == 0 && Math.mod(i, 2) != 0)
            {
                cntTemp.RecordTypeId = recordTypeBusiness;
                cntTemp.CRAN_VEC_ADV_P_PersonType__c = '121';
                cntTemp.CRAN_ICA_ADV_B_EsComercio__c = false;
            }

            else if (Math.mod(i, 2) == 0)
            {
                cntTemp.CRAN_ICA_ADV_B_EsComercio__c = false;
            }

            cntInsertLst.add(cntTemp);
        }

        Insert cntInsertLst;
        return cntInsertLst;
    }

    global static List<Account> createBPBanking()
    {
        List<Account> accInsertLst = new List<Account>();
        Date myDate = Date.newInstance(2016, 1, 1);
        Id recordType = recordTypeIdByDeveloperName(new Account(), 'CRAN_VEC_ADV_Business_Partner');

        List<User> userSearch = [SELECT Id FROM User WHERE EmployeeNumber = '0000'];

        if(userSearch.Size() > 0)
        {
            Id dummy = userSearch[0].Id;

            for(Integer i = 0; i < 200; i++)
            {
                Account accTemp = new Account(
                    CRAN_VEC_ADV_T_BPId__c = '9_599' + i,
                    CRAN_VEC_ADV_D_Open__c = myDate.addDays(i),
                    AccountNumber = '599' + i,
                    Name = '599' + i + ' bp',
                    CRAN_VEC_ADV_T_FullName__c = 'bp PostCopy_' + i,
                    CRAN_VEC_ADV_P_BPType__c = '2',
                    CRAN_VEC_ADV_P_Bunit__c = '9',
                    CRAN_VEC_ADV_P_ReportingCcy__c = 'EUR',
                    CRAN_VEC_ADV_P_DomRefm__c = 'AD',
                    CRAN_VEC_ADV_P_TaxResid__c = 'AD',
                    CRAN_VEC_ADV_P_Language__c = 'ca',
                    CRAN_VEC_ADV_P_Country__c = 'AD',
                    CRAN_VEC_ADV_P_BPPersonType__c = '3',
                    CRAN_VEC_ADV_L_MainMngr__c = dummy,
                    CRAN_VEC_ADV_L_RMOMngr__c = dummy,
                    CRAN_VEC_ADV_N_Number__c = '1008' + i,
                    CRAN_VEC_ADV_P_CustType__c = '8270',
                    CRAN_VEC_ADV_P_Bdivision__c = '6722',
                    CRAN_VEC_ADV_P_CliNature__c = '500450',
                    CRAN_VEC_ADV_P_NatCliSubt__c = '500455',
                    CRAN_VEC_ADV_P_Branch__c = '6320',
                    CRAN_VEC_ADV_P_MngBranch__c = '515885',
                    CRAN_VEC_ADV_P_JointAccType__c = '8191',
                    CRAN_VEC_ADV_P_BPLegalForm__c = '8101',
                    CRAN_VEC_ADV_B_ULK__c = false,
                    FinServ__ClientCategory__c = '508053',
                    CRAN_VEC_ADV_B_BigCliUnit__c = false,
                    CRAN_VEC_ADV_B_CliSBD__c = false,
                    CRAN_VEC_ADV_B_Resident__c = true,
                    CRAN_VEC_ADV_B_AdvAccount__c = false,
                    CRAN_VEC_ADV_B_eCreditAdvised__c = false,
                    CRAN_ICA_KER_P_Oficina__c = '10',
                    CRAN_VEC_ADV_B_ContractSigned__c = false,
                    OwnerId = dummy,
                    CRAN_ICA_KER_P_Identity__c = '101',
                    RecordTypeId = recordType
                );

                accInsertLst.add(accTemp);
            }

            Insert accInsertLst;
            return accInsertLst;
        }

        return null;
    }

    global static void createContainerBanking(List<Account> bp)
    {
        List<FinServ__FinancialAccount__c> faInsertLst = new List<FinServ__FinancialAccount__c>();
        Id recordType = recordTypeIdByDeveloperName(new FinServ__FinancialAccount__c(), 'CRAN_VEC_ADV_Container');
        
        for(Integer i = 0; i < 200; i++)
        {
            FinServ__FinancialAccount__c faTemp = new FinServ__FinancialAccount__c(
                CRAN_VEC_DEV_T_ContainerID__c = '9_876' + i,
                Name = 'Container ' + i,
                CRAN_VEC_DEV_T_FA_FullName__c = 'Container PostCopy_' + i,
                FinServ__PrimaryOwner__c = bp[i].Id,
                CRAN_VEC_ADV_P_Bunit__c = '9',
                CRAN_VEC_ADV_P_RefCcy__c = 'EUR',
                FinServ__FinancialAccountNumber__c = '1047992.' + i,
                CRAN_VEC_ADV_T_OldAccountKey__c = 'T85' + i,
                CRAN_VEC_ADV_P_TypeProd__c = '7101',
                CRAN_VEC_ADV_B_USMktAccess__c = false,
                CRAN_VEC_ADV_P_MngStatus__c = '2501',
                CRAN_ICA_KER_P_Oficina__c = '10',
                CRAN_ICA_KER_P_Identity__c = '101',
                RecordTypeId = recordType
            );

            faInsertLst.add(faTemp);
        }

        Insert faInsertLst;
    }

    global static void createRelBanking(List<Account> bp, List<Contact> person)
    {
        List<FinServ__FinancialAccountRole__c> farInsertLst = new List<FinServ__FinancialAccountRole__c>();
        Id recordType = recordTypeIdByDeveloperName(new FinServ__FinancialAccountRole__c(), 'ContactRole');
        Date myDate = Date.newInstance(2016, 1, 1);

        for(Integer i = 0; i < 200; i++)
        {
            FinServ__FinancialAccountRole__c faTemp = new FinServ__FinancialAccountRole__c(
                FinServ__SourceSystemId__c = '9_968' + i,
                CRAN_VEC_ADV_P_Bunit__c = '9',
                CRAN_VEC_ADV_T_PersonId__c = person[i].CRAN_VEC_ADV_T_PersonId__c,
                FinServ__RelatedContact__c = person[i].Id,
                CRAN_VEC_ADV_T_BPId__c = bp[i].CRAN_VEC_ADV_T_BPId__c,
                FinServ__RelatedAccount__c = bp[i].Id,
                FinServ__Role__c = '1',
                FinServ__StartDate__c = myDate.addDays(i),
                FinServ__EndDate__c = myDate.addDays(i + 38000),
                FinServ__Active__c = true,
                FinServ__Editable__c = true,
                RecordTypeId = recordType
            );

            farInsertLst.add(faTemp);
        }

        Insert farInsertLst;
    }

    global static void createAssetBanking()
    {
        List<FinServ__Securities__c> fsinsertLst = new List<FinServ__Securities__c>();
        Id recordType = recordTypeIdByDeveloperName(new FinServ__Securities__c(), 'CRAN_VEC_ADV_Advisory');

        for(Integer i = 0; i < 200; i++)
        {
            FinServ__Securities__c fsTemp = new FinServ__Securities__c(
                FinServ__SourceSystemId__c = '9_1285' + i,
                CRAN_VEC_ADV_P_AssetCategory__c = '17',
                CRAN_VEC_ADV_T_Abbreviation__c = '0200' + i,
                FinServ__SecuritiesName__c = '0200' + i + ' Security PostCopy_' + i,
                Name = '0200' + i + ' Security PostCopy_' + i,
                CRAN_VEC_ADV_T_FullName__c = 'Security PostCopy_' + i + '(0200' + i + ')',
                CRAN_VEC_ADV_T_Issuer__c = '9_36' + i,
                CRAN_VEC_ADV_P_IssuerDomicile__c = 'AD',
                CRAN_VEC_ADV_P_AssetDomicile__c = 'AD',
                CRAN_VEC_ADV_P_DenomCcy__c = 'EUR',
                CRAN_VEC_ADV_P_RiskCcy__c = 'EUR',
                CRAN_VEC_ADV_P_YieldCcy__c = 'EUR',
                CRAN_VEC_ADV_N_CRANCode__c = '724' + i,
                CRAN_VEC_ADV_P_AQAssetType__c = '2432',
                CRAN_VEC_ADV_P_InstrGroup__c = '8043',
                CRAN_VEC_ADV_P_CatActivo__c = '504788',
                CRAN_VEC_ADV_P_PFMMktCat__c = '504133',
                CRAN_VEC_ADV_P_PFMMktClass__c = '504134',
                CRAN_VEC_ADV_P_PFMMkt__c = '504135',
                RecordTypeId = recordType
            );

            fsinsertLst.add(fsTemp);
        }

        Insert fsinsertLst;
    }

    private static Id recordTypeIdByDeveloperName(SObject auxObject, String recordTypeName) {
        List<Schema.RecordTypeInfo> recordTypes = auxObject.getSObjectType().getDescribe().getRecordTypeInfos();
        for (Schema.RecordTypeInfo recordType : recordTypes) {
            if (recordType.isAvailable() && recordTypeCache.containsKey(recordType.getRecordTypeId()) && recordTypeName == recordTypeCache.get(recordType.getRecordTypeId()).DeveloperName) {
                return recordType.getRecordTypeId();
            }
        }
        return null;
    }

}