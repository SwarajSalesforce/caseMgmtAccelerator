public class gaugePageController {
    public String currentRecordId {get;set;}
    public String parameterValue {get;set;}
    public Case caseData{get;set;}
 
    public gaugePageController(ApexPages.StandardController controller) {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
         caseData = [select Liner_brand__c ,	Priority, 	Time_remaining_to_close__c from Case where id =: currentRecordId ];
        parameterValue = ApexPages.CurrentPage().getparameters().get('nameParam');
    }
}