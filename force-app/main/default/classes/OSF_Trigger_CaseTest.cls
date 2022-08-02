/**********************************************************************
 * @Name         : OSF_Trigger_CaseTest
 * @Description  : test class for the trigger on Case.
 *
 * @Created By   : Marta Demeny
 * @Created Date : 05 jul. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
@isTest
public with sharing class OSF_Trigger_CaseTest {

/**********************************************************************
 * @Name         : testPersonAccountCreation
 * @Description  : test method to test that at the Case creation a new Person Account is created.
 * @Created By   : Marta Demeny
 * @Created Date : 05 jul. 2022
 *
 *********************************************************************/ 
    @isTest 
    private static void testPersonAccountCreation() {
        Case newCase = new Case(Origin = 'Web', Status = 'New', Brand__c = 'Brand 1', SuppliedEmail = 'test@gmail.com');

        insert newCase;

        Account account = [SELECT Name, Brand__c, personcontactId, personEmail  FROM Account WHERE Brand__c = :newCase.Brand__c AND personEmail = :newCase.SuppliedEmail];

        System.assertEquals('test@gmail.com', account.PersonEmail);
        System.assertEquals('Brand 1', account.Brand__c);

    }
/**********************************************************************
 * @Name         : testPersonAccountCreation
 * @Description  : test method to test that at the Case creation a new Person Account is created.
 * @Created By   : Marta Demeny
 * @Created Date : 05 jul. 2022
 *
 *********************************************************************/ 
    @isTest 
    private static void testPersonAccountUpdate() {
        String brand1 = 'Brand 1', suppliedEmail = 'test@gmail.com';
        List<Case> cases = new List<Case>();
        Case newCase = new Case(Origin = 'Web', Status = 'New', Brand__c = brand1, SuppliedEmail = suppliedEmail, Subject = 'Subject 1');
        cases.add(newCase);
        newCase = new Case(Origin = 'Web', Status = 'New', Brand__c = brand1, SuppliedEmail = suppliedEmail, Subject = 'Subject 2');
        cases.add(newCase);

        insert cases;

        List<Account> accounts = [SELECT Name, Brand__c, personcontactId, personEmail  FROM Account WHERE Brand__c = :brand1 AND personEmail = :suppliedEmail];

        System.assert(accounts.size() == 1);

        List<Case> insertedCases = [SELECT AccountId, ContactId FROM Case WHERE Brand__c = :brand1 AND SuppliedEmail = :suppliedEmail ORDER BY CaseNumber DESC];
        System.assert(insertedCases.size() == 2);
        System.assertEquals(accounts[0].Id, insertedCases[0].AccountId);
        System.assertEquals(accounts[0].personcontactId, insertedCases[0].ContactId);

    }    
}
