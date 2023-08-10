import { LightningElement, api , track } from 'lwc';
import fetchRecords from '@salesforce/apex/ReusableMultiSelectLookupController.fetchRecords';
const DELAY = 500;

export default class ReusableMultiSelectLookupChild extends LightningElement {
    @api helpText = "";
    @api label = "";
    @api required;
    @api selectedIconName = "";
    recordsList = [];
    selectedRecordName;
    @api searchByOtherField = false;
    @api objectApiName = "";
    @api fieldApiName = "";
    @api otherFieldApiName = "";
    @api searchString = "";
    @api parentRecordId;
    @api parentFieldApiName;
    @track msg='';
    @track msgBoolean=false;
    preventClosingOfSerachPanel = false;
    isValueSelected = false;

    get methodInput() {
        return {
            objectApiName: this.objectApiName,
            fieldApiName: this.fieldApiName,
            otherFieldApiName: this.otherFieldApiName,
            searchString: this.searchString,
            parentRecordId: this.parentRecordId,
            parentFieldApiName: this.parentFieldApiName,
            searchByOtherField:this.searchByOtherField
        };
    }

    get showRecentRecords() {
        if (!this.recordsList) {
            return false;
        }
        return this.recordsList.length > 0;
    }
    connectedCallback() {
    }

    fetchSobjectRecords(loadEvent) {
        fetchRecords({
            inputWrapper: this.methodInput
        }).then(result => {
            if (result) {
                this.recordsList = JSON.parse(JSON.stringify(result));
            } else {
                this.recordsList = [];
            }
            if(this.recordsList.length < 1){
                this.msgBoolean=true;
                this.msg='No Records Found for \''+this.searchString+'\'';
               
            }
        }).catch(error => {
            console.log(error);
        })
    }

// Added by BV
    handleSaveToApex() {
        apexMethodName({ selectedOptions: this.selectedOptions,objectApiName:this.objectApiName })
            .then(result => {
                // Handle the Apex method response here
                console.log('Apex method response:', result);
            })
            .catch(error => {
                // Handle any errors that occur during the Apex method call
                console.error('Error calling Apex method:', error);
            });
    }
//Ended by BV

    handleChange(event) {
        this.searchString = event.target.value;
        this.fetchSobjectRecords(false);
    }
    handleClick(event) {
        this.searchString = event.target.value;
        this.fetchSobjectRecords(false);
    }
    handleBlur() {
        this.recordsList = [];
        this.msgBoolean=false;
        this.preventClosingOfSerachPanel = false;
    }
    // handleDivClick() {
    //     this.msgBoolean=false;
    //     this.preventClosingOfSerachPanel = true;
    // }
    handleCommit(event) {
        let index = event.target.dataset.id;
        this.selectedOptions.splice(index, 1);
        if(this.selectedOptions.length == 0)
        {
            this.isValueSelected = false;
            const selectedEvent = new CustomEvent('valueselected', {
                detail: []
            });
            this.dispatchEvent(selectedEvent);
        }
    }
@track selectedOptions = [];
    handleSelect(event) {
        let existedRecord = false;
        let selectedRecord = {
            mainField: event.currentTarget.dataset.mainfield,
            subField: event.currentTarget.dataset.subfield,
            id: event.currentTarget.dataset.id
        };
        for(let i=0;i<this.selectedOptions.length;i++)
        {            
            if(this.selectedOptions[i].id == selectedRecord.id)
            {
                existedRecord = true;
                break;
            }
        }
        if(existedRecord == false)
        {
            this.selectedOptions.push(selectedRecord);
            this.isValueSelected = true;
        }
        this.recordsList = [];
        console.log('this.recordsList===>',this.recordsList);

            const selectedEvent = new CustomEvent('valueselected', {
                detail: this.selectedOptions
            });
            this.dispatchEvent(selectedEvent);   
            console.log('this.selectedOptions===>',JSON.stringify(this.selectedOptions));
    }
    handleInputBlur(event) {
        this.msgBoolean=false;
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            if (!this.preventClosingOfSerachPanel) {
                this.recordsList = [];
            }
            this.preventClosingOfSerachPanel = false;
        }, DELAY);
    }

}