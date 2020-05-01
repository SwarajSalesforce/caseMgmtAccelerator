Global class SkillsBasedRouting {
    @InvocableMethod
    public static void routeUsingSkills(List<String> cases) {
        List<Case> caseObjects = [SELECT Id, Liner_brand__c FROM Case WHERE Id in :cases];
        for (Case caseObj : caseObjects) {
            try {
                // Create a PendingServiceRouting to initiate routing
                createPendingServiceRouting(caseObj);
            } catch(exception e) {
                System.debug('ERROR:' + e.getStackTraceString());
                throw e;
            }
        }
    }
    
    static void createPendingServiceRouting(Case caseObj) {
        // Create a new SkillsBased PendingServiceRouting
        PendingServiceRouting psrObj = new PendingServiceRouting(
            CapacityWeight = 1,
            IsReadyForRouting = FALSE,
            RoutingModel  = 'MostAvailable',
            RoutingPriority = 1,
            RoutingType = 'SkillsBased',
            ServiceChannelId = getChannelId(),
            WorkItemId = caseObj.Id,
            PushTimeout = 0
        );
        insert psrObj;
        psrObj = [select id, IsReadyForRouting from PendingServiceRouting where id = : psrObj.id];
        
        // Now add SkillRequirement(s) to the PendingServiceRouting
        SkillRequirement srObj = new SkillRequirement(
            RelatedRecordId = psrObj.id,
            SkillId = getSkillId(caseObj.Liner_brand__c),
            SkillLevel = 5
        );
        insert srObj;
        
        // Update PendingServiceRouting as IsReadyForRouting
        psrObj.IsReadyForRouting = TRUE;
        update psrObj; 
    }
    
    static String getChannelId() {
        ServiceChannel channel = [Select Id From ServiceChannel Where RelatedEntity = 'Case'];
        return channel.Id;
    }
    
    static String getSkillId(String linerBrand) {
        String skillName = 'Wholesale';
        if (linerBrand != null) {
            if (linerBrand.contains('Liquor')) {
                skillName = 'Liquor';
            } else if (linerBrand.contains('Retail')) {
                skillName = 'Retail';
            }
        }
        
        Skill skill = [Select Id From Skill Where DeveloperName = :skillName];
        System.debug('SKill name'+ skillName);
        return skill.Id;
    }
}