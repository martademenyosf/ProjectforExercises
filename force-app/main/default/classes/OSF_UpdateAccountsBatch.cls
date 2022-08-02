/**********************************************************************
 * @Name         : OSF_UpdateAccountsBatch
 * @Description  : A batch class that modify Accounts Weather data
 * @Created By   : Marta Demeny
 * @Created Date : 13 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/

global with sharing class OSF_UpdateAccountsBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    // instance member to retain state across transactions
    public Integer recordsProcessed = 0;

/**********************************************************************
 * @Name         : start
 * @Description  : Implements the batchable interface method and it's invoked when the batch job starts. 
 *                 
 * @Created By   : Marta Demeny
 * @Created Date : 13 jun. 2022
 *
 * @param Database.BatchableContext - contains the job Id
 * @return Database.QueryLocator - record set as a QueryLocator object that will be batched for execution.
 *********************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        try {
            return Database.getQueryLocator('SELECT Id, Temperature__c, Description, Real_Feeling__c, Icon__c, Humidity__c,  BillingCity FROM Account');
        } catch (DMLException e) {
            System.debug(e.getMessage());
            return null;
        }
    }

/**********************************************************************
 * @Name         : execute
 * @Description  : Implements the batchable interface method, it's invoked when the batch job executes and operates on one batch of records.
 *                 Return the weather data and update the account records.
 * @Created By   : Marta Demeny
 * @Created Date : 13 jun. 2022
 *
 * @param Database.BatchableContext - Contains the job Id.
 * @param List<Opportunity> - Contains the batch of records to process.
 *
 *********************************************************************/
    global void execute(Database.BatchableContext bc, List<Account> source) {

        for (Account acc: source) {
             if (acc.BillingCity != null) {
                List<OSF_WeatherReaderResult> results = OSF_WeatherReader.getWeatherInfo(new List<String>{acc.BillingCity});
                if (!results.isEmpty()) {
                    OSF_WeatherReaderResult result = results[0];
                    acc.Icon__c = result.icon;
                    acc.Description = result.description;
                    acc.Real_Feeling__c = result.real_Feeling;
                    acc.Humidity__c = result.humidity;
                    acc.Temperature__c = result.temperature;
                }
            }
            recordsProcessed = recordsProcessed + 1;
        }
        update source;
    }

/**********************************************************************
 * @Name         : finish
 * @Description  : Implements the batchable interface method and it's invoked when the batch job is finished. 
 *               
 *                 
 * @Created By   : Marta Demeny
 * @Created Date : 13 jun. 2022
 *
 * @param Database.BatchableContext - contains the job Id
 *
 *********************************************************************/    
    public void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        System.debug('Job info: ' + job.Status);
    }
}