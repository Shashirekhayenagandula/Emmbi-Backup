import { LightningElement,api,track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchInventoryRecords from '@salesforce/apex/NewPackingListController.fetchInventoryRecords';
import insertPackingList from '@salesforce/apex/NewPackingListController.insertPackingList';
import getApprovedOrders from '@salesforce/apex/NewPackingListController.getApprovedOrders';
import getCustomerDetails from '@salesforce/apex/NewPackingListController.getCustomerDetails';
import getEmployerRecords from '@salesforce/apex/NewPackingListController.getEmployerRecords';
import getCurrentUserName from '@salesforce/apex/NewPackingListController.getCurrentUserName';
import { CloseActionScreenEvent } from 'lightning/actions';
import { CurrentPageReference } from 'lightning/navigation';

// import updateInventoryRecords from '@salesforce/apex/NewPackingListController.updateInventoryRecords';
//import createBundles from '@salesforce/apex/NewPackingListController.createBundles';


export default class NewPackagingList extends NavigationMixin (LightningElement) {

    @track selectedOrderId;
    customerDetails;
    approvedOrders = [];
    isRecent = false;
    customer;
    address;
    netweight;
    inventoryid;
    tareweight;
    qty;
    @api recordId;
    @api dateval;
    @track inventories = [];
    @track orderId;
    @track supervisorValue;
    @track completeValues;
    @track invoiceNoValue = '';
    @track addressValue = '';
    @track dateValue;
    @track orderIdValue = '';
    @track addCustomerValue = '';
    @track vehicleNumberValue = '';
    @track commentsValue = '';
    @track timeValue;
    @track packagingListId;
    @track bundleError=false;
    @track saveBoolean=false;
    @api parentId;
   
    base64Context;
    addressableContext;
    @wire(CurrentPageReference)
    pageRef;
    
    richtext = '<h2>Default <s>Value</s></h2>';

    connectedCallback (){
   // this.addRow();
    this.inventories.Bundle_No__c=0;
    this.inventories.QR_Code__c;
    this.inventories.Quality_Check_Status__c=0;
    this.inventories.Availability__c=0;
    this.inventories.Sales_Qty__c=0;
    this.inventories.Distributor_Price__c=0;
    this.inventories.Date_Time__c=0;
    this.inventories.Product_Name__c=0;
    this.inventories.Product_Group__c=0;
    this.inventories.Weight_kg__c=0;
    this.inventories.Instock__c=0;
    this.inventories.Quantity__c=0;
    this.inventories.Order_Product_Quantity__c=0;
    if(this.dateValue == undefined)
    {
      this.dateValue = new Date().toISOString().substring(0, 10);
    }
    console.log('this.timeValue=>',this.timeValue);
    if(this.timeValue == undefined)
    {
        const now = new Date();
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        this.timeValue = `${hours}:${minutes}`;
      //this.timeValue = new Date().toLocaleTimeString('en-US', { hour12: false });
      console.log('this.timeValue2=>',this.timeValue);
      this.base64Context = this.pageRef.state.inContextOfRef;
      if (this.base64Context.startsWith("1\.")) {
          this.base64Context = this.base64Context.substring(2);
      }
      this.addressableContext = JSON.parse(window.atob(this.base64Context));
      this.parentId = this.addressableContext.attributes.recordId;
      this.selectedOrderId=this.parentId;
    }
     
    }

     handleToggleClick(event) {
        this.isRecent = event.detail;
        // Call the wire method again to fetch the appropriate employees
        this.getEmployerRecords();
        this.getCurrentUserName();
    }

     @wire(getEmployerRecords, { isRecent: '$isRecent' })
    wiredSupervisorOptions({ data, error }) {
        if (data) {
            this.supervisorOptions = data.map((supervisor) => ({
                label: supervisor.Name,
                value: supervisor.Id
            }));
        } else if (error) {
            console.error(error);
        }
    }
     @wire(getCurrentUserName)
     wiredDefaultUser({ data, error }) {
         if (data) {
             for (let i = 0; i < this.supervisorOptions.length; i++) {
                 if (this.supervisorOptions[i].label === data) {
                     this.supervisorId = this.supervisorOptions[i].value;
                 }
             }

         } else if (error) {
             console.error(error);
         }
     }

    @wire(getCustomerDetails, { orderId: '$selectedOrderId' })
    wiredCustomerDetails({ data, error }) {
        if (data) {
            this.customerDetails = data;
        } else if (error) {
            console.error('Error fetching customer details:', error);
        }
    }

    @wire(getApprovedOrders)
    fetchApprovedOrders({ data, error }) {      
        if (data) {
            this.approvedOrders = data.map(order => ({ label: order.Name, value: order.Id }));
            //console.log('order.Id',order.Id );
           
                console.log('this.selectedOrderId',this.selectedOrderId);
   
      // Initialize a flag to track if the selectedOrderId is found in approvedOrders
      let isOrderIdFound = false;
      
      // Iterate through approvedOrders and compare each ID with the selectedOrderId
      const approvedOrdersArray = Array.from(this.approvedOrders.values());
        console.log('approvedOrdersArray',approvedOrdersArray);
      // Initialize a flag to track if the selectedOrderId is found in approvedOrders
   
      
      // Iterate through approvedOrdersArray and compare each value with the selectedOrderId
      for (let i = 0; i < approvedOrdersArray.length; i++) {
          console.log('approvedOrdersArray[i].value:', approvedOrdersArray[i].value);
          console.log('this.selectedOrderId:', this.selectedOrderId);
      
          if (approvedOrdersArray[i].value === this.selectedOrderId) {
              console.log('Matching ID found:', this.selectedOrderId);
              isOrderIdFound = true;
              break; // Exit the loop since the ID is found
          }
      }
      
      if (isOrderIdFound) {
        if (this.selectedOrderId) {
            fetchInventoryRecords({ orderId: this.selectedOrderId })
                .then((result) => {
                    console.log('result==184', result);
    
                    // Create an array to store maps for each inventory record
                    const inventoryMaps = [];
    
                    // Iterate through each fetched inventory record and create a map for each record
                    for (let i = 0; i < result.length; i++) {
                        const inventoryMap = {
                            QR_Code__c: result[i].QR_Code__c,
                            Add_Product__c: result[i].Product_Name__c,
                           // Quantity__c: result[i].Sales_Qty__c,
                           // Order_Product_Quantity__c:0;
                            Net_Weight__c: result[i].Net_Weight__c,
                            Tare_Weight__c: result[i].Tare_Weight__c,
                            Gross_Weight__c: result[i].Gross_Weight__c,
                            Remarks__c: result[i].Remarks__c,
                            Get_Lot_No__c: result[i].Lot_No__c,
                        };
                        inventoryMaps.push(inventoryMap);
                    }
    
                    // Now, inventoryMaps is an array of maps, where each map contains the desired field-value pairs of an inventory record
                    console.log('inventoryMaps', inventoryMaps);
    
                    // If you want to assign this.inventories directly:
                    this.inventories = inventoryMaps;
                    // Map fields from order product to inventory
                    const orderProductMap = this.orderProducts.reduce((map, op) => {
                        map[op.Product__c] = op.Quantity__c;
                        return map;
                    }, {});
    
                    // Map fetched inventory records to update Order_Product_Quantity__c property
                    this.inventories = result.map((inventory) => ({
                        ...inventory,
                        Order_Product_Quantity__c: orderProductMap[inventory.Product_Name__c] || 0,
                    }));
                
    
    
                    // Or, if you want to push each map to the existing this.inventories list:
                    // this.inventories = []; // If you want to reset the existing array
                     this.inventories.push(...inventoryMaps); // Push each map to this.inventories
                })
                .catch((error) => {
                    // Handle the error if necessary
                });
        } else {
            this.inventories = []; // If no orderId selected, reset the inventories array
        }
    
    
        this.fetchCustomer();
        }
    
            
        } else if (error) {
            console.error(error);
        }
    }

     handleSupervisorSelection(event) {
        this.supervisorId = event.detail;
    }
    handleChangeProductName(event){
        let rowIndex = event.target.dataset.index;
        let fieldName = event.target.fieldName;
        this.inventories[rowIndex][fieldName] = event.target.value;
    }
    handleChangeInventoryQuantity(event){
        console.log('method entered');
        let rowIndex = event.target.dataset.index;
        console.log('rowIndex',rowIndex);
        let fieldName = event.target.fieldName;
        console.log('fieldName',fieldName);
        this.inventories[rowIndex].Quantity__c = event.target.value;
        console.log('this.inventories[rowIndex][fieldName]',+this.inventories[rowIndex].Quantity__c);
    }
    handleChangeInventoryOrderproductQuantity(event){
        let rowIndex = event.target.dataset.index;
        let fieldName = event.target.fieldName;
        this.inventories[rowIndex][fieldName] = event.target.value;
    }

    handleChangeInventoryNetWeight(event){
        let rowIndex = event.target.dataset.index;
        let fieldName = event.target.fieldName;
        this.inventories[rowIndex][fieldName] = event.target.value;
    }
    handleChangeInventoryTarWeight(event){
        let rowIndex = event.target.dataset.index;
        let fieldName = event.target.fieldName;
        this.inventories[rowIndex][fieldName] = event.target.value;
    }
    handleChangeInventoryGrossWeight(event){
        let rowIndex = event.target.dataset.index;
        let fieldName = event.target.fieldName;
        this.inventories[rowIndex][fieldName] = event.target.value;
    }
    handleChangeInventoryRemarks(event){
        let rowIndex = event.target.dataset.index;
        let fieldName = event.target.fieldName;
        this.inventories[rowIndex][fieldName] = event.target.value;
    }
    handleChangeInventoryLotNo(event){
        let rowIndex = event.target.dataset.index;
        let fieldName = event.target.fieldName;
        this.inventories[rowIndex][fieldName] = event.target.value;
    }
    onchangeComplete(event){
        this.completeValues=event.detail.value;
        console.log('this.completeValues==279',this.completeValues);
    }
    get fieldHidden() {
        return 'fieldHidden';
      }


    handleOrderChange(event) {
        this.selectedOrderId = event.detail.value;
        console.log('this.selectedOrderId==179', this.selectedOrderId);
        //this.fetchInventories();
        for (let i = 0; i < this.inventories.length; i++) {
            this.inventories[i].Quantity__c=null;
            this.inventories[i].Net_Weight__c=null;
            this.inventories[i].Tare_Weight__c=null;
            this.inventories[i].Gross_Weight__c=null;
            this.inventories[i].Get_Lot_No__c=null;
            this.inventories[i].Remarks__c=null;

            console.log('this.inventories[i].Quantity__c',this.inventories[i].Quantity__c);
        }
        if (this.selectedOrderId) {
            fetchInventoryRecords({ orderId: this.selectedOrderId })
                .then((result) => {
                    console.log('result==184', result);

                    // Create an array to store maps for each inventory record
                    const inventoryMaps = [];

                    // Iterate through each fetched inventory record and create a map for each record
                    for (let i = 0; i < result.length; i++) {
                        const inventoryMap = {
                            QR_Code__c: result[i].QR_Code__c,
                            Add_Product__c: result[i].Product_Name__c,
                           // Quantity__c: result[i].Sales_Qty__c,
                           // Order_Product_Quantity__c:0;
                            Net_Weight__c: result[i].Net_Weight__c,
                            Tare_Weight__c: result[i].Tare_Weight__c,
                            Gross_Weight__c: result[i].Gross_Weight__c,
                            Remarks__c: result[i].Remarks__c,
                            Get_Lot_No__c: result[i].Lot_No__c,
                        };
                        inventoryMaps.push(inventoryMap);
                    }

                    // Now, inventoryMaps is an array of maps, where each map contains the desired field-value pairs of an inventory record
                    console.log('inventoryMaps', inventoryMaps);

                    // If you want to assign this.inventories directly:
                    this.inventories = inventoryMaps;
                    // Map fields from order product to inventory
                    const orderProductMap = this.orderProducts.reduce((map, op) => {
                        map[op.Product__c] = op.Quantity__c;
                        return map;
                    }, {});
    
                    // Map fetched inventory records to update Order_Product_Quantity__c property
                    this.inventories = result.map((inventory) => ({
                        ...inventory,
                        Order_Product_Quantity__c: orderProductMap[inventory.Product_Name__c] || 0,
                    }));
                


                    // Or, if you want to push each map to the existing this.inventories list:
                    // this.inventories = []; // If you want to reset the existing array
                     this.inventories.push(...inventoryMaps); // Push each map to this.inventories
                })
                .catch((error) => {
                    // Handle the error if necessary
                });
                this.fetchCustomer();
        } 
        
        else {
            this.inventories = []; // If no orderId selected, reset the inventories array
        }
    

        this.fetchCustomer();
        //console.log('this.fetchInventories-->73',this.fetchInventories());
        console.log('this.fetchCustomer-->87',this.fetchCustomer());
    }

    get dateValue(){
        if(this.dateval == undefined)
        {
          this.dateval = new Date().toISOString().substring(0, 10);
        }
        return this.dateval;
    }

    changedate(event){
        this.dateval = event.target.value;
    }
    get options() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' }           
        ];
    } 

    handleChange(event) {
        this.richtext = event.detail.value;
    }

    addRow(event) {

      this.inventories.push({
        //Bundle_No__c:'',
        QR_Code__c:'',
        Add_Product__c:'',
        Quantity__c:'',
        Order_Product_Quantity__c:'',
        Net_Weight__c:'',
        Tare_Weight__c:'',
        Gross_Weight__c:'',
        Remarks__c:'',
        Get_Lot_No__c:'',
       
      });
    }
    removeRow(event) {
    const index = event.currentTarget.dataset.index;
    if (this.inventories.length > 1) {
        this.inventories.splice(index, 1);
        // this.calculation();
    }
    }

    handleChange(event){

            let empName = event.target.name;
            if(empName == 'invoice'){
                this.invoiceNoValue = event.target.value;
            }
            if (empName == 'address'){
                this.addressValue = event.target.value;
            }
            if (empName == 'date'){
                this.dateValue = event.target.value;
            }
            if (empName == 'vehicleNo'){
                console.log('event.target.value=>',event.target.value);
                this.vehicleNumberValue = event.target.value;
                console.log('vehicleNumberValue=>',this.vehicleNumberValue);
            }
            if (empName == 'comments'){
                this.commentsValue = event.target.value;
            }
            if (empName == 'time'){
                this.timeValue = event.target.value;
                //const timeParts = event.target.value.split(':');
                //const hours = timeParts[0];
                //const minutes = timeParts[1];

                // Formatting the 'timeValue' in 'HH:mm:ss.SSSZ' format
                //this.timeValue = `${hours}:${minutes}:00.000Z`;
                //this.timeValue = this.timeValue.toISOString().split('T')[1].slice(0, -1);

                 console.log('timeValue: ', this.timeValue);
            }

        
    }
   
  /* handleChangeInventoryItems(event){
        console.log('entered into handleChangeInventoryItems');
        console.log('event.target.name=>',event.target.name);
        console.log('event.detail.fields=>',event.detail.fields);
        const fieldName = event.target.label
        console.log('fieldName=>',fieldName);
        for (let rec of this.inventories){
            console.log('rec=>',rec);
            console.log('Bundle_No__c=>',rec.Bundle_No__c);
            console.log('Gross_Weight__c=>',rec.Gross_Weight__c);
            console.log('Product_Name__c=>',rec.Product_Name__c);
            console.log('Lot_No__c=>',rec.Lot_No__c);
            console.log('Net_Weight__c=>',rec.Net_Weight__c);
            console.log('Tare_Weight__c=>',rec.Tare_Weight__c);
            console.log('id=>',rec.id);
        }
        //this.inventories = { ...this.inventories, [fieldName]: event.target.value };
        console.log('inventories=>',this.inventories);


        let empName = event.target.name;
            if(empName === 'productName'){
                this.Product_Name__c = event.target.value;
            }
            if(empName === 'bundle'){
                this.Bundle_No__c = event.target.value;
            }
            if(empName === 'instock'){
                this.Instock__c = event.target.value;
            }
    }*/
    
    handleCancel(){
        this[NavigationMixin.Navigate]({ 
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Retail_Packaging_List__c',
                actionName: 'list'
                        },
            state: {       
                filterName: 'Recent' 
                    }
        })
    } 
    // handleOrderSelection(event) {
    //     this.orderId = event.target.value;
    //     this.fetchInventories();
    // }

    // handleChangeInventoryItems(event) {
    // const netweight = event.target.value;
    // const qty = event.target.value;
    // const tareweight = event.target.value;
    // const inventoryid = event.target.dataset.id;
    // }

    handleSave(event) {
        this.saveBoolean=true;
        // const bundleRecords  = [];
        console.log('entered  into handleSave');
        //const supervisor = this.supervisorValue;
        const supervisor = this.supervisorId;
        console.log('supervisor=>',supervisor);
        const completeValue = this.completeValues;
        console.log('completeValue=>  509',completeValue);
        const invoiceNo = this.invoiceNoValue;
        console.log('invoiceNo=>',invoiceNo);
        const address = this.addressValue;
        console.log('address=>',address);
        const dispatchDate = new Date(this.dateValue);
        console.log('dispatchDate=>',dispatchDate);
        const orderId = this.selectedOrderId;
        console.log('orderId=>',orderId);
        const addCustomer = this.addCustomerValue;
        console.log('addCustomer=>',addCustomer);
        const vehicleNumber = this.vehicleNumberValue;
        console.log('vehicleNumber=>',vehicleNumber);
        const comments = this.commentsValue;
        console.log('comments=>',comments);
        const parsedTime = new Date(`2000-01-01T${this.timeValue}`);
        //const timeVal= new Date('00:15:00.000Z');//parsedTime.toLocaleTimeString('en-US', { hour12: true });
        //const timeVal = this.timeValue;
        
        const timeVal = this.timeValue.valueOf('00:15:00.000Z');
        console.log('timeVal=>',timeVal);

    //     const bundleRecords = [];
    //         for (const inventory of this.inventories) {
    //         bundleRecords.push({
    //         Product_Name__c: inventory.Product_Name__c,
    //         Bundle_No__c: inventory.Bundle_No__c,
    //         Instock__c: inventory.Instock__c,
    //         Net_Weight__c: inventory.Net_Weight__c,
    //         Tare_Weight__c: inventory.Tare_Weight__c,
    //         Gross_Weight__c: inventory.Gross_Weight__c,
    //         Remarks__c: inventory.Remarks__c,
    //         Lot_No__c: inventory.Lot_No__c,
    //         Add_Supplier__c: inventory.Add_Supplier__c,
    //     });
    // }


        // const inventoriesToUpdate = this.inventories.map(inventory => ({
        // Id: inventory.id,
        // Net_Weight__c: inventory.Net_Weight__c,
        // Tare_Weight__c: inventory.Tare_Weight__c
        // // Add more fields as needed
        // }));
        // console.log('inventory.Tare_Weight__c',inventory.Tare_Weight__c);
        console.log('timeValue',this.timeValue);
        console.log('this.timeValue',this.timeValue);
        insertPackingList({
            supervisor: supervisor,
            completeValue: completeValue,
            invoiceNo: invoiceNo,
            address: this.address,
            dispatchDate: dispatchDate,
            orderId: orderId,
            addCustomer: this.addCustomerValue,
            vehicleNumber: vehicleNumber,
            comments: comments, inventories: this.inventories
        })
            .then((result) => {
                // Handle success, e.g., display a success message or navigate to a new page
                console.log('Record inserted successfully.',result);
                this.packagingListId = result;
                console.log('packagingListId=>',this.packagingListId);
                const even = new ShowToastEvent({
                    title: 'Success!',
                    message: 'Packaging List was saved successfully!',
                    variant: 'success'
                  });
                  this.dispatchEvent(even);
        
                  this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                      recordId: this.packagingListId,
                      objectApiName: 'Retail_Packaging_List__c',
                      actionName: 'view'
                    }
                  });
                })
                setTimeout(function(){
                    window.location.reload();
                 }, 1000);  
              this.dispatchEvent(new CloseActionScreenEvent());
            }
    
        closeQuickAction(event) {
          this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
              objectApiName: 'Retail_Packaging_List__c',
              actionName: 'list'
            },
            state: {
              filterName: 'Recent'
            },
          })
          setTimeout(function(){
            window.location.reload();
         }, 1000);  
          this.dispatchEvent(new CloseActionScreenEvent());
      
        }


  

    fetchCustomer(){
        if(this.selectedOrderId){
           getCustomerDetails({orderId: this.selectedOrderId})
           .then((result) => {
              console.log('result-->230',JSON.stringify(result)); 
                    this.customer = result.Shop_Name__c +" - "+result.Billing_First_Name__c+" "+result.Billing_Last_Name__c;
                    console.log('result-this.customer->233',this.customer);
                    this.address = result.Shop_Name__c +" - "+result.Village__c +"\n"+result.Taluka__r.Name +" "+result.District__r.Name +"\n"+result.State__r.Name +" "+result.Pin_code__c;
                    this.addCustomerValue=result.Id;
                })
                .catch((error) => {
                    // Handle the error if necessary
                });
        } else {
            this.inventories = [];
        } 
        
    }
   
        validateError() {
            this.bundleError = false;
            this.saveBoolean=false;
            
            let bundleSet = new Set();
            for (let i = 0; i < this.inventories.length; i++) {
              const bundle = this.inventories[i];
             
              console.log('if entered 221 ');
              // Check if the product group is empty
              if (bundle.Quantity__c == null || bundle.Quantity__c == '' || bundle.Quantity__c == undefined) {
                this.bundleError = true;
                console.log('if entered');
                this.template.querySelectorAll('lightning-input-field[data-name="quantity"]').forEach(element => {
                  console.log('if entered===');
                  element.reportValidity();
                });
            }
           /* if (bundle.Net_Weight__c == null || bundle.Net_Weight__c == '' || bundle.Net_Weight__c == undefined) {
                this.bundleError = true;
                console.log('if entered 535');
                this.template.querySelectorAll('lightning-input-field[data-name="netWeight"]').forEach(element => {
                  console.log('if entered===');
                  element.reportValidity();
                });
            }
            if (bundle.Tare_Weight__c == null || bundle.Tare_Weight__c == '' || bundle.Tare_Weight__c == undefined) {
                this.bundleError = true;
                console.log('if entered 543');
                this.template.querySelectorAll('lightning-input-field[data-name="tareWeight"]').forEach(element => {
                  console.log('if entered===');
                  element.reportValidity();
                });
            }
            if (bundle.Gross_Weight__c == null || bundle.Gross_Weight__c == '' || bundle.Gross_Weight__c == undefined) {
                this.bundleError = true;
                console.log('if entered 551');
                this.template.querySelectorAll('lightning-input-field[data-name="grossWeight"]').forEach(element => {
                  console.log('if entered===');
                  element.reportValidity();
                });
            }*/
            console.log('bundle.Net_Weight__c',parseFloat(bundle.Net_Weight__c));
             if ((bundle.Net_Weight__c == null || bundle.Net_Weight__c == '' || bundle.Net_Weight__c == undefined)|| (bundle.Tare_Weight__c == null || bundle.Tare_Weight__c == '' || bundle.Tare_Weight__c == undefined) || (bundle.Gross_Weight__c == null || bundle.Gross_Weight__c == '' || bundle.Gross_Weight__c == undefined)) {
                this.bundleError = true;
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Please update Net Weight,Gross Weight and Tare Weight in Inventory Level',
                    variant: 'error',
                    mode: 'dismissable'
                  });
                  this.dispatchEvent(evt);
        }
    }
        if (this.bundleError == false) {
            this.handleSave();
          }
    }

    /*fetchInventories() {
        if (this.selectedOrderId) {
            console.log('Selected Order Id: ', this.selectedOrderId);
            fetchInventoryRecords({ orderId: this.selectedOrderId })
                .then((result) => {
                    console.log('Fetched Inventory Records: ', JSON.stringify(result));
                   this.inventories = result;
                    let invList = [];
                    for (let rec of result){
                        let record = {};
                        record.id = rec.Id;
                        record.Bundle_No__c = rec.Bundle_No__c;
                        record.QR_Code__c = rec.QR_Code__c;
                        record.Quality_Check_Status__c = rec.Quality_Check_Status__c;
                        record.Availability__c = rec.Availability__c;
                        record.Sales_Qty__c = rec.Sales_Qty__c;
                        record.Retailer_Price__c = rec.Retailer_Price__c;
                        record.Distributor_Price__c = rec.Distributor_Price__c;
                        record.Date_Time__c = rec.Date_Time__c;
                        record.Product_Name__c = rec.Product_Name__c;
                        record.Weight_kg__c = rec.Weight_kg__c;
                        record.Tare_Weight__c = rec.Tare_Weight__c;
                        record.Net_Weight__c = rec.Net_Weight__c;
                        record.Gross_Weight__c = rec.Gross_Weight__c;
                        record.Remarks__c = rec.Remarks__c;
                        record.Lot_No__c = rec.Lot_No__c;
                        record.Add_Supplier__c = rec.Add_Supplier__c;
                        record.Quantity__c=0;
                        record.Order_Product_Quantity__c=0;
                        invList.push(record);
                        console.log('invList-->444',JSON.stringify(invList));
                    }
                    this.inventories = invList;
                    console.log('this.inventories-->446',JSON.stringify(this.inventories));
                })
                .catch((error) => {
                    // Handle the error if necessary
                    console.error('Error fetching inventory records: ', error);
                });
        } else {
            this.inventories = [];
            console.log('entered into else');
        }
    }*/
    
       
}