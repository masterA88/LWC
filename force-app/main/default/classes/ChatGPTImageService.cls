public with sharing class ChatGPTImageService {
    private static final String API_KEY = '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'; // Replace with your actual API key
    private static final String ENDPOINT_URL = 'https://api.openai.com/v1/chat/completions';
    private static final String MODEL = 'gpt-3.5-turbo'; // Ensure this is the correct model you intend to use

    @AuraEnabled(cacheable=false)
    public static String encodeImage(String documentId) {
        ContentVersion content = [SELECT VersionData FROM ContentVersion WHERE Id = :documentId LIMIT 1];
        return EncodingUtil.base64Encode(content.VersionData);
    }

    @AuraEnabled(cacheable=false)
    public static String sendImageToChatGPT(String base64String, String messageText) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT_URL);
        req.setMethod('POST');
        req.setTimeout(120000); // 2 minutes
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + API_KEY);

        // Prepare the request body with messages data and the model parameter
        Map<String, Object> requestBody = new Map<String, Object>();
        List<Map<String, String>> messagesList = new List<Map<String, String>>();
        Map<String, String> message = new Map<String, String>();
        message.put('content', messageText); // 'content' key may vary based on the API specification
        messagesList.add(message);
        
        requestBody.put('messages', messagesList);
        requestBody.put('model', MODEL);

        // Serialize the request body to JSON
        String requestBodyJSON = JSON.serialize(requestBody);
        req.setBody(requestBodyJSON);

        Http http = new Http();
        HttpResponse res;
        try {
            res = http.send(req);
            if (res.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Map<String, Object>> responses = (List<Map<String, Object>>) responseBody.get('choices');
                if (responses != null && !responses.isEmpty()) {
                    // Assuming 'text' is the correct key for the response content
                    return (String) responses.get(0).get('message');
                }
                return null;
            } else {
                String errorDetails = res.getBody();
                System.debug('ChatGPT API callout error: ' + errorDetails);
                throw new ChatGPTException('ChatGPT API error response: ' + errorDetails);
            }
        } catch (Exception e) {
            System.debug('Exception during ChatGPT API callout: ' + e.getMessage());
            throw new ChatGPTException('Exception during ChatGPT API callout: ' + e.getMessage());
        }
    }

    public class ChatGPTException extends Exception {
    }
}
