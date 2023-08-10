import { LightningElement, api,track,wire} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getLeadVisit from '@salesforce/apex/NewOverrideLeadVisitController.getLeadVisit';
import { CurrentPageReference } from 'lightning/navigation';
export default class ModalPopup extends NavigationMixin(LightningElement)  {
  @api recordId;
  @track validateError=false;
  @track leadVisit={};
  @track isDisplaySellerId=true;
  @track showErrorSellerID=false;
  @api parentId;
  @track isDisplayOtherText=false;
  @track sellerIdValue;
  @track isDisplayOrderId=true;
  @track showErrorOrderID=false;
  @track OrderIdValue;
 
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
      getLeadVisit({ leadVisitId: this.recordId })
      .then(result => {
        this.leadVisit = result;
      console.log('this.leadVisit.Lead_Type__c'+this.leadVisit.Lead_Type__c);
      if (this.leadVisit.Lead_Type__c == 'Farmer') {
        this.isDisplaySellerId = false;
      }
      else if(this.leadVisit.Lead_Type__c != 'Farmer' && this.leadVisit.Level_of_Interest__c=='Converted'){
        //this.showErrorOrderID=true;
        this.isDisplayOrderId = false;
      }
      if(this.leadVisit.Lead_Type__c == 'Farmer' && this.leadVisit.Level_of_Interest__c=='Incomplete Data'){
        this.showErrorSellerID=true;
        this.isDisplaySellerId = false;
      }
      

      if(this.leadVisit.Level_of_Interest__c=='Cold Lead'){
        if(this.leadVisit.Reason_for_Cold_Lead__c!=null || this.leadVisit.Reason_for_Cold_Lead__c!='' || this.leadVisit.Reason_for_Cold_Lead__c!= undefined){
          console.log('this.leadVisit.Other_Reason_For_Cold__c'+this.leadVisit.Other_Reason_For_Cold__c);
    
      if(this.leadVisit.Other_Reason_For_Cold__c!=null || this.leadVisit.Other_Reason_For_Cold__c!='' || this.leadVisit.Other_Reason_For_Cold__c!= undefined){
        console.log('this.leadVisit.Other_Reason_For_Cold__c====60'+this.leadVisit.Other_Reason_For_Cold__c);
        this.isDisplayOtherText=true;
      }
      }
      
  }
  if(this.leadVisit.Order_ID__c!=null || this.leadVisit.Order_ID__c!='' || this.leadVisit.Order_ID__c!=undefined ){
    this.OrderIdValue=this.leadVisit.Order_ID__c;

  }
  if(this.leadVisit.Seller_ID__c!=null || this.leadVisit.Seller_ID__c!='' || this.leadVisit.Seller_ID__c!=undefined ){
    this.sellerIdValue=this.leadVisit.Seller_ID__c;

  }
    })
    .catch(error => {
      // Handle the error
      console.error('Error retrieving lead visit:', error);
    });
  }

  closeModal() {
    this.dispatchEvent(new CustomEvent('close'));
  }
 /* handleOnChangeName(event){
    
        this.leadVisit.Lead_Name__c= event.target.value;
  }
  handleOnChangeLeadType(event){
    
    this.leadVisit.Lead_Type__c = event.target.value;
  }
  handleOnChangeLevelOfInterest(event){
   
    this.leadVisit.Level_of_Interest__c = event.target.value;
   
  }*/
  handleOnchangeSeller(event){
    //this.isDisplaySellerId = false;
   this.sellerIdValue = event.target.value;
    //this.leadVisit.Seller_ID__c=event.target.value;
    console.log('sellerIdValue'+ this.leadVisit.Seller_ID__c);
  }
  handleOnchangeOrderId(event){
   this.OrderIdValue=event.target.value;
    //this.leadVisit.Order_ID__c=event.target.value;
    console.log('OrderIdValue'+this.leadVisit.Order_ID__c);
  
  }
  /*handleOnChangeFollowup(event) {
    //this.isDisplayFollowup = false;
    this.leadVisit.Follow_up_Date__c = event.target.value;

  }*/
  handleOnchangeReasonforCold(event){
    this.leadVisit.Reason_for_Cold_Lead__c = event.target.value;
  }
  handleOnchangeOtherReasonforCold(event){
  this.leadVisit.Other_Reason_For_Cold__c = event.target.value;
  console.log('this.leadVisit.Other_Reason_For_Cold__c'+this.leadVisit.Other_Reason_For_Cold__c);
  
  }
 /* handleOnChangeSaleType(event) {
   
    //this.isDisplaySaleId = false;
    this.leadVisit.Sale_Type__c = event.target.value;
  }*/
  handleSubmit(event){
    this.validateError=false;
    event.preventDefault();       // stop the form from submitting
    const fields = event.detail.fields;
    if(this.isDisplaySellerId == false){
      if(this.sellerIdValue=='' || this.sellerIdValue== null ||this.sellerIdValue==undefined){
        this.validateError=true;
        this.showErrorSellerID=true;
      }

    }
      if(this.isDisplayOrderId == false){
        if(this.OrderIdValue=='' || this.OrderIdValue== null ||this.OrderIdValue==undefined){
          if(this.leadVisit.Lead_Type__c != 'Farmer' && this.leadVisit.Level_of_Interest__c=='Converted'){
          this.validateError=true;
          this.showErrorOrderID=true;
          }
        }
      }
    
      if(this.validateError==false){
        this.template.querySelector('lightning-record-edit-form').submit(fields);
      }
    
    
  }


  handleSave(event) {
    console.log("Entered");
    
                const even = new ShowToastEvent({
                  title: 'Success!',
                  message: 'LeadVisit was saved successfully!',
                  variant: 'success'
              });
  
              if (this.parentId == undefined) {
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
            }
            else if (this.parentId != this.recordId) {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.parentId,
                        objectApiName: 'Retail_Lead__c',
                        actionName: 'view'
                    }
                });
            }

            else if (this.parentId == this.recordId) {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recordId,
                        objectApiName: 'Retail_Lead_Visit__c',
                        actionName: 'view'
                    }
                });
            }
            this.dispatchEvent(even);
           
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
}