import { LightningElement, track } from 'lwc';

export default class DateForm extends LightningElement {
    @track dateValue = '';  // Tracks the value of the date input
    @track dayOfWeek = '';  // Tracks the day of the week
    @track errorMessage = '';  // Tracks the error message for validation

    handleDateChange(event) {
        this.dateValue = event.target.value;
        console.log('Date changed to:', this.dateValue); // Added for debugging
        this.updateDayOfWeek();
        this.validateDate();
    }

    updateDayOfWeek() {
        if (this.dateValue) {
            const inputDate = new Date(this.dateValue);
            const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
            this.dayOfWeek = days[inputDate.getDay()];
        } else {
            this.dayOfWeek = '';
        }
    }

    validateDate() {
        this.errorMessage = '';  // Reset the error message

        if (!this.dateValue) {
            this.errorMessage = 'Date is required.';
            console.log('Validation error:', this.errorMessage); // Added for debugging
            return false;
        }

        // Add any additional validation logic here

        return true;
    }

    handleSubmit() {
        console.log('Submit button clicked'); // Added for debugging

        if (this.validateDate()) {
            console.log('Form submitted with date:', this.dateValue, 'and day:', this.dayOfWeek);

            // Additional form submission logic goes here
        } else {
            console.log('Form submission blocked due to validation error'); // Added for debugging
        }
    }
}
