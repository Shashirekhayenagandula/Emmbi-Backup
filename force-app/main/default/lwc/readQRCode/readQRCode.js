import {LightningElement, api, track, wire} from 'lwc';
import fetchProductDetails from '@salesforce/apex/QRCodeController.fetchProductDetails';
import updateProductDetails from '@salesforce/apex/QRCodeController.updateProductDetails';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {CurrentPageReference} from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';

export default class ReadQRCode extends NavigationMixin(LightningElement) {
    @track records;
    @api recordId;
    @track error;
    @api ProdQuantity;
    @api isLoaded = false;
    @wire(CurrentPageReference)
    getPageReference(currentPageReference) {
        if (currentPageReference) {
            const state = currentPageReference.state;
            this.recordId = state.c__recordId || null;
        }
    }
    connectedCallback(){
        fetchProductDetails({ ProductId: this.recordId})
            .then(result => {
                console.log('result',result.length);
                console.log('JSON.stringify(result)',JSON.stringify(result));
                if (result.length === 0){
                    console.log('==result',result);
                    this.handlePageMessages();
                }
                else{
                    console.log('at else');
                    this.records=result;
                    this.error = undefined;
                }
            })
            .catch(error => {
                this.error = error;
                this.records = undefined;
            });
    }
    handleProductQuantity(event){
        this.ProdQuantity = event.detail.value;
    }
    handlePageMessages(){
        console.log('==hereresult');
        const evt = new ShowToastEvent({
            title: 'Product Inventory QR Code Information',
            message: 'This QR code scanned withing 2 min',
            variant: 'Success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    @api
    updateProductQuantity(){
        this.isLoaded = !this.isLoaded;
        updateProductDetails({Quantity: this.ProdQuantity, ProductId: this.recordId})
            .then(result => {
                const res = result;
                const evt = new ShowToastEvent({
                    title: 'Product update Information',
                    message: res,
                    variant: 'Success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
        });
                this.navigateToProduct();
    }
        navigateToProduct(){
            const recId = this.recordId;
            this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes: {
                recordId:recId,
                objectApiName:"Retail_Product__c",
                actionName: "view"
            }
            });
        }
}