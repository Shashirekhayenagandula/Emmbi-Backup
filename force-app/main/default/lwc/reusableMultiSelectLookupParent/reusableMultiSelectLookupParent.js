import { LightningElement } from 'lwc';

export default class ReusableMultiSelectLookupParent extends LightningElement {
   SelectedRecord;
   handleValueSelected(event) {
        this.SelectedRecords = event.detail;  
    }
}