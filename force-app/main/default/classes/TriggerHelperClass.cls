public with sharing class TriggerHelperClass {

    /*Question 1: When an account is inserted change the account type to 'Prospect' if there is no value in the type field.
         * Trigger should only fire on insert.*/
    public static void triggerOneHelper(List<Account> newAccounts) {
        for(Account acc : newAccounts) {
            if(acc.Type == null) {
                acc.Type = 'Prospect';
            }
        }        

    }

    /*Question 2
        * Account Trigger
        * When an account is inserted copy the shipping address to the billing address.
        * BONUS: Check if the shipping fields are empty before copying.
        * Trigger should only fire on insert.*/
    public static void triggerTwoHelper(List<Account> newAccounts) {
        for(Account acc : newAccounts) {
            if(acc.ShippingStreet == null && acc.ShippingCity == null) {
                continue;
            } else {
                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingPostalCode = acc.ShippingPostalCode;
                acc.BillingCountry = acc.ShippingCountry;
                }
        }
    }

    /*
    * Question 3
    * Account Trigger
	* When an account is inserted set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value.
    * Trigger should only fire on insert.
    */
    public static void triggerThreeHelper (List<Account> newAccounts) {
        for (Account acc : newAccounts) {
            if (!(acc.Phone == null && acc.Website == null && acc.Fax == null)) {
                acc.Rating = 'Hot';
            }
        }
    }

    /*
    * Question 4
    * Account Trigger
    * When an account is inserted create a contact related to the account with the following default values:
    * LastName = 'DefaultContact'
    * Email = 'default@email.com'
    * Trigger should only fire on insert.
    */

    public static void triggerFourHelper (List<Account> newAccounts) {
        List<Contact> contacts = new List<Contact>();

        for (Account acc : newAccounts) {
            Contact contact = new Contact();
            contact.AccountId = acc.Id;
            contact.LastName = 'DefaultContact';
            contact.Email = 'default@email.com';
            contacts.add(contact);
        }
        insert contacts;
    }

     /*
    * Question 5
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Error Message: 'Opportunity amount must be greater than 5000'
    * Trigger should only fire on update.
    */

    public static void triggerFiveHelper (List<Opportunity> updatedOpps) {
        for (Opportunity opp : updatedOpps) {
            if (opp.Amount < 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
    }

    /*
     * Question 6
	 * Opportunity Trigger
	 * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
	 * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
	 * Trigger should only fire on delete.
	 */

    public static void triggerSixHelper (List<Opportunity> deletedOpps) {
        Set<Id> accIds = new Set<Id>();
        for (Opportunity opp : deletedOpps) {
            accIds.add(opp.AccountId);
        }

        //List<Account> bankingAccounts = [SELECT Id, Industry FROM Account WHERE Industry = 'Banking' AND Id IN :accIds];
        //Map<Id, Account> bankingAccountsMap = new Map<Id, Account> (bankingAccounts);

        Map<Id, Account> bankingAccountsMap = new Map<Id, Account> ([SELECT Id, Industry FROM Account WHERE Industry = 'Banking' AND Id IN :accIds]);

        for (Opportunity opp : deletedOpps) {
            Account acc = bankingAccountsMap.get(opp.AccountId);
            if (opp.StageName == 'Closed Won' && acc != null) {
            opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }

     /*
    * Question 7
    * Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
    * Trigger should only fire on update.
    */

    public static void triggerSevenHelper (List<Opportunity> updatedOpps) {
        Set<Id> relatedAccountIds = new Set<Id>();

        for (Opportunity opp : updatedOpps) {
            relatedAccountIds.add(opp.AccountId);
        }

        List<Contact> ceoContacts = [SELECT Id, AccountId, Title FROM Contact WHERE Title = 'CEO' AND AccountId IN :relatedAccountIds];

        Map<Id, Contact> ceoByAccountId = new Map<Id, Contact> ();

        for(Contact c: ceoContacts) {
            if (!ceoByAccountId.containsKey(c.AccountId)) {
                ceoByAccountId.put(c.AccountId, c);
            }
        }

        for (Opportunity opp : updatedOpps) {
            Contact contact = ceoByAccountId.get(opp.AccountId);
            if (contact != null && opp.Primary_Contact__c != contact.Id) {
                opp.Primary_Contact__c = contact.Id;
            }
        }
    }
}