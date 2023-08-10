import { LightningElement ,api,track,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Checkin from '@salesforce/apex/CheckInCheckout.Checkin';
import CheckOut from '@salesforce/apex/CheckInCheckout.CheckOut';
import { CurrentPageReference,NavigationMixin } from 'lightning/navigation';
export default class AvanaCheckInCheckOut extends NavigationMixin( LightningElement) {
    @api recId;
    @track lat;
    @track lng;
    @track res;
    @track err;
    @track incheck=false;
   // @api pgURL;
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
    }

    connectedCallback(){
        console.log('ID=>'+this.recId);
        console.log('CURRENT  PG URL OBJ=>:::'+this.currentPageReference.attributes.objectApiName);
        
    }

    handlecheckin(){
     console.log('checkin:::::');
      this.incheck=true;
      this.locationfetch(); 
    }
    handleCheckOut(){
        console.log('checkout:::');
        this.locationfetch();
    }


    // Location Fetch Using Javascript
    locationfetch(){
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition((position)=>{
            this.lat = position.coords.latitude; 
            this.lng = position.coords.longitude; 
            console.log("lat: "+this.lat);
            console.log("lng: "+this.lng);
            if(this.incheck===true){
               // if(this.currentPageReference.attributes.objectApiName==='Lead__c'){
                    console.log('Check In Method Call.');
                //Lead checkin Method
                    Checkin({ ObjId:this.recId,lati:this.lat,lon:this.lng })
                        .then(result=>{
                            this.res=result;
                            if(this.res==='sucess'){
                                const event = new ShowToastEvent({
                                    title: 'Success',
                                    message: 'Successfully Checked-In.',
                                    variant: 'success',
                                });
                                this.dispatchEvent(event);
                                if(this.currentPageReference.attributes.objectApiName==='Lead__c'){
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__recordPage',
                                        attributes: {
                                            recordId:this.recId,
                                            objectApiName: 'Lead__c',
                                            actionName: 'view',
                                            
                                        },
                                    });
                                }
                                else if(this.currentPageReference.attributes.objectApiName==='Account'){
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__recordPage',
                                        attributes: {
                                            recordId:this.recId,
                                            objectApiName: 'Account',
                                            actionName: 'view',
                                            
                                        },
                                    });
                                }
                                else{
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__recordPage',
                                        attributes: {
                                            recordId:this.recId,
                                            objectApiName: 'Complaint__c',
                                            actionName: 'view',
                                            
                                        },
                                    });
                                }

                            }
                            else if(this.res==='checkoutfist'){
                                const even = new ShowToastEvent({
                                    title: 'Error',
                                    message: 'Fisrt CheckOut Your Previous checkin',
                                    variant: 'error',
                                });
                                this.dispatchEvent(even);
                            }
                            else{
                                const even = new ShowToastEvent({
                                    title: 'Error',
                                    message: 'Contact system admin',
                                    variant: 'error',
                                });
                                this.dispatchEvent(even);

                            }
                        })
                        .catch(error=>{
                            this.err=error;
                        })
                        this.incheck=false;
                   /* }
                    else{
                        console.log('Complaint Check In Method Call.');
                        this.incheck=false;
                    }*/

                }   
            else{
               // if(this.currentPageReference.attributes.objectApiName==='Lead__c'){
                    console.log('Check Out Method Call.');
            //Lead checkOut Method    
                    CheckOut({ObjId:this.recId,lati:this.lat,lon:this.lng})
                    .then(result=>{
                            this.res=result;
                            if(this.res==='sucesscheckout'){
                                const even = new ShowToastEvent({
                                    title: 'Success',
                                    message: 'Successfully Checked Out',
                                    variant: 'success',
                                });
                                this.dispatchEvent(even);
                                if(this.currentPageReference.attributes.objectApiName==='Lead__c'){
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__recordPage',
                                        attributes: {
                                            recordId: this.recId,
                                            objectApiName: 'Lead__c',
                                            actionName: 'view',
                                            
                                        },
                                    });
                                }
                                else if(this.currentPageReference.attributes.objectApiName==='Account'){
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__recordPage',
                                        attributes: {
                                            recordId: this.recId,
                                            objectApiName: 'Account',
                                            actionName: 'view',
                                            
                                        },
                                    }); 
                                }
                                else{
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__recordPage',
                                        attributes: {
                                            recordId: this.recId,
                                            objectApiName: 'Complaint__c',
                                            actionName: 'view',
                                            
                                        },
                                    });
                                }

                            }
                            else if(this.res==='checkinfirst'){
                                const even = new ShowToastEvent({
                                    title: 'Warning',
                                    message: 'Check In Fisrt',
                                    variant: 'Warning',
                                });
                                this.dispatchEvent(even);

                            }
                            else{
                                const even = new ShowToastEvent({
                                    title: 'Error',
                                    message: 'Contact system admin',
                                    variant: 'error',
                                });
                                this.dispatchEvent(even);


                            }
                    })
                    .catch(error=>{
                    this.err=error;
                  })
               /* }
                else{
                    console.log('Complaint Check Out Method Call.');
                 }*/
            }   
        });      
    }    
 }
}