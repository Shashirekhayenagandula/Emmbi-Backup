import { LightningElement, api,track,wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import leadRecordList from '@salesforce/apex/LeadControllerForEdit.leadRecords';
import objectApiNameLead from '@salesforce/schema/Retail_Lead__c';


import { CurrentPageReference } from 'lightning/navigation';

import Leadtype_FIELD from '@salesforce/schema/Retail_Lead__c.Lead_Type__c';
import owner_FIELD from '@salesforce/schema/Retail_Lead_Visit__c.Visit_Owner__c';
import Name_FIELD from '@salesforce/schema/Retail_Lead_Visit__c.Lead_Name__c';
import interest_OBJECT from '@salesforce/schema/Retail_Lead_Visit__c.Level_of_Interest__c';


export default class ModalPopup extends NavigationMixin(LightningElement)  {
  @api recordId;
  //@api parentId;
  @track SelectedRecords;
  @track isFieldDisabled=false;//true makes disable,false makes enable
  @track hideIscustomerId=true;//false in lwc:if makes hide
  @track iscustomerIdDisabled=true;//true makes disable,false makes enable
  @track sellernameDisabled=true;
  leadRecordData;
 @track recordData;
 @track leadtypevalueholder;
 @track linkcustomeridvalueholder;

   @wire(leadRecordList, {leadRecordId: '$recordId' })
   leadRecordsData({ error, data }) {
    if (data) {
       
        // Handle the data returned from Apex
        this.recordData = data;
        this.leadtypevalueholder =  this.recordData.Lead_Type__c;
        this.linkcustomeridvalueholder = this.recordData.Link_Customer_Id__c;
    
       console.log('this.leadtypevalueholder===>', this.leadtypevalueholder);
        console.log(JSON.stringify(this.recordData));

        console.log('Executing wire method');
    } else if (error) {
        // Handle any errors
        console.error('Error:', error);
    }
 this.handleDisablingFields(this.leadtypevalueholder,this.linkcustomeridvalueholder);
  }


  handleDisablingFields(leadTypee,linkCustomerr)
  {
    console.log("Entered method");
    //this.leadRecordData = this.recordData;
    if(leadTypee == 'Farmer'){
        this.isFieldDisabled = true; //This makes the fields disable
        this.hideIscustomerId=false;//false in lwc:if makes hide
        this.sellernameDisabled = false;//False makes the field enable
        console.log('Fields are disabled');
    }
    else if(leadTypee != 'Farmer'){
        this.isFieldDisabled = true; //This makes the fields disable
        this.hideIscustomerId=true;//false in lwc:if makes hide & true makes display
        if(linkCustomerr == null){
            this.iscustomerIdDisabled = false;
            
        }
        else{
            this.iscustomerIdDisabled = true;

        }


    }
  }
  

  /*connectedCallback(){
    
    leadRecordList({leadRecordId: '$recordId'})
            .then(result => {
                //this.contacts = result;
                this.recordData = result;
        console.log(JSON.stringify(this.recordData));
            })
            .catch(error => {
               // this.error = error;
            });
   }



 /*  handleDisablingFields(){
    console.log('Entered function');

    leadRecords({leadRecordId: '$recordId'})
         .then(result => {
              recordData = result;
             if(recordData.Lead_Type__c == 'Farmer'){
                console.log('Bye2');
                //console.log("recordData.Lead_Type__c ==>"+JSON.stringify(recordData.Lead_Type__c));
                console.log('Bye3');

                this.isFieldDisabled = false;
                this.iscustomerIdDisabled = false;
                //this.hideIscustomerId = true;
                this.sellernameDisabled = true;

             }
             else if(recordData.Lead_Type__c != 'Farmer'){
                //this.isFieldDisabled = false;
               // this.hideIscustomerId = false;
              // this.hideIscustomerId = true;

                if(recordData.Link_Customer_Id__c == null){
                    this.iscustomerIdDisabled = true;

                }
               


             }
            
           /*  else {
                this.isFieldDisabled = true;
                this.hideIscustomerId = true;

                if(recordData.Link_Customer_Id__c == null){
                    this.iscustomerIdDisabled = true;
                }
                else if(recordData.Link_Customer_Id__c != null){
                    this.iscustomerIdDisabled = false;

                }
             }

         })
         .catch(error => {
             this.error = error;
         });
 




}*/
 
  handleValueSelected(event) {
    console.log('handleValueSelected called');
       this.SelectedRecords = event.detail; 
       console.log('this.SelectedRecords===',this.SelectedRecords);
   }

  closeModal() {
    this.dispatchEvent(new CustomEvent('close'));
  }

  /*handleSuccess() {
    this.closeModal();
    // Handle success if needed
  }*/

 /* handleSuccess(event) {
     
    const evt = new ShowToastEvent({
        title: 'Account Updated',
        message: 'Record ID: ' + event.detail.id,
        variant: 'success',

    });
    
    this.dispatchEvent(evt);

}*/

  /*handleSubmit(event) {
    event.preventDefault();
    // Handle submit if needed
  }*/

//Added newly by BV
  handleSubmit(event) {
    console.log('handle submit entered '+JSON.stringify(event.detail));
    event.preventDefault();

    const fields = event.detail;
    console.log('fields=='+JSON.stringify(this.fields));
    // Call the Apex method to save the data
    saveDataApex({ recordData: fields, lookupfields : this.SelectedRecords })
        .then(result => {
            // Show success message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record saved successfully',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            // Show error message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An error occurred while saving the record',
                    variant: 'error'
                })
            );
        });
}

//Added newly by BV

  handleSuccess(event){
    const even = new ShowToastEvent({
        title: 'Success!',
        message: 'Lead was saved successfully!',
        variant: 'success'
    });
    this.dispatchEvent(even);

    const inputFields = this.template.querySelectorAll(
        'lightning-input-field'
    );
    if (inputFields) {
        inputFields.forEach(field => {
            field.reset();
        });
    }

     // Navigate to object's list view
     this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
          objectApiName: 'Retail_Lead__c',
          actionName: 'list'
        }
      });


  }
  
  handleSave(event) {
    console.log("Entered");
    const even = new ShowToastEvent({
        title: 'Success!',
        message: 'Lead was saved successfully!',
        variant: 'success'
    });
    this.dispatchEvent(even);
    //this.parentId = event.detail.id; // Retrieve the parentId from the event
    //this.showEditpage = false;
   /* this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            //recordId: this.parentId,
            objectApiName: 'Retail_Lead_Visit__c',
            actionName: 'view'
        }
    })*/
}
  closeQuickAction() {
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'Retail_Lead__c',
            actionName: 'list'
        },
        state: {
            filterName: 'Recent'
        },
    })
    .then(() => {
        this.dispatchEvent(new CloseActionScreenEvent());
    })
    .catch(error => {
        console.error('Error navigating to object page:', error);
    });
}
}