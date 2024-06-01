import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import processData from '@salesforce/apex/MyDataProcessor.processData';

export default class MyFileUploader extends NavigationMixin(LightningElement) {
    @track file;

    handleFilesChange(event) {
        this.file = event.target.files[0];
    }

    handleUpload() {
        if (this.file) {
            let reader = new FileReader();
            reader.onload = () => {
                let csv = reader.result;
                let csvRows = csv.split('\n').map(row => row.split(','));
                processData({ csvData: csvRows })
                    .then(() => {
                        this.showNotification('Success', 'File processed successfully', 'success');
                        this.navigateToContactsPage();
                    })
                    .catch(error => {
                        this.showNotification('Error', 'Error processing file: ' + error.body.message, 'error');
                    });
            };
            reader.onerror = () => {
                this.showNotification('Error', 'File could not be read', 'error');
            };
            reader.readAsText(this.file);
        } else {
            this.showNotification('Error', 'No file selected', 'error');
        }
    }

    navigateToContactsPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'home'
            }
        });
    }

    showNotification(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }
}
