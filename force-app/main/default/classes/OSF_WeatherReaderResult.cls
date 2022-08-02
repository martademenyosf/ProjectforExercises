/**********************************************************************
 * @Name         : OSF_WeatherReaderResult
 * @Description  : Wrapper class for returned wheater data 
 * @Created By   : Marta Demeny
 * @Created Date : 18 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
public with sharing class OSF_WeatherReaderResult {
    
    @AuraEnabled @InvocableVariable public Decimal temperature;
    @AuraEnabled @InvocableVariable public String description;
    @AuraEnabled @InvocableVariable public Decimal real_Feeling;
    @AuraEnabled @InvocableVariable public Decimal humidity;
    @AuraEnabled @InvocableVariable public String icon;

}