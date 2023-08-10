import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import getLeadDetails from '@salesforce/apex/CustomerControllerForNew.getLeadDetails';
import getCustomerDetails from '@salesforce/apex/CustomerControllerForNew.getCustomerDetails';
import updateLead from '@salesforce/apex/CustomerControllerForNew.updateLead';
import getCustomerPhoneDetails from '@salesforce/apex/CustomerControllerForNew.getCustomerPhoneDetails';
import OrderRelatedCustomer from '@salesforce/apex/CustomerControllerForNew.OrderRelatedCustomer';
import getCustomerEmailDeatils from '@salesforce/apex/CustomerControllerForNew.getCustomerEmailDeatils';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
export default class newOverrideCustomer extends NavigationMixin(LightningElement) {
    @track showEditpage = true;
    @api recordId;
    @api parentId;
    base64Context;
    addressableContext;
    @wire(CurrentPageReference)
    pageRef;
    @api masterId;
   @track stateValue;
   @track districtValue;
   @track talukaValue;
   @track shopName;
   @track phone;
   @track customerLeadId;
   @track validatePAN=false;
   currentDate;
   @track customerNameChangeValue;
   @track isDisplayHideFields=false;
   @track orderCounterValue;
   @track returningCustomerValue;
   @track isPreviousPaymentValue;
   @track blacklistedValue;
   @track greyListedValue;
   @track villageValue;
   @track customerError=false;
   @track customerTypeValue;
   @track GSTNumberValue;
   @track validateGST=false;
   @track pincodeValue;
   @track validatePin=false;
   @track panNumberValue;
   @track validatePAN=false;
   @track validatePhone=false;
   @track phonevalue;
   @track customerPhone;
   @track validateUniquePhone=false;
   @track saveBool=false;
   @track emailValue;
   @track customerEamil;
   @track validateUniqueEmail=false;
  
   wiredRecordResult;
   
  
    connectedCallback() {
        console.log('onload ==');
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
        this.masterId=this.parentId;
        // if(this.recordId!=null || this.recordId!=undefined || this.recordId!=''){
        //     console.log('recordId===='+this.recordId);
        //     this.masterId=this.recordId;
        // } 
        if (this.masterId && (this.masterId != '' || this.masterId != null || this.masterId != undefined)) {
            getCustomerDetails({ masterId: this.masterId })
                .then(result => {
                    let customerData = result;
                    
                    if (customerData) {
                        console.log('customerData' + customerData);
                        this.customerLeadId = customerData.Link_Lead_ID__c;
                        console.log('this.customerLeadId=======' + this.customerLeadId);
    
                        if (this.customerLeadId === this.masterId) {
                            console.log('if else entered');
                            const evt = new ShowToastEvent({
                                title: 'Error',
                                message: 'Please select a lead that is not linked to a customer yet!',
                                variant: 'error',
                            });
                            this.dispatchEvent(evt);
                        } else {
                            getLeadDetails({ masterId: this.masterId })
                                .then(result => {
                                    let leadData = result;
                                    if (leadData) {
                                        this.stateValue = leadData.RetailLeadState__c;
                                        this.districtValue = leadData.Retail_Lead_District__c;
                                        this.talukaValue = leadData.Retail_Lead_Taluka__c;
                                        this.villageValue=leadData.Village__c;
                                        this.shopName = leadData.Lead_Name__c;
                                        this.phonevalue = leadData.Phone__c;
                                        this.customerNameChangeValue = 'Yes';
                                        console.log('this.customerNameChangeValue'+this.customerNameChangeValue);
                                        this.orderCounterValue=0;
                                        console.log('this.orderCounterValue'+this.orderCounterValue);
                                        this.returningCustomerValue='No';
                                        this.isPreviousPaymentValue='No';
                                        this.blacklistedValue='No';
                                        this.greyListedValue='No';


                                    }
                                })
                                .catch(error => {
                                    console.error('Error retrieving customer details:', error);
                                });
                        }
                    }
                })
                .catch(error => {
                    console.error('Error retrieving lead details:', error);
                });
            }
        console.log('recordID------>',this.parentId);
    }
    
