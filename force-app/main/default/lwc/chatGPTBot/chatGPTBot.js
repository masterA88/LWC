import { LightningElement, track } from 'lwc';
import sendImageToChatGPT from '@salesforce/apex/ChatGPTImageService.sendImageToChatGPT';

export default class ChatGPTImageBot extends LightningElement {
    @track imagePreview;
    @track userMessage = '';
    @track chatGPTResponse = '';

    handleImageUpload(event) {
        const file = event.target.files[0];
        if (file) {
            let reader = new FileReader();
            reader.onload = () => {
                this.imagePreview = reader.result;
            };
            reader.readAsDataURL(file);
        }
    }

    handleMessageChange(event) {
        this.userMessage = event.target.value;
    }

    sendRequest() {
        const base64String = this.imagePreview ? this.imagePreview.split(',')[1] : null;
        sendImageToChatGPT({ base64String: base64String, messageText: this.userMessage })
            .then(response => {
                this.chatGPTResponse = response;
                // Additional logic to handle the response
            })
            .catch(error => {
                console.error('Error:', error);
                this.chatGPTResponse = 'Error in processing your request';
            });
    }
}
