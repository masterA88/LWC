public class TransportDataParser {
    
    // Parses the JSON response from the CKAN API
    public static List<Dataset> parseCKANResponse(String jsonResponse) {
        CKANResponse response = (CKANResponse) JSON.deserialize(jsonResponse, CKANResponse.class);
        if (response != null && response.result != null && response.result.results != null) {
            return response.result.results;
        } else {
            return new List<Dataset>();
        }
    }
    
    public class CKANResponse {
        @AuraEnabled
        public Result result;
    }

    public class Result {
        @AuraEnabled
        public List<Dataset> results;
    }
    
    public class Dataset {
        @AuraEnabled public String name;
        @AuraEnabled public String title;
        @AuraEnabled public String schedules; // Correctly parsed if directly available
        @AuraEnabled public String routes;    // Correctly parsed if directly available
    }
}
