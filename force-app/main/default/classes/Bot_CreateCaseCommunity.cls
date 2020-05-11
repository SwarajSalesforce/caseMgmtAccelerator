public with sharing class Bot_CreateCaseCommunity {
    public Bot_CreateCaseCommunity() {
        System.debug('Inside Constructor');
    }
    public class CaseInput{
        @InvocableVariable(required=true)
        public String contactId;
        @InvocableVariable(required=true)
        public String linearBrand;
    }
    public class CaseOutput{
        @InvocableVariable(required=true)
        public String caseNumber;
    }
    @InvocableMethod(label='Create Case')
    public static List<CaseOutput> createCase(List<CaseInput> caseInputs){
        List<Case> caseList = new List<Case>();
        List<CaseOutput> caseOutputList = new List<CaseOutput>();
        for(CaseInput caseDetail : caseInputs){
            case newCase = new case();
            newcase.ContactId = caseDetail.contactId;
            newcase.Liner_brand__c = caseDetail.linearBrand;
            newcase.Origin = 'Web';   
            caseList.add(newCase);
        }
        database.saveresult[] results = database.insert(caseList, false);

        for(Case caseRecord: caseList){
            CaseOutput caseOutputDetail = new CaseOutput();
            caseOutputDetail.caseNumber = caseRecord.CaseNumber;
            caseOutputList.add(caseOutputDetail);
        }
        return caseOutputList;
    }

}
