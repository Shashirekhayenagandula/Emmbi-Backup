import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LeadFetch from '@salesforce/apex/PromotionalMassSMSClass.LeadFetch';
import CustomerFetch from '@salesforce/apex/PromotionalMassSMSClass.CustomerFetch';
import SearchValLeadFetch from '@salesforce/apex/PromotionalMassSMSClass.SearchValLeadFetch';
import SearchValCustomerFetch from '@salesforce/apex/PromotionalMassSMSClass.SearchValCustomerFetch';
import bulkSMSsend from '@salesforce/apex/PromotionalMassSMSClass.bulkSMSsend';

export default class PromotinalMassSMSLwc extends LightningElement {
    @track LeadTableLayout=false;
    @track CustomerTableLayout=false;
    @track IsSelected=true;
    @track LeadList=[];
    @track CustomerList=[];
    @track FinalList=[];
    @track CopyList=[];
    @track error;
    @track searchVal;
    @track SelectVal;
    @track buttonDisable=true;
    @track NextTemplate=false;
    @track pgURL;
    @track SMSWriteModal=false;
    @track MobileList=[];
    @track TextMsg;
    @track sendButton=false;
    @track sucs;
    @track isSpinner=false;

    connectedCallback(){
        this.pgURL=window.location.href;
        console.log('URL::'+this.pgURL);
    }

    LeadOrCustomerFetch(){
        this.SelectVal=this.template.querySelector('.slct').value;
        console.log('Select::'+this.SelectVal);
        this.isSpinner=true;
        if(this.SelectVal=='Lead'){
            this.IsSelected=false;
            LeadFetch()
            .then(result=>{
                this.LeadList=result;
                this.CopyList=this.LeadList;
                //console.log('Lead Copy::'+JSON.stringify(this.CopyList));
                console.log('List ChKval');
                if(this.FinalList.length>0){
                   // console.log('FLEN:'+this.FinalList.length);
                    for(let i=0;i<this.FinalList.length;i++){
                        for(let j=0;j<this.LeadList.length;j++){
                            if(this.LeadList[j].Id==this.FinalList[i].Id){
                                this.LeadList[j].chkval=true;
                            }
                        }
                    }
                }
                this.CustomerTableLayout=false;
                this.LeadTableLayout=true;
                this.isSpinner=false;
                
            })
            .catch(error=>{
                this.error=error;
            });
        }
        else if(this.SelectVal=='Customer'){
            this.IsSelected=false;
            CustomerFetch()
            .then(result=>{
                this.CustomerList=result;
                this.CopyList=this.CustomerList;
                //console.log('Cust Copy::'+JSON.stringify(this.CopyList));
                if(this.FinalList.length>0){
                   // console.log('FLEN:'+this.FinalList.length);
                    for(let i=0;i<this.FinalList.length;i++){
                        for(let j=0;j<this.CustomerList.length;j++){
                            if(this.CustomerList[j].Id==this.FinalList[i].Id){
                                this.CustomerList[j].chkval=true;
                            }
                        }
                    }
                }
                this.LeadTableLayout=false;
                this.CustomerTableLayout=true;
                this.isSpinner=false;
            })
            .catch(error=>{
                this.error=error;
               
            });
        }
        else{
            this.IsSelected=true;
            this.LeadTableLayout=false;
            this.CustomerTableLayout=false;
            this.LeadList=[];
            this.CustomerList=[];
            this.FinalList=[];
            this.buttonDisable=true;
            this.isSpinner=false;
        }
    }

