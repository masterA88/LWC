import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import RATING_FIELD from '@salesforce/schema/Account.Rating';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';

export default class LwcUiRecordApi extends LightningElement {
    accName;
    accIndustryPicklist; accRatingPicklist;
    selectedRating; selectedIndustry;

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accObjectInfo;

    @wire(getPicklistValuesByRecordType, {
        objectApiName: ACCOUNT_OBJECT,
        recordTypeId: '012000000000000AAA' // Replace with your actual record type ID
    })
    accAllPicklistValues({data, error}){
        if(data){
            this.accIndustryPicklist = data.picklistFieldValues.Industry.values;
            this.accRatingPicklist = data.picklistFieldValues.Rating.values;
        } else {
            console.error(error);
        }
    }

    picklistHandleChange(event){
        const { name, value } = event.detail;
        if(name === 'rating'){
            this.selectedRating = value;
        } else if(name === 'industry'){
            this.selectedIndustry = value;
        }
    }

    handleInput(event){
        this.accName = event.target.value;
    }

    createAccount(){
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.accName;
        fields[RATING_FIELD.fieldApiName] = this.selectedRating;
        fields[INDUSTRY_FIELD.fieldApiName] = this.selectedIndustry;

        const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };
        createRecord(recordInput)
        .then((accId) => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Account created with id ' + accId.id,
                variant: 'success'
            }));
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error creating record',
                message: error.body.message,
                variant: 'error'
            }));
        });
    }
}
