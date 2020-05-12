public with sharing class Bot_CreateCaseCommunity {
    public Bot_CreateCaseCommunity() {
        System.debug('Inside Constructor');
    }
    public class CaseInput{
        @InvocableVariable(required=true)
        public String contactId;
        @InvocableVariable(required=true)
        public String linearBrand;
        @InvocableVariable(required=true)
        public String subject;
        @InvocableVariable(required=true)
        public String productLine;
        @InvocableVariable(required=true)
        public String description;
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
            newCase.ContactId = caseDetail.contactId;
            newCase.Liner_brand__c = caseDetail.linearBrand;
            newCase.Origin = 'Web';   
            newCase.Product__c = caseDetail.productLine;
            newCase.Subject = caseDetail.subject;
            newCase.Description = caseDetail.description;
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
