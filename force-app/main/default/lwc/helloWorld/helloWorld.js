import { LightningElement, track } from 'lwc';

export default class HelloWorld extends LightningElement {
    greetingMessage = 'World';
 
    changeHandler(event) {
        this.greetingMessage = event.target.value;
    }
}