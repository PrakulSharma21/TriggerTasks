public with sharing class AccountService {

    public static Contact createContact(Account account) {
        if(account == NULL) {
            return NULL;
        }

        Contact contact = new Contact();
        contact.AccountId = account.ID;
        contact.Lastname = account.Name;
        contact.Phone = account.Phone;
        return contact;
    }

    public static Opportunity createOpportunity(Account account) {
        if(account == NULL) {
            return NULL;
        }

        Opportunity opportunity = new Opportunity();
        opportunity.AccountID = account.ID;
        opportunity.Name = account.Name+'\'s Opportunity';
        opportunity.CloseDate = System.today();
        opportunity.StageName = 'Prospecting';
        return opportunity;
    }

    public static List<Contact> getUpdateContactHomePhone(Map<Id, String> accountIdToPhoneMap) {//NOPMD
        List<Contact> contacts = ContactSelector.fetchContactRelatedtoAccount(accountIdToPhoneMap.keySet()); 
        for (Contact contact : contacts) {
            contact.HomePhone = accountIdToPhoneMap.get(contact.AccountId);
        }
        return !contacts.isEmpty() ? contacts : NULL;
    }

    public static List<Contact> copyBillingAddressToMailingAddress(List<Contact> contactsToUpdate , Map<Id, Account> updatedAccountMap) {
        List<Contact> contacts = new List<Contact>();
        for(Contact contact : contactsToUpdate) {
            Account account = updatedAccountMap.get(contact.AccountId);
            contact.MailingStreet = account.BillingStreet;
            contact.MailingCity = account.BillingCity;
            contact.MailingState = account.BillingState;
            contact.MailingPostalCode = account.BillingPostalCode;
            contact.MailingCountry = account.BillingCountry;
            contacts.add(contact);
        }
        return !contacts.isEmpty() ? contacts : NULL;
    }
}