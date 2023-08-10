import { LightningElement, api, track, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import insertOrderWithProduct from '@salesforce/apex/NewOverrideOrderController.insertOrderWithProduct';
import getPrevoiusOrders from '@salesforce/apex/NewOverrideOrderController.getPrevoiusOrders';
import getProductDetails from '@salesforce/apex/NewOverrideOrderController.getProductDetails';
import getUnitPrice from '@salesforce/apex/NewOverrideOrderController.getUnitPrice';
import getMulchProductGroup from '@salesforce/apex/NewOverrideOrderController.getMulchProductGroup';
import getCustomerDetails from '@salesforce/apex/NewOverrideOrderController.getCustomerDetails';
import getLeadVisitOptions from '@salesforce/apex/NewOverrideOrderController.getLeadVisitOptions';
import getProductOptions from '@salesforce/apex/NewOverrideOrderController.getProductOptions';
export default class NewOverrideRetailOrder extends NavigationMixin(LightningElement) {
  @api recordId;
  @track productError = false;
  @track productList = [];
  @api parentId;
  @track orderList = {};
  @track isOrderCustomer;
  @track isMulchProductGroup=false;
  @track isDisplayWarehouse = false;
  @track isDisplayReceiptWarehouse = false;
  @track isFreightCharge = false;
  @track isDisableStdPkg = false;
  @track isErrorQuantity = false;
  @track isAfterAdvance = false;
  @track OrderCustomerDetails;
  @track productStdPkg;
  @track inventoryDetails;
  @track isDisableFreightCharge=false;
  @track saveBool=false;
  @track relatedLeadVisitData=[];
  @track relatedProductData=[];
  @track chosenValue = '';
  @track productChoosenValue='';

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
    this.orderList.Retail_Customer__c = this.parentId;
    this.orderList.Order_Discount__c=0;
    this.orderList.Advance__c=0;
    this.orderList.Credit__c=0;
    this.addRow();

  }

  onchangeOrderDate(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeOwnerId(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeOrderType(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
    this.isDisplayWarehouse = false;
    this.isDisplayReceiptWarehouse = false;
    this.orderList.Order_Discount__c = 0;
    if (this.orderList[fieldName] == 'Internal Stock Transfer') {
      this.isDisplayWarehouse = true;
      this.isDisplayReceiptWarehouse = true;
      this.orderList.Order_Discount__c = 10;
    }
  }
  onchangeReceiptWarehouse(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;

  }
  onchangeWarehouse(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
    if (this.orderList[fieldName] != '' || this.orderList[fieldName] != null || this.orderList[fieldName] != undefined) {
      this.orderList.Retail_Warehouse__c = this.orderList[fieldName];
    }

  }
  onchangeRetailCustomer(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
    this.orderList.Freight_Charge_Bearer_values__c = null;
    this.isDisableFreightCharge=false;
    this.relatedLeadVisitData='';
    this.chosenValue = '';
    this.orderList.Add_Lead_Visit_Visit_Id__c='';
    console.log('this.orderList[fieldName]' + this.orderList[fieldName]);
    if (this.orderList[fieldName] != null || this.orderList[fieldName] != undefined || this.orderList[fieldName] != '') {
      getPrevoiusOrders({ customerId: this.orderList[fieldName] })
        .then(result => {
          this.isOrderCustomer = result;
          console.log(' this.isOrderCustomer========' + this.isOrderCustomer);

          if (this.isOrderCustomer != null) {
            this.orderList.Freight_Charge_Bearer_values__c = 'Customer';
            this.isDisableFreightCharge=true;
          }
        })

      getCustomerDetails({ customerId: this.orderList[fieldName] })
        .then(result => {
          this.OrderCustomerDetails = result;
          console.log(' this.isOrderCustomer========' + this.OrderCustomerDetails.GST_Number__c);

          if ((this.OrderCustomerDetails.GST_Number__c == null || this.OrderCustomerDetails.GST_Number__c == 0 || this.OrderCustomerDetails.GST_Number__c == '' || this.OrderCustomerDetails.GST_Number__c == undefined) && (this.OrderCustomerDetails.PAN_Number__c == null || this.OrderCustomerDetails.PAN_Number__c == 0 || this.OrderCustomerDetails.PAN_Number__c == '' || this.OrderCustomerDetails.PAN_Number__c == undefined)) {
            const evt = new ShowToastEvent({
              title: 'Alert For Customer PAN and GST Numbers',
              message: 'Please ensure GST and PAN Number in Customer',
              variant: 'warning',
              mode: 'dismissable'
            });
            this.dispatchEvent(evt);

          }
        })
        getLeadVisitOptions({ customerId: this.orderList[fieldName] })
        .then(result => {
          console.log(' result========' + JSON.stringify(result));
          console.log('result.length==='+result.length);
          for(let i=0; i<result.length; i++) {
            console.log('id=' + result[i].Id);
            this.relatedLeadVisitData = [...this.relatedLeadVisitData ,{value: result[i].Id , label: result[i].Name}];      
         
          //console.log(' this.relatedLeadVisitData========' + this.relatedLeadVisitData);
          }
        })
    }
    
  }
  get statusOptionsLeadVisit() {
    console.log('this.relatedLeadVisitData'+this.relatedLeadVisitData);
    return this.relatedLeadVisitData;
}
  onchangeHasCustomerFaced(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeleadVisit(event) {
    // let fieldName = event.target.fieldName;
    // this.orderList[fieldName] = event.target.value;
    const selectedOption = event.detail.value;
    console.log('selected value=' + selectedOption);
    this.chosenValue = selectedOption;
    this.orderList.Add_Lead_Visit_Visit_Id__c=this.chosenValue;

}

//this value will be shown as selected value of combobox item
get LeadVisitvalue(){
    return this.chosenValue;
}
  
onchangeDispatchWarehouse(event) {
  let fieldName = event.target.fieldName;
  this.orderList[fieldName] = event.target.value;
  console.log('this.orderList[fieldName]' + this.orderList[fieldName]);

  // Corrected condition using logical AND (&&)
  if (this.orderList[fieldName] != null && this.orderList[fieldName] !== '' && this.orderList[fieldName] !== undefined) {
    for (let i = 0; i < this.productList.length; i++) {
      const product = this.productList[i];
      if (product.Product__c != null && product.Product__c !== undefined && product.Product__c !== '') {
        console.log('product.Product__c' + product.Product__c);
        getUnitPrice({ productId: product.Product__c, dispatchWarehouseId: this.orderList[fieldName] })
        .then(result => {
          this.inventoryDetails = result;
          console.log('this.inventoryDetails========111' + this.inventoryDetails);

          if (this.inventoryDetails == null) {
            console.log('this.inventoryDetails========else===' + this.inventoryDetails);
            product.Unit_Price__c = 0;
            product.Discounted_Kg_Rate__c = 0;
            const evt = new ShowToastEvent({
              title: 'Error',
              message: 'Selected Product is not present in Warehouse',
              variant: 'error',
              mode: 'dismissable'
            });
            this.dispatchEvent(evt);
          } else if (this.inventoryDetails != null && this.inventoryDetails.Retailer_Price__c != null) {
            console.log('this.inventoryDetails========if===' + this.inventoryDetails);
            product.Unit_Price__c = this.inventoryDetails.Retailer_Price__c;
            product.Discounted_Kg_Rate__c = this.inventoryDetails.Retailer_Price__c;
          }

          if (product.Quantity__c != null && product.Quantity__c !== undefined && product.Quantity__c !== '') {
            console.log('product.Quantity__c' + product.Quantity__c);
            console.log('product.Unit_Price__c' + product.Unit_Price__c);

            if (product.Unit_Price__c == null || product.Unit_Price__c == 0 || product.Unit_Price__c === undefined) {
              product.Sub_Total__c = 0;
              product.Net_Total_for_Product__c = 0;
              product.Product_Discount__c = 0;
              this.calculation();
            } else if (product.Unit_Price__c != null && product.Unit_Price__c != 0 && product.Unit_Price__c !== undefined) {
              product.Sub_Total__c = product.Quantity__c * product.Unit_Price__c;
              console.log('product.Sub_Total__c' + product.Sub_Total__c);

              product.Net_Total_for_Product__c = product.Discounted_Unit_Price__c * product.Quantity__c;
              console.log('percent--->', ((product.Unit_Price__c - product.Discounted_Unit_Price__c) / product.Unit_Price__c * 100).toFixed(2));
              product.Product_Discount__c = parseFloat(((product.Unit_Price__c - product.Discounted_Unit_Price__c) / product.Unit_Price__c * 100).toFixed(2));

              this.calculation();
            }
          }
        })
      }
    }
  }


  
  

  }
  onchangeExpectedDeliveryDate(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }

  onchangeFreightCharge(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangePreferedTransportCompany(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeClosestTransport(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  handleOnchangeProductGroup(event) {
    this.relatedProductData = '';
   
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
     this.productList[rowIndex].isMulchProductGroup = false;
    this.productList[rowIndex].relatedProductData = '';
    console.log('this.productList[rowIndex].relatedProductData' + this.productList[rowIndex].relatedProductData);
    this.productList[rowIndex][fieldName] = event.target.value;
  
    const mulchPromise = getMulchProductGroup({ productGroupId: this.productList[rowIndex][fieldName] });
    const optionsPromise = getProductOptions({ productGroupId: this.productList[rowIndex][fieldName] });
  
    Promise.all([mulchPromise, optionsPromise])
      .then(([mulchResult, optionResult]) => {
        this.productList[rowIndex].isMulchProductGroup = mulchResult;
        console.log('this.isMulchProductGroup========' + this.productList[rowIndex].isMulchProductGroup);
  
        console.log('result========85====' + JSON.stringify(optionResult));
        console.log('result.length===86===' + optionResult.length);
        const options = [];
        for (let j = 0; j < optionResult.length; j++) {
          console.log('id=' + optionResult[j].Id);
          options.push({ value: optionResult[j].Id, label: optionResult[j].Product_Name__c });
        }
        this.productList[rowIndex].relatedProductData = options;
      })
      .catch((error) => {
        // Handle any errors that occurred during the async calls
        console.error('Error fetching data:', error);
      });
  }
  
//   get statusOptionsProduct(event) {
//     let rowIndex = event.target.dataset.index;
   
//     console.log('this.relatedProductData275'+this.relatedProductData);
//     return this.productList[rowIndex].relatedProductData;
// }
  onchangeProduct(event) {
    this.isDisableStdPkg = false;
    const selectedOption = event.detail.value;
    console.log('selected value=' + selectedOption);

    let rowIndex = event.target.dataset.index;
    this.productList[rowIndex].productChoosenValue = selectedOption;
    this.productList[rowIndex].Product__c = selectedOption;

    console.log( ' this.productList[rowIndex].Product__c'+ this.productList[rowIndex].Product__c)
    //this.productList[rowIndex].Unit_Price__c = 0;
    //this.productList[rowIndex].Discounted_Unit_Price__c = 0;
    //this.productList[rowIndex].Std_Pkg_Sizes__c = 0;
    if ( this.productList[rowIndex].Product__c != null ||  this.productList[rowIndex].Product__c != '' ||  this.productList[rowIndex].Product__c != undefined) {
      getProductDetails({ productId:  this.productList[rowIndex].Product__c })
        .then(result => {
          this.productDetails = result;
          console.log('this.productDetails========' + this.productDetails);
          console.log(' this.productDetails.Std_Pkg_Sizes__c========' + this.productDetails.Std_Pkg_Sizes__c);

          if (this.productDetails.Std_Pkg_Sizes__c != 0) {
            this.productList[rowIndex].Std_Pkg_Sizes__c = this.productDetails.Std_Package_Size__c;
            this.isDisableStdPkg = true;
          }
        })
    }
    if ( this.productList[rowIndex].Product__c != null ||  this.productList[rowIndex].Product__c != '' ||  this.productList[rowIndex].Product__c != undefined) {
      getUnitPrice({ productId:  this.productList[rowIndex].Product__c, dispatchWarehouseId: this.orderList.Dispatch_Warehouse__c })
        .then(result => {
          this.inventoryDetails = result;
          console.log('this.inventoryDetails========' + this.inventoryDetails);
          //console.log(' this.inventoryDetails.Retailer_Price__c========' + this.inventoryDetails.Retailer_Price__c);

          if (this.inventoryDetails && this.inventoryDetails.Retailer_Price__c != 0) {
            this.productList[rowIndex].Unit_Price__c = this.inventoryDetails.Retailer_Price__c;
            this.productList[rowIndex].Discounted_Unit_Price__c = this.inventoryDetails.Retailer_Price__c;
            
          }
          else{
            this.productList[rowIndex].Unit_Price__c =0;
            this.productList[rowIndex].Discounted_Unit_Price__c = 0;
            const evt = new ShowToastEvent({
              title: 'Error',
              message: 'Selected Product is not present in Warehouse',
              variant: 'error',
              mode: 'dismissable'
            });
            this.dispatchEvent(evt);
          }
          if (this.productList[rowIndex].Quantity__c != null || this.productList[rowIndex].Quantity__c != undefined || this.productList[rowIndex].Quantity__c != '') {
            console.log('this.productList[rowIndex].Quantity__c'+this.productList[rowIndex].Quantity__c);
            console.log(' this.productList[rowIndex].Unit_Price__c'+ this.productList[rowIndex].Unit_Price__c);
            this.productList[rowIndex].Sub_Total__c = this.productList[rowIndex].Quantity__c * this.productList[rowIndex].Unit_Price__c;
            console.log('this.productList[rowIndex].Sub_Total__c'+this.productList[rowIndex].Sub_Total__c);
      
            this.productList[rowIndex].Net_Total_for_Product__c = this.productList[rowIndex].Discounted_Unit_Price__c * this.productList[rowIndex].Quantity__c;
            console.log('percent--->', ((this.productList[rowIndex].Unit_Price__c - this.productList[rowIndex].Discounted_Unit_Price__c) / this.productList[rowIndex].Unit_Price__c * 100).toFixed(2));
            this.productList[rowIndex].Product_Discount__c = parseFloat(((this.productList[rowIndex].Unit_Price__c - this.productList[rowIndex].Discounted_Unit_Price__c) / this.productList[rowIndex].Unit_Price__c * 100).toFixed(2));
      
            this.calculation();
          }
        })
    }
    
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

  handleChangeQuantity(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;

    if (this.productList[rowIndex][fieldName] != null || this.productList[rowIndex][fieldName] != undefined || this.productList[rowIndex][fieldName] != '') {
      
      this.productList[rowIndex].Sub_Total__c = this.productList[rowIndex][fieldName] * this.productList[rowIndex].Unit_Price__c;
      this.productList[rowIndex].Net_Total_for_Product__c = this.productList[rowIndex].Discounted_Unit_Price__c * this.productList[rowIndex].Quantity__c;
      console.log('percent--->', ((this.productList[rowIndex].Unit_Price__c - this.productList[rowIndex].Discounted_Unit_Price__c) / this.productList[rowIndex].Unit_Price__c * 100).toFixed(2));
      this.productList[rowIndex].Product_Discount__c = parseFloat(((this.productList[rowIndex].Unit_Price__c - this.productList[rowIndex].Discounted_Unit_Price__c) / this.productList[rowIndex].Unit_Price__c * 100).toFixed(2));

      this.calculation();
    }
  }
  handleBlur(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
    if (parseFloat(this.productList[rowIndex][fieldName]) > parseFloat(this.inventoryDetails.Instock__c)) {
      console.log('parseFloat(this.inventoryDetails.Instock__c' + parseFloat(this.inventoryDetails.Instock__c));
      const evt = new ShowToastEvent({
        title: 'Alert for Delay in Delivery',
        message: 'The stock for this product is running low, please expect a delay in delivery',
        variant: 'warning',
        mode: 'dismissable'
      });
      this.dispatchEvent(evt);
    }

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
    if (this.productList[rowIndex][fieldName] != 0 || this.productList[rowIndex][fieldName] != null || this.productList[rowIndex][fieldName] != undefined) {
      this.productList[rowIndex].Net_Total_for_Product__c = this.productList[rowIndex][fieldName] * this.productList[rowIndex].Quantity__c;
      this.productList[rowIndex].Product_Discount__c = parseFloat(((this.productList[rowIndex].Unit_Price__c - this.productList[rowIndex].Discounted_Unit_Price__c) / this.productList[rowIndex].Unit_Price__c * 100).toFixed(2));
    }
    this.calculation();
  }
  calculation(event) {
    let totAmtSubTotal = 0;
    for (let rec of this.productList) {
      totAmtSubTotal = totAmtSubTotal + rec.Net_Total_for_Product__c;
    }
    this.orderList.Sub_Total__c = totAmtSubTotal;
    if (this.orderList.Sub_Total__c != 0 || this.orderList.Sub_Total__c != null || this.orderList.Sub_Total__c) {
      this.orderList.Net_Total__c = this.orderList.Sub_Total__c - ((this.orderList.Order_Discount__c / 100) * this.orderList.Sub_Total__c);
    }

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
  onchangeProductDiscount(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeNetTotal(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.productList[rowIndex][fieldName] = event.target.value;
  }
  onchangeCredit(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeAdvance(event) {
    this.isAfterAdvance = false;
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
    if (parseFloat(this.orderList[fieldName]) != 0 && this.orderList[fieldName] != null && this.orderList[fieldName] != undefined && this.orderList[fieldName] != '') {
      this.isAfterAdvance = true;
    }
  }
  onchangeSubTotal(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeOrder(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
    if (parseFloat(this.orderList.Order_Discount__c) != 0 && this.orderList.Order_Discount__c != null && this.orderList.Order_Discount__c != undefined) {
      this.calculation();
    }

  }
  onchangeNetTotal(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeCommemts(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }

  onchangeReferenceNumber(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeAdvancePaymentDate(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeAdvancePaymentReceipt(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }
  onchangeOrderStatus(event) {
    let fieldName = event.target.fieldName;
    this.orderList[fieldName] = event.target.value;
  }

  addRow(event) {

    this.productList.push({
      Id: '',
      Product_Group__c: '',
      Product__c: '',
      HoleType__c: '',
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

    });
  }
  removeRow(event) {
    const index = event.currentTarget.dataset.index;
    if (this.productList.length > 1) {
      this.productList.splice(index, 1);
      this.calculation();
    }

  }


  validateError() {
    this.productError = false;
    this.saveBool=false;
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
      if (product.Product__c == null || product.Product__c == '' || product.Product__c == undefined) {
        this.productError = true;
        console.log('if entered');
        this.template.querySelectorAll('lightning-input-field[data-name="product"]').forEach(element => {
          console.log('if entered===');
          element.reportValidity();
        });

      }
      if(parseFloat(product.Unit_Price__c)==0){
        this.productError = true;
        const evt = new ShowToastEvent({
          title: 'Error',
          message: 'Selected Product is not present in Warehouse',
          variant: 'error',
          mode: 'dismissable'
        });
        this.dispatchEvent(evt);
      }
      //console.log('this.product.isMulchProductGroup== '+product.isMulchProductGroup);
      if(product.isMulchProductGroup==true){
        console.log('if entered 554 ');
      if (product.HoleType__c == null || product.HoleType__c == '' || product.HoleType__c == undefined) {
        this.productError = true;
        console.log('if entered');
        this.template.querySelectorAll('lightning-input-field[data-name="holeType"]').forEach(element => {
          console.log('if entered===');
          element.reportValidity();
        });

      }
      if (product.Hole_Spacing__c == null || product.Hole_Spacing__c == '' || product.Hole_Spacing__c == undefined) {
        this.productError = true;
        console.log('if entered');
        this.template.querySelectorAll('lightning-input-field[data-name="holeSpacing"]').forEach(element => {
          console.log('if entered===');
          element.reportValidity();
        });

      }
    }
      if (product.Quantity__c == '' || product.Quantity__c == null || product.Quantity__c == undefined) {
        console.log('if Quantity entered');
        this.productError = true;

        this.template.querySelectorAll('lightning-input-field[data-name="quantity"]').forEach(element => {
          console.log('if entered===');
          element.reportValidity();

        });
      }
      else if ((product.Quantity__c % product.Std_Pkg_Sizes__c) != 0) {
        this.productError = true;
        const evt = new ShowToastEvent({
          title: 'Error',
          message: 'Please ensure Quantity is a multiple of Standard Packaging Size!',
          variant: 'error',
          mode: 'dismissable'
        });
        this.dispatchEvent(evt);
      }
      if (parseFloat(product.Quantity__c) > parseFloat(this.inventoryDetails.Instock__c)) {
        console.log('parseFloat(this.inventoryDetails.Instock__c' + parseFloat(this.inventoryDetails.Instock__c));
        const evt = new ShowToastEvent({
          title: 'Alert For Delay in Delivery',
          message: 'The stock for this product is running low, please expect a delay in delivery',
          variant: 'error',
          mode: 'dismissable'
        });
        this.dispatchEvent(evt);
      }

    }
    if (this.orderList.Order_Type__c != 'Internal Stock Transfer') {
      console.log('this.orderList.Advance__c--------->', this.orderList.Advance__c);
      if (parseFloat(this.orderList.Advance__c) != 0 || parseFloat(this.orderList.Advance__c) != null || parseFloat(this.orderList.Advance__c) != undefined || parseFloat(this.orderList.Advance__c) != '') {
        if (this.orderList.Net_Total__c != 0 || this.orderList.Net_Total__c != null || this.orderList.Net_Total__c != undefined) {

          if (this.orderList.Net_Total__c != parseFloat(this.orderList.Advance__c) + parseFloat(this.orderList.Credit__c)) {
            this.productError = true;
            const evt = new ShowToastEvent({
              title: 'Error',
              message: 'Please ensure Credit and Advance are Equal to Net Total',
              variant: 'error',
              mode: 'dismissable'
            });
            this.dispatchEvent(evt);
          }
        }
      }
      // if(this.orderList.Order_Type__c== null || this.orderList.Order_Type__c == undefined || this.orderList.Order_Type__c==''){
      //   console.log('if entered 612');
      //   this.productError = true;
      //   this.template.querySelectorAll('lightning-input-field[data-name="ordertype"]').forEach(element => {
      //     element.reportValidity();
      //   });
      // }
      if(this.isDisplayReceiptWarehouse==false){
      if(this.orderList.Retail_Customer__c== null || this.orderList.Retail_Customer__c == undefined || this.orderList.Retail_Customer__c==''){
        console.log('if entered 619');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="customer"]').forEach(element => {
          element.reportValidity();
        });
      }
     
        if(this.orderList.Has_this_Customer_faced_issues_with_orde__c== null || this.orderList.Has_this_Customer_faced_issues_with_orde__c == undefined || this.orderList.Has_this_Customer_faced_issues_with_orde__c==''){
          console.log('if entered 626');
          this.productError = true;
          this.template.querySelectorAll('lightning-input-field[data-name="problem"]').forEach(element => {
            element.reportValidity();
          });
        }
      }
      
      if(this.orderList.Dispatch_Warehouse__c== null || this.orderList.Dispatch_Warehouse__c == undefined || this.orderList.Dispatch_Warehouse__c==''){
        console.log('if entered 633');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="dispatchWarehouse"]').forEach(element => {
          element.reportValidity();
        });
      }
      // if(this.orderList.Freight_Charge_Bearer_values__c== null || this.orderList.Freight_Charge_Bearer_values__c == undefined || this.orderList.Freight_Charge_Bearer_values__c==''){
      //   console.log('if entered 372');
      //   this.productError = true;
      //   this.template.querySelectorAll('lightning-input-field[data-name="freight"]').forEach(element => {
      //     element.reportValidity();
      //   });
      // }
      if(this.orderList.Prefered_Transport_Company__c== null || this.orderList.Prefered_Transport_Company__c == undefined || this.orderList.Prefered_Transport_Company__c==''){
        console.log('if entered 647');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="preferedTranport"]').forEach(element => {
          element.reportValidity();
        });
      }
      if(this.orderList.Closest_Tranport_Branch__c== null || this.orderList.Closest_Tranport_Branch__c == undefined || this.orderList.Closest_Tranport_Branch__c==''){
        console.log('if entered 654');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="closestTranport"]').forEach(element => {
          element.reportValidity();
        });
      }
     
    }
    else {
      if (this.orderList.Net_Total__c != parseFloat(this.orderList.Credit__c)) {
        this.productError = true;
        const evt = new ShowToastEvent({
          title: 'Error',
          message: 'Please ensure Credit is Equal to Net Total',
          variant: 'error',
          mode: 'dismissable'
        });
        this.dispatchEvent(evt);
      }
      if(this.isDisplayReceiptWarehouse==true){
        if(this.orderList.Warehouse__c== null || this.orderList.Warehouse__c == undefined || this.orderList.Warehouse__c==''){
          console.log('if entered 372');
          this.productError = true;
          this.template.querySelectorAll('lightning-input-field[data-name="warehouse"]').forEach(element => {
            element.reportValidity();
          });
        }
      
      if(this.orderList.Retail_Warehouse__c== null || this.orderList.Retail_Warehouse__c == undefined || this.orderList.Retail_Warehouse__c==''){
        console.log('if entered 372');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="receiptWarehouse"]').forEach(element => {
          element.reportValidity();
        });
      }
    }
      
      if(this.orderList.Dispatch_Warehouse__c== null || this.orderList.Dispatch_Warehouse__c == undefined || this.orderList.Dispatch_Warehouse__c==''){
        console.log('if entered 372');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="dispatchWarehouse"]').forEach(element => {
          element.reportValidity();
        });
      }
      if(this.orderList.Prefered_Transport_Company__c== null || this.orderList.Prefered_Transport_Company__c == undefined || this.orderList.Prefered_Transport_Company__c==''){
        console.log('if entered 647');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="preferedTranport"]').forEach(element => {
          element.reportValidity();
        });
      }
      if(this.orderList.Closest_Tranport_Branch__c== null || this.orderList.Closest_Tranport_Branch__c == undefined || this.orderList.Closest_Tranport_Branch__c==''){
        console.log('if entered 654');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="closestTranport"]').forEach(element => {
          element.reportValidity();
        });
      }
    }
    

    if (this.productError == false) {
      this.handleSave();
    }
  }
  handleSave(event) {
    this.saveBool=true;
    if(this.orderList.Order_Type__c == 'Internal Stock Transfer'){
      this.orderList.Status__c = 'Payment Approved';
    }
    if(this.orderList.Order_Type__c != 'Internal Stock Transfer')
    {
    if(parseFloat(this.orderList.Order_Discount__c)!=0){
      this.orderList.Status__c = 'Exec Discount Approval';
    }
    else if ((parseFloat(this.orderList.Credit__c)!=0) && (parseFloat(this.orderList.Credit__c) == parseFloat(this.orderList.Net_Total__c) || parseFloat(this.orderList.Credit__c) + parseFloat(this.orderList.Advance__c) == parseFloat(this.orderList.Net_Total__c))) {
      this.orderList.Status__c = 'Awaiting Exec Approval';
    }
    else if ((parseFloat(this.orderList.Advance__c) == parseFloat(this.orderList.Net_Total__c)) && parseFloat(this.orderList.Credit__c)==0) {
      this.orderList.Status__c = 'Awaiting Accounts';
    }
  }
    
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
        setTimeout(function(){
          window.location.reload();
       }, 1000);  
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
  get cssClass() {
    return this.isDisplayWarehouse ? 'display-warehouse-id' : 'hide-warehouse-id';
  }
  get fieldHidden() {
    return 'fieldHidden';
  }

}