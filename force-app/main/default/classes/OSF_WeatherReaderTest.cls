
/**********************************************************************
 * @Name         : OSF_AccountCityWeatherTest
 * @Description  : Test class for OSF_WeatherReader
 * 
 * @Created By   : Marta Demeny
 * @Created Date : 20 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version        Developer        Date            Description
 *___________________________________________________________________
 *
 *********************************************************************/
@isTest
public with sharing class OSF_WeatherReaderTest {
/**********************************************************************
 * @Name         : setup
 * @Description  : Helper method to create the testing data.
 * @Created By   : Marta Demeny
 * @Created Date : 17 jun. 2022
 *
 *********************************************************************/ 
    @testSetup 
    private static void setup() {
        Account accountsList = new Account(Name = 'Test weather', BillingCity='London');
        insert accountsList;
    }
/**********************************************************************
 * @Name         : testDailyScheduler
 * @Description  : Test method for getWeatherInfo.
 * @Created By   : Marta Demeny
 * @Created Date : 17 jun. 2022
 *
 *********************************************************************/

    @isTest
    private static void testWeather() {
        Account account = [SELECT ID, BillingCity FROM Account WHERE Name = 'Test weather'];
        
        // Set mock callout class 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OSF_WeatherCalloutMock()); 
        Test.stopTest();
        
        OSF_WeatherReaderResult weatherResult = OSF_WeatherReader.getWeatherInfo(new List<String>{'London'})[0];
        
        System.assertEquals('mist', weatherResult.description);
        System.assertEquals(7, weatherResult.temperature);


    }
    
}