    SearchValResult(){
        this.SelectVal=this.template.querySelector('.slct').value;
        this.searchVal=this.template.querySelector('.srch').value;
        console.log('SELECT::'+this.SelectVal);
        console.log('SEARCH::'+this.searchVal);
        if(this.searchVal!=''){
            if(this.SelectVal=='Lead'){
               /* SearchValLeadFetch({sval:this.searchVal})
                .then(result=>{
                    this.LeadList=result;
                    this.CustomerTableLayout=false;
                    this.LeadTableLayout=true;
                })
                .catch(error=>{
                    this.error=error;
                });*/

                this.LeadList= this.CopyList.filter(item=>{
                    return item.Farmer_First_Name__c.toLowerCase().startsWith(this.searchVal.toLowerCase());
                });
            }
            else{
              /*  SearchValCustomerFetch({sval:this.searchVal})
                .then(result=>{
                    this.CustomerList=result;
                    this.LeadTableLayout=false;
                    this.CustomerTableLayout=true;
                })
                .catch(error=>{
                    this.error=error;
                });*/

                this.CustomerList= this.CopyList.filter(item=>{
                    return item.Farmer_First_Name__c.toLowerCase().startsWith(this.searchVal.toLowerCase());
                });
            }
        } 
        else{
            if(this.SelectVal=='Lead'){
                this.IsSelected=false;
                this.LeadList=this.CopyList;
                this.CustomerTableLayout=false;
                this.LeadTableLayout=true;
               /* LeadFetch()
                .then(result=>{
                    this.LeadList=result;
                    this.CustomerTableLayout=false;
                    this.LeadTableLayout=true;
                    
                })
                .catch(error=>{
                    this.error=error;
                });*/
            }
            else{
                 this.IsSelected=false;
                 this.CustomerList=this.CopyList;
                 this.LeadTableLayout=false;
                 this.CustomerTableLayout=true;
                /*CustomerFetch()
                .then(result=>{
                    this.CustomerList=result;
                    this.LeadTableLayout=false;
                    this.CustomerTableLayout=true;
                })
                .catch(error=>{
                    this.error=error;
               
                });*/
            }   
        }
    }

    SelectedList(event){
        this.SelectVal=this.template.querySelector('.slct').value;
        console.log('SELECTVAL::'+this.SelectVal);
        console.log('Check Val::'+event.target.value);

        if(event.target.checked==true){
            if(this.SelectVal=='Lead'){
                for(let i=0;i<this.LeadList.length;i++){
                    if(event.target.value==this.LeadList[i].Id){
                        console.log('LeadPreFinalList::'+JSON.stringify(this.FinalList));
                        console.log('LeadList::'+JSON.stringify(this.LeadList));
                        this.FinalList.push({'Id':this.LeadList[i].Id,'FName':this.LeadList[i].Farmer_First_Name__c,'LName':this.LeadList[i].Farmer_Last_Name__c,'Mobile':this.LeadList[i].Mobile_Number__c});
                       console.log('FinalList:::'+JSON.stringify(this.FinalList));
                        this.LeadList[i].chkval=true;
                    }
                }
            }
            else{
                for(let i=0;i<this.CustomerList.length;i++){
                    if(event.target.value==this.CustomerList[i].Id){
                        console.log('CustPreFinalList::'+this.FinalList);
                        console.log('CustList::'+JSON.stringify(this.CustomerList));
                        this.FinalList.push({'Id':this.CustomerList[i].Id,'FName':this.CustomerList[i].Farmer_First_Name__c,'LName':this.CustomerList[i].Name,'Mobile':this.CustomerList[i].Phone});
                        console.log('FinalList:::'+JSON.stringify(this.FinalList));
                        this.CustomerList[i].chkval=true;
                    }
                }
            } 
            if(this.FinalList.length>0){
                this.buttonDisable=false;
            }    
        }
        else{
            if(this.SelectVal=='Lead'){
                for(let i=0;i<this.LeadList.length;i++){
                    if(event.target.value==this.FinalList[i].Id){
                        this.FinalList.splice(i,1);
                       // console.log('UNCHECK::'+JSON.stringify(this.FinalList));
                        for(let j=0;j<this.LeadList.length;j++){
                            if(event.target.value==this.LeadList[j].Id){
                                this.LeadList[j].chkval=false;
                            }
                        }
                        break;
                    }
                }
            }
            else{
                for(let i=0;i<this.CustomerList.length;i++){
                    if(event.target.value==this.FinalList[i].Id){
                        this.FinalList.splice(i,1);
                        //console.log('UNCHECK::'+JSON.stringify(this.FinalList));
                        for(let j=0;j<this.CustomerList.length;j++){
                            if(event.target.value==this.CustomerList[j].Id){
                                this.CustomerList[j].chkval=false;
                            }
                        }
                        break;
                    }
                }
            } 
           if(this.FinalList.length==0){
               this.buttonDisable=true;
           }   
        }
    }

