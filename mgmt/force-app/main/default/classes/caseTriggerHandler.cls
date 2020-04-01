public class caseTriggerHandler extends TriggerHandlerExt{
    public override void beforeInsert(){
        assignEntitlementToCase((List<Case>)Trigger.new);
        setLinerBrand((List<Case>)Trigger.new);
    }
    
    public override void beforeUpdate(){
        assignEntitlementToCase((List<Case>)Trigger.new);
    }
    
    public static void assignEntitlementToCase(List<Case> caseList){
        Set<Id> contactIds = new Set<Id>();
        Set<Id> acctIds = new Set<Id>();
        for (Case c : caseList) {
            contactIds.add(c.ContactId);
            acctIds.add(c.AccountId);
        }
        System.debug('contactIds==>'+ contactIds);
        System.debug('AccountIds==>'+ acctIds);
        List <EntitlementContact> entlContacts = 
            [Select e.EntitlementId,e.ContactId,e.Entitlement.AssetId 
             From EntitlementContact e
             Where e.ContactId in :contactIds
             And e.Entitlement.EndDate >= Today 
             And e.Entitlement.StartDate <= Today];
        System.debug('contacts==>'+entlContacts );
        if(entlContacts.isEmpty()==false){
            for(Case c : caseList){
                if(c.EntitlementId == null && c.ContactId != null){
                    for(EntitlementContact ec:entlContacts){
                        if(ec.ContactId==c.ContactId){
                            c.EntitlementId = ec.EntitlementId;
                            if(c.AssetId==null && ec.Entitlement.AssetId!=null)
                                c.AssetId=ec.Entitlement.AssetId;
                            break;
                        }
                    } 
                }
            } 
        } else{
            List <Entitlement> entls = [Select e.StartDate, e.Id, e.EndDate, 
                                        e.AccountId, e.AssetId
                                        From Entitlement e
                                        Where e.AccountId in :acctIds And e.EndDate >= Today 
                                        And e.StartDate <= Today];
             System.debug('Entitlement==>'+entls );
            if(entls.isEmpty()==false){
                for(Case c : caseList){
                    if(c.EntitlementId == null && c.AccountId != null){
                        for(Entitlement e:entls){
                            if(e.AccountId==c.AccountId){
                                c.EntitlementId = e.Id;
                                if(c.AssetId==null && e.AssetId!=null)
                                    c.AssetId=e.AssetId;
                                break;
                            }
                        } 
                    }
                } 
            }
        }
    }
    public static void setLinerBrand(List<Case> caseList){
    
    Map<Id,String> mapGroupIdWithLinerBrand = new Map<Id,String>();
        for(group grp :[select Id,name from Group where  Type = 'Queue' AND NAME IN('LiquorServiceCenter' ,'RetailServiceCenter','WholesaleServiceCenter')]){
            mapGroupIdWithLinerBrand.put(grp.id,grp.name);
        }
        System.debug('map==>'+ mapGroupIdWithLinerBrand);
        
        for(case cc : caseList){
            if(mapGroupIdWithLinerBrand.containsKey(cc.ownerid)){
                if(mapGroupIdWithLinerBrand.get(cc.ownerid) == 'LiquorServiceCenter'){
                    cc.Liner_brand__c ='Liquor';
                }
                 if(mapGroupIdWithLinerBrand.get(cc.ownerid) == 'RetailServiceCenter'){
                    cc.Liner_brand__c ='Retail';
                }
                if(mapGroupIdWithLinerBrand.get(cc.ownerid) == 'WholesaleServiceCenter'){
                    cc.Liner_brand__c ='Wholesale';
                }
            }
            system.debug('liner brand===>' + cc.Liner_brand__c);
        }
        
    }
}