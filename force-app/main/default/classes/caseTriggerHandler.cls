public class caseTriggerHandler extends TriggerHandlerExt {
    public override void beforeInsert() {
        assignEntitlementToCase((List < Case > ) Trigger.new);
        setLinerBrand((List < Case > ) Trigger.new);
        getStoreName((List < Case > ) Trigger.new);
    }

    public override void beforeUpdate() {
        assignEntitlementToCase((List < Case > ) Trigger.new);
    }

    public override void afterInsert() {
        getProducts((List < Case > ) Trigger.new);
    }
    public static void assignEntitlementToCase(List < Case > caseList) {
        Set < Id > contactIds = new Set < Id > ();
        Set < Id > acctIds = new Set < Id > ();
        for (Case c: caseList) {
            contactIds.add(c.ContactId);
            acctIds.add(c.AccountId);
        }
        System.debug('contactIds==>' + contactIds);
        System.debug('AccountIds==>' + acctIds);
        List < EntitlementContact > entlContacts = [Select e.EntitlementId, e.ContactId, e.Entitlement.AssetId
            From EntitlementContact e
            Where e.ContactId in: contactIds
            And e.Entitlement.EndDate >= Today
            And e.Entitlement.StartDate <= Today
        ];
        System.debug('contacts==>' + entlContacts);
        if (entlContacts.isEmpty() == false) {
            for (Case c: caseList) {
                if (c.EntitlementId == null && c.ContactId != null) {
                    for (EntitlementContact ec: entlContacts) {
                        if (ec.ContactId == c.ContactId) {
                            c.EntitlementId = ec.EntitlementId;
                            if (c.AssetId == null && ec.Entitlement.AssetId != null)
                                c.AssetId = ec.Entitlement.AssetId;
                            break;
                        }
                    }
                }
            }
        } else {
            List < Entitlement > entls = [Select e.StartDate, e.Id, e.EndDate,
                e.AccountId, e.AssetId
                From Entitlement e
                Where e.AccountId in: acctIds And e.EndDate >= Today
                And e.StartDate <= Today
            ];
            System.debug('Entitlement==>' + entls);
            if (entls.isEmpty() == false) {
                for (Case c: caseList) {
                    if (c.EntitlementId == null && c.AccountId != null) {
                        for (Entitlement e: entls) {
                            if (e.AccountId == c.AccountId) {
                                c.EntitlementId = e.Id;
                                if (c.AssetId == null && e.AssetId != null)
                                    c.AssetId = e.AssetId;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    public static void setLinerBrand(List < Case > caseList) {

        Map < Id, String > mapGroupIdWithLinerBrand = new Map < Id, String > ();
        for (group grp: [select Id, name from Group where Type = 'Queue'
                AND NAME IN('LiquorServiceCenter', 'SuperMarketQueue', 'WholesaleServiceCenter')
            ]) {
            mapGroupIdWithLinerBrand.put(grp.id, grp.name);
        }
        for (
            case cc: caseList) {
            if (mapGroupIdWithLinerBrand.containsKey(cc.ownerid)) {
                if (mapGroupIdWithLinerBrand.get(cc.ownerid) == 'LiquorServiceCenter') {
                    cc.Liner_brand__c = 'Liquor Retail';
                }
                if (mapGroupIdWithLinerBrand.get(cc.ownerid) == 'SuperMarketQueue') {
                    cc.Liner_brand__c = 'Supermarkets';
                }
                if (mapGroupIdWithLinerBrand.get(cc.ownerid) == 'WholesaleServiceCenter') {
                    cc.Liner_brand__c = 'Wholesale';
                }
            }
        }

    }

    public static void getStoreName(List < Case > caseList) {
        String keywordStore = 'store - ';
        for (Case c: caseList) {
            String storeName = findLine(c, keywordStore);
            if(storeName!=''){
             	List < Store__c > storeId = [SELECT ID, Name FROM Store__c WHERE Name =: storeName];
            	if (storeId.size() > 0) {
                	System.debug('found the store having ID ' + storeId[0].ID);
                	c.Coles_Store__c = storeId[0].ID;
            	}   
            }            
        }
    }

    public static void getProducts(List < Case > caseList) {
        String keywordProd = 'product - ';
        for (Case c: caseList) {
            String prodName = findLine(c, keywordProd);
            if(prodName!=''){
             	List < Product2 > productId = [SELECT ID, Name FROM Product2 WHERE Name =: prodName];
            	Complaint_Product__c cmp = new Complaint_Product__c();
            	if (productId.size() > 0) {
                	System.debug('found the product having ID ' + productId[0].ID);
                    cmp.Product__c = productId[0].ID;
                    cmp.Complaint__c = c.Id;
                    insert cmp;
            	}            	
            }            
        }
    }

    public static String findLine(Case c, String keyword) {
        String emailBody = c.Description;
        if (c.Origin == 'Email' && emailBody.containsIgnoreCase(keyword)) {
            List < String > lines = emailBody.split('\\r?\\n');
            for (String eachLine: lines) {
                Integer result = eachLine.indexOfIgnoreCase(keyword);
                if (result > -1) {
                    System.debug(keyword + ' keyword found at position ' + result + ' of line->' + eachLine);
                    System.debug(keyword + ' Name is ' + eachLine.substringAfter('- '));
                    return eachLine.substringAfter('- ');
                }
            }
        }
        return '';
    }

}