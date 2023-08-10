public class Unique_Email {

    Public static void  conEmail(Retail_Employee__c[] conEmaildata )
    {
              
         List<Retail_Employee__c> newassets = (List<Retail_Employee__c>) conEmaildata;
         List<Retail_Employee__c> conList = [SELECT Id,Email__c FROM Retail_Employee__c WITH SECURITY_ENFORCED ];
        List<String> emailConList = new List<String>();
        
        for(Retail_Employee__c con : conList){
            emailConList.add(con.Email__c);
        }
        for(Retail_Employee__c con : newassets)
        {
            if(emailConList.contains(con.Email__c)){
                con.addError('Email already exist');
            }
        }
    }
    Public static void  conEmailUpdate(List<Retail_Employee__c> conList, Map<Id,Retail_Employee__c> oldConMap ){
        
        List<String> emailList = new List<String>();
        for(Retail_Employee__c con : conList){
            emailList.add(con.Email__c);
        }
        List<Retail_Employee__c> conEmailList = [SELECT Id,Name,Email__c FROM Retail_Employee__c WHERE Email__c IN :emailList];
        for(Retail_Employee__c con : conList){
            if(oldConMap.get(con.Id).Email__c != con.Email__c){
				  for(Retail_Employee__c oldCon : conEmailList){
                    if( con.Email__c == oldCon.Email__c && con.Id != oldCon.Id){
                        con.addError('Email already exist');
                    }
                } 
            }
        }
    }

}