    onchangePhone(event){
        this.phonevalue=event.target.value;
        this.validatePhone=false;
        this.validateUniquePhone=false;
        const phoneRegex = /^[0-9]{10}$/;
        if (!phoneRegex.test(this.phonevalue)) {
            this.validatePhone=true;
        }
        if ( this.phonevalue && ( this.phonevalue != '' ||  this.phonevalue != null ||  this.phonevalue != undefined)) {
            getCustomerPhoneDetails({ phone:  this.phonevalue })
                .then(result => {
                    let customerData = result;
                    
                    if (customerData) {
                        console.log('customerData' + customerData);
                        this.customerPhone = customerData.Phone_Number__c;
                        console.log('this.customerPhone=======' +this.customerPhone);
                    }
                    if(this.customerPhone== this.phonevalue){
                        this.validateUniquePhone=true;
                        console.log('this.validateUniquePhone=======' +this.validateUniquePhone);
                    }
                });
            }

        }
    onchangeEmail(event){
        this.emailValue=event.target.value;
        this.validateUniqueEmail=false;
        if ( this.emailValue && ( this.emailValue != '' ||  this.emailValue != null ||  this.emailValue != undefined)) {
            getCustomerEmailDeatils({ email:  this.emailValue })
                .then(result => {
                    let customerData = result;
                    
                    if (customerData) {
                        console.log('customerData' + customerData);
                        this.customerEamil = customerData.Email__c;
                        console.log('this.customerEamil =======' +this.customerEamil );
                    }
                    if(this.customerEamil== this.emailValue){
                        this.validateUniqueEmail=true;
                        console.log('this.validateUniqueEmail=======' +this.validateUniqueEmail);
                    }
                });
            }

    }
    onchangeNewCustomer(event){
        this.customerNameChangeValue=event.target.value;
    }
    onchangeLeadShopName(event){
        this.shopName=event.target.value;
       
    }
    onchangeCustomerType(event){
        this.customerTypeValue=event.target.value;
    }
    onchangeGSTnumber(event){
        this.GSTNumberValue=event.target.value;
    }
    onchangePanNumber(event){
        this.panNumberValue=event.target.value;

    }
    onchangePincode(event){
        this.pincodeValue=event.target.value;
        console.log('this.pincodeValue'+this.pincodeValue);
    }
    onchangeNewCustomer(event){
        this.customerNameChangeValue=event.target.value;
    }
    handleLeadChange(event) {
        this.masterId = event.target.value;
        this.stateValue = '';
            this.districtValue = '';
            this.talukaValue = '';
            this.villageValue='';
                                        this.shopName = '';
                                        this.phonevalue = '';
                                        this.customerNameChangeValue = '';
                                        this.orderCounterValue=null;
                                        this.returningCustomerValue='';
                                        this.isPreviousPaymentValue='';
                                        this.blacklistedValue='';
                                        this.greyListedValue='';
        console.log('this.masterId===============' + this.masterId);
        if (this.masterId && (this.masterId != '' || this.masterId != null || this.masterId != undefined)) {
            getCustomerDetails({ masterId: this.masterId })
                .then(result => {
                    let customerData = result;
                    
                    if (customerData) {
                        console.log('customerData' + customerData);
                        this.customerLeadId = customerData.Link_Lead_ID__c;
                        console.log('this.customerLeadId=======' + this.customerLeadId);
    
                        if (this.customerLeadId === this.masterId) {
                            console.log('if else entered');
                            const evt = new ShowToastEvent({
                                title: 'Error',
                                message: 'Please select a lead that is not linked to a customer yet!',
                                variant: 'error',
                            });
                            this.dispatchEvent(evt);
                        } else {
                            getLeadDetails({ masterId: this.masterId })
                                .then(result => {
                                    let leadData = result;
                                    if (leadData) {
                                        this.stateValue = leadData.RetailLeadState__c;
                                        this.districtValue = leadData.Retail_Lead_District__c;
                                        this.talukaValue = leadData.Retail_Lead_Taluka__c;
                                        this.villageValue=leadData.Village__c;
                                        this.shopName = leadData.Lead_Name__c;
                                        this.phonevalue = leadData.Phone__c;
                                        this.customerNameChangeValue = 'Yes';
                                        console.log('this.customerNameChangeValue'+this.customerNameChangeValue);
                                        this.orderCounterValue=0;
                                        console.log('this.orderCounterValue'+this.orderCounterValue);
                                        this.returningCustomerValue='No';
                                        this.isPreviousPaymentValue='No';
                                        this.blacklistedValue='No';
                                        this.greyListedValue='No';


                                    }
                                })
                                .catch(error => {
                                    console.error('Error retrieving customer details:', error);
                                });
                        }
                    }
                })
                .catch(error => {
                    console.error('Error retrieving lead details:', error);
                });
        } else {
            this.stateValue = '';
            this.districtValue = '';
            this.talukaValue = '';
            this.villageValue='';
                                        this.shopName = '';
                                        this.phonevalue= '';
                                        this.customerNameChangeValue = '';
                                        this.orderCounterValue=null;
                                        this.returningCustomerValue='';
                                        this.isPreviousPaymentValue='';
                                        this.blacklistedValue='';
                                        this.greyListedValue='';

        }
    }
   
 
    handleSubmit(event){
        this.saveBool=true;
        this.customerError=false;
        this.validateGST=false;
        this.validatePin=false;
        this.validateUniquePhone=false;
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        console.log('fields ============',JSON.stringify(fields));
        if (this.customerLeadId && this.customerLeadId === this.masterId) {
            this.customerError=true;
            this.saveBool=false;
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'This lead is already assigned to a different customer',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }

        if (this.GSTNumberValue && this.GSTNumberValue.length < 15) {
            this.customerError=true;
            this.saveBool=false;
            this.validateGST = true;
            this.errorMessage = 'GST number must have 15 characters!';
        } else {
            this.validateGST = false;
            this.saveBool=true;
            this.errorMessage = '';
        }
        if (this.pincodeValue.length < 6) {
            console.log('this.pincodeValue if'+this.pincodeValue);
            this.customerError=true;
            this.saveBool=false;
            this.validatePin = true;
          
        } else {
            this.validatePin = false;
        }
        if (this.panNumberValue && this.panNumberValue.length < 10) {
            console.log('this.panNumberValue if'+this.panNumberValue);
            this.saveBool=false;
            this.customerError=true;
            this.validatePAN = true;
           
        } else {
            this.validatePAN = false;
        }
        
    if (this.phonevalue) {
        const phoneRegex = /^[0-9]{10}$/;
        if (!phoneRegex.test(this.phonevalue)) {
            this.validatePhone=true;
            this.saveBool=false;
            this.customerError=true;
        }
        if(this.customerPhone== this.phonevalue){
            this.validateUniquePhone=true;
            this.saveBool=false;
            this.customerError=true;
            console.log('this.validateUniquePhone=======' +this.validateUniquePhone);
        }
    }
    if (this.emailValue) {
        
        if(this.customerEamil== this.emailValue){
            this.validateUniqueEmail=true;
            this.saveBool=false;
            this.customerError=true;
            console.log('this.validateUniqueEmail=======' +this.validateUniqueEmail);
        }
    }

         
        if( this.customerError==false){
            this.saveBool=true;
            console.log(' this.customerError204;'+this.customerError);
            if(this.shopName!='' || this.shopName!= null || this.shopName!=undefined){
                console.log('this.shopName'+this.shopName); 

                updateLead({  leadId: this.masterId  })
                .then(result => {
                 let leadData = result;
                 console.log('result'+result);
             })
             .catch(error => {
                 console.error('Error retrieving customer details:', error);
             });
             }
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }
       
     }
     @wire(getRecord, { recordId: '$recordId', fields: [] })
wiredRecord(result) {
    this.wiredRecordResult = result;
}

    handleSave(event) {
        this.saveBool=true;
        this.isDisplayHideFields = false;
        const recordId = event.detail.id;
        console.log('recordId'+recordId);
        const even = new ShowToastEvent({
            title: 'Success!',
            message: 'Customer was saved successfully!',
            variant: 'success'
        });
        this.dispatchEvent(even); 

        this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId:recordId,
                    objectApiName: 'Retail_Customer__c',
                    actionName: 'view'
                }
            });

            setTimeout(function(){
                window.location.reload();
             }, 1000);       
        
            this.dispatchEvent(new CloseActionScreenEvent());

        
    }
    

    closeQuickAction() {
        if (this.parentId == undefined) {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Retail_Customer__c',
                    actionName: 'list'
                },
                state: {
                    filterName: 'Recent'
                },
            });
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
                    objectApiName: 'Retail_Customer__c',
                    actionName: 'view'
                }
            });
        }
        this.dispatchEvent(even);
       
    }
}