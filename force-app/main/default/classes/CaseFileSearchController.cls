public with sharing class CaseFileSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> searchFiles(Id caseId, String searchTerm) {
        List<Map<String, Object>> searchResults = new List<Map<String, Object>>();
        
        // Query ContentDocumentLink to get the documents related to the case
        List<ContentDocumentLink> cdlList = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :caseId
        ];
        
        for (ContentDocumentLink cdl : cdlList) {
            // Get the latest version of the document
            ContentDocument contentDoc = [
                SELECT Id, Title, LatestPublishedVersionId
                FROM ContentDocument 
                WHERE Id = :cdl.ContentDocumentId
                LIMIT 1
            ];
            
            // Search for the term in the ContentVersion
            List<ContentVersion> contentVersions = [
                SELECT Id, Title, ContentDocumentId, FileExtension
                FROM ContentVersion
                WHERE ContentDocumentId = :contentDoc.Id 
                AND Title LIKE :('%' + searchTerm + '%')
            ];
            
            for (ContentVersion cv : contentVersions) {
                Map<String, Object> searchResult = new Map<String, Object>();
                searchResult.put('Id', cv.Id);
                searchResult.put('Title', cv.Title);
                searchResult.put('LatestPublishedVersionId', contentDoc.LatestPublishedVersionId);
                searchResult.put('ContentDocumentId', cv.ContentDocumentId);
                searchResult.put('FileExtension', cv.FileExtension);
                searchResults.add(searchResult);
            }
        }
        
        return searchResults;
    }
}
