public with sharing class LWC_GetContactDetails {
    public LWC_GetContactDetails() {
        System.debug('Inside Constructor');
    }
    @AuraEnabled(cacheable=true)
    public static Contact getContactDetails(Id caseId){
        Id contactId = [Select contactId from case where id=:caseId].contactId;
        return [
            SELECT Id,Name,Title,Phone,Email 
            FROM Contact
            WHERE Id=:contactId 
            WITH SECURITY_ENFORCED LIMIT 1];
    }

}
