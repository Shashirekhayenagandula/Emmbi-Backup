/* ───────────────────────────────────────────────────────────────────────────────
* @Description      : 
* @Author           : 
* @Company          : Venerate Solutions
* @created          : 
* @Last Modified By : 
* @Last Modified On : 
* @Modification Log : 
* ─────────────────────────────────────────────────────────────────────────────────
*/
trigger EnquiryTrigger on Opportunity__c (after update) {
	 if(AvanaTrigger__c.getInstance().EnquiryTrigger__c==true){
        System.debug('inside Trigger Active::::');
        new EnquiryTriggerHandler().run();
        //new EnquiryConvertLeadConvert().run();
    }
}