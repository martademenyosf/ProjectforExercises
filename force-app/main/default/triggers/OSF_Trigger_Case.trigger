trigger OSF_Trigger_Case on Case (before insert, before update) {
    System.debug('Trigger.New: ' + Trigger.new);
    System.debug('Trigger.isInsert ' + Trigger.isInsert);
    System.debug('Trigger.isUpdate ' + Trigger.isUpdate);
    System.debug('Trigger.isBefore ' + Trigger.isBefore);
    System.debug('Trigger.isAfter ' + Trigger.isAfter);  
    
    
    List<Account> accounts = [SELECT Id, Name, Brand__c, personcontactId, personEmail  
                               FROM Account 
                               WHERE RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()];
    List<Account> existingAccounts = new List<Account>();                           
    for (Case cs : Trigger.new) {
        for (Account acc : accounts) {
            if (acc.Brand__c != null && acc.personEmail != null && acc.Brand__c == cs.Brand__c && acc.personEmail == cs.SuppliedEmail) {
                existingAccounts.add(acc);
                break;
            }
        }
    }
    System.debug('existingAccounts: ' + existingAccounts);

    if (existingAccounts.size() == 0) {
         //create new PersonAccount
        OSF_Trigger_Case_Handler.createAccounts(Trigger.New, Trigger.isUpdate);
    } else {
        //update Case with Account Info
        OSF_Trigger_Case_Handler.updateCases(Trigger.New, Trigger.isUpdate, existingAccounts);
    } 

}