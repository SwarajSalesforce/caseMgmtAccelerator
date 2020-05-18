// wireGetRecordDynamicContact.js
import { LightningElement, api, wire } from 'lwc';
import getContactDetails from '@salesforce/apex/LWC_GetContactDetails.getContactDetails';


export default class WireGetRecordDynamicContact extends LightningElement {
    @api recordId; 
    @wire(getContactDetails, {caseId : '$recordId' })
    contact;
    
}