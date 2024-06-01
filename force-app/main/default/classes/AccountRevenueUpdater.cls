public class AccountRevenueUpdater {

    public static void updateAccountTypes() {
        // Query Accounts modified in the last 30 days
        List<Account> accountsToUpdate = [SELECT Id, AnnualRevenue, Type
                                          FROM Account
                                          WHERE LastModifiedDate >= LAST_N_DAYS:30];

        // Check if there are any accounts to process
        if (!accountsToUpdate.isEmpty()) {
            // Check revenue and update the type for each account
            for (Account acc : accountsToUpdate) {
                if (acc.AnnualRevenue != null && acc.AnnualRevenue > 1000000) {
                   
                    acc.Type = 'Prospect';
                }
            }

            // Update accounts in Salesforce
            try {
                update accountsToUpdate;
            } catch (DmlException e) {
                // Handle the exception
                System.debug('An error occurred while updating accounts: ' + e.getMessage());
            }
        }
    }
}
