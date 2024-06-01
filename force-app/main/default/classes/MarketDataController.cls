public class MarketDataController {

    @AuraEnabled(cacheable=true)
    public static String getMarketData(String symbol) {
        try {
            // Assuming AlphaVantageService.getMarketData(symbol) is static and returns String
            return AlphaVantageService.getMarketData(symbol);
        } catch (Exception e) {
            // It's important to log the actual error for debugging purposes
            System.debug('Error fetching data: ' + e.getMessage());
            // Consider what you return here; for security purposes, you might not want to return the actual error message to the client
            return 'Error fetching data';
        }
    }
}
