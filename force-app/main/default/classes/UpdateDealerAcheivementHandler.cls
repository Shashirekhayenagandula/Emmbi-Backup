public class UpdateDealerAcheivementHandler {
   
    public Static void acheivementUpdate(List<Opportunity__c> opps){
    if( Label.update_dealer_achivement == 'Yes'){   
    Set<Id> parentIds = new Set<Id>();
    List<Dealer_with_Tehsil__c> LastThreeMonthUpdate = new List<Dealer_with_Tehsil__c>();
    List<Dealer_with_Tehsil__c> LastOneMonthUpdate = new List<Dealer_with_Tehsil__c>();
    List<Dealer_with_Tehsil__c> CurrentMonthUpdate = new List<Dealer_with_Tehsil__c>();    
    		
    for (Opportunity__c deal: opps) {
        parentIds.add(deal.Dealer_with_Tehsil__c);
    }
    if(parentIds.size()>0){
    for (Id parentId : parentIds) {
        
        // Update last 3 month Achievements
       
        Dealer_with_Tehsil__c d = [SELECT Id, Last_Three_Month_Achievement__c, (SELECT Achivement__c,Invoice_Date__c FROM Product_Information__r where Invoice_Date__c = LAST_N_MONTHS:3) FROM Dealer_with_Tehsil__c WHERE Id = :parentId];
       Decimal totalThreeMonthAchievement= 0;
		        
        for (Opportunity__c child : d.Product_Information__r) {
            
            if(child.Invoice_Date__c != null){
            

            totalThreeMonthAchievement+= child.Achivement__c;
        	 }
        }
        
        d.Last_Three_Month_Achievement__c= totalThreeMonthAchievement;
   		
        LastThreeMonthUpdate.add(d);
        
        
        // Update last month achievement
        
         Dealer_with_Tehsil__c d1 = [SELECT Id, Previous_Month_Achievement__c, (SELECT Achivement__c,Invoice_Date__c FROM Product_Information__r where Invoice_Date__c = LAST_MONTH) FROM Dealer_with_Tehsil__c WHERE Id = :parentId];
       Decimal totalLastMonthAchievement= 0;
		        
        for (Opportunity__c child : d1.Product_Information__r) {
            
            if(child.Invoice_Date__c != null){
            

            totalLastMonthAchievement+= child.Achivement__c;
        	 }
        }
        
        d1.Previous_Month_Achievement__c= totalLastMonthAchievement;
   		
        LastOneMonthUpdate.add(d1);
        
        
        // Update Current month Achievemnts
        
        Dealer_with_Tehsil__c d2 = [SELECT Id, This_Month_Achievement__c, (SELECT Achivement__c,Invoice_Date__c FROM Product_Information__r where Invoice_Date__c = THIS_MONTH) FROM Dealer_with_Tehsil__c WHERE Id = :parentId];
       Decimal totalThisMonthAchievement= 0;
		        
        for (Opportunity__c child : d2.Product_Information__r) {
            
            if(child.Invoice_Date__c != null){
            

            totalThisMonthAchievement+= child.Achivement__c;
        	 }
        }
        
        d2.This_Month_Achievement__c= totalThisMonthAchievement;
   		
        CurrentMonthUpdate.add(d2);
 
    }
    }    
    System.debug(LastThreeMonthUpdate.size());
    System.debug(LastOneMonthUpdate.size());
    System.debug(CurrentMonthUpdate.size());
    update LastThreeMonthUpdate;
    update LastOneMonthUpdate;
    update CurrentMonthUpdate;
      
    }
    
}
    
    
    
    
    
    
    
    
    
    /* 
    public Static void acheivementUpdate(List<Opportunity__c> opps){
        
    Set<Id> parentIds = new Set<Id>();
    List<Dealer__c> dealersToUpdate = new List<Dealer__c>();
    		
    for (Opportunity__c deal: opps) {
        parentIds.add(deal.Dealer__c);
    }
    
    for (Id parentId : parentIds) {
        
        Dealer__c d = [SELECT Id, Three_Month_Achievement__c, (SELECT Pondliner_Size_Requested_Required_Sq_Mt__c,Invoice_Date__c FROM Enquiry__r where Invoice_Date__c = LAST_N_MONTHS:3) FROM Dealer__c WHERE Id = :parentId];
       Decimal totalThreeMonthAchievement= 0;
		        
        for (Opportunity__c child : d.Enquiry__r) {
            
            if(child.Invoice_Date__c != null){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            totalThreeMonthAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	 }
        }
        if (totalThreeMonthAchievement ==0 ||totalThreeMonthAchievement== null ){
            d.Three_Month_Achievement__c = d.Three_Month_Achievement__c;
        }else{
        
        d.Three_Month_Achievement__c= totalThreeMonthAchievement;
   		}
        dealersToUpdate.add(d);
    }
    
    update dealersToUpdate;
      
    }
    
    
    
    
    public Static void acheivementThisMonthUpdate(List<Opportunity__c> opp){
        
    Set<Id> parentIds = new Set<Id>();
    List<Dealer__c> dealersToUpdate = new List<Dealer__c>();
    		
    for (Opportunity__c deal: opp) {
        parentIds.add(deal.Dealer__c);
    }
    
    for (Id parentId : parentIds) {
        
       Dealer__c d = [SELECT Id, This_Month_Achievement__c, (SELECT Pondliner_Size_Requested_Required_Sq_Mt__c,Invoice_Date__c FROM Enquiry__r where Invoice_Date__c = LAST_WEEK) FROM Dealer__c WHERE Id = :parentId];
       Decimal totalThisMonthAchievement= 0;
        
        for (Opportunity__c child : d.Enquiry__r) {
            
            if(child.Invoice_Date__c != null){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            totalThisMonthAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	 }
        }
        if (totalThisMonthAchievement ==0 ||totalThisMonthAchievement== null ){
            d.This_Month_Achievement__c = d.This_Month_Achievement__c;
        }else{
        
        d.This_Month_Achievement__c= totalThisMonthAchievement;
   		}
        dealersToUpdate.add(d);
    }
    
     update dealersToUpdate;
      
    }
    
    public Static void acheivementMonthsUpdate(List<Opportunity__c> opp){
        
    Set<Id> parentIds = new Set<Id>();
    List<Dealer__c> dealersToUpdate = new List<Dealer__c>();
    		
    for (Opportunity__c deal: opp) {
        parentIds.add(deal.Dealer__c);
    }
    
    for (Id parentId : parentIds) {
        
       Dealer__c d = [SELECT Id, January_Achievement__c,February_Achievement__c,March_Achievement__c,April_Achievement__c,May_Achievement__c,
			June_Achievement__c,July_Achievement__c,August_Achievement__c,September_Achievement__c,October_Achievement__c,November_Achievement__c,December_Achievement__c,
		(SELECT Pondliner_Size_Requested_Required_Sq_Mt__c,Invoice_Date__c,Invoice_Month__c,Invoice_Year__c FROM Enquiry__r where Invoice_Year__c  =: Label.Invoice_Year) FROM Dealer__c WHERE Id = :parentId];
       Decimal JanuaryAchievement= 0;
	   Decimal FebruaryAchievement= 0;
	   Decimal MarchAchievement= 0;
	   Decimal AprilAchievement= 0;
	   Decimal MayAchievement= 0;
	   Decimal JuneAchievement= 0;
	   Decimal JulyAchievement= 0;
	   Decimal AugustAchievement= 0;
	   Decimal SeptemberAchievement= 0;
	   Decimal OctoberAchievement= 0;
	   Decimal NovemberAchievement= 0;
	   Decimal DecemberAchievement= 0;
        
        for (Opportunity__c child : d.Enquiry__r) {
            
            if(child.Invoice_Date__c != null && child.Invoice_Month__c ==1 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            JanuaryAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==2 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            FebruaryAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==3 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            MarchAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==4 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            AprilAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			 
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==5 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            MayAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==6 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            JuneAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==7 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            JulyAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==8 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            AugustAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==9 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            SeptemberAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==10 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            OctoberAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==11 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            NovemberAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	 }
			 
			else if(child.Invoice_Date__c != null && child.Invoice_Month__c ==12 ){
            if(child.Pondliner_Size_Requested_Required_Sq_Mt__c == null){
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=0;
            }else{
                child.Pondliner_Size_Requested_Required_Sq_Mt__c=child.Pondliner_Size_Requested_Required_Sq_Mt__c;
            }

            DecemberAchievement+= child.Pondliner_Size_Requested_Required_Sq_Mt__c;
        	}
			
			
        }
        
        d.January_Achievement__c= JanuaryAchievement ;
		d.February_Achievement__c= FebruaryAchievement ;
		d.March_Achievement__c= MarchAchievement ;
		d.April_Achievement__c= AprilAchievement ;
		d.May_Achievement__c= MayAchievement ;
		d.June_Achievement__c= JuneAchievement ;
		d.July_Achievement__c= JulyAchievement ;
		d.August_Achievement__c= AugustAchievement ;
		d.September_Achievement__c= SeptemberAchievement ;
		d.October_Achievement__c= OctoberAchievement ;
		d.November_Achievement__c= NovemberAchievement ;
		d.December_Achievement__c= DecemberAchievement ;
		
   		
        dealersToUpdate.add(d);
    }
    
     update dealersToUpdate;
      
    }

    public static void CCHelp(){
    integer i=1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    i=1+1;
    } */
}