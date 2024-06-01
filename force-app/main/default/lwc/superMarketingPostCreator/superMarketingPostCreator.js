import { LightningElement, track, api } from 'lwc';
import postToTwitter from '@salesforce/apex/ChatGPTService.postToTwitter';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SuperMarketingPostCreator extends LightningElement {
    @track recordId = '';
    @track topic = '';

    handleInput(event) {
        const field = event.target.name;
        if (field === "recordId") {
            this.recordId = event.target.value;
        } else if (field === "topic") {
            this.topic = event.target.value;
        }
    }

    generatePost() {
        // Trim the input values to remove any leading/trailing whitespace
        const trimmedRecordId = this.recordId.trim();
        const trimmedTopic = this.topic.trim();

        if (trimmedRecordId && trimmedTopic) {
            postToTwitter({ recordId: trimmedRecordId, topic: trimmedTopic })
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'The Twitter post has been generated successfully!',
                            variant: 'success'
                        })
                    );
                })
                .catch(error => {
                    // Handle any errors that occur during the callout
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error generating post',
                            message: error.body ? error.body.message : 'Unknown error',
                            variant: 'error'
                        })
                    );
                });
        } else {
            // Display an error toast if either field is blank after trimming
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please fill in both Record ID and Topic fields.',
                    variant: 'error'
                })
            );
        }
    }
}
