public with sharing class MyDataProcessor {
    @AuraEnabled
    public static String processData(List<List<String>> csvData) {
        // Check the data format received from LWC
        System.debug('Received CSV Data: ' + csvData);
        
        // Assuming the first row is headers, start from index 1
        List<Contact> contactsToInsert = new List<Contact>();
        for (Integer i = 1; i < csvData.size(); i++) {
            List<String> csvRow = csvData[i];
            // Create a new Contact record and add to the list
            Contact newContact = new Contact(
                FirstName = csvRow[0],
                LastName = csvRow[1],
                Email = csvRow[2]
                // Add other fields as necessary
            );
            contactsToInsert.add(newContact);
        }

        try {
            // Perform the DML operation
            insert contactsToInsert;
            return 'Success - Inserted ' + contactsToInsert.size() + ' Contacts.';
        } catch (DmlException e) {
            System.debug('DML Exception: ' + e);
            throw new AuraHandledException('DML Error: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception: ' + e);
            throw new AuraHandledException('Processing Error: ' + e.getMessage());
        }
    }
}