import { LightningElement, api,track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
//import saveDataApex from '@salesforce/apex/ReusableMultiSelectLookupController.saveDataApex';
import getRetailLeadPhoneDetails from '@salesforce/apex/RetailLeadCls.getRetailLeadPhoneDetails';
import getLeadDetails from '@salesforce/apex/RetailLeadCls.getLeadDetails';
import getDistrictOptions from '@salesforce/apex/RetailLeadCls.getDistrictOptions';
import getTalukaOptions from '@salesforce/apex/RetailLeadCls.getTalukaOptions';


import { CurrentPageReference } from 'lightning/navigation';

// import Retail_Lead_Visit_Object from '@salesforce/schema/Retail_Lead_Visit__c';
// import Date_FIELD from '@salesforce/schema/Retail_Lead_Visit__c.Date__c';
// import owner_FIELD from '@salesforce/schema/Retail_Lead_Visit__c.Visit_Owner__c';
// import Name_FIELD from '@salesforce/schema/Retail_Lead_Visit__c.Lead_Name__c';
// import interest_OBJECT from '@salesforce/schema/Retail_Lead_Visit__c.Level_of_Interest__c';


export default class ModalPopup extends NavigationMixin(LightningElement)  {
  @api recordId;
  @api masterId;

  //@api parentId;
  @track SelectedRecords;
  @track leadtypeFieldValue;
  @track sellerNameFieldBool = false;
  @track linkCustomerIdFieldBool = false;
  @track isConvertedFieldBool = false;
  @track leadvisitIdBool = false;
  @track lastOrderDateBool = false;
  @track saleTypeBool = false;
  @track pendingDataFieldsBool = false;
  @track validatePhone=false;
  @track phonevalue;
  @track customerPhone;
  @track validateUniquePhone=false;
  @track customerError=false;

  @track relatedDistrictData =[];
  @track relatedTalukaData = [];
  @track districtchosenValue = '';
  @track talukachosenValue = '';
  showSpinner = false;

  
  onchangePhone(event){
    this.phonevalue=event.target.value;
    this.validatePhone=false;
    this.validateUniquePhone=false;
    const phoneRegex = /^[0-9]{10}$/;
    if (!phoneRegex.test(this.phonevalue)) {
        this.validatePhone=true;
    }
    if ( this.phonevalue && ( this.phonevalue != '' ||  this.phonevalue != null ||  this.phonevalue != undefined)) {
      getRetailLeadPhoneDetails({ phone:  this.phonevalue })
            .then(result => {
                let customerData = result;
                
                if (customerData) {
                    console.log('customerData' + customerData);
                    this.customerPhone = customerData.Phone__c;
                    console.log('this.customerPhone=======' +this.customerPhone);
                }
                if(this.customerPhone== this.phonevalue){
                    this.validateUniquePhone=true;
                    console.log('this.validateUniquePhone=======' +this.validateUniquePhone);
                    this.showSpinner = false;
                }
            });
        }

    }

  handleLeadTypeFieldValue(event){
    this.leadtypeFieldValue = event.target.value;
    console.log('leadtypeFieldValue====>'+this.leadtypeFieldValue);
    if(this.leadtypeFieldValue == 'Farmer'){
        this.sellerNameFieldBool = true;
        this.linkCustomerIdFieldBool = false;
    }
    else if(this.leadtypeFieldValue == 'Retailer'){
        this.sellerNameFieldBool = true;
        this.linkCustomerIdFieldBool = true;
    }
    else if(this.leadtypeFieldValue == 'Distributor'){
        this.sellerNameFieldBool = false;
        this.linkCustomerIdFieldBool = true;

    }

  }







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
    this.showSpinner = true;
    this.customerError=false;
    console.log('handle submit entered '+JSON.stringify(event.detail));
    event.preventDefault();

    var fields ={...event.detail.fields};
    let tempData = fields;
    console.log('fields=='+JSON.stringify(fields));
    fields.Retail_Lead_District__c = this.districtchosenValue;
fields.Retail_Lead_Taluka__c = this.talukachosenValue;

    if (this.linkedCustomerId && this.linkedCustomerId === this.masterId) {
        this.showSpinner = false;
      this.customerError=true;
      const evt = new ShowToastEvent({
          title: 'Error',
          message: 'This customer is already assigned to a different Lead',
          variant: 'error',
      });
      this.dispatchEvent(evt);
  }


    if (this.phonevalue) {
      const phoneRegex = /^[0-9]{10}$/;
      if (!phoneRegex.test(this.phonevalue)) {
          this.validatePhone=true;
          this.customerError=true;
          this.showSpinner = false;
      }
      if(this.customerPhone== this.phonevalue){
          this.validateUniquePhone=true;
          this.customerError=true;
          console.log('this.validateUniquePhone=======' +this.validateUniquePhone);
          this.showSpinner = false;
      }
  }

  if( this.customerError==false){
    this.template.querySelector('lightning-record-edit-form').submit(fields);

     }
}


    // Call the Apex method to save the data
    // saveDataApex({ recordData: fields, lookupfields : this.SelectedRecords })
    //     .then(result => {
    //         // Show success message
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Success',
    //                 message: 'Record saved successfully',
    //                 variant: 'success'
    //             })
    //         );
    //     })
    //     .catch(error => {
    //         // Show error message
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Error',
    //                 message: 'An error occurred while saving the record',
    //                 variant: 'error'
    //             })
    //         );
    //     });



//Added newly by BV

  handleSuccess(event){
      this.showSpinner = false;
      console.log('lead record id-->',event.detail.id);
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
console.log('lead record id-->',event.detail.id);
     // Navigate to object's list view
     this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: event.detail.id,
          objectApiName: 'Retail_Lead__c',
          actionName: 'view'
        }
      });


  }


  
  handleSave(Event) {
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

handleLeadChange(event) {
  this.masterId = event.target.value;
  
  console.log('this.masterId===============' + this.masterId);
  if (this.masterId && (this.masterId != '' || this.masterId != null || this.masterId != undefined)) {
    getLeadDetails({ masterId: this.masterId })
          .then(result => {
              let leadData = result;
              
              if (leadData) {
                  console.log('leadData' + leadData);
                  this.linkedCustomerId = leadData.Link_Customer_Id__c;
                  console.log('this.linkedCustomerId=======' + this.linkedCustomerId);

                  if (this.linkedCustomerId === this.masterId) {
                      console.log('if else entered');
                      this.showSpinner = false;
                      const evt = new ShowToastEvent({
                          title: 'Error',
                          message: 'Please select a customer that is not linked to a Lead yet!',
                          variant: 'error',
                      });
                      this.dispatchEvent(evt);
                  } 
              }
          })
          .catch(error => {
              console.error('Error retrieving lead details:', error);
          });
  } 
}

handleError(event) {
    this.showSpinner = false;
        let message = event.detail.detail;
        //do some stuff with message to make it more readable
        message = "Something went wrong!";
        //this.showToast(TOAST_TITLE_ERROR, message, TOAST_VARIANT_ERROR);
       //this.clearEditMode();
    }

onchangeState(event){
    console.log('State id--->'+event.target.value);
    const stateId = event.target.value;
    this.relatedDistrictData = '';
    getDistrictOptions({ stateId: stateId })
        .then(result => {
          console.log(' result========' + JSON.stringify(result));
          console.log('result.length==='+result.length);
          for(let i=0; i<result.length; i++) {
            console.log('id=' + result[i].Id);
            this.relatedDistrictData = [...this.relatedDistrictData ,{value: result[i].Id , label: result[i].Name}];      
         }
        })
}

onchangeDistrict(event) {
    // let fieldName = event.target.fieldName;
    // this.orderList[fieldName] = event.target.value;
    const districtSelectedOption = event.detail.value;
    console.log('onchangeDistrict::selected value=' + districtSelectedOption);
    this.districtchosenValue = districtSelectedOption;
    
    this.relatedTalukaData = '';
    getTalukaOptions({ districtId : districtSelectedOption})
    .then(result=>{
        console.log(' result========' + JSON.stringify(result));
          console.log('result.length==='+result.length);
          for(let i=0; i<result.length; i++) {
            console.log('id=' + result[i].Id);
            this.relatedTalukaData = [...this.relatedTalukaData ,{value: result[i].Id , label: result[i].Name}];      
          }
    })

}

//this value will be shown as selected value of combobox item
get Districtvalue(){
    return this.districtchosenValue;
}

get statusOptionsDistrict() {
    console.log('this.relatedDistrictData'+this.relatedDistrictData);
    return this.relatedDistrictData;
}



onchangeTaluka(event) {
    // let fieldName = event.target.fieldName;
    // this.orderList[fieldName] = event.target.value;
    const talukaSelectedOption = event.detail.value;
    console.log('onchangeTaluka::selected value=' + talukaSelectedOption);
    this.talukachosenValue = talukaSelectedOption;
}

//this value will be shown as selected value of combobox item
get Talukavalue(){
    return this.talukachosenValue;
}

get statusOptionsTaluka() {
    console.log('this.relatedTalukaData'+this.relatedTalukaData);
    return this.relatedTalukaData;
}




    get fieldHidden() {
    return 'fieldHidden';
  }


}