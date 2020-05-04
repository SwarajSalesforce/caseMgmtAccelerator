public with sharing class gaugeChartController {
    getCaseData(){
        return case;
    }
    public gaugeChartController() {
        
    }
    @AuraEnabled(cacheable=true)
    public static List<Case> getCaseData(String currentRecordId) {
        return [select Liner_brand__c, Priority, Time_remaining_to_close__c from Case where id =: '5002w0000046kl0AAA'];
    }
}