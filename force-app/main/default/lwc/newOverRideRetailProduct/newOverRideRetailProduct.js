import { LightningElement, api, track, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
// import insertLeadVisit from '@salesforce/apex/NewOverrideLeadVisitController.insertLeadVisit';
// import getProductGroupDetails from '@salesforce/apex/NewOverrideLeadVisitController.getProductGroupDetails';
// import getLinkCustomer from '@salesforce/apex/NewOverrideLeadVisitController.getLinkCustomer';
// import getLinkCustomerLead from '@salesforce/apex/NewOverrideLeadVisitController.getLinkCustomerLead';
// import insertLeadVisitOnly from '@salesforce/apex/NewOverrideLeadVisitController.insertLeadVisitOnly';
// import insertLeadVisitWithProduct from '@salesforce/apex/NewOverrideLeadVisitController.insertLeadVisitWithProduct';
import { CurrentPageReference } from 'lightning/navigation';
import insertProductWithInventory from '@salesforce/apex/NewOverrideProductController.insertProductWithInventory';

export default class NewOverRideRetailProduct extends NavigationMixin(LightningElement) {
  @api recordId;
  @track inventoryList = [];
  @track productList = {};
  @track currentDate;
  @track dateError = false;
  @track addQtyValue;
  @track productError = false;
  @track lineItemError = false;
  @track sameItemError = false;
  @track checkWareHouseBool = false;
  @track checkDateBool = false;
  @track retailerPriceBool = false;
  @track distributorPriceBool = false;
  @track notifiThreValuePriceBool = false;
  @track addQtyBool = false;
  @track defaultDateCheck = false;
  @track wareCount = 0;
  @track dateCount = 0;
  
  @api parentId;
  base64Context;
  addressableContext;
  @wire(CurrentPageReference)
  pageRef;

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
    this.inventoryList.Date__c = `${year}-${month}-${day}`;
    this.currentDate = `${year}-${month}-${day}`;
    console.log('Hi this is connected call back');
    console.log('this.inventoryList.Date__c', this.inventoryList.Date__c);

    this.addRow();
    this.inventoryList.Retailer_MOQ__c = 0;
    this.inventoryList.Distributor_MOQ__c = 0;
    this.inventoryList.Sales_Qty__c = 0;
    this.inventoryList.Pending_QC_Stock__c = 0;
    this.inventoryList.Saleable_Stock__c = 0;
    this.inventoryList.QC_Failed_Stock__c = 0;
    this.inventoryList.QC_Instock__c = 0;
    console.log('parent group iD' + this.recordId);
    this.base64Context = this.pageRef.state.inContextOfRef;
    if (this.base64Context.startsWith("1\.")) {
      this.base64Context = this.base64Context.substring(2);
    }
    this.addressableContext = JSON.parse(window.atob(this.base64Context));
    this.parentId = this.addressableContext.attributes.recordId;
    this.productList.Retail_Product_Group__c = this.parentId;
    //this.defaultDateSet();
console.log('68',JSON.stringify(this.inventoryList));
  }

   defaultDateSet(){
       if(this.defaultDateCheck == false){
       this.inventoryList.Date__c = this.currentDate;
       console.log('this.inventoryList.Date__c', this.inventoryList.Date__c);
    }
    console.log('75',JSON.stringify(this.inventoryList));
   }



  onchangeretailproductGroup(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
       // this.inventoryList.Product_Group__c = this.productList.Retail_Product_Group__c;

  }

  onchangeproductName(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
    console.log('fieldName==>', this.productList[fieldName]);
  }

  onchangeproductCode(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangestdpackageSize(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangetotalInstock(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
    for (let i = 0; i < this.inventoryList.length; i++) {
      const inventoryStock = this.inventoryList[i];
      inventoryDate.dateError = false;
      console.log('if entered 221 ');
      if (inventoryStock.Instock__c != null) {
        inventoryStock.dateError = true;
        console.log('if entered');
        var instockHolder = inventoryStock.Instock__c;
        productList.Total_In_Stock__c = 0 + instockHolder;



      }

    }

  }
   

  onchangeType(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangeMaterial(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangeSize(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangeColour(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangeThicknessmic(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangeGSM(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangeWeight(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangeLength(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }

  onchangeBundlenumbertracker(event) {
    let fieldName = event.target.fieldName;
    this.productList[fieldName] = event.target.value;
  }


  handleOnchangeDate(event) {
    console.log('this.currentDate', this.currentDate);
    console.log('170',JSON.stringify(this.inventoryList));
    this.dateError = false;
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
    this.defaultDateCheck = true;
    console.log('176',JSON.stringify(this.inventoryList));
    for (let i = 0; i < this.inventoryList.length; i++) {
      const inventoryDate = this.inventoryList[i];
      inventoryDate.dateError = false;
       this.dateCount = 0;
      console.log('if entered 221 ');
      if (inventoryDate.Date__c > this.currentDate) {
        inventoryDate.dateError = true;
        this.checkDateBool = true;
        this.dateCount = 1;
        console.log('if entered');
        this.template.querySelectorAll('lightning-input-field[data-name="date"]').forEach(element => {
          console.log('if entered===');
          element.reportValidity();
        });

      }
      else{
        this.checkDateBool = false;
         //this.dateCount = this.dateCount-1;

      }

    }


  }

  handleOnchangeWarehouseCode(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
    this.sameItemError = false;
    //this.checkWarehouseDuplicates();
    this.check2();
    // for (let i = 0; i < this.inventoryList.length; i++) {
    //   if (this.inventoryList[i].Warehouse_Code__c == '') {
    //     this.lineItemError = true;
    //     this.template.querySelectorAll('lightning-input-field[data-name="warehouseCode"]').forEach(element => {
    //       element.reportValidity();
    //     });
    //   }
    //   for (let j = i + 1; j < this.inventoryList.length; j++) {

    //     if (this.inventoryList[i].Warehouse_Code__c != '') {

    //       if (this.inventoryList[i].Warehouse_Code__c == this.inventoryList[j].Warehouse_Code__c) {
    //         this.lineItemError = true;
    //         this.inventoryList[j].sameItemError = true;
    //         console.log('Entered warehouse check');

    //         //break;
    //       }
    //       else {
    //         this.inventoryList[j].sameItemError = false;
    //         console.log('Entered warehouse check false');

    //       }
    //     }
    //   }
    //   if (lineItemError == true) {
    //     break;
    //   }
    // }

  }

  checkWarehouseDuplicates(){
 for (let i = 0; i < this.inventoryList.length; i++) {
      // if (this.inventoryList[i].Warehouse_Code__c === '') {
      //   this.lineItemError = true;
      //   this.template.querySelectorAll('lightning-input-field[data-name="warehouseCode"]').forEach(element => {
      //     element.reportValidity();
      //   });
      // }
      for (let j = i+1; j < this.inventoryList.length; j++) {

        if (this.inventoryList[i].Warehouse_Code__c != '') {

          if (this.inventoryList[i].Warehouse_Code__c == this.inventoryList[j].Warehouse_Code__c) {
           // this.lineItemError = true;
            this.inventoryList[j].sameItemError = true;
            console.log('Entered warehouse check');
            //this.wareCount = 1;

            //break;
          }
          else {
            this.inventoryList[j].sameItemError = false;

            console.log('Entered warehouse check false');

          }
        }
      }
      // if (lineItemError == true) {
      //   break;
      // }
    }





  }


  check2(){
    for (let i = 0; i < this.inventoryList.length; i++) {
      // if (this.inventoryList[i].Warehouse_Code__c === '') {
      //   this.lineItemError = true;
      //   this.template.querySelectorAll('lightning-input-field[data-name="warehouseCode"]').forEach(element => {
      //     element.reportValidity();
      //   });
      // }
      this.inventoryList[i].sameItemError = false; // Reset the flag for each element
    this.wareCount = 0;
      for (let j = 0; j < this.inventoryList.length; j++) {
        if (j !== i && this.inventoryList[j].Warehouse_Code__c !== '') {
          if (this.inventoryList[j].Warehouse_Code__c === this.inventoryList[i].Warehouse_Code__c) {
            this.inventoryList[i].sameItemError = true;
            //this.checkWareHouseBool = false;
            this.wareCount = this.wareCount + 1;
;
            console.log('Entered warehouse check');
          }
          else{
            this.checkWareHouseBool = true;
                       // this.wareCount = this.wareCount - 1;


          }
        }
      }
    }
    
  }

  handleOnchangeretailerPrice(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
    this.retailerPriceBool = true;

  }

  handleOnchangedistributorPrice(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
    this.distributorPriceBool = true;
  }

  handleOnchangeretailerMOQ(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
  }

  handleOnchangedistributorMOQ(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
  }

  handleOnchangenotificationThresholdValue(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
    this.notifiThreValuePriceBool = true;
    // for (let rec of this.inventoryList) {
    //   if(rec.Notification_Threshold_Value__c < rec.Instock__c){
    //     rec.Availability__c = 'Instock';
    //   }
    //  else if(rec.Notification_Threshold_Value__c > rec.Instock__c){
    //     rec.Availability__c = 'Low Stock';
    //   }
    //   else{
    //     rec.Availability__c = 'Low Stock';
    //   }
    // }
    //this.calculation2();

  }

  /*calculation2(event){
    for (let rec of this.inventoryList) {
      if(rec.Notification_Threshold_Value__c != null){
        console.log('Entered the if statement inside when NV value is not NUll');
        if(rec.Notification_Threshold_Value__c < rec.Instock__c){
          console.log('Entered =====> if(rec.Notification_Threshold_Value__c < rec.Instock__c)')
          rec.Availability__c = 'Instock';
        }
       else if(rec.Notification_Threshold_Value__c > rec.Instock__c){
          rec.Availability__c = 'Low Stock';
          console.log('Entered ====> else if(rec.Notification_Threshold_Value__c > rec.Instock__c');
        }
        else{
          console.log('Threshold is not null');
        }
      }
      // else{
      //   rec.Availability__c = 'None';
      //   console.log('Threshold is null');
      // }
      
     
    }
  } */

  handleOnchangeaddQty(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;

    this.addQtyValue = this.inventoryList[rowIndex][fieldName];
    console.log('this.addQtyValue', this.addQtyValue);
    //Instock__c
    //this.handleOnchangeInstock();
    this.inventoryList[rowIndex].Instock__c = this.addQtyValue;
    //this.onchangetotalInstock();
    this.calculation();
    this.addQtyBool = true;
    //this.calculation2();


  }

  // calculation(event){
  //   let totAmtSubTotal = 0;
  //   for (let rec of this.inventoryList) {
  //     totAmtSubTotal=totAmtSubTotal+rec.Instock__c;
  // }
  // this.productList.Total_In_Stock__c=totAmtSubTotal;
  // }

  calculation(event) {
    let totAmtSubTotal = 0;
    for (let rec of this.inventoryList) {
      // Convert the string value to a number using parseInt or parseFloat
      const instockValue = parseFloat(rec.Instock__c); // Use parseInt if integers are expected
      totAmtSubTotal += instockValue;
    }
    // Assign the calculated total to the Total_In_Stock__c property
    this.productList.Total_In_Stock__c = totAmtSubTotal;
  }


  handleOnchangesalesQty(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
    
  }

  handleOnchangeInstock(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    // this.inventoryList[rowIndex][fieldName] = event.target.value;
    this.inventoryList[rowIndex][fieldName] = this.addQtyValue;
    this.calculation2;
    console.log('handleonCHangeInstock() runningg');

  }

  handleOnchangependingqcStock(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
  }

  handleOnchangesaleableStock(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
  }

  handleOnchangeqcfailedStock(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
  }

  handleOnchangeqcInstock(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
  }

  handleOnchangeAvailibility(event) {
    let rowIndex = event.target.dataset.index;
    let fieldName = event.target.fieldName;
    this.inventoryList[rowIndex][fieldName] = event.target.value;
  }


  addRow(event) {

    this.inventoryList.push({
      Id: '',
      Date__c: '',
      Warehouse_Code__c: '',
      Retailer_Price__c: '',
      Distributor_Price__c: '',
      Retailer_MOQ__c: 0,
      Distributor_MOQ__c: 0,
      Notification_Threshold_Value__c: '',
      Add_Qty__c: '',
      Sales_Qty__c: 0,
      Instock__c: '',
      Pending_QC_Stock__c: 0,
      Saleable_Stock__c: 0,
      QC_Failed_Stock__c: 0,
      QC_Instock__c: 0,
      Availability__c: '',
      Image_Testing__c: '',
    });
   
    
    
  }

  removeRow(event) {
    const index = event.currentTarget.dataset.index;
    if (this.inventoryList.length > 1) {
      this.inventoryList.splice(index, 1);
      this.calculation();
    }
  
  }


  closeQuickAction() {
    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
        objectApiName: 'Retail_Product__c',
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

  validateError() {
    this.productError = false;
    if (this.productList.Retail_Product_Group__c == null || this.productList.Retail_Product_Group__c == undefined || this.productList.Retail_Product_Group__c == '') {
      console.log('2');
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="retailProductGroup"]').forEach(element => {
        element.reportValidity();

      });
    }
   

    if (this.productList.Product_Code__c == null || this.productList.Product_Code__c == undefined || this.productList.Product_Code__c == '') {
      console.log('2');
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="productCode"]').forEach(element => {
        element.reportValidity();

      });
    }

    if (this.productList.Std_Package_Size__c == null || this.productList.Std_Package_Size__c == undefined || this.productList.Std_Package_Size__c == '') {
      console.log('2');
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="stdpackageSize"]').forEach(element => {
        element.reportValidity();

      });
    }

    if (this.productList.Product_Name__c == null || this.productList.Product_Name__c == undefined || this.productList.Product_Name__c == '') {
      console.log('2');
      this.productError = true;
      this.template.querySelectorAll('lightning-input-field[data-name="productName"]').forEach(element => {
        element.reportValidity();

      });
    }

    // //This is for InventoryList
    // let productSet = new Set(); // Create a set to store unique product values
    // for (let i = 0; i < this.inventoryList.length; i++) {
    //   if (this.inventoryList[i].Warehouse_Code__c == '') {
    //     this.lineItemError = true;
    //     this.template.querySelectorAll('lightning-input-field[data-name="warehouseCode"]').forEach(element => {
    //       element.reportValidity();
    //     });
    //   }
    //   for (let j = i + 1; j < this.inventoryList.length; j++) {

    //     if (this.inventoryList[i].Warehouse_Code__c != '') {

    //       if (this.inventoryList[i].Warehouse_Code__c == this.inventoryList[j].Warehouse_Code__c) {
    //         this.lineItemError = true;
    //         this.inventoryList[j].sameItemError = true;
    //         console.log('Entered warehouse check');

    //         //break;
    //       }
    //       else {
    //         this.inventoryList[j].sameItemError = false;
    //         console.log('Entered warehouse check false');

    //       }
    //     }
    //   }
    //   if (lineItemError == true) {
    //     break;
    //   }
    // }











    for (let i = 0; i < this.inventoryList.length; i++) {
      console.log('22223+1');
      const inventory = this.inventoryList[i];
      console.log('22223+2',JSON.stringify(inventory));
      if (inventory.Warehouse_Code__c == null || inventory.Warehouse_Code__c == undefined || inventory.Warehouse_Code__c == '') {
        console.log('Warehouse_Code__c 22223+3');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="warehouseCode"]').forEach(element => {
          element.reportValidity();

        });
      }
      else if(inventory.Warehouse_Code__c != null){
        //this.productError = true;
      }
      if (inventory.Retailer_Price__c == null || inventory.Retailer_Price__c == undefined || inventory.Retailer_Price__c == '') {
        console.log('Retailer_Price__c 22223+3');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="retailerPrice"]').forEach(element => {
          element.reportValidity();

        });
      }
      if (inventory.Distributor_Price__c == null || inventory.Distributor_Price__c == undefined || inventory.Distributor_Price__c == '') {
        console.log('Distributor_Price__c 22223+3');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="distributorPrice"]').forEach(element => {
          element.reportValidity();

        });
      }
      if (inventory.Retailer_MOQ__c == null || inventory.Retailer_MOQ__c === '' || inventory.Retailer_MOQ__c == undefined ) {
        console.log('Retailer_MOQ__c 22223+3',inventory.Retailer_MOQ__c);
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="retailerMOQ"]').forEach(element => {
          element.reportValidity();

        });
      }
      if (inventory.Distributor_MOQ__c == null || inventory.Distributor_MOQ__c == undefined || inventory.Distributor_MOQ__c === '') {
        console.log('Distributor_MOQ__c 22223+3');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="distributorMOQ"]').forEach(element => {
          element.reportValidity();

        });
      }
      if (inventory.Notification_Threshold_Value__c == null || inventory.Notification_Threshold_Value__c == undefined || inventory.Notification_Threshold_Value__c == '') {
        console.log('Notification_Threshold_Value__c 22223+3');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="notificationThresholdValue"]').forEach(element => {
          element.reportValidity();

        });
      }
      if (inventory.Add_Qty__c == null || inventory.Add_Qty__c == undefined || inventory.Add_Qty__c == '') {
        console.log('Add_Qty__c 22223+3');
        this.productError = true;
        this.template.querySelectorAll('lightning-input-field[data-name="addQty"]').forEach(element => {
          element.reportValidity();

        });
      }
      //continue;
    }
