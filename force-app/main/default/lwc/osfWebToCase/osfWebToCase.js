import { LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getCases from '@salesforce/apex/OSF_CaseController.getCases';
import getCustomFields from '@salesforce/apex/OSF_CaseController.getCustomFields';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OsfWebToCase extends LightningElement {
    @track userId = Id;
    @track error;
    @track customFields;

  
    cases;
    caseColumns = [
      { label: 'Case Id', fieldName: 'Id'},
      { label: 'Case Number', fieldName: 'CaseNumber' },
      { label: 'Origin', fieldName: 'Origin' },
      { label: 'Status', fieldName: 'Status' },
    ];
  
    handleLoadCases() {
  
        getCases({ ownerId: this.userId })
            .then(result => {
                this.cases = result;
                this.error = undefined;
                console.log('cases: ' + JSON.stringify(this.cases));                
            })
            .catch(error => {
                this.cases = undefined;
                this.error = error;
            });
          
    }
  
    @wire(getCustomFields)
    wireCustomFields({ error, data }) {
        if (data) {                   
            this.customFields = data;
            this.error = undefined;
            console.log('customFields: ' + JSON.stringify(this.customFields));
        } else if ( error ) {
            this.customFields = undefined;
            this.error = error;
        }      
    };

    caseId;
    handleCaseCreated(event) {
        this.caseId = event.detail.id;
        console.log('Created Case Id: ' + this.caseId);
        if(this.caseId !== null) {
            this.dispatchEvent(new ShowToastEvent({
                    title: "SUCCESS! ",
                    message: "Recod with Id="+ this.caseId +" has been saved.",
                    variant: "success",
                }),
             );
                
        }        
    }     

    handleCaseCreatedError(event) {
        console.log('Case Created Error: ' + event.detail.error);
    }

    handleSubmit(event) {
        /*
        alert('hello');
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        alert(JSON.stringify(fields));
        console.log(fields);
        this.template.querySelector('lightning-record-edit-form').submit(fields);
        */
     }    
}