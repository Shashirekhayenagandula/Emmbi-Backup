import { LightningElement,track,wire } from 'lwc';
import { CurrentPageReference,NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CloseComplaint from '@salesforce/apex/ComplaintClose.CloseComplaint';

export default class OTPComponentLwc extends NavigationMixin(LightningElement) {

    @track getOTP;
    @track clickSubmit=false;
    @track sucs;
    @track er;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }

    connectedCallback(){
        console.log('currentPageReference=>'+JSON.stringify(this.currentPageReference));
        console.log('CURRENT  OBJ=>:::'+this.currentPageReference.attributes.recordId);
        
    }

    handleSubmit(){
        this.clickSubmit=true;
        console.log('SUBMIT');
        this.getOTP=this.template.querySelector('.OTP').value;
        console.log('OTP::::'+this.getOTP);
        if(this.getOTP===''){
            const even = new ShowToastEvent({
                variant: 'error',
                message: 'Please Enter Customer OTP!!!',
            });
            this.dispatchEvent(even);
            this.clickSubmit=false;
        }
        else{
            CloseComplaint({ObjId:this.currentPageReference.attributes.recordId,OTPNO:this.getOTP})
            .then(result=>{
                this.sucs=result;
                if(this.sucs=='success'){
                    const event = new ShowToastEvent({
                        title: 'Success',
                        variant: 'success',
                        message: 'Complaint Closed Successfully.',
                    });
                    this.dispatchEvent(event);
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.currentPageReference.attributes.recordId,
                            objectApiName: this.currentPageReference.attributes.objectApiName, // objectApiName is optional
                            actionName: 'view'
                        }
                    });
                }
                else if(this.sucs=='error'){
                    const e = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: 'Please Enter Correct OTP!!!',
                    });
                    this.dispatchEvent(e);
                    this.clickSubmit=false;
                }
                else{
                    const en = new ShowToastEvent({
                        title: 'Warning!!!',
                        variant: 'Warning',
                        message: 'Please Generate OTP!!!',
                    });
                    this.dispatchEvent(en);
                    this.clickSubmit=false;
                }
            })
            .catch(error=>{
                this.er=error;
            })
        }
    }

    handleCancel(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.currentPageReference.attributes.recordId,
                objectApiName: this.currentPageReference.attributes.objectApiName, // objectApiName is optional
                actionName: 'view'
            }
        });
    }
}