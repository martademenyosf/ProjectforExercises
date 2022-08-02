/**********************************************************************
 * @Name         : OSF_WeatherWrapper
 * @Description  : Wrapper class for wheater data
 * @Created By   : Marta Demeny
 * @Created Date : 18 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
public with sharing class OSF_WeatherWrapper {
        
    public OSF_WeatherWrapperMain main {get; set;}
    public List<OSF_WeatherWrapperWeatherData> weather {get; set;}    
}