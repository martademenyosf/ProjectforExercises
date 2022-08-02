
/**********************************************************************
 * @Name         : OSF_WeatherCalloutMock
 * @Description  : Mock class for API call
 * @Created By   : Marta Demeny
 * @Created Date : 20 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
public with sharing class OSF_WeatherCalloutMock implements HttpCalloutMock {
 /**********************************************************************
 * @Name         : respond
 * @Description  : Helper method to return face responde depending of the request parameters value.
 * @Created By   : Marta Demeny
 * @Created Date : 20 jun. 2022
 *
 * @return HTTPResponse
 *********************************************************************/   
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        String londonWeather = '{"id":2643743,"name":"London","coord":{"lat":51.5085,"lon":-0.1258},"main":{"temp":7,"pressure":1012,"humidity":81,"temp_min":5,"temp_max":8},"dt":1485791400,"wind":{"speed":4.6,"deg":90},"sys":{"country":"GB"},"rain":null,"snow":null,"clouds":{"all":90},"weather":[{"id":701,"main":"Mist","description":"mist","icon":"50d"}]}';
        
        response.setBody(londonWeather);
        
        return response; 
    }
}