import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import getLeadDetails from '@salesforce/apex/CustomerControllerForNew.getLeadDetails';
import getCustomerDetails from '@salesforce/apex/CustomerControllerForNew.getCustomerDetails';
import updateLead from '@salesforce/apex/CustomerControllerForNew.updateLead';

export default class editOverrideCustomer extends NavigationMixin(LightningElement) {
   
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
    @track customerLeadId;
    @track currentDate;
    @track customerNameChangeValue;
    @track isDisplayHideFields = false;
    @track orderCounterValue;
    @track returningCustomerValue;
    @track isPreviousPaymentValue;
    @track blacklistedValue;
    @track greyListedValue;
    @track villageValue;
    @track customerError = false;
    @track customerTypeValue;
    @track GSTNumberValue;
    @track validateGST = false;
    @track pincodeValue;
    @track validatePin = false;
    @track panNumberValue;
    @track validatePAN = false;
    @track validatePhone = false;
    @track phonevalue;
    @track ownerValue;
    @track linkLeadIdValue;
    @track nameValue;
    @track lastNameValue;
    @track billingFirstName;
    @track billingLastName;
    @track shopAddress;
    @track countryCodeValue;
    @track emailValue;
    @track assignCreditLimitValue;
    @track creditLimitValue;
    @track creditLimitUsedValue;
    @track creditLimitPending;
    @track creditLimitOvershotValue;
    @track createdbyValue;
    @track lastModifiedValue;
    @track isDisplayWarehouseCode=false;
    @track warehouseCodeValue;
    @track isErrorWarehouse=false;

    connectedCallback() {
        this.base64Context = this.pageRef.state.inContextOfRef;
        if (this.base64Context.startsWith("1\.")) {
            this.base64Context = this.base64Context.substring(2);
        }
        this.addressableContext = JSON.parse(window.atob(this.base64Context));
        this.parentId = this.addressableContext.attributes.recordId;
      
    }
    handelOnload(event) {
        var record = event.detail.records;
        var fields = record[this.recordId].fields;

         this.ownerValue = fields.OwnerId.value;
         this.currentDate = fields.Date__c.value;
         this.linkLeadIdValue = fields.Link_Lead_ID__c.value;
        // console.log(' this.linkLeadIdValue' + this.linkLeadIdValue);
        //  this.customerTypeValue = fields.Customer_Type__c.value;
        //  if(this.customerTypeValue=='Distributor'){
        //     this.isDisplayWarehouseCode=true;
        // }
        
         this.nameValue = fields.Name__c.value;
         this.lastNameValue = fields.Last_Name__c.value;
         this.billingFirstName = fields.Billing_First_Name__c.value;
         this.billingLastName = fields.Billing_Last_Name__c.value;
        this.shopName = fields.Shop_Name__c.value;
        this.shopAddress = fields.Shop_Address__c.value;
         this.countryCodeValue = fields.Country_Code__c.value;
         this.phonevalue = fields.Phone_Number__c.value;
        this.emailValue = fields.Email__c.value;
         this.GSTNumberValue = fields.GST_Number__c.value;
         this.panNumberValue = fields.PAN_Number__c.value;
         this.stateValue = fields.State__c.value;
        this.districtValue = fields.District__c.value;
         this.talukaValue = fields.Taluka__c.value;
         this.villageValue = fields.Village__c.value;
        this.pincodeValue = fields.Pin_code__c.value;
        this.assignCreditLimitValue = fields.Assign_Credit_limit__c.value;
        this.creditLimitValue = fields.Credit_Limit__c.value;
        this.creditLimitUsedValue = fields.Credit_Limit_Used__c.value;
        this.creditLimitPending = fields.Credit_Limit_Pending__c.value;
        this.creditLimitOvershotValue = fields.Credit_Limit_Overshot__c.value;
         this.createdbyValue = fields.CreatedById.value;
        this.lastModifiedValue = fields.LastModifiedById.value;
         //this.customerNameChangeValue = fields.New_Customer__c.value;
        // this.orderCounterValue = fields.Order_Counter__c.value;
        // this.returningCustomerValue = fields.Returning_Customer__c.value;
        // this.isPreviousPaymentValue = fields.Is_Previous_Payment_Pending__c.value;
        // this.blacklistedValue = fields.Blacklisted__c.value;
        // this.greyListedValue = fields.Greylisted__c.value;
    }

    onchangePhone(event) {
        this.phonevalue = event.target.value;
        this.validatePhone = false;
        const phoneRegex = /^[0-9]{10}$/;
        if (!phoneRegex.test(this.phonevalue)) {
            this.validatePhone = true;
        }
    }
    
