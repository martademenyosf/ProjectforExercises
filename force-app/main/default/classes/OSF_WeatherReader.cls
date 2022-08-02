/**********************************************************************
 * @Name         : OSF_WeatherReader
 * @Description  : Class to invoke openweathermap API in order to get the weather of the account city.
 *
 * @Created By   : Marta Demeny
 * @Created Date : 18 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
public with sharing class OSF_WeatherReader {
    private static final String WEATHER_URL; // = 'https://api.openweathermap.org/data/2.5/weather';
    private static final String WEATHER_IMG_URL; // = 'https://openweathermap.org/img/wn/';
    private static final String APPID; // = '9ab4d1340bf4d964ff4412a9068f7edc';
    static {
        //grab from custom setting values
        Weather_Http_List_Setting__c settings = Weather_Http_List_Setting__c.getInstance('WeatherInfo');
        System.debug('WeatherInfo: ' + settings);
        WEATHER_URL = settings.Weather_API_URL__c;
        APPID = settings.APPID__c;
        WEATHER_IMG_URL = settings.Weather_IMG_URL__c;
        System.debug('WEATHER_URL: ' + WEATHER_URL);
        System.debug('WEATHER_IMG_URL: ' + WEATHER_IMG_URL);
        System.debug('APPID: ' + APPID);  
    }

    public static OSF_WeatherCalloutMock mock = null;

/**********************************************************************
 * @Name         : getWeatherInfo   
 * @Description  : Returns the weather info 
 *
 * @Created By   : Marta Demeny
 * @Created Date : 11 jun. 2022
 *
 * @param List<String> - string containing  the BillingCity
 * @return List<OSF_WeatherReaderResult> - list of result object
 *********************************************************************/
    @InvocableMethod(callout=true label='Get Account Weather Info')
    public static List<OSF_WeatherReaderResult> getWeatherInfo(List<String> accountBillingCity) {   
        OSF_WeatherWrapper weatherWrapper = executeAPICall(accountBillingCity[0]);
        //adding the URL to images if they exist
        List<OSF_WeatherWrapperWeatherData> weatherDataList = (List<OSF_WeatherWrapperWeatherData>) weatherWrapper.weather;
        OSF_WeatherReaderResult result = new OSF_WeatherReaderResult();
        for(OSF_WeatherWrapperWeatherData wd: weatherDataList) {
            if ((wd.icon != null) && (wd.icon.length() != 0)) {
                result.icon = WEATHER_IMG_URL + wd.icon + '.png';
            }
            result.description = wd.description;
            break;
        }

        result.temperature = weatherWrapper.main.temp;
        result.real_Feeling = weatherWrapper.main.feels_like;
        result.humidity = weatherWrapper.main.humidity;
        return new List<OSF_WeatherReaderResult>{result};
    }


/**********************************************************************
 * @Name         : getWeatherInfo
 * @Description  : Use Rest API to get the weather information for a given City.
 *
 * @Created By   : Marta Demeny
 * @Created Date : 11 jun. 2022
 *
 * @param String - containing the city
 * @return OSF_WeatherReaderResult - result object with weather info
 *********************************************************************/
    public static OSF_WeatherWrapper executeAPICall(String accountBillingCity) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HTTPResponse response = new HttpResponse();
    
        String weatherURL = WEATHER_URL + '?APPID=' + APPID + '&q=' + accountBillingCity;

        request.setEndpoint(weatherURL);
        request.setMethod('GET');
        request.setCompressed(true);
 
        if (Test.isRunningTest() && (mock!=null)) {
            response = mock.respond(request);
        } else {
            response = http.send(request);
        }
        
        return (OSF_WeatherWrapper) JSON.deserialize(response.getBody(), OSF_WeatherWrapper.class);        
    }

}