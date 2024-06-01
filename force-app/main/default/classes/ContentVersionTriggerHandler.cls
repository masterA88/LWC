public class ContentVersionTriggerHandler {
    @future(callout=true)
    public static void callGoogleDrive(String cvId) {
        String key = '199936825505-2rnq2h63pbgv3s6ntadm12rmh6qverum.apps.googleusercontent.com';
        String secret = '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';
        String redirect_uri = 'https://developers.google.com/oauthplayground';

        String accesstoken;
        String refreshToken = '1//04zKb5LYfCh8vCgYIARAAGAQSNwF-L9IrB_xIgsbJqR77VKdLheZp-PNROh4_qLFQImNK_ekuAZcscDfbyNrV-RNf8PeiLxy0s00';
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('POST');
        req2.setEndpoint('https://www.googleapis.com/oauth2/v4/token');
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'client_id=' + key + '&client_secret=' + secret + '&refresh_token=' + refreshToken + '&redirect_uri=' + redirect_uri + '&grant_type=refresh_token';
        req2.setHeader('Content-length', String.valueOf(messageBody.length()));
        req2.setBody(messageBody);
        req2.setTimeout(60 * 1000);
        Http h2 = new Http();
        HttpResponse res2 = h2.send(req2);
        String resp2 = res2.getBody();
        System.debug('resp2-->>' + resp2);
        JSONParser parser = JSON.createParser(resp2);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'access_token') {
                    accesstoken = parser.getText();
                } else if (fieldName == 'expires_in') {
                    Integer expiresIn = parser.getIntegerValue();
                } else if (fieldName == 'token_type') {
                    String tokentype = parser.getText();
                }
            }
        }

        ContentVersion cv = [SELECT Id, Title, ContentDocumentId, VersionData, FileExtension FROM ContentVersion WHERE Id = :cvId];
        Blob myBlob = cv.VersionData;
        String fileExtension = cv.FileExtension.toLowerCase();
        String mimeType = getMimeType(fileExtension);
        String url = 'https://www.googleapis.com/upload/drive/v3/files?uploadType=media';
        String authorizationHeader = 'Bearer ' + accesstoken; 
        Integer contentSize = myBlob.size();
        HttpRequest req1 = new HttpRequest();
        req1.setHeader('Authorization', authorizationHeader);
        req1.setHeader('Content-Length', String.valueOf(contentSize));
        req1.setHeader('Content-Type', mimeType);
        req1.setMethod('POST'); 
        req1.setEndpoint(url); 
        req1.setBodyAsBlob(myBlob); 
        Http h1 = new Http();
        HttpResponse resp1 = h1.send(req1);
        // Handle the response from Google Drive
    }

    private static String getMimeType(String fileExtension) {
        Map<String, String> mimeTypes = new Map<String, String>{
            'pdf'  => 'application/pdf',
            'png'  => 'image/png',
            'jpg'  => 'image/jpeg',
            'jpeg' => 'image/jpeg',
            'txt'  => 'text/plain',
            'csv'  => 'text/csv',
            'html' => 'text/html',
            'htm'  => 'text/html',
            'doc'  => 'application/msword',
            'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'xls'  => 'application/vnd.ms-excel',
            'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'ppt'  => 'application/vnd.ms-powerpoint',
            'pptx' => 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
            'gif'  => 'image/gif',
            'bmp'  => 'image/bmp',
            'tiff' => 'image/tiff',
            'svg'  => 'image/svg+xml',
            'mp3'  => 'audio/mpeg',
            'mp4'  => 'video/mp4',
            'mov'  => 'video/quicktime',
            'wmv'  => 'video/x-ms-wmv',
            'flv'  => 'video/x-flv',
            'avi'  => 'video/x-msvideo',
            'zip'  => 'application/zip',
            'rar'  => 'application/x-rar-compressed'
        };
        return mimeTypes.containsKey(fileExtension) ? mimeTypes.get(fileExtension) : 'application/octet-stream';
    }    
}
