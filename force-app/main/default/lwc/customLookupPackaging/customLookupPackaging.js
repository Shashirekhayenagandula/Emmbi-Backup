import { LightningElement,api,track,wire } from 'lwc';
export default class CustomLookupPackaging extends LightningElement {
    @api label;
    @api placeholder;
    @api options;
    @api selectedValue;
    @api isRecent = false; // Add this attribute

    handleSelection(event) {
        this.selectedValue = event.detail.value;
        const selectEvent = new CustomEvent('selection', {
            detail: this.selectedValue
        });
        this.dispatchEvent(selectEvent);
    }

    // Handle the click event on the input field
    handleInputClick() {
        // Toggle the isRecent flag when the input field is clicked
        this.isRecent = !this.isRecent;
        // Dispatch an event to notify the parent component about the isRecent flag change
        const toggleEvent = new CustomEvent('toggleclick', {
            detail: this.isRecent
        });
        this.dispatchEvent(toggleEvent);
    }

}