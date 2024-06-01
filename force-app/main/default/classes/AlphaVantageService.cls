public class AlphaVantageService {
    // Method to retrieve market data for a given symbol from the Alpha Vantage API
    public static String getMarketData(String symbol) {
        // Get the API key from the Custom Setting's organization default
        APIKeys__c apiKeySetting = APIKeys__c.getOrgDefaults();
        String apiKey = apiKeySetting.AlphaVantageAPIKey__c;

        // Prepare the HTTP request using the endpoint URL
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=' + EncodingUtil.urlEncode(symbol, 'UTF-8') + '&apikey=' + apiKey);
        req.setMethod('GET');

        // Make the callout and return the response body or null if an error occurs
        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            // Check the response status and return the body
            if (res.getStatusCode() == 200) {
                return res.getBody();
            } else {
                System.debug('HTTP Response status: ' + res.getStatus());
                return null;
            }
        } catch (Exception e) {
            // Log and handle any exceptions
            System.debug('Callout error: ' + e.getMessage());
            return null;
        }
    }

    // Method to parse the JSON response and return the latest close price
    public static String getLatestClosePrice(String jsonResponse) {
        // Parse the JSON response into a MarketData object
        MarketData marketData = MarketData.parse(jsonResponse);
        if (marketData != null && marketData.timeSeriesDaily != null && !marketData.timeSeriesDaily.isEmpty()) {
            // Get the first (latest) entry in the map which should be the most recent date
            String latestDate = marketData.timeSeriesDaily.keySet().iterator().next();
            // Return the close price for that date
            return marketData.timeSeriesDaily.get(latestDate).close;
        }
        return null; // Return null if there's no data
    }
}
