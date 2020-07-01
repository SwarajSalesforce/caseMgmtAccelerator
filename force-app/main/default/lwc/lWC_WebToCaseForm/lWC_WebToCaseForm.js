import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import createCaseRecordOnSubmit from '@salesforce/apex/CreateCaseContactRecords.createCaseRecordOnSubmit';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import CASE_OBJECT from '@salesforce/schema/Case';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CaseCreator extends NavigationMixin(LightningElement)
{
    contactRecord = {FirstName:'',LastName:'',Email:''};
    //caseRecord = {subject:'',Liner_brand__c:'',Product__c:'',description:''};
    caseRecord = {};
    MAX_FILE_SIZE = 5 * 1024 * 1024; //Max file size 5.0 MB
    filesUploaded = [];
    file;
    fileName
    fileContents;
    fileReader;
    content;
    fileAttached=false;
    fileError='';
    
    handleFieldChange(e)
     {
        if(e.currentTarget.name === 'FirstName' || e.currentTarget.name === 'LastName' || e.currentTarget.name === 'Email')
        {
            this.contactRecord[e.currentTarget.name] = e.target.value;
            console.log('contact :',JSON.stringify(this.contactRecord));
        }
       /* else if(e.currentTarget.name === 'subject' || e.currentTarget.name === 'Liner_brand__c' || e.currentTarget.name === 'Product__c' || e.currentTarget.name === 'description'){
            this.caseRecord[e.currentTarget.name] = e.target.value;
            console.log('case :',JSON.stringify(this.caseRecord));
        }*/
        else
        {
            this.caseRecord[e.currentTarget.fieldName] = e.target.value;
            console.log('case :',JSON.stringify(this.caseRecord));
        }
    }

    handleFileUploaded(event) {
        if (event.target.files.length > 0) {
            this.fileAttached=true;
            this.fileError ='';
            this.filesUploaded = event.target.files;           
            this.fileName = event.target.files[0].name;
            this.file = this.filesUploaded[0];     
            console.log('fileName:filesize', this.fileName,this.file.size);       
            if (this.file.size > this.MAX_FILE_SIZE) {
                this.fileError = 'File Size is too long. File size should be less then 5MB';
                this.fileAttached=false;
            }         
        }
    }
    
    saveForm()
    {                  
            if(this.fileAttached){
                this.fileReader = new FileReader();
                this.fileReader.onloadend = (() => {
                    this.fileContents = this.fileReader.result;
                    console.log('file',this.fileContents);
                    let base64 = 'base64,';
                    this.content = this.fileContents.indexOf(base64) + base64.length;
                    this.fileContents = this.fileContents.substring(this.content);
                    this.createCase();
                });this.fileReader.readAsDataURL(this.file); 
            }else{
                this.fileName=null;
                this.fileContents=null;
                this.createCase();
            }                       
      
    }
    
    createCase(){
        console.log('contact :',JSON.stringify(this.contactRecord));
        console.log('case :',JSON.stringify(this.caseRecord));
        console.log('fileContents:',this.fileContents);
        console.log('fileName:',this.fileName);
        createCaseRecordOnSubmit({ conObj: { ...this.contactRecord, sobjectType: CONTACT_OBJECT.objectApiName },caseObj: { ...this.caseRecord, sobjectType: CASE_OBJECT.objectApiName },fileName: this.fileName,base64Data: encodeURIComponent(this.fileContents) })
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