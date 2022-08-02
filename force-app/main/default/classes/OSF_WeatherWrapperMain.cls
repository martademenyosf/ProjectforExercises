
/**********************************************************************
 * @Name         : OSF_WeatherWrapperMain
 * @Description  : Wrapper class for main data
 *
 * @Created By   : Marta Demeny
 * @Created Date : 19 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
public with sharing class OSF_WeatherWrapperMain {
    public Decimal temp {get; set;}
    public Decimal feels_like {get; set;}
    public Decimal humidity {get; set;}

}