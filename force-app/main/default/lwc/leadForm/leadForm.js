import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LeadForm extends LightningElement {
    firstName = '';
    lastName = '';
    company = '';
    email = '';
    phone = '';
    title = '';
    street = ''; // Assuming it's a custom field
    city = '';   // Assuming it's a custom field
    state = '';  // Assuming it's a custom field
    country = ''; // Assuming it's a custom field
    zip = '';    // Assuming it's a custom field

    handleInputChange(event) {
        this[event.target.dataset.field] = event.target.value;
    }

    submitForm() {
        console.log('Submitting form with the following details:', { // Debugging: Log the form details
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
        });

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
                console.log('Lead creation successful.'); // Debugging: Log success message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Lead created',
                        variant: 'success',
                    })
                );
                this.clearForm();
            })
            .catch(error => {
                console.error('Error creating lead:', error); // Debugging: Log error details
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error',
                    })
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
