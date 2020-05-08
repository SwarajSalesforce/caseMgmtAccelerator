public with sharing class Bot_GetCaseStatus {
    public Bot_GetCaseStatus() {
        System.debug('Inside constructor');
    }
    public class CaseInput{
        @InvocableVariable(required=true)
        public String sCaseNumber;
    }
    public class CaseOutput{
        @InvocableVariable(required=true)
        public String sCaseStatus;
    }
    @InvocableMethod(label='Get Case Status')
    public static List<CaseOutput> getCaseStatus(List<CaseInput> caseInputs) {
    Set<String> caseNumbers = new Set<String>(); 

    // Get the order numbers from the input
    for (CaseInput caseInput : caseInputs) {
        caseNumbers.add(caseInput.sCaseNumber);
    }

    // Get the order objects from the set of order numbers
    List<Case> cases = 
      [SELECT CaseNumber, Status FROM Case where CaseNumber in :caseNumbers];
      
    // Create a map of order numbers and order status values
    Map<String, String> mapNameStatus = new Map<String, String>(); 
    if (cases.size() > 0) {
        for (Case caseRecord : cases) {
             mapNameStatus.put(caseRecord.CaseNumber, caseRecord.Status);
        }
    }
    
    // Build a list of order status values for the output
    List<CaseOutput> caseOutputs = new List<CaseOutput>();
    for (CaseInput caseInput : caseInputs) {
      caseOutput caseOutput = new CaseOutput();
      
      // Do we have a status for this order number?
      if (mapNameStatus.containsKey(caseInput.sCaseNumber)) {
          // If so, then add the status
          caseOutput.sCaseStatus = mapNameStatus.get(caseInput.sCaseNumber);
      } else {
          // If not, then add an unknown status value
          caseOutput.sCaseStatus = 'Case not found';
      }
      caseOutputs.add(caseOutput);
    }

    return caseOutputs;    
  }

}
