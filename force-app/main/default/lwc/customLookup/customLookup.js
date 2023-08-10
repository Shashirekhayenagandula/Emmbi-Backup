import search from '@salesforce/apex/customLookupController.search';
import { api, LightningElement, track, wire } from 'lwc';


export default class customLookUp extends LightningElement 
{
    @api objName; 
    @api objIndex;  
    @api objType;
    @api objCol;
    @api selectedCol;
    @api selectedObjType;  
    @api iconName;
    @api searchPlaceholder='Search';

    @track selectedName;
    @track selectId;
    @track records;
    @track isValueSelected;
    @track blurTimeout;
    @track recName = false;
    @track recCaseNumber = false;
    @track recInvoiceNumber = false;
    @track searchTerm;

    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';

  
    @wire(search, {searchTerm : '$searchTerm', myObject : '$objName'})
    wiredRecords({ error, data }) {
        if (data) {           
            this.error = undefined;
            console.log('data -->'+JSON.stringify(data)); 
            if(this.objType == this.selectedObjType && this.objCol == this.selectedCol)
            {
                this.records = data;
                console.log('objCol' + this.objCol);             
            }
            else
            {
                this.records = '';
            }
            
        for(let i = 0; i < this.records.length; i++) 
        {          
            if(this.records[i].Name !== undefined) 
            {
               this.recName = true;
               this.recCaseNumber = false;
               this.recInvoiceNumber = false;
            }
            else
            {
                if(this.objName == 'Case')
                {                   
                    this.selectedName = this.records[i].CaseNumber;
                    this.recName = false;
                    this.recCaseNumber = true;
                    this.recInvoiceNumber = false;
                } 
                else if(this.objName == 'Invoice')   
                {
                    this.selectedName = this.records[i].InvoiceNumber;
                    this.recName = false;
                    this.recCaseNumber = false;
                    this.recInvoiceNumber = true;
                }          
            }
        }

        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
          
    }
    handleClick() {
        this.searchTerm = '';
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }

    onBlur() {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }

    onSelect(event) {
        this.searchTerm = '';
        let selectedId = event.currentTarget.dataset.id;
        this.selectId = selectedId;   

        this.isValueSelected = true;

        let selectedName = event.currentTarget.dataset.name;
        this.selectedName = selectedName;

        const valueSelectedEvent = new CustomEvent('lookupselected', {detail: {selectedId : selectedId, selectedName : selectedName}});
        this.dispatchEvent(valueSelectedEvent);
        if(this.blurTimeout) {
        clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }

    handleRemovePill() 
    {
        this.searchTerm = '';
        this.isValueSelected = false;

       const valueSelectedEvent = new CustomEvent('lookupselected', { detail: {objIndex: this.objIndex} });
       this.dispatchEvent(valueSelectedEvent); 

    }

    onChange(event) {
        this.searchTerm = event.target.value;
    }

}