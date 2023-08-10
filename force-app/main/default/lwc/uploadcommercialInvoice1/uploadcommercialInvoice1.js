import { LightningElement, api,track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import saveRecord from '@salesforce/apex/UploadFileCls.saveContacttt'; 
const MAX_FILE_SIZE = 100000000; //10mb  
export default class ModalPopup extends NavigationMixin(LightningElement)  {
  @api recordId;
  @api masterId;
  @track leadtypeFieldValue;
  @track dispatchDate;
  @track selectOrder;
  @track readyToDispatch;
  @track customerError=false;
  @track ifFile=false;
  uploadedFiles = []; file; fileContents; fileReader; content; fileName  
  

  handleLeadTypeFieldValue(event){
    this.leadtypeFieldValue = event.target.value;
    console.log('leadtypeFieldValue====>'+this.leadtypeFieldValue);
  }

  onUpdateDate(event){
    this.dispatchDate = event.target.value;
    console.log('dispatchDate====>'+this.dispatchDate);
  }

  onSelectedOrder(event){
    this.selectOrder = event.target.value;
    console.log('selectOrder====>'+this.selectOrder);
  }

  onDispatch(event){
    this.readyToDispatch = event.target.value;
    console.log('readyToDispatch====>'+this.readyToDispatch);
  }
///////////////c/avanaCheckInCheckOut
onFileUpload(event) {  
  console.log('uploadedFilesLength----->'+event.target.files.length);
    if (event.target.files.length > 0) {  
      this.ifFile = true;
      this.uploadedFiles = event.target.files;  
      this.fileName = event.target.files[0].name;  
      this.file = this.uploadedFiles[0];  
      if (this.file.size > this.MAX_FILE_SIZE) {  
        alert("File Size Can not exceed" + MAX_FILE_SIZE);  
      }  
    } 
    console.log('uploadedFiles----->'+this.uploadedFiles); 
  }  
 ////////////////ForMultiple upload////////// 
//  onFileUploadmultiple(event) {  
//   console.log('uploadedFilesLength----->'+event.target.files.length);
//     if (event.target.files.length > 0) { 
//       for(var i=0; i< event.target.files.length; i++){
//         this.ifFile = true;
//         this.uploadedFiles = event.target.files[i];  
//         this.fileName = event.target.files[0].name;  
//         this.file = this.uploadedFiles[0];  
//         if (this.file.size > this.MAX_FILE_SIZE) {  
//           alert("File Size Can not exceed" + MAX_FILE_SIZE);  
//         }  
//       } 
//       console.log('uploadedFiles----->'+this.uploadedFiles); 
//       } 
     
//   }  

///////////////////////////

  saveContact() {  
    if(this.ifFile== true){
      this.fileReader = new FileReader();  
      this.fileReader.onloadend = (() => {  
        this.fileContents = this.fileReader.result;  
        let base64 = 'base64,';  
        this.content = this.fileContents.indexOf(base64) + base64.length;  
        this.fileContents = this.fileContents.substring(this.content);  
        this.saveRecord();
        console.log('Record created with upload');
      });  
      this.fileReader.readAsDataURL(this.file);  
    }
    else if(this.ifFile== false){
      //this.ifFile = false;
      this.saveRecordd(); 
      console.log('record created without upload');
    }
  } 

  saveRecord() {  
    var invoice = {  
      'sobjectType': 'Retail_Upload_Commercial_Invoice__c',  
      'Select_Order__c': this.selectOrder,
      'Invoice_Upload_Date__c': this.dispatchDate,
      'Invoice_No__c': this.leadtypeFieldValue,
      'Ready_for_dispatch__c': true,  // Replace 'Field1__c' with the API name of your field
      // Add other fields as needed for your custom object
    };  
  
    saveRecord({  
      invoiceRec: invoice,  
      file: encodeURIComponent(this.fileContents),  
      fileName: this.fileName  
    })
    .then(invoiceId => {  
      if (invoiceId) {  
        this.dispatchEvent(  
          new ShowToastEvent({  
            title: 'Success',  
            variant: 'success',  
            message: 'Invoice Successfully created'+ invoiceId,  // Update the message for your custom object
          }),  
        );  
        this[NavigationMixin.Navigate]({  
          type: 'standard__recordPage',  
          attributes: {  
            recordId: invoiceId,  // Use the invoiceId instead of conId
            objectApiName: 'Retail_Upload_Commercial_Invoice__c',  // Use the API name of your custom object
            actionName: 'view'  
          },  
        });  
      }  
    })
    .catch(error => {  
      console.log('error ', error);  
    });  
  }
  ///////////////////c/avanaCheckInCheckOut

  saveRecordd() {  
    var invoice = {  
      'sobjectType': 'Retail_Upload_Commercial_Invoice__c',  
      'Select_Order__c': this.selectOrder,
      'Invoice_Upload_Date__c': this.dispatchDate,
      'Invoice_No__c': this.leadtypeFieldValue,
      'Ready_for_dispatch__c': true,  // Replace 'Field1__c' with the API name of your field
      // Add other fields as needed for your custom object
    };  
  
    saveRecord({  
      invoiceRec: invoice,  
      
    })
    .then(invoiceId => {  
      if (invoiceId) {  
        this.dispatchEvent(  
          new ShowToastEvent({  
            title: 'Success',  
            variant: 'success',  
            message: 'Invoice Successfully created'+ invoiceId,  // Update the message for your custom object
          }),  
        );  
        this[NavigationMixin.Navigate]({  
          type: 'standard__recordPage',  
          attributes: {  
            recordId: invoiceId,  // Use the invoiceId instead of conId
            objectApiName: 'Retail_Upload_Commercial_Invoice__c',  // Use the API name of your custom object
            actionName: 'view'  
          },  
        });  
      }  
    })
    .catch(error => {  
      console.log('error ', error);  
    });  
  }
  

////////////////

  closeModal() {
    this.dispatchEvent(new CustomEvent('close'));
  }
//   handleSubmit(event) {

//    // this.customerError=false;
   
//     console.log('handle submit entered '+JSON.stringify(event.detail));
//     event.preventDefault();

//     const fields = event.detail.fields;

  
//     console.log('fieldscreated=='+JSON.stringify(this.fields));

// //     if (this.linkedCustomerId && this.linkedCustomerId === this.masterId) {
// //     //  this.customerError=true;
// //       const evt = new ShowToastEvent({
// //           title: 'Error',
// //           message: 'This customer is already assigned to a different Lead',
// //           variant: 'error',
// //       });
// //       this.dispatchEvent(evt);
// //   }

// //   if( this.customerError==false){
// //     this.template.querySelector('lightning-record-edit-form').submit(fields);

// //      }
//      this.template.querySelector('lightning-record-edit-form').submit(fields);
     

// }
  
//   handleSave(Event) {
//     console.log("Entered");
//     const even = new ShowToastEvent({
//         title: 'Success!',
//         message: 'Upload Commercial Invoice was saved successfully!',
//         variant: 'success'
//     });
//     this.dispatchEvent(even);
// }
  closeQuickAction() {
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'Retail_Upload_Commercial_Invoice__c',
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