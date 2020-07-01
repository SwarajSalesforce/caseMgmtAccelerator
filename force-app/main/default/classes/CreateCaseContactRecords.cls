public without sharing class CreateCaseContactRecords 
{

    @AuraEnabled
    public static void createCaseRecordOnSubmit(Contact conObj,Case caseObj, String fileName, String base64Data) 
    {
        string cFirstName = conObj.FirstName;
        String cLastName = conObj.LastName;
        String cEmail = conObj.Email;
        System.debug('contact => '+conObj);
        System.debug('contact FirstName=> '+conObj.FirstName);
        System.debug('contact LastName=> '+conObj.LastName);
        System.debug('contact LastName=> '+conObj.Email);

        System.debug('case => '+caseObj);
        System.debug('Case Subject=> '+caseObj.Subject);

       List<Contact> conList = [SELECT id from Contact where  FirstName = : cFirstName and LastName = :cLastName and Email = :cEmail LIMIT 1];
        Contact getConObj  = new Contact ();
        if( !conList.isEmpty())
        {
            getConObj = conList[0];
            System.debug('Existing Contact=' + getConObj);
           
        } 
        else
         {
             if( String.isNotBlank(conObj.FirstName) && String.isNotBlank(conObj.LastName) && String.isNotBlank(caseObj.Liner_brand__c))
             {
                getConObj.FirstName = conObj.FirstName;
                getConObj.LastName = conObj.LastName;
                getConObj.Email = conObj.Email;
                getConObj.Preferred_Notification_Channel__c = 'Email';
                getConObj.Country__c = 'Australia';
                getConObj.Brand__c = caseObj.Liner_brand__c;
                insert getConObj;
             }          
        
         }  
         if( getConObj != null)
         {
             Case newCaseObj = new Case();
             newCaseObj.Subject =caseObj.Subject;
             newCaseObj.Liner_brand__c = caseObj.Liner_brand__c;
             newCaseObj.Product__c = caseObj.Product__c;
             newCaseObj.Description = caseObj.Description;
             newCaseObj.ContactId = getConObj.id;
             insert newCaseObj;
             System.debug('Case created:'+newCaseObj.id);
             if(fileName!=null){
                System.debug('file Contents:'+base64Data);
                base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');        
                ContentVersion v = new ContentVersion();
                v.versionData = EncodingUtil.base64Decode(base64Data);
                v.title = fileName;
                v.pathOnClient ='/'+fileName;
                v.FirstPublishLocationId = newCaseObj.id;
                insert v;
                System.debug('Content created:'+v.id);
             }            
         }  
        
    }
    
}