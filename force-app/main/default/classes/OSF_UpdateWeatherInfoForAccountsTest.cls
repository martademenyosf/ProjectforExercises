/**********************************************************************
 * @Name         : OSF_UpdateWeatherInfoForAccountsTest
 * @Description  : Test class for OSF_UpdateWeatherInfoForAccounts
 * @Created By   : Marta Demeny
 * @Created Date : 17 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version        Developer        Date            Description
 *___________________________________________________________________
 *
 *********************************************************************/
@isTest
public with sharing class OSF_UpdateWeatherInfoForAccountsTest {
        //cronmaker.com: CRON_EXP = sec minutes hour DayOfMonth Month DayOfWeek op Year
    private final static String CRON_DAILY = '0 0 09 1/1 * ?'; // daily at 09:00 AM
    private final static String CRON_WEEK = '0 0 13 ? * 6'; //  once a week (Friday at 1:00 PM)
    private final static String CRON_MONTH = '0 0 18 ? 1/1 6L'; // once a month(Last Friday of the Month at 6:00 PM)
    
/**********************************************************************
 * @Name         : setup
 * @Description  : Helper method to create the testing data.
 * @Created By   : Marta Demeny
 * @Created Date : 17 jun. 2022
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
 * @Name         : testDailyScheduler
 * @Description  : Test method for daily scheduler.
 * @Created By   : Marta Demeny
 * @Created Date : 17 jun. 2022
 *
 *********************************************************************/
    @isTest
    private static void testDailyScheduler() {
        String jobId;
        CronTrigger ct;
        OSF_WeatherReader.mock = new OSF_WeatherCalloutMock();
        
        Test.startTest();      
        
        jobId = System.schedule('Schedule Accounts Weather Update', CRON_DAILY, new OSF_UpdateWeatherInfoForAccounts());
        
        // Get the information from the CronTrigger API object
        ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the job has not run 
        System.assertEquals(0, ct.TimesTriggered); 
        Test.stopTest();
        
    }
}