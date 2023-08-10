public with sharing class CheckInCheckout {
    
    @AuraEnabled
    public static string Checkin(String ObjId,Double lati,Double lon){
        System.debug('id:::::::::'+ObjId);
        Id myId=ObjId;
        String sObjName = myId.getSObjectType().getDescribe().getName();
        System.debug('object name::'+sObjName);
        Id  userId=UserInfo.getUserId();
        String res;
        if(sObjName=='Opportunity__c'){
                List<Event> fetchchecklist=[select id,ownerId,Related_To_Enquiry__c from event where Related_To_Enquiry__c=:ObjId and Check_In__c=true and Check_Out__c=false and createddate=today and ownerId=:userId];
                System.debug('fetchchecklist for Lead::::: '+fetchchecklist);
                if(fetchchecklist.size()>0 && fetchchecklist!=null){
                    System.debug('inside false:::'); 
                    return 'checkoutfist'; 
                } 
                else{
                    List<Event> evtlist=CheckInCheckout.createEvent(ObjId,lati,lon);
                    if(evtlist.size()>0 && evtlist!=null){
                        res= 'sucess';
                    }
                    return res;
                }
        }
        else if(sObjName =='Account'){
                List<Event> fetchchecklist=[select id,ownerId,Related_To_Customer__c from event where Related_To_Customer__c=:ObjId and Check_In__c=true and Check_Out__c=false and createddate=today and ownerId=:userId];
                System.debug('fetchchecklist for Account:::::'+fetchchecklist);
                if(fetchchecklist.size()>0 && fetchchecklist!=null){
                    System.debug('inside false:::'); 
                    return 'checkoutfist'; 
                } 
                else{
                    List<Event> evtlist=CheckInCheckout.createEvent(ObjId,lati,lon);
                    if(evtlist.size()>0 && evtlist!=null){
                        res= 'sucess';
                }
                return res;
                }
        } 
        else{
            List<Event> fetchchecklist=[select id,ownerId,Related_To_Complaint__c from event where Related_To_Complaint__c=:ObjId and Check_In__c=true and Check_Out__c=false and createddate=today and ownerId=:userId];
            System.debug('fetchchecklist for Complaint:::::'+fetchchecklist);
            if(fetchchecklist.size()>0 && fetchchecklist!=null){
                System.debug('inside false:::'); 
                return 'checkoutfist'; 
            } 
            else{
                List<Event> evtlist=CheckInCheckout.createEvent(ObjId,lati,lon);
                if(evtlist.size()>0 && evtlist!=null){
                    res= 'sucess';
            }
            return res;
            }
        } 

    }
    @AuraEnabled
    public static string CheckOut(String ObjId,Double lati,Double lon){
       System.debug('Object id for checkout:::::::::'+ObjId);
       Id myId=ObjId;
       String sObjName = myId.getSObjectType().getDescribe().getName();
       System.debug('object name::'+sObjName);
       Id  userId=UserInfo.getUserId();
       List<Event> checkoutEvent=new List<Event>();
       if(sObjName=='Opportunity__c'){
       List<Event> evlist=[select id,ownerId,Related_To_Enquiry__c from event where Related_To_Enquiry__c=:ObjId and Check_In__c=true and Check_Out__c=false and createddate=today and ownerId=:userId];
       System.debug('fetched checkin for Lead:::::::::'+evlist);      
       if(evlist!=null && evlist.size()>0){
           for(Event evt:evlist){
               evt.Check_Out__c=true;
               evt.Check_Out_Date_Time__c=System.now();
               evt.CheckOut_Location__Latitude__s=lati;
               evt.CheckOut_Location__Longitude__s=lon;
               checkoutEvent.add(evt);
           }
         }
       }
       else if(sObjName=='Account'){
       List<Event> evlist=[select id,ownerId,Related_To_Customer__c from event where Related_To_Customer__c=:ObjId and Check_In__c=true and Check_Out__c=false and createddate=today and ownerId=:userId];
       System.debug('fetched checkin for Account:::::::::'+evlist);      
       if(evlist!=null && evlist.size()>0){
           for(Event evt:evlist){
               evt.Check_Out__c=true;
               evt.Check_Out_Date_Time__c=System.now();
               evt.CheckOut_Location__Latitude__s=lati;
               evt.CheckOut_Location__Longitude__s=lon;
               checkoutEvent.add(evt);
           }
         }

       }
       else{
        List<Event> evlist=[select id,ownerId,Related_To_Complaint__c from event where Related_To_Complaint__c=:ObjId and Check_In__c=true and Check_Out__c=false and createddate=today and ownerId=:userId];
        System.debug('fetched checkin for Account:::::::::'+evlist);      
        if(evlist!=null && evlist.size()>0){
            for(Event evt:evlist){
                evt.Check_Out__c=true;
                evt.Check_Out_Date_Time__c=System.now();
                evt.CheckOut_Location__Latitude__s=lati;
                evt.CheckOut_Location__Longitude__s=lon;
                checkoutEvent.add(evt);
            }
          }
       }
           if(checkoutEvent!=null && checkoutEvent.size()>0){
               update checkoutEvent;
               return 'sucesscheckout';
           }
           else{
               return 'checkinfirst';
           }
       

    }


Public  static List<Event> createEvent(String lid,Double lati,Double lon){
    System.debug(' id of which object:::::::::'+lid);
    Id myId=lid;
    String sObjName = myId.getSObjectType().getDescribe().getName();
    System.debug('object name::'+sObjName);
    Id  userId=UserInfo.getUserId();
    List<Event> Inevlist=new List<Event>();
    if(sObjName=='Opportunity__c'){
        System.debug('inside lead event creation:::');
        Event evt=new Event();
        evt.Subject='Meeting';
        evt.StartDateTime=System.now();
        evt.EndDateTime=System.now();
        evt.Related_To_Enquiry__c=lid;
        evt.Check_In_Date_Time__c=System.now();
        evt.CheckIn_Location__Latitude__s=lati;
        evt.CheckIn_Location__Longitude__s=lon;
        evt.Check_In__c=True;
        evt.ownerId=userId;
        Inevlist.add(evt);
    }
    else if(sObjName=='Account'){
        System.debug('inside Account event creation:::');
        Event evt=new Event();
        evt.Subject='Call';
        evt.StartDateTime=System.now();
        evt.EndDateTime=System.now();
        evt.Related_To_Customer__c=lid;
        evt.Check_In_Date_Time__c=System.now();
        evt.CheckIn_Location__Latitude__s=lati;
        evt.CheckIn_Location__Longitude__s=lon;
        evt.Check_In__c=True;
        evt.ownerId=userId;
        Inevlist.add(evt);

    }
    else{
        System.debug('inside Account event creation:::');
        Event evt=new Event();
        evt.Subject='Call';
        evt.StartDateTime=System.now();
        evt.EndDateTime=System.now();
        evt.Related_To_Complaint__c=lid;
        evt.Check_In_Date_Time__c=System.now();
        evt.CheckIn_Location__Latitude__s=lati;
        evt.CheckIn_Location__Longitude__s=lon;
        evt.Check_In__c=True;
        evt.ownerId=userId;
        Inevlist.add(evt);
    }

    if(Inevlist.size()>0 && Inevlist!=null){
        insert Inevlist;
        return Inevlist;
    }
    else{
       return null;
    }
    
}




}