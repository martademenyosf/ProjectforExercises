/**********************************************************************
 * @Name         : OSF_UpdateAccountsBatchTest
 * @Description  : Test class for OSF_UpdateAccountsBatch
 * @Created By   : Marta Demeny
 * @Created Date : 26 jul. 2022
 * @Modification Log: 
 ********************************************************************
 * Version        Developer        Date            Description
 *___________________________________________________________________
 *
 *********************************************************************/
@isTest
public with sharing class OSF_UpdateAccountsBatchTest {
/**********************************************************************
 * @Name         : setup
 * @Description  : Helper method to create the testing data.
 * @Created By   : Marta Demeny
 * @Created Date : 26 jul. 2022
 *
 *********************************************************************/ 
    @testSetup 
    private static void setup() {
        List<Account> accountsList = new List<Account>{new Account(Name = 'Test weather', BillingCity='London')};
        insert accountsList;

        Weather_Http_List_Setting__c settings = new Weather_Http_List_Setting__c();

        settings.Name = 'WeatherInfo';
        settings.Weather_API_URL__c = 'https://api.openweathermap.org/data/2.5/weather';
        settings.Weather_IMG_URL__c = 'https://openweathermap.org/img/wn/';
        settings.APPID__c = '9ab4d1340bf4d964ff4412a9068f7edc';
        System.debug('WeatherInfo: ' + settings);

        insert settings;
    }
/**********************************************************************
 * @Name         : testBatch
 * @Description  : Test method batch method.
 * @Created By   : Marta Demeny
 * @Created Date : 26 jul. 2022
 *
 *********************************************************************/
@isTest
private static void testBatch() {
    OSF_WeatherReader.mock = new OSF_WeatherCalloutMock();
       
    Test.startTest();      
        OSF_UpdateAccountsBatch updateAccount = new OSF_UpdateAccountsBatch();
        Id batchId = Database.executeBatch(updateAccount);
    Test.stopTest();
    Account acc = [SELECT Id, Temperature__c, Description, Real_Feeling__c, Icon__c, Humidity__c,  BillingCity FROM Account WHERE Name = 'Test weather'];

    System.assertEquals(7, acc.Temperature__c);
    System.assertEquals('mist', acc.Description);
    
}

}
