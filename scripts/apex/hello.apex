// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<case> caselist = [select id from case];
delete caselist;

List<entitlement> lstentitle = [SELECT id from entitlement ];
delete lstentitle;

List<contact> contactList = [select id from contact];
delete contactList;

List<Account> accountList = [select id from Account];
delete accountList;