public class PublicTransportDataService {
    private static final String BASE_URL = 'https://ckan.multimediagdansk.pl/en/api/3/action/';

    public static String queryCKAN(String actionPath, String queryParams) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL + actionPath + '?' + queryParams);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            // Handle errors or unexpected response codes
            System.debug('Error fetching data: ' + response.getStatus());
            return null;
        }
    }
}
