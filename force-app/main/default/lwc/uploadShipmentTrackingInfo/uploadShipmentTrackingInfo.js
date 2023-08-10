import { LightningElement, api,track, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import uploadFiles from '@salesforce/apex/FileUploadMultiController.uploadFiles';
import ShipmentInfo from '@salesforce/apex/FileUploadMultiController.ShipmentInfo';
import { CurrentPageReference } from 'lightning/navigation';
const MAX_FILE_SIZE = 2097152;
export default class ModalPopup extends NavigationMixin(LightningElement)  {
  @api recordId;
  @api masterId;
  @api orderId;
  @track preferedTrp;
  @track ConsignmentTracking;
  @track TransportCompany;
  @track hasbeenDispatched;
  @track selectedOrder;
  @track dispatchDate;
  @track customerPrefTsComp;
  @track vehicleNumber;
  @track driverPhone;
  @track otherTsCompany;
  @track otherComapyDisable=false;
  @track customerError=false;
  
  @track filesData = [];
  @track showSpinner = false;
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
     ShipmentInfo({ orderId: this.parentId})
      .then((result) => 
      {
        console.log('Resultttt-----37',JSON.stringify(result)); 
        this.preferedTrp = result[0].Prefered_Transport_Company__c;
      })
      .catch((error) => 
      {
        console.log('error-----',error);
      });

  
}

  
  handleSelectedOrder(event){
    this.selectedOrder = event.target.value;
    console.log('selectedOrder====>'+this.selectedOrder);
   
      ShipmentInfo({ orderId: this.selectedOrder})
      .then((result) => 
      {
        console.log('Resultttt-----37',JSON.stringify(result)); 
        this.preferedTrp = result[0].Prefered_Transport_Company__c;
      })
      .catch((error) => 
      {
        console.log('error-----',error);
      });

  }

  handleDispatchDate(event){
    this.dispatchDate = event.target.value;
    console.log('dispatchDate====>'+this.dispatchDate);
  }


  handleConsignmentTracking(event){
    this.ConsignmentTracking = event.target.value;
    console.log('ConsignmentTracking====>'+this.ConsignmentTracking);
  }

  handleVehicleNumber(event){
    this.vehicleNumber = event.target.value;
    console.log('vehicleNumber====>'+this.vehicleNumber);
  }

  handleCountryCode(event){
    this.countryCode = event.target.value;
    console.log('countryCode====>'+this.countryCode);
  }

  handelDriverPhone(event){
    this.driverPhone = event.target.value;
    console.log('driverPhone====>'+this.driverPhone);
  }


  handleHasbeenDispatched(event){
    this.hasbeenDispatched = event.target.value;
    console.log('hasbeenDispatched====>'+this.hasbeenDispatched);
  }

  handleOtherTransportCompany(event){
    this.otherTsCompany = event.target.value;
    console.log('otherTsCompany====>'+this.otherTsCompany);
  }

  handleTransportCompany(event){
    this.TransportCompany = event.target.value;
    console.log('TransportCompany====>'+this.TransportCompany);
    if(this.TransportCompany == 'Any Other'){
        this.otherComapyDisable = true;
    }else{
      this.otherComapyDisable = false;
    }
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

/////////////////////////
  

  closeModal() {
    this.dispatchEvent(new CustomEvent('close'));
  }
  handleSubmit(event) {

   // this.customerError=false;
   
    console.log('handle submit entered '+JSON.stringify(event.detail));
    event.preventDefault();

    const fields = event.detail.fields;
    console.log('fields=='+JSON.stringify(this.fields));
    console.log('before query');
    if(this.filesData.length > 1) {
      this.showToast('Error', 'error', 'Only one file can be submit'); return;
  }else{
      this.template.querySelector('lightning-record-edit-form').submit(fields);
  }

      console.log('aftere query');
      this.showSpinner = true;
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
        objectApiName: 'Retail_Upload_Shipment_tracking_Info__c',
        actionName: 'list'
      }
    });


}



  
  handleSave(Event) {
    console.log("Entered");
    const even = new ShowToastEvent({
        title: 'Success!',
        message: 'Upload Commercial Invoice was saved successfully!',
        variant: 'success'
    });
    this.dispatchEvent(even);
}
  closeQuickAction() {
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'Retail_Upload_Shipment_tracking_Info__c',
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