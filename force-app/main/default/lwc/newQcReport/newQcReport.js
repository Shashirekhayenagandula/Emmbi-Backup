import { LightningElement, api,track,wire} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import uploadFiles from '@salesforce/apex/FileUploadMultiController.uploadFiles'
// import uploadFiless from '@salesforce/apex/FileUploadMultiController.uploadFiless'
import { CurrentPageReference } from 'lightning/navigation';

const MAX_FILE_SIZE = 2097152;
export default class ModalPopup extends NavigationMixin(LightningElement)  {
  @api recordId;
  @api masterId;
  @api orderId;
  @track leadtypeFieldValue;
  @track customerError=false;
  @track filesData = [];
//   @track filesDataa = [];
  @track showSpinner = false;
  @track FileDisable = false;
  @track order;
  @track parentId;
  base64Context;
  addressableContext;
  @wire(CurrentPageReference)
  pageRef;
connectedCallback(){
    this.base64Context = this.pageRef.state.inContextOfRef;
     if (this.base64Context.startsWith("1\.")) {
    this.base64Context = this.base64Context.substring(2);
     }
     this.addressableContext = JSON.parse(window.atob(this.base64Context));
     this.parentId = this.addressableContext.attributes.recordId;
     console.log('this.parentId====>'+this.parentId);
  
}


  handleLeadTypeFieldValue(event){
    this.leadtypeFieldValue = event.target.value;
    console.log('leadtypeFieldValue====>'+this.leadtypeFieldValue);
  }



  ////////////////file upload handlers //////////////////c/avanaCheckInCheckOut
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
    console.log('file upload sucessfully');
  }
  
//   handleFileUploadedd(event) {
   
//     if (event.target.files.length > 0) {
//         for(var i=0; i< event.target.files.length; i++){
//             if (event.target.files[i].size > MAX_FILE_SIZE) {
//                 this.showToast('Error!', 'error', 'File size exceeded the upload size limit.');
//                 return;
//             }
//             let filee = event.target.files[i];
//             let reader = new FileReader();
//             reader.onload = e => {
//                 var fileContentss = reader.result.split(',')[1]
//                 this.filesDataa.push({'fileName':filee.name, 'fileContent':fileContentss});
//             };
//             reader.readAsDataURL(filee);
//         }
        
//     }
//     console.log('file upload sucessfully');
//     console.log('File Length'+ this.filesDataa.length);
//   }

  removeReceiptImage(event) {
    var index = event.currentTarget.dataset.id;
    this.filesData.splice(index, 1);
  }
  ///c/avanaCheckInCheckOut
//   removeReceiptImagee(event) {
//     var index = event.currentTarget.dataset.id;
//     this.filesDataa.splice(index, 1);
//   }
  
  showToast(title, variant, message) {
    this.dispatchEvent(
        new ShowToastEvent({
            title: title,
            variant: variant,
            message: message,
        })
    );
  }

  /////////////////////////

  closeModal() {
    this.dispatchEvent(new CustomEvent('close'));
  }
  handleSubmit(event) {

   // this.customerError=false;
   
   console.log('handle submit entered '+JSON.stringify(event.detail));
   event.preventDefault();

   const filelenght = this.filesData.length;
   console.log('Length of commercial invoice '+filelenght);

//    const filelenghtt = this.filesDataa.length;
//    console.log('Length of commercial invoice '+filelenghtt);

   const fields = event.detail.fields;
   console.log('fields=='+JSON.stringify(this.fields));
   if(this.filesData == [] || this.filesData.length == 0) {
    this.showToast('Error', 'error', 'Please select Quality Test Report'); return;
} if(this.filesData.length > 1){
    this.showToast('Error', 'error', 'Only one file can be upload'); return;
}
else{
    this.template.querySelector('lightning-record-edit-form').submit(fields);
}
//    this.template.querySelector('lightning-record-edit-form').submit(fields);

   const recid = event.detail.id;
   console.log('RecordId in submit--------'+recid);
   this.showSpinner = true;
}

  handleSuccess(event){

    
    const recid = event.detail.id;
    console.log('RecordId--------'+recid);

    if(this.filesData == [] || this.filesData.length == 0) {
        this.showToast('Error', 'error', 'Please select files first'); return;
    }
    this.showSpinner = true;
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
    ///////////////////////////////////////////////////

//     if(this.filesDataa == [] || this.filesDataa.length == 0) {
//         this.showSpinner = true;
//         uploadFiless({
//             recordId : recid,           
//         })
//         .then(result => {
//            // console.log(result);
//             if(result && result == 'success') {
//                 this.filesDataa = [];
//                 this.showToast('Success', 'success', 'Files Uploaded successfully.');
//             } else {
//                // this.showToast('Error', 'error', result);
//             }
//         }).catch(error => {
//             if(error && error.body && error.body.message) {
//                 this.showToast('Error', 'error', error.body.message);
//             }
//         }).finally(() => this.showSpinner = false );
      
//   }else{
//     this.showSpinner = true;
//     uploadFiless({
//         recordId : recid,
//         filedataa : JSON.stringify(this.filesDataa)
        
//     })
//     .then(result => {
//         console.log(result);
//         if(result && result == 'success') {
//             this.filesDataa = [];
//             this.showToast('Success', 'success', 'Files Uploaded successfully.');
//         } else {
//             this.showToast('Error', 'error', result);
//         }
//     }).catch(error => {
//         if(error && error.body && error.body.message) {
//             this.showToast('Error', 'error', error.body.message);
//         }
//     }).finally(() => this.showSpinner = false ); 


//   }
 


  ////////////////////file 2
  
 
  ///////////////

    const even = new ShowToastEvent({
        title: 'Success!',
        message: 'QC Report saved successfully!',
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
     if(recid != '')
     { 
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
              objectApiName: 'Retail_QC_Report__c',
              actionName: 'list'
            }
          });

     }
     else{
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
              objectApiName: 'Retail_Order__c',
              actionName: 'list'
            }
          });
     }
    

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
    console.log('record page from order');
      
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Retail_QC_Report__c',
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