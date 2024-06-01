public with sharing class TransportDataController {
    @AuraEnabled(cacheable=true)
    public static List<TransportDataParser.Dataset> getPublicTransportData() {
        // Example query parameters - adjust as necessary
        String actionPath = 'package_search';
        String queryParams = 'q=public+transport';
        
        String jsonResponse = PublicTransportDataService.queryCKAN(actionPath, queryParams);
        
        // Parse the response to extract dataset information
        List<TransportDataParser.Dataset> datasets = TransportDataParser.parseCKANResponse(jsonResponse);
        
        return datasets;
    }
}
