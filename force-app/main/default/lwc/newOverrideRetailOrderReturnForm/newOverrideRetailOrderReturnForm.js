import { LightningElement, api, track, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import insertOrderWithProduct from '@salesforce/apex/NewOverrideOrderReturnController.insertOrderWithProduct';

export default class newOverrideRetailOrderReturnForm extends NavigationMixin(LightningElement) {
  @api recordId;
  @track productError=false;
  @track productList = [];
  @api parentId;
  @track orderList = {};
 
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
    this.orderList.Order_Date__c = `${year}-${month}-${day}`;
    this.base64Context = this.pageRef.state.inContextOfRef;
    if (this.base64Context.startsWith("1\.")) {
      this.base64Context = this.base64Context.substring(2);
    }
    this.addressableContext = JSON.parse(window.atob(this.base64Context));
    this.parentId = this.addressableContext.attributes.recordId;
    this.orderList.Retail_Customer__c=this.parentId;
    this.addRow();

  }
  
  onchangeUploadCreditNote(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeOwnerId(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeOrderId(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeRetailCustomer(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeWarehouse(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
 

  handleOnchangeProductGroup(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeProduct(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeHoleType(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeHoleSapcing(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }

  onchangeStdPkgSizes(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  handleChangeQuantity(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeUnitPrices(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeDiscountedUnitPrice(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeKgRate(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeDiscountedKgRate(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeWeight(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeSubTotal(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeNetTotal(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeReturnQuantity(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeDeliveryDate(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeOrderDiscount(event){
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeReturnQuantity(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeReturnWeight(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeReturnNetTotalForProduct(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
 
  onchangeComments(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeReturnFreightChargeBearer(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeCreditNote(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeReturnNetTotal(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeReturnSubTotal(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }

  onchangeModeOfRefund(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeReasonForReturn(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }

  addRow(event) {

    this.productList.push({
      Id: '',
      Product_Group__c: '',
      Products__c: '',
      Hole_Type__c: '',
      Hole_Spacing__c: '',
      Std_Pkg_Sizes__c: '',
      Quantity__c: '',
      Unit_Price__c: '',
      Discounted_Unit_Price__c: '',
      Kg_Rate__c: '',
      Discounted_Kg_Rate__c: '',
      Weight_Kg__c: '',
      Sub_Total__c: '',
      Product_Discount__c: '',
      Net_Total_for_Product__c: '',
      Return_Quantity__c:'',
      Return_Weight__c:'',
      Return_Net_Total_for_Product__c:''

    });
  }
  removeRow(event) {
    const index = event.currentTarget.dataset.index;
    if (this.productList.length > 1) {
      this.productList.splice(index, 1);
    }

  }
  

  validateError() {
    this.productError=false;
    // if(this.productList.product.Product__c==null || this.productList.product.Product__c=='' || this.productList.product.Product__c==undefined){
    //   this.productError = true;
    //   this.template.querySelectorAll('lightning-input-field[data-name="product"]').forEach(element => {
    //     element.reportValidity();
        
    //   });
    // }
    let productSet = new Set(); 
    for (let i = 0; i < this.productList.length; i++) {
      const product = this.productList[i];
      product.productComplete = false;
      console.log('if entered 221 ');
      // Check if the product group is empty
   if(product.Products__c==null || product.Products__c=='' || product.Products__c==undefined){
      this.productError = true;
        console.log('if entered');
        this.template.querySelectorAll('lightning-input-field[data-name="product"]').forEach(element => {
          console.log('if entered===');
          element.reportValidity();
        });
        
      }
      if (product.Quantity__c == '' || product.Quantity__c ==null || product.Quantity__c ==undefined) {
        console.log('if Quantity entered');
        this.productError = true;

      this.template.querySelectorAll('lightning-input-field[data-name="quantity"]').forEach(element => {
        console.log('if entered===');
        element.reportValidity();

      });
    }
    }
    if(this.productError==false){
      this.handleSave();
    }
  }
  handleSave(event) {
    if (this.productList && this.productList.length > 0) {
    insertOrderWithProduct({ productList: this.productList, order: this.orderList })
      .then(data => {
        let orderId;
        orderId = data;
        console.log('orderId 514');

        const even = new ShowToastEvent({
          title: 'Success!',
          message: 'Order was saved successfully!',
          variant: 'success'
        });
        this.dispatchEvent(even);

        this[NavigationMixin.Navigate]({
          type: 'standard__recordPage',
          attributes: {
            recordId: orderId,
            objectApiName: 'Retail_Order__c',
            actionName: 'view'
          }
        });
      })
    this.dispatchEvent(new CloseActionScreenEvent());
    }
  }
  closeQuickAction(event) {
    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
        objectApiName: 'Retail_Order__c',
        actionName: 'list'
      },
      state: {
        filterName: 'Recent'
      },
    })
    this.dispatchEvent(new CloseActionScreenEvent());
   
  }

}