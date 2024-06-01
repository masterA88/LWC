import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LeadForm extends LightningElement {
    @track firstName = '';
    @track lastName = '';
    @track company = '';
    @track email = '';
    @track phone = '';
    @track title = '';
    @track street = '';
    @track city = '';
    @track state = '';
    @track country = '';
    @track zip = '';

    handleInputChange(event) {
        const field = event.target.dataset.field;
        this[field] = event.target.value;
    }

    submitForm() {
        const fields = {
            FirstName: this.firstName,
            LastName: this.lastName,
            Company: this.company,
            Email: this.email,
            Phone: this.phone,
            Title: this.title,
            Street__c: this.street, // Custom field
            City__c: this.city,     // Custom field
            State__c: this.state,   // Custom field
            Country__c: this.country, // Custom field
            PostalCode__c: this.zip  // Custom field
        };

        const recordInput = { apiName: LEAD_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Lead created successfully',
                        variant: 'success',
                    }),
                );
                this.clearForm();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }

    clearForm() {
        this.firstName = '';
        this.lastName = '';
        this.company = '';
        this.email = '';
        this.phone = '';
        this.title = '';
        this.street = '';
        this.city = '';
        this.state = '';
        this.country = '';
        this.zip = '';
    }
}