// if(this.productError == false){
//   this.handleSave();
// }

  }

  handleSave(event) {
    this.validateError();
        console.log(JSON.stringify(this.inventoryList));
         console.log(this.wareCount);
        console.log(this.dateCount);
        console.log(this.checkWareHouseBool);
        console.log(this.retailerPriceBool);
        console.log(this.distributorPriceBool);
        console.log(this.notifiThreValuePriceBool);
        console.log(this.addQtyBool);
        console.log('this.productError-->'+this.productError);

    if(this.wareCount == 0 && this.dateCount == 0 && this.retailerPriceBool == true && this.distributorPriceBool == true && this.notifiThreValuePriceBool  == true && this.addQtyBool == true && !this.productError ){
      console.log('At save level Datebool value',this.checkDateBool);
      console.log('At save level Warehousebool value',this.checkWareHouseBool);

      if (this.inventoryList && this.inventoryList.length > 0) {
        console.log('inventoryList at save()', JSON.stringify(this.inventoryList));
        insertProductWithInventory({ inventoryList: this.inventoryList, product: this.productList })
          .then(data => {
            console.log('Save() data');
            let productId;
            productId = data;
            console.log('data===>', data);
            console.log('productId===>', productId);


            const even = new ShowToastEvent({
              title: 'Success!',
              message: 'product was saved successfully!',
              variant: 'success'
            });
            this.dispatchEvent(even);

            this[NavigationMixin.Navigate]({
              type: 'standard__recordPage',
              attributes: {
                recordId: productId,
                objectApiName: 'Retail_Product__c',
                actionName: 'view'
              }
            });
          })
              
    
        this.dispatchEvent(new CloseActionScreenEvent());
      //   setTimeout(function(){
      //     window.location.reload();
      //  }, 1000);   
      }
      else {
        console.log('Inevntory itemlist is not greaterthan 1');
        const even = new ShowToastEvent({
          title: 'error!',
          message: 'Enter Inventory Data!',
          variant: 'warning'
        });
        this.dispatchEvent(even);

      }
    
  }
//   setTimeout(function(){
//     window.location.reload();
//  }, 1000);  


    }
      
}