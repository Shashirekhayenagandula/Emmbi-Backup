import { LightningElement,track,api } from 'lwc';
import searchRecords from '@salesforce/apex/LookupController.getAccountData';

export default class CustomLoockup extends LightningElement {
    searchKey;

    @track error;

    @track accounts;
    //This Funcation will get the value from Text Input.
    handelSearchKey(event){
        this.searchKey = event.target.value;
        console.log( searchKey);
       
    }

    //This funcation will fetch the Account Name on basis of searchkey
    SearchAccountHandler(){
        //call Apex method.
        searchRecords({searchTerm: this.searchKey})
        .then(result => {
    console.log(this.result);
                this.accounts = result;
        })
        .catch( error=>{
            this.accounts = null;
            this.error=error;
          
        });

    }
    

  

  
}