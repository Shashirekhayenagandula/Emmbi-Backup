import { LightningElement,track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getLeadName from '@salesforce/apex/LeadConvertClass.getLeadName';
import LeadCnvrt from '@salesforce/apex/LeadConvertClass.LeadCnvrt';
import OppTest from '@salesforce/apex/LeadConvertClass.OppTest';
import OppStageTest from '@salesforce/apex/LeadConvertClass.OppStageTest';

export default class CustomConvertLead extends NavigationMixin(LightningElement){
@api recId;
@track accfName;
@track accmName;
@track acclName;
@track error;
@track res;
@track stg;
@track temp=false;
@track temp1=false;
@track isOpp=false;
@track checkStg=false;
@track OppStg;
@track countOpp;

connectedCallback(){
    console.log('RECID'+this.recId);
    getLeadName({lId:this.recId})
    .then(result=>{
        let aName=result;
        this.accfName=aName.Farmer_First_Name__c;
        this.accmName=aName.Farmer_Middle_Name__c;
        this.acclName=aName.Farmer_Last_Name__c;
        this.stg=aName.Stages__c;
       // console.log('NAME::'+this.accName);
        if(this.stg=='Converted'){
            this.temp=true;
            this.temp1=false;
            this.isOpp=false;
        }
        else{
            OppTest({lId:this.recId})
            .then(rest=>{
                this.countOpp=rest;
                if(this.countOpp==true){
                   /* this.isOpp=false;
                    this.temp1=true; 
                    this.temp=false;*/
                    OppStageTest({lId:this.recId})
                    .then(r=>{
                        this.OppStg=r;
                        if(this.OppStg==true){
                            this.isOpp=false;
                            this.temp1=true; 
                            this.temp=false;
                        }
                        else{
                            this.checkStg=true;
                            this.temp1=false;
                         }
                    })
                    .catch(error=>{
                        this.error=error;
                    })
                }
                else{
                    this.isOpp=true;
                     this.temp1=false;
                    this.temp=false;
                }
            })
            .catch(error=>{
                this.error=error;
            })
        }
    })
    .catch(error=>{
        this.error=error;
    })


}

handleConvert(){
    this.accfName=this.template.querySelector('.acfName').value;
    this.accmName=this.template.querySelector('.acmName').value;
    this.acclName=this.template.querySelector('.aclName').value;
    //console.log('CUSTOMEFR::'+this.accName);
    LeadCnvrt({ldId:this.recId,fName:this.accfName,mName:this.accmName,lName:this.acclName})
    .then(result=>{
        this.res=result;
        console.log('ACCCCC:::'+this.res);
        if(this.res!='error' && this.res!='NoOppWon' && this.res!='duplicate'){
            const event = new ShowToastEvent({
                variant: 'success',
                message: 'Lead Successfully Converted To Customer.',
            });
            this.dispatchEvent(event);
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.res,
                    objectApiName: 'Account', // objectApiName is optional
                    actionName: 'view'
                }
            });
        }
        else if(this.res=='NoOppWon'){
            const eve = new ShowToastEvent({
                variant: 'warning',
                message: 'There is no Enquiry with Stage Enquiry Won!!!',
            });
            this.dispatchEvent(eve);
        }
        else if(this.res=='duplicate'){
            const ev = new ShowToastEvent({
                variant: 'warning',
                message: 'There is a Customer with same Mobile Number!!!',
            });
            this.dispatchEvent(ev);
        }
        else{
            const even = new ShowToastEvent({
                variant: 'error',
                message: 'Something Wrong!!!',
            });
            this.dispatchEvent(even);
        }
    })
    .catch(error=>{
      this.error=error;  
    })
}

handleCancel(){
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.recId,
            objectApiName: 'Lead__c', // objectApiName is optional
            actionName: 'view'
        }
    });
}
}