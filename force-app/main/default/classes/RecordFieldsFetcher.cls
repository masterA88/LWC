public with sharing class RecordFieldsFetcher {

    // Exclude system fields specific to Leads
    private static List<String> excludedFields = new List<String>{
        'Id'.toUpperCase(), 'IsDeleted'.toUpperCase(), 'MasterRecordId'.toUpperCase(), 'CurrencyIsoCode'.toUpperCase(),
        'CreatedById'.toUpperCase(), 'LastModifiedById'.toUpperCase(), 'OwnerId'.toUpperCase(),
        'ConvertedAccountId'.toUpperCase(), 'ConvertedContactId'.toUpperCase(), 'ConvertedOpportunityId'.toUpperCase(),
        'RecordTypeId'.toUpperCase(), 'SystemModstamp'.toUpperCase(), 'LastActivityDate'.toUpperCase(),
        // Add any other Lead specific fields to be excluded
    };

    // Update this list if there are specific child relationships you want to include for Leads
    private static List<String> childRelationships = new List<String>{
        // Example: 'LeadHistories'
    };

    @AuraEnabled(cacheable=true)
    public static String getNonBlankFields(String recordId) {
        if (String.isEmpty(recordId)) {
            return 'Record Id is required.';
        }

        Id objectId = Id.valueOf(recordId);
        String objectName = objectId.getSObjectType().getDescribe().getName();

        if (!objectName.equalsIgnoreCase('Lead')) {
            return 'This method is only applicable for Lead records.';
        }

        List<String> fieldNames = getFieldNames(objectName);

        String query = 'SELECT ' + String.join(fieldNames, ',');
        for (String relationship : childRelationships) {
            String childObjectName = getChildObjectName(relationship, objectName);
            if (childObjectName != null) {
                List<String> childFieldNames = getFieldNames(childObjectName);
                query += ', (SELECT ' + String.join(childFieldNames, ',') + ' FROM ' + relationship + ')';
            }
        }
        query += ' FROM ' + objectName + ' WHERE Id = :objectId';

        SObject record = Database.query(query);

        List<String> nonBlankFieldList = getNonBlankFieldList(record, objectName);

        String promptPrefix = 'Based on the following Lead information, can you provide an analysis or insights? -';
        String prompt = promptPrefix + String.join(nonBlankFieldList, ', '); 
        return ChatGPTService.generateResponse(prompt);
    }

    private static List<String> getFieldNames(String objectName) {
        // ... existing implementation
    }

    private static String getChildObjectName(String relationshipName, String parentObjectName) {
        // ... existing implementation
    }

    private static List<String> getNonBlankFieldList(SObject record, String objectName) {
        // ... existing implementation
    }
}
