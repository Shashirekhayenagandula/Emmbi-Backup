import { LightningElement,track } from 'lwc';
import getMonthFirstStageEmpTargetList from '@salesforce/apex/LwcForTargetsVsAchivement.getMonthFirstStageEmpTargetList';
import getMonthSecondStageEmpTargetList from '@salesforce/apex/LwcForTargetsVsAchivement.getMonthSecondStageEmpTargetList';
import getMonthThirdStageEmpTargetList from '@salesforce/apex/LwcForTargetsVsAchivement.getMonthThirdStageEmpTargetList';
import getMonthForthStageEmpTargetList from '@salesforce/apex/LwcForTargetsVsAchivement.getMonthForthStageEmpTargetList';
import getMonthAllTargetEmpTargetList from '@salesforce/apex/LwcForTargetsVsAchivement.getMonthAllTargetEmpTargetList';


const cols =[
    {label :"Employee Name",fieldName: 'Name'},
    {label :"Previous Month Achievement",fieldName: 'Previous_Month_Achievement__c'},
    {label :"Previous Month Target",fieldName: 'Previous_Month_Target__c'},
  /*{label :"Contact Name",fieldName: 'Contact_Name__c'}, 
    {label :"Case Subject",fieldName: 'Subject'},
    {label :"Case Status",fieldName: 'Status'},
   */
];

export default class TargetCompletedEmp extends LightningElement {

    @track value = '';
    @track isVisiable= false;
    @track columns=cols;

    @track data =[];
   


    get options() {
        return [
            { label: 'Less Than 40 %', value: 'Step1' },
            { label: 'In Between 40 To 60', value: 'Step2' },  
            { label: 'In Between 60 To 80', value: 'Step3' },
            { label: 'Greater Than 80', value: 'Step4' }, 
            { label: 'All Employee', value: 'All' },  
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
        this.isVisiable =true;
        if(this.value === 'Step1'){
            getMonthFirstStageEmpTargetList()
            .then(res =>{
                this.data=res;
            })
            .catch(err=>{
                console.log("Error");
            })
        }
        else if(this.value === 'Step2'){

            getMonthSecondStageEmpTargetList()
            .then(res =>{
                this.data=res;

            })
            .catch(err=>{
                console.log("Error");
            })

        }
        else if(this.value === 'Step3'){

            getMonthThirdStageEmpTargetList()
            .then(res =>{
                this.data=res;

            })
            .catch(err=>{
                console.log("Error");
            })

        }
        else if(this.value === 'Step4'){

            getMonthForthStageEmpTargetList()
            .then(res =>{
                this.data=res;

            })
            .catch(err=>{
                console.log("Error");
            })

        }
        else if(this.value === 'All'){

            getMonthAllTargetEmpTargetList()
            .then(res =>{
                this.data=res;

            })
            .catch(err=>{
                console.log("Error");
            })

        }
        
    }

   

    downloadCSVFile() {   
        let rowEnd = '\n';
        let csvString = '';
        
        let rowData = new Set();

       
        this.data.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
            });
        });

        
        rowData = Array.from(rowData);
        
       
        csvString += rowData.join(',');
        csvString += rowEnd;

        
        for(let i=0; i < this.data.length; i++){
            let colValue = 0;

            
            for(let key in rowData) {
                if(rowData.hasOwnProperty(key)) {
                    
                    let rowKey = rowData[key];
                   
                    if(colValue > 0){
                        csvString += ',';
                    }
                    
                    let value = this.data[i][rowKey] === undefined ? '' : this.data[i][rowKey];
                    csvString += '"'+ value +'"';
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

       
        let downloadElement = document.createElement('a');

        
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        
        downloadElement.download = 'Case Data.csv';
        
        document.body.appendChild(downloadElement);
        
        downloadElement.click(); 
    }


    connectedCallback(){

        
    }

}