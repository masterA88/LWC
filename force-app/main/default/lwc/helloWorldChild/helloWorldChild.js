import { LightningElement, api } from 'lwc';

export default class HelloWorldChild extends LightningElement {
    @api message;
    @api greeting;
}
