public class WeatherService {
    private static final String ENDPOINT = 'https://api.openweathermap.org/data/3.0/onecall';

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getWeatherData(Decimal latitude, Decimal longitude) {
        // Retrieve the API key from the custom setting
        ExternalAPISettings__c settings = ExternalAPISettings__c.getOrgDefaults();
        String apiKey = settings.OpenWeatherMapAPIKey__c;

        // Logging the API Key for debugging purposes (remove this in production)
        System.debug('API Key from Custom Setting: ' + apiKey);

        String url = ENDPOINT + '?lat=' + latitude + '&lon=' + longitude + '&appid=' + apiKey;
        // Logging the full URL for debugging (consider security implications)
        System.debug('Full request URL: ' + url);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        // Check the status and log the response for debugging
        if (response.getStatusCode() == 200) {
            System.debug('API Response: ' + response.getBody());
            return (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        } else {
            // Log errors
            System.debug('Error Status: ' + response.getStatusCode());
            System.debug('Error Body: ' + response.getBody());
            return null;
        }
    }
}
