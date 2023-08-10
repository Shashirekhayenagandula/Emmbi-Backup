import { LightningElement, api, track, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import insertLeadVisit from '@salesforce/apex/NewOverrideLeadVisitController.insertLeadVisit';
import getProductGroupDetails from '@salesforce/apex/NewOverrideLeadVisitController.getProductGroupDetails';
import getLinkCustomer from '@salesforce/apex/NewOverrideLeadVisitController.getLinkCustomer';
import getLinkCustomerLead from '@salesforce/apex/NewOverrideLeadVisitController.getLinkCustomerLead';
import insertLeadVisitOnly from '@salesforce/apex/NewOverrideLeadVisitController.insertLeadVisitOnly';
import insertLeadVisitWithProduct from '@salesforce/apex/NewOverrideLeadVisitController.insertLeadVisitWithProduct';
import { CurrentPageReference } from 'lightning/navigation';
export default class ModalPopup extends NavigationMixin(LightningElement) {
  @api recordId;
  @track saveBool = false;
  @api productGroupId;
  @track productList = [];
  @track leadVisit = {};
  @track deleteAction;
  @track productMaster;
  @track isDisplayReasonForColdLead = false;
  @track isDisplayFollowup = false;
  @track followupError = false;
  @track isDisplaySellerId = false;
  @track isDisplaySaleId = false;
  @track isProductQuantity = false;
  @track productError = false;
  @track isDisplayQuantity=false;
  @track isDisplayLinkedCustomerId=false;
  @track isDisplayOtherText=false;
  @track isDisPlayConvertedText=false;
  @track isErrorProduct=false;
  @track isOrderId=false;
  @api parentId;
  base64Context;
  addressableContext;
  @wire(CurrentPageReference)
  pageRef;
  currentDate;

  connectedCallback() {
    const today = new Date();
    const year = today.getFullYear();
    let month = today.getMonth() + 1;
    let day = today.getDate();

    // Add leading zeros if month or day is less than 10
    if (month < 10) {
      month = '0' + month;
    }
    if (day < 10) {
      day = '0' + day;
    }
    this.currentDate = `${year}-${month}-${day}`;
    this.base64Context = this.pageRef.state.inContextOfRef;
    if (this.base64Context.startsWith("1\.")) {
      this.base64Context = this.base64Context.substring(2);
    }
    this.addressableContext = JSON.parse(window.atob(this.base64Context));
    this.parentId = this.addressableContext.attributes.recordId;
    this.leadVisit.Lead_Name__c=this.parentId;
   /* if(this.recordId!=null || this.recordId!=undefined || this.recordId!=''){
      console.log('recordId'+this.recordId);
      this.leadVisit.Lead_Name__c=this.recordId;
    } */
    if( this.leadVisit.Lead_Name__c!=null ||  this.leadVisit.Lead_Name__c!='' || this.leadVisit.Lead_Name__c!=undefined){
      this.isDisplayLinkedCustomerId=true;
    
    
    getLinkCustomer({leadId: this.leadVisit.Lead_Name__c })
        .then(result => {
          let customerDetails=result;
          console.log(' customerDetails.Lead_Name__c;'+customerDetails.Id);
          if(customerDetails.Id!=null || customerDetails.Id!='' || customerDetails.Id!=undefined){
            console.log(' customerDetails.Lead_Name__cif;'+customerDetails.Id);
            this.leadVisit.Linked_Customer__c=customerDetails.Id;
            // this.leadVisit.Seller_ID__c=customerDetails.Id;
           // console.log(' customerDetails.Lead_Name__cif;'+this.leadVisit.Linked_Customer__c);
          }
         
        })
    
        getLinkCustomerLead({leadId: this.leadVisit.Lead_Name__c })
        .then(result => {
          let leadDetails=result;
          console.log(' Lead typr'+leadDetails.Lead_Type__c);
          if(leadDetails.Id!=null || leadDetails.Id!='' || leadDetails.Id!=undefined){
            console.log(' Lead typr===='+leadDetails.Lead_Type__c);
            this.leadVisit.Lead_Type__c=leadDetails.Lead_Type__c;
            // this.leadVisit.Seller_ID__c=leadDetails.Seller_Name__c;
            console.log(' this.leadVisit.Seller_ID__c120'+ this.leadVisit.Seller_ID__c);
          }
         
        })
      }
  }

  closeModal() {
    this.dispatchEvent(new CustomEvent('close'));
  }
  handleOnchangeReasonforCold(event){
    this.isDisplayOtherText=false;
    this.leadVisit.Reason_for_Cold_Lead__c = event.target.value;
    if(this.leadVisit.Reason_for_Cold_Lead__c=='Other'){
      this.isDisplayOtherText=true;

    }
  }

  handleOnChangeSaleType(event) {
    this.isDisplaySellerId = false;
    this.isOrderId=false;
    this.leadVisit.Sale_Type__c='';
    this.leadVisit.Seller_ID__c='';
    //this.isDisplaySaleId = false;
    this.leadVisit.Sale_Type__c = event.target.value;
    if (this.leadVisit.Sale_Type__c == 'Indirect') {
      this.isDisplaySellerId = true;
    }
    else if(this.leadVisit.Sale_Type__c == 'Direct'){
      this.isOrderId=true;
    }
  }
  handleOnchangeOtherReasonforCold(event){
    this.leadVisit.Other_Reason_For_Cold__c = event.target.value;
  }
  handleOnChangeOrderType(event){
    this.leadVisit.isOrderId = event.target.value;
  }

  handleOnChangeName(event) {
    this.isDisplayOtherText=false;
    this.isDisplayLinkedCustomerId=false;
    this.leadVisit.Linked_Customer__c='';
    this.leadVisit.Lead_Type__c='';
    this.leadVisit.Lead_Name__c = event.target.value;
    if( this.leadVisit.Lead_Name__c!=null ||  this.leadVisit.Lead_Name__c!='' || this.leadVisit.Lead_Name__c!=undefined){
      this.isDisplayLinkedCustomerId=true;
    }
    
    getLinkCustomer({leadId: this.leadVisit.Lead_Name__c })
        .then(result => {
          let customerDetails=result;
          console.log(' customerDetails.Lead_Name__c;'+customerDetails.Id);
          if(customerDetails.Id!=null || customerDetails.Id!='' || customerDetails.Id!=undefined){
            console.log(' customerDetails.Lead_Name__cif;'+customerDetails.Id);
            this.leadVisit.Linked_Customer__c=customerDetails.Id;
            // this.leadVisit.Seller_ID__c=customerDetails.Id;
           // console.log(' customerDetails.Lead_Name__cif;'+this.leadVisit.Linked_Customer__c);
          }
         
        })
    
        getLinkCustomerLead({leadId: this.leadVisit.Lead_Name__c })
        .then(result => {
          let leadDetails=result;
          console.log(' Lead typr'+leadDetails.Lead_Type__c);
          if(leadDetails.Id!=null || leadDetails.Id!='' || leadDetails.Id!=undefined){
            console.log(' Lead typr===='+leadDetails.Lead_Type__c);
            this.leadVisit.Lead_Type__c=leadDetails.Lead_Type__c;
            // this.leadVisit.Seller_ID__c=leadDetails.Seller_Name__c;
            console.log(' this.leadVisit.Seller_ID__c120'+ this.leadVisit.Seller_ID__c);
          }
         
        })
    }

  
  handleOnChangeLeadType(event) {
    this.isDisplaySellerId = false;
    this.isDisplaySaleId = false;
    this.leadVisit.Sale_Type__c='';
    this.leadVisit.Seller_ID__c=undefined;
    this.leadVisit.Lead_Type__c = event.target.value; 
    this.productError=false;
    this.followupError=false;
    this.isOrderId=false;
    if(this.leadVisit.Lead_Type__c == 'Distributor' && this.leadVisit.Level_of_Interest__c == 'Converted'){
        this.isOrderId=true;
    }
    if (this.leadVisit.Level_of_Interest__c == 'Converted' && this.leadVisit.Lead_Type__c == 'Farmer') {
      this.isDisplaySellerId = true;

    }
    else if (this.leadVisit.Level_of_Interest__c == 'Converted' && this.leadVisit.Lead_Type__c == 'Retailer') {
      this.isDisplaySaleId = true;
    }
    /*if(this.leadVisit.Lead_Type__c =='Farmer'){
      this.isDisplayReasonForColdLead=true;

    }*/
  }
  handleOnChangeLevelOfInterest(event) {
    this.isDisplayOtherText=false;
    this.leadVisit.Reason_for_Cold_Lead__c='';
    this.isDisplayReasonForColdLead = false;
    this.isDisplayFollowup = false;
    this.isDisplaySellerId = false;
    this.isDisplaySaleId = false;
    this.isProductQuantity = false;
    this.isOrderId=false;
    this.leadVisit.Sale_Type__c='';
    this.leadVisit.Seller_ID__c=undefined;
    this.leadVisit.Other_Reason_For_Cold__c='';
    this.leadVisit.Follow_up_Date__c=null;
    
    this.leadVisit.Level_of_Interest__c = event.target.value;
   
    if (this.leadVisit.Level_of_Interest__c == 'Cold Lead') {
      this.isDisplayReasonForColdLead = true;

    }
    else if (this.leadVisit.Level_of_Interest__c == 'Interested') {
      this.isDisplayFollowup = true;
    }
    else if (this.leadVisit.Level_of_Interest__c == 'Converted') {
      
      if(this.leadVisit.Lead_Type__c == 'Farmer') {
        this.isDisplaySellerId = true;
      }
      else if(this.leadVisit.Lead_Type__c == 'Retailer') {
        this.isDisplaySaleId = true;
      }
      else if(this.leadVisit.Lead_Type__c == 'Distributor'){
        this.isOrderId=true;
    }
      if (this.leadVisit.Linked_Customer__c != null || this.leadVisit.Linked_Customer__c != undefined) {
        this.leadVisit.New_Lead__c = 'No';
        this.leadVisit.New_Lead_Counter__c = 0;
        this.leadVisit.Old_Lead_Counter__c = 1;

      }
      else if (this.leadVisit.Linked_Customer__c == null || this.leadVisit.Linked_Customer__c == undefined) {
        this.leadVisit.New_Lead__c = 'Yes';
        this.leadVisit.New_Lead_Counter__c = 1;
        this.leadVisit.Old_Lead_Counter__c = 0;
      }

    }
    else if(this.leadVisit.Level_of_Interest__c == 'Completed'){


    }
   

  }
  handleOnchangeSeller(event){
    //this.isDisplaySellerId = false;
    this.leadVisit.Seller_ID__c = event.target.value;
    console.log(' customerDetails.Lead_Name__cif;'+this.leadVisit.Linked_Customer__c);
  }
  handleOnChangeFollowup(event) {
    //this.isDisplayFollowup = false;
    this.leadVisit.Follow_up_Date__c = event.target.value;

  }
  handleOnchangeLinkedCustomerId(event){
    this.leadVisit.Linked_Customer__c=event.target.value;

  }

  handleOnchangeProductGroup(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
    this.productGroupId = event.target.value;
    console.log('this.productGroupId' + this.productGroupId);
    if (this.productGroupId != '' || this.productGroupId != null || this.productGroupId != undefined) {
      console.log('this.productGroupId if' + this.productGroupId);

      getProductGroupDetails({ productGroupId: this.productGroupId })
        .then(result => {
          this.productMaster[rowIndex] = result;
          console.log('this.productMaster[rowIndex]========' + result);
          this.productList.Id[rowIndex] = result.Id;
        })
    }
  }
  handleChangeQuantity(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
    console.log('this.productList[rowIndex][fieldName]' + this.productList[rowIndex][fieldName]);
  }
  addRow(event) {
  
      this.productList.push({
        Id:'',
        Retail_Product_Group__c: '',
        Quantity__c:''
      });
    }
  
  // Remove a row from the productList array
  removeRow(event) {
    const index = event.currentTarget.dataset.index;
    this.productList.splice(index, 1);
  }
  validateError() {
    this.productError = false;
    this.isErrorProduct=false;
    this.followupError=false;
    this.saveBool=false;
    console.log('this.productError233'+this.productError);
    if (this.leadVisit.Lead_Name__c == null || this.leadVisit.Lead_Name__c == undefined || this.leadVisit.Lead_Name__c=='') {
      console.log('2');
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="leadName"]').forEach(element => {
        element.reportValidity();
        
      });
    }
    // if (this.leadVisit.Lead_Type__c == null || this.leadVisit.Lead_Type__c == undefined) {
    //   console.log('3');
    //   this.productError = true;
    //   this.template.querySelectorAll('lightning-input-field[data-name="leadType"]').forEach(element => {
    //     element.reportValidity();
        
    //   });
    // }
    
    if (this.leadVisit.Level_of_Interest__c == null || this.leadVisit.Level_of_Interest__c == undefined) {
      console.log('4');
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="levelOfInterest"]').forEach(element => {
        element.reportValidity();
      });
    }
    let productSet = new Set(); // Create a set to store unique product values
    for (let i = 0; i < this.productList.length; i++) {
      const product = this.productList[i];

      // Check if the product group is empty
      if (product.Retail_Product_Group__c == '') {
        this.productError = true;
        product.productGroupComplete = true;
       if(this.leadVisit.Level_of_Interest__c == 'Converted'){
        console.log('if entered');
        
          if (product.Quantity__c == '') {
            console.log('if Quantity entered');
            this.productError = true;

          this.template.querySelectorAll('lightning-input-field[data-name="quantity"]').forEach(element => {
            console.log('if entered===');
            element.reportValidity();

          });
        }
        }
        continue;
      }

      // Check if the product group is already added
      if (productSet.has(product.Retail_Product_Group__c)) {
        this.productError = true;
        product.sameItemError = true;
      } 
      else {
        product.sameItemError = false;
        productSet.add(product.Retail_Product_Group__c);
      }
    }
    console.log('this.leadVisit.Follow_up_Date__c'+this.leadVisit.Follow_up_Date__c);
    if (this.leadVisit.Follow_up_Date__c < this.currentDate) {
      console.log('this.leadVisit.Follow_up_Date__c11111111'+this.leadVisit.Follow_up_Date__c);
      this.followupError = true;
      this.productError = true;

    }
    console.log('this.leadVisit.Seller_ID__c'+this.leadVisit.Seller_ID__c);
  if (this.leadVisit.Level_of_Interest__c == 'Converted' && this.leadVisit.Lead_Type__c == 'Farmer') {
    console.log('this.leadVisit.Seller_ID__c1111'+this.leadVisit.Seller_ID__c);
    if (this.leadVisit.Seller_ID__c==undefined ) {
      console.log('this.leadVisit.Seller_ID__c2222'+this.leadVisit.Seller_ID__c);
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="sellerId"]').forEach(element => {
        element.reportValidity();
      });
    }
    
   
  }
  else if (this.leadVisit.Sale_Type__c == 'Indirect') {
    if (this.leadVisit.Seller_ID__c==undefined ) {
      console.log('this.leadVisit.Seller_ID__c2222'+this.leadVisit.Seller_ID__c);
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="sellerId"]').forEach(element => {
        element.reportValidity();
      });
    }
  }
  else if(this.leadVisit.Sale_Type__c == 'Direct'){
    if (this.leadVisit.isOrderId==undefined || this.leadVisit.isOrderId==null || this.leadVisit.isOrderId=='') {
      console.log('this.leadVisit.isOrderId'+this.leadVisit.isOrderId);
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="orderId"]').forEach(element => {
        element.reportValidity();
      });
    }
  }
  if (this.leadVisit.Level_of_Interest__c == 'Converted' && this.leadVisit.Lead_Type__c == 'Retailer') {
    if (this.leadVisit.Sale_Type__c==undefined || this.leadVisit.Sale_Type__c==null) {
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="saleId"]').forEach(element => {
        element.reportValidity();
      });
    }
    if (this.leadVisit.Sale_Type__c == 'Indirect') {
      if (this.leadVisit.Seller_ID__c==undefined ) {
        console.log('this.leadVisit.Seller_ID__c2222'+this.leadVisit.Seller_ID__c);
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="sellerId"]').forEach(element => {
          element.reportValidity();
        });
      }
    }
    else if(this.leadVisit.Sale_Type__c == 'Direct'){
      if (this.leadVisit.isOrderId==undefined || this.leadVisit.isOrderId==null || this.leadVisit.isOrderId=='') {
        console.log('this.leadVisit.isOrderId'+this.leadVisit.isOrderId);
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="orderId"]').forEach(element => {
          element.reportValidity();
        });
      }
    }
    
  }
  if (this.leadVisit.Level_of_Interest__c == 'Converted' && this.leadVisit.Lead_Type__c == 'Distributor') {
    if (this.leadVisit.isOrderId==undefined || this.leadVisit.isOrderId==null || this.leadVisit.isOrderId=='') {
      console.log('this.leadVisit.isOrderId'+this.leadVisit.isOrderId);
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="orderId"]').forEach(element => {
        element.reportValidity();
      });
    }
  }
  if (this.leadVisit.Level_of_Interest__c == 'Cold Lead') {
    if (this.leadVisit.Reason_for_Cold_Lead__c==undefined || this.leadVisit.Reason_for_Cold_Lead__c==null || this.leadVisit.Reason_for_Cold_Lead__c=='') {
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="reasonForCold"]').forEach(element => {
        element.reportValidity();
      });
    }
    else if(this.leadVisit.Reason_for_Cold_Lead__c=='Other'){
      console.log('this.leadVisit.Reason_for_Cold_Lead__c'+this.leadVisit.Reason_for_Cold_Lead__c);
      console.log('this.leadVisit.Other_Reason_For_Cold__c===='+this.leadVisit.Other_Reason_For_Cold__c);
      
      if(this.leadVisit.Other_Reason_For_Cold__c== null || this.leadVisit.Other_Reason_For_Cold__c == undefined || this.leadVisit.Other_Reason_For_Cold__c==''){
        console.log('if entered 372');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="otherReasonForCold"]').forEach(element => {
          element.reportValidity();
        });
      }

    }
    
  }
  else if (this.leadVisit.Level_of_Interest__c == 'Interested') {
    if (this.leadVisit.Follow_up_Date__c==undefined || this.leadVisit.Follow_up_Date__c==null) {
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="sellerId"]').forEach(element => {
        element.reportValidity();
      });
    }
    
  }
  else if(this.leadVisit.Level_of_Interest__c == 'Converted'){
     
    if ((this.productList.Retail_Product_Group__c == null) || (this.productList.Retail_Product_Group__c == undefined || this.productList.Retail_Product_Group__c=='')) {
      //this.productError = true;
      console.log('this.productList.length'+this.productList.length);
      if (this.productList.length == 0) {
        this.productError = true;
        this.productList.push({
          Id:'',
          Retail_Product_Group__c: '',
          Quantity__c:''
        });
     
        this.isErrorProduct=true;
      }
    }
    else{
      this.productError = false;
    }
 
}
    console.log('this.productError'+this.productError);
    if (this.productError==false) {
      this.handleSave();
      if (this.leadVisit.Level_of_Interest__c == 'Converted' && (this.leadVisit.Linked_Customer__c==null ||this.leadVisit.Linked_Customer__c== '' || this.leadVisit.Linked_Customer__c==undefined)) {
        this.showToast("Please don't forget to link this lead with the associated customer!", 'info');
      }
      if(this.leadVisit.Level_of_Interest__c == 'Converted' && this.leadVisit.Lead_Type__c == 'Distributor' && (this.leadVisit.Order_ID__c!=null || this.leadVisit.Order_ID__c!=undefined || this.leadVisit.Order_ID__c!='')){
        this.leadVisit.Level_of_Interest__c == 'Incomplete Data';
      }
      else if(this.leadVisit.Lead_Type__c == 'Retailer' && (this.leadVisit.Order_ID__c!=null || this.leadVisit.Order_ID__c!=undefined || this.leadVisit.Order_ID__c!='') && (this.leadVisit.Seller_ID__c!=null || this.leadVisit.Seller_ID__c!=undefined || this.leadVisit.Seller_ID__c!='')){
        this.leadVisit.Level_of_Interest__c == 'Incomplete Data';
      }
    }
  }
  handleSave(event) {
    console.log('Entered');
    this.saveBool=true;
   if(this.leadVisit.Level_of_Interest__c == 'Cold Lead' || this.leadVisit.Level_of_Interest__c == 'Interested' || this.leadVisit.Level_of_Interest__c == 'Incomplete Data'){
      console.log('this.leadVisit========'+this.leadVisit);
          insertLeadVisit({leadId: this.leadVisit.Lead_Name__c,leadVisit: this.leadVisit})
          .then(data => {
            let LeadVisitData;
            LeadVisitData = data;
            console.log('LeadVisitData 514');
          
          const even = new ShowToastEvent({
            title: 'Success!',
            message: 'LeadVisit was saved successfully!',
            variant: 'success'
          });
    
          this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
              recordId: LeadVisitData,
              objectApiName: 'Retail_Lead_Visit__c',
              actionName: 'view'
            }
          });
        })
          this.dispatchEvent(event);
       
        }
        else if (this.productList && this.productList.length > 0 && this.leadVisit.Level_of_Interest__c == 'Converted') {
          console.log('save 477');
          insertLeadVisitWithProduct({ productList: this.productList, leadVisit: this.leadVisit,leadId: this.leadVisit.Lead_Name__c})
            .then(data => {
              let LeadVisitData;
              LeadVisitData = data;
              const even = new ShowToastEvent({
                title: 'Success!',
                message: 'LeadVisit was saved successfully!',
                variant: 'success'
              });
    
             
                this[NavigationMixin.Navigate]({
                  type: 'standard__recordPage',
                  attributes: {
                    recordId: LeadVisitData,
                    objectApiName: 'Retail_Lead_Visit__c',
                    actionName: 'view'
                  }
                });
            
            });
        }
        else if (this.productList.length == 0 && this.leadVisit.Level_of_Interest__c == 'Converted') {
          console.log('save 523');
            insertLeadVisitOnly({leadId: this.leadVisit.Lead_Name__c,leadVisit: this.leadVisit})
            .then(data => {
              let LeadVisitData;
              LeadVisitData = data;
              console.log('LeadVisitData 514');
            
            const even = new ShowToastEvent({
              title: 'Success!',
              message: 'LeadVisit was saved successfully!',
              variant: 'success'
            });
            this.dispatchEvent(even);
            this[NavigationMixin.Navigate]({
              type: 'standard__recordPage',
              attributes: {
                recordId: LeadVisitData,
                objectApiName: 'Retail_Lead_Visit__c',
                actionName: 'view'
              }
            });
          })
         
          }
          setTimeout(function(){
            window.location.reload();
         }, 1000);  
  }

  closeQuickAction() {
    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
        objectApiName: 'Retail_Lead_Visit__c',
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
  showToast(message, variant) {
    const toastEvent = new ShowToastEvent({
      message: message,
      variant: variant,
    });
    this.dispatchEvent(toastEvent);
  }
  get cssClass() {
    return this.isDisplaySellerId ? 'display-seller-id' : 'hide-seller-id';
}
}