    onchangeLeadShopName(event) {
        this.shopName = event.target.value;

    }
    onchangeCustomerType(event) {
        this.isDisplayWarehouseCode=false;
        this.customerTypeValue = event.target.value;
        if(this.customerTypeValue=='Distributor'){
            this.isDisplayWarehouseCode=true;
        }
       
    }
    onchangeGSTnumber(event) {
        this.GSTNumberValue = event.target.value;
    }
    onchangePanNumber(event) {
        this.panNumberValue = event.target.value;

    }
    onchangePincode(event) {
        this.pincodeValue = event.target.value;
        console.log('this.pincodeValue' + this.pincodeValue);
    }
    handleChangeWarehouseCode(event){
        this.warehouseCodeValue=event.target.value;
    }
   
    handleLeadChange(event) {
        this.masterId = event.target.value;
        this.stateValue = '';
        this.districtValue = '';
        this.talukaValue = '';
        this.villageValue = '';
        this.shopName = '';
        this.phonevalue = '';
        this.customerNameChangeValue = '';
        this.orderCounterValue = null;
        this.returningCustomerValue = '';
        this.isPreviousPaymentValue = '';
        this.blacklistedValue = '';
        this.greyListedValue = '';
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
                                        this.villageValue = leadData.Village__c;
                                        this.shopName = leadData.Lead_Name__c;
                                        this.phonevalue = leadData.Phone__c;
                                        this.customerNameChangeValue = 'Yes';
                                        console.log('this.customerNameChangeValue' + this.customerNameChangeValue);
                                        this.orderCounterValue = 0;
                                        console.log('this.orderCounterValue' + this.orderCounterValue);
                                        this.returningCustomerValue = 'No';
                                        this.isPreviousPaymentValue = 'No';
                                        this.blacklistedValue = 'No';
                                        this.greyListedValue = 'No';


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
            this.villageValue = '';
            this.shopName = '';
            this.phonevalue = '';
            this.customerNameChangeValue = '';
            this.orderCounterValue = null;
            this.returningCustomerValue = '';
            this.isPreviousPaymentValue = '';
            this.blacklistedValue = '';
            this.greyListedValue = '';

        }
    }


    handleSubmit(event) {
        this.customerError = false;
        this.isErrorWarehouse=false;
        this.validateGST = false;
        this.validatePin = false;
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        if (this.customerLeadId && this.customerLeadId === this.masterId) {
            this.customerError = true;
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'This lead is already assigned to a different customer',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }

        if (this.GSTNumberValue && this.GSTNumberValue.length < 15) {
            this.customerError = true;
            this.validateGST = true;
            this.errorMessage = 'GST number must have 15 characters!';
        } else {
            this.validateGST = false;
            this.errorMessage = '';
        }
        if (this.pincodeValue.length < 6) {
            console.log('this.pincodeValue if' + this.pincodeValue);
            this.customerError = true;
            this.validatePin = true;

        } else {
            this.validatePin = false;
        }
        if (this.panNumberValue && this.panNumberValue.length < 10) {
            console.log('this.panNumberValue if' + this.panNumberValue);
            this.customerError = true;
            this.validatePAN = true;

        } else {
            this.validatePAN = false;
        }

        if (this.phonevalue) {
            const phoneRegex = /^[0-9]{10}$/;
            if (!phoneRegex.test(this.phonevalue)) {
                this.validatePhone = true;
                this.customerError = true;
            }
        }
        if(this.isDisplayWarehouseCode==true){
            console.log('this.isDisplayWarehouseCode'+this.isDisplayWarehouseCode);
        if(this.customerTypeValue=='Distributor') {
            console.log('this.customerTypeValue'+this.customerTypeValue);
            console.log('this.warehouseCodeValue111'+this.warehouseCodeValue);
        if(this.warehouseCodeValue==null || this.warehouseCodeValue==undefined || this.warehouseCodeValue==''){
            console.log('this.warehouseCodeValue22'+this.warehouseCodeValue);
            this.isErrorWarehouse=true;
            this.customerError = true;
        }
        else{
            this.customerError = false; 
            this.isErrorWarehouse=false;
        }   
    }
    }

        if (this.customerError == false) {
            console.log(' this.customerError204;' + this.customerError);
            if (this.shopName != '' || this.shopName != null || this.shopName != undefined) {
                console.log('this.shopName' + this.shopName);
                updateLead({ leadId: this.masterId })
                    .then(result => {
                        let leadData = result;
                        console.log('result' + result);
                    })
                    .catch(error => {
                        console.error('Error retrieving customer details:', error);
                    });
            }
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }

    }


    handleSave(event) {
        this.isDisplayHideFields = false;
        const recordId = event.detail.id;
        console.log('recordId' + recordId);

        const even = new ShowToastEvent({
            title: 'Success!',
            message: 'Customer was edited successfully!',
            variant: 'success'
        });
        this.dispatchEvent(even);
 
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Retail_Customer__c',
                actionName: 'view'
            }
        });

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