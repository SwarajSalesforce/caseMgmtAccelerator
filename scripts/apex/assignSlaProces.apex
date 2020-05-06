
Id businessid = [SELECT Id FROM BusinessHours where Name IN('Australia')].Id;
Id slaid =[SELECT BusinessHoursId ,Name,SobjectType FROM SlaProcess Where Name='Wholesale Support'][0].Id;
List<entitlement> entitleList = [Select id,BusinessHoursId ,slaprocessid from entitlement];
for(entitlement entitle : entitleList){
    entitle.BusinessHoursId  = businessid;
    entitle.slaprocessid = slaid;
}

update entitleList;