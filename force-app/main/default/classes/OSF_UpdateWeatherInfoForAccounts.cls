/**********************************************************************
 * @Name         : OSF_UpdateWeatherInfoForAccounts
 * @Description  : 
 * @Created By   : Marta Demeny
 * @Created Date : 16 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
public with sharing class OSF_UpdateWeatherInfoForAccounts implements Schedulable {
/**********************************************************************
 * @Name         : start
 * @Description  : Implements the schedulable interface method. 
 *                 
 * @Created By   : Marta Demeny
 * @Created Date : 13 jun. 2022
 *
 * @param SchedulableContext - contains the context
 *********************************************************************/
    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new OSF_UpdateAccountsBatch());
    }

}