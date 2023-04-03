public with sharing class ContactSelector {
    public static List<Contact> fetchContactRelatedtoAccount(Set<Id> accountIds) {
        //NOPMD
        List<Contact> contacts = [
          SELECT Id, Phone, AccountId , HomePhone
          FROM Contact
          WHERE AccountId IN :accountIds
        ];
        return !contacts.isEmpty() ? contacts : null;
    }
    public static List<Contact> getMailingDetailForRelatedContact(Set<Id> accountIds) {

      List<Contact> contacts = [SELECT Id, AccountId, MailingStreet, MailingCty, MailingState, MailingPostalCode, MailingCountry
                                FROM Contact WHERE AccountId IN :accountIds];
      return !contacts.isEmpty() ? contacts : NULL;
    }
}