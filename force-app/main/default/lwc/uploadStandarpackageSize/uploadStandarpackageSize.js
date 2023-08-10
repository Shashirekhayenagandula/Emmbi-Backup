import { LightningElement, api,track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import uploadFiles from '@salesforce/apex/FileUploadMultiController.uploadFiles'
const MAX_FILE_SIZE = 2097152;
export default class ModalPopup extends NavigationMixin(LightningElement)  {
  @api recordId;
  @api masterId;
  @track leadtypeFieldValue;
  @track product;
  @track customerError=false;
  @track filesData = [];
  showSpinner = false;
  

  handleLeadTypeFieldValue(event){
    this.leadtypeFieldValue = event.target.value;
    console.log('leadtypeFieldValue====>'+this.leadtypeFieldValue);
  }

  handleProduct(event){
    this.product = event.target.value;
    console.log('leadtypeFieldValue====>'+this.product);
  }
/////////////////file upload handlers //////////////////c/avanaCheckInCheckOut
handleFileUploaded(event) {
  if (event.target.files.length > 0) {
      for(var i=0; i< event.target.files.length; i++){
          if (event.target.files[i].size > MAX_FILE_SIZE) {
              this.showToast('Error!', 'error', 'File size exceeded the upload size limit.');
              return;
          }
          let file = event.target.files[i];
          let reader = new FileReader();
          reader.onload = e => {
              var fileContents = reader.result.split(',')[1]
              this.filesData.push({'fileName':file.name, 'fileContent':fileContents});
          };
          reader.readAsDataURL(file);
      }
  }
  this.dispatchEvent(
    new ShowToastEvent({
        title: 'Success',
        message: ' Files uploaded Successfully: ',
        variant: 'success',
    }),
);
  console.log('file upload sucessfully');
}

removeReceiptImage(event) {
  var index = event.currentTarget.dataset.id;
  this.filesData.splice(index, 1);
}

showToast(title, variant, message) {
  this.dispatchEvent(
      new ShowToastEvent({
          title: title,
          variant: variant,
          message: message,
      })
  );
}


//////////////////////file upload attachment ///////////////c/avanaCheckInCheckOut

handleUploadFinished(event) {
        try{
           // Get uploaded files
        this.uploadedFiles = event.detail.files;
         let tempList = [];
           console.log('uploadedFiles',this.uploadedFiles);
     
         // Add uploaded files to attachments list
          for(let i = 0; i < this.uploadedFiles.length; i++) {
             this.attachments.push(this.uploadedFiles[i].contentVersionId);
            this.attList.push({Name:this.uploadedFiles[i].name,FileId:this.uploadedFiles[i].documentId});
           }
          this.docList = this.attList
           console.log('this.attList',JSON.stringify(this.attList));
         console.log('this.attachments',JSON.stringify(this.attachments));
         }catch(error){
          console.log('error',error);
         }
    }
    remove(event){
           let cmp=event.target.dataset.id;
        let cmpName=event.target.name;
    console.log('cmp---102',cmp);
      let tempDelList = [];
        deleteRecord(cmp)
          .then(() => {
       for(let i = 0; i <this.attList.length; i++ ){
           if(this.attList[i].FileId == cmp && this.attList[i].Name == cmpName ){
 
             }else{
       tempDelList.push({Name:this.attList[i].Name,FileId:this.attList[i].FileId});
               }
             }
             this.attList = tempDelList;
          this.docList = this.attList;
         console.log('deletedId');
              console.log('this.attList',JSON.stringify(this.attList) );
          console.log('this.attachments',JSON.stringify(this.attachments) );
               })
           .catch(error => {
         console.log('delete Failed');
          });
    }

////////////////file upload atttachment////////////


///////////////////////////////

  closeModal() {
    this.dispatchEvent(new CustomEvent('close'));
  }
  handleSubmit(event) {

   // this.customerError=false;
   
    console.log('handle submit entered '+JSON.stringify(event.detail));
    event.preventDefault();

    const fields = event.detail.fields;
    console.log('fields=='+JSON.stringify(this.fields));
 
    this.template.querySelector('lightning-record-edit-form').submit(fields);

    const recid = event.detail.id;
    console.log('RecordId in submit--------'+recid);
}

  handleSuccess(event){

    const recid = event.detail.id;
    console.log('RecordId--------'+recid);

    if(this.filesData == [] || this.filesData.length == 0) {
     // this.showToast('Error', 'error', 'Please select files first'); return;
     this.showSpinner = true;
  uploadFiles({
      recordId : recid,
     // filedata : JSON.stringify(this.filesData)
  })
  .then(result => {
      console.log(result);
      if(result && result == 'success') {
          this.filesData = [];
          this.showToast('Success', 'success', 'Files Uploaded successfully.');
      } else {
         // this.showToast('Error', 'error', result);
      }
  }).catch(error => {
      if(error && error.body && error.body.message) {
          this.showToast('Error', 'error', error.body.message);
      }
  }).finally(() => this.showSpinner = false );
  }
 else{ this.showSpinner = true;
  uploadFiles({
      recordId : recid,
      filedata : JSON.stringify(this.filesData)
  })
  .then(result => {
      console.log(result);
      if(result && result == 'success') {
          this.filesData = [];
          this.showToast('Success', 'success', 'Files Uploaded successfully.');
      } else {
          this.showToast('Error', 'error', result);
      }
  }).catch(error => {
      if(error && error.body && error.body.message) {
          this.showToast('Error', 'error', error.body.message);
      }
  }).finally(() => this.showSpinner = false );
 }
  ////////////////
    const even = new ShowToastEvent({
        title: 'Success!',
        message: 'product standard Package size successfully updated!',
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
          objectApiName: 'Retail_Update_standard_packaging_size__c',
          actionName: 'list'
        }
      });


  }


  
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
            objectApiName: 'Retail_Update_standard_packaging_size__c',
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