    handleCancel(){
        location.reload();
       /* this.template.querySelector('.slct').value='NONE';
        this.template.querySelector('.srch').value='';
        this.LeadList='';
        this.CustomerList='';
        this.FinalList='temp';
        this.LeadTableLayout=false;
        this.CustomerTableLayout=false;
        this.IsSelected=true;
        this.buttonDisable=true;*/
    }

    handleNext(){
        this.NextTemplate=true;
    }

    deleteItem(event){
        for(let i = 0;i<this.FinalList.length;i++){
            if(event.target.value == this.FinalList[i].Id){
                this.FinalList.splice(i,1);
                if(this.SelectVal=='Lead'){
                    for(let j=0;j<this.LeadList.length;j++){
                        if(event.target.value==this.LeadList[j].Id){
                            this.LeadList[j].chkval=false;
                        }
                    }
                }
                else{
                    for(let j=0;j<this.CustomerList.length;j++){
                        if(event.target.value==this.CustomerList[j].Id){
                            this.CustomerList[j].chkval=false;
                        }
                    }
                }
            }
        }

        if(this.FinalList.length == 0){
            this.NextTemplate = false;
            this.buttonDisable=true;
        }
    } 

    handleNextMsg(){
        this.NextTemplate=false;
        this.SMSWriteModal=true;
    }

    /*SecondCancel(){
        location.reload();
       this.template.querySelector('.slct').value='NONE';
        this.template.querySelector('.srch').value='';
        this.LeadList='';
        this.CustomerList='';
        this.FinalList='temp';
        this.LeadTableLayout=false;
        this.CustomerTableLayout=false;
        this.IsSelected=true;
        this.buttonDisable=true;
        this.NextTemplate=false;
    }*/

    handleBack(){
        console.log('Back');
        this.NextTemplate=false;
    }

    handleSMSBack(){
        this.SMSWriteModal=false;
        this.NextTemplate=true;
    }

    handleSendMsg(){
        this.sendButton=true;
        this.TextMsg=this.template.querySelector('.TxtArea').value;
        for(let i=0; i<this.FinalList.length;i++){
            this.MobileList.push(this.FinalList[i].Mobile);
        }
        console.log('Mobile List::'+this.MobileList);
        console.log('TEXT MSG::'+this.TextMsg);
        if(this.TextMsg.length==0){
            const ev = new ShowToastEvent({
                title: 'Warning',
                message: 'You Can Not Send SMS With Blank Message.Please Write Some Message!!!',
                variant: 'warning',
            });
            this.dispatchEvent(ev);
            this.MobileList=[];
            this.sendButton=false;
        }
        else{
            console.log('Send SMS Method Call');
        
         bulkSMSsend({MobList:this.MobileList,Msg:this.TextMsg})
            .then(result=>{
                this.sucs=result;
                if(this.sucs==='success'){
                    const event = new ShowToastEvent({
                        title: 'Success',
                        message: 'SMS Send Successfully.',
                        variant: 'success',
                    });
                    this.dispatchEvent(event);
                    location.reload();
                }
                else{
                    const even = new ShowToastEvent({
                        title: 'Error',
                        message: 'SMS Not Send Successfully!!!!',
                        variant: 'error',
                    });
                    this.dispatchEvent(even);
                    this.MobileList=[];
                    this.sendButton=false;
                }
            })
            .catch(error=>{
                this.error=error;
                const eve = new ShowToastEvent({
                    title: 'Error',
                    message: 'Something Wrong!!!Please Contact Your System Admin.',
                    variant: 'error',
                });
                this.dispatchEvent(eve);
                this.MobileList=[];
                this.sendButton=false;
            });
        }
    }
}