public with sharing class ChatGPTService {
    private static final String API_KEY = 'API Key'; 
    private static final String ENDPOINT_URL = 'URL';

    //Extended==============
    @AuraEnabled(cacheable=false)
    public static void postToTwitter(String recordId, String topic) {
        // Generate the post content based on the topic
        String postContent = generateResponse('Generate a Twitter post about ' + topic);

        // Check if the post content was generated successfully
        if (String.isNotBlank(postContent)) {
            // Query the 'Publish on Twitters' record
            Publish_on_Twitter__c twitterPost = [SELECT Id, To_post__c FROM Publish_on_Twitter__c WHERE Id = :recordId LIMIT 1];

            // Update the 'To post' field with the generated content
            twitterPost.To_post__c = postContent;
            update twitterPost;
        } else {
            // Handle the case where no content is generated
            throw new ChatGPTException('Error: No content generated for the Twitter post.');
        }
    }
     //Extended==============

    @AuraEnabled(cacheable=false)
    public static String generateResponse(String messageText) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT_URL);
        req.setMethod('POST');
        req.setTimeout(1000*120);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + API_KEY); 

        // Set the request body
        String prompt = 'You are a helpful assistant.\nUser: ' + messageText + '\nAssistant:';
        System.debug(prompt); 

        Map<String, Object> PromptBody = new Map<String, Object>();
        PromptBody.put('role','user');
        PromptBody.put('content',messageText);

        List<Object> lstPrompts = new List<Object>();
        lstPrompts.add(PromptBody);

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('messages', lstPrompts);
        requestBody.put('model', 'gpt-3.5-turbo');
        //requestBody.put('max_tokens', 50);
        //requestBody.put('n', 1);
        //requestBody.put('stop', new List<String>{'\n'});

        req.setBody(JSON.serialize(requestBody));
        System.debug('Request Body: ' + req.getBody());

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            System.debug(res.getBody());
            Map<String, Object> responseBody = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            List<Object> choices = (List<Object>)responseBody.get('choices');
            if (choices.size() > 0) {
                Map<String, Object> choice = (Map<String, Object>)choices.get(0);
                Map<String,Object> mpMessages = (Map<String,Object>)choice.get('message');

                String responseText = (String)mpMessages.get('content');

                responseText = responseText != null ? responseText.trim() : '';
                //system.debug('Response Text: ' + responseText);
                return responseText;
            }
        } else {
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
            throw new ChatGPTException('Error: Unable to generate response from ChatGPT.');
        }

        return '';
    }

    /**
     * @description Custom exception class
     */
    public class ChatGPTException extends Exception {}
}
