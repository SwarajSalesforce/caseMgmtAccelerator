import { LightningElement } from 'lwc';
import CASE_OBJECT from '@salesforce/schema/Case';
import CONTACT from '@salesforce/schema/Case.ContactId';
import SUBJECT from '@salesforce/schema/Case.Subject';
import BRAND from '@salesforce/schema/Case.Liner_brand__c';
import PRODUCT from '@salesforce/schema/Case.Product__c';
import DESCRIPTION from '@salesforce/schema/Case.Description';
import PRIORITY from '@salesforce/schema/Case.Priority';
import CASETYPE from '@salesforce/schema/Case.Case_Type__c';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
/**
 * Creates Account records.
 */
export default class CaseCreator extends NavigationMixin(LightningElement){

    caseObject = CASE_OBJECT;
    myFields = [CONTACT, SUBJECT, BRAND, PRODUCT, DESCRIPTION, PRIORITY, CASETYPE ];

    handleCaseCreated(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'successpage'
            }
        },
        true
      );
 }
}