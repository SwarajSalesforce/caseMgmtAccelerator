window._snapinsSnippetSettingsFile = (function() {
console.log("Snippet settings file loaded.");	// Logs that the snippet settings file was loaded successfully

embedded_svc.snippetSettingsFile.extraPrechatInfo = [{
  "entityName": "Account",
  "linkToEntityName": "Contact",
  "linkToEntityField": "AccountId",
  "entityFieldMaps": [{
    "isExactMatch": true,
    "fieldName": "Name",
    "doCreate": true,
    "doFind": true,
    "label": "Last Name"
  }]
}];

})();