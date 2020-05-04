// wireGetRecordDynamicContact.js
import { LightningElement, api, wire } from 'lwc';
import { getRecord,getFieldValue } from 'lightning/uiRecordApi';
import CONTACT_FIELD from  '@salesforce/schema/Case.ContactId';
const FIELDS = [
    CONTACT_FIELD
];

export default class WireGetRecordDynamicContact extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: CONTACT_FIELD })
    case;

    get contactId() {
        return getFieldValue(this.case.data, FIELDS);
    }
    get hasCaseData() {
        return this.case && this.case.data;
    }

}