import { LightningElement, wire, track, api } from 'lwc';
import getPublicTransportData from '@salesforce/apex/TransportDataController.getPublicTransportData';

export default class PublicTransportData extends LightningElement {
    @track datasets = [];
    @track error;
    @api recordId; // Only if needed, for use on record pages
    @api resourceName; // If you need to pass a specific resource name to your Apex controller

    @wire(getPublicTransportData)
    wiredData({ error, data }) {
        if (data) {
            // Append a unique key to each dataset item
            this.datasets = data.map((item, index) => ({
                ...item,
                _uniqueKey: `${item.name}_${index}` // Creating a unique key
            }));
            this.error = undefined;
        } else if (error) {
            console.error('Error:', error);
            this.error = error;
            this.datasets = undefined;
        }
    }
}
