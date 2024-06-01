public class MarketData {
    // Inner class to represent the metadata section of the JSON response
    public class MetaData {
        public String information;
        public String symbol;
        public String lastRefreshed;
        public String outputSize;
        public String timeZone;
    }
    
    // Inner class to represent the time series data section of the JSON response
    public class TimeSeriesData {
        public String open;
        public String high;
        public String low;
        public String close;
        public String volume;
    }
    
    // Properties to hold the deserialized data
    public MetaData metaData;
    public Map<String, TimeSeriesData> timeSeriesDaily;
    
    // Method to parse the JSON string into a MarketData object
    public static MarketData parse(String jsonResponse) {
        return (MarketData) JSON.deserialize(jsonResponse, MarketData.class);
    }
}
