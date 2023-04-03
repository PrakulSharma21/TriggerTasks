/**
 * @description AccountHandler
 */
public with sharing class AccountTriggerHandler {
    /**
    * @description insertRating
    */
    public static void beforeInsert(List<Account> newAccounts) {
        //copyBillingAddressToShippingAddress(accounts);
       // updateRatingToHot(newAccounts);
       
    }

    public static void afterInsert(List<Account> newAccounts) {
        //createRelatedContact(newAccounts);
       // createRelatedContactAndOpportunity(newAccounts);
        //createRelatedOpportunity(newAccounts);
        
    }

    public static void beforeUpdate(List<Account> newAccounts, List<Account> oldAccounts) {//NOPMD -- Blank Function
        //copyBillingAddressToShippingAddress(newAccounts);
        //updateDescription(newAccounts, oldAccounts);
       // updateRatingToHot(newAccounts);
       //updateRelatedContactNumber(newAccounts);
       checkAccountCreatedSevenDaysBefore(oldAccounts);
        
    }

    public static void afterUpdate(List<Account> newAccounts, List<Account> oldAccounts, Map<Id,Account> accountMap) {
        //updatePhoneOnRelatedContact(newAccounts, accountMap);
        //updateMailingAddressForRelatedContact(newAccounts, accountMap);
        //checkAndUpdateRelatedOpportunity(newAccounts, accountMap);
        updatePhoneUsingParentChildUsingSoql(newAccounts, accountMap);
    }

    public static void beforeDelete(List<Account> oldAccounts) {//NOPMD -- Blank Function
      //checkAccountIsActive(oldAccounts);
        checkRelatedOpportunityExists(oldAccounts);
        //checkRelatedCaseExists(oldAccounts);
        // checkAccountDeleterIsSystemAdmin(oldAccounts);
    }

    public static void afterDelete() {//NOPMD -- Blank Function
        
    }

    private static void updateRatingToHot(List<Account> accounts) {
        for(Account account  :accounts) {
            if(account.Industry != NULL && account.Industry == 'Media') {
                account.Rating = 'Hot';
            }
            else if(account.Industry != 'Media'){
                account.Rating = '';
            }
        }
    }

    private static void copyBillingAddressToShippingAddress(List<Account> accounts) {
        Integer indexOfOldAccounts = 0;
        for(Account account : accounts) {
            if(account.Copy_Billing_To_Shipping__c == true) {

                if(String.isNotBlank(account.BillingStreet)) {
                    account.ShippingStreet = account.BillingStreet;
                }

                if(String.isNotBlank(account.BillingCity)) {
                    account.ShippingCity = account.BillingCity;
                }

                if(String.isNotBlank(account.BillingCountry)) {
                    account.ShippingCountry = account.BillingCountry;
                }

                if(String.isNotBlank(account.BillingPostalCode)) {
                    account.ShippingPostalCode = account.BillingPostalCode;
                }

                if(String.isNotBlank(account.BillingState)) {
                    account.ShippingState = account.BillingState;
                }
            }
        }
    }

    private static void createRelatedContact(List<Account> accounts){
        List<Contact> contacts = new List<Contact>();
        for(Account account : accounts) {
            contacts.add(AccountService.createContact(account));
        }

        if(!contacts.isEmpty()) {
            insert contacts;//NOPMD
        }
    }

    private static void createRelatedOpportunity(List<Account> accounts){
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Account account : accounts) {
            opportunities.add(AccountService.createOpportunity(account));
        }
        if(!opportunities.isEmpty()) {
            insert opportunities;//NOPMD
        }
    }

    private static void createRelatedContactAndOpportunity(List<Account> accounts) {
        List<Opportunity> opportunities = new List<Opportunity> ();
        List<Contact> contacts = new List<Contact> ();
        for(Account accountInstance : accounts) {
            if(accountInstance.Create_Related_Contact__c) {
                contacts.add(AccountService.createContact(accountInstance));
            }

            if(accountInstance.Create_Related_Opportunity__c && accountInstance.Active__c == 'Yes') {
                opportunities.add(AccountService.createOpportunity(accountInstance));
            }
        }

        if(!contacts.isEmpty()) {
            insert contacts;
        }

        if(!opportunities.isEmpty()) {
            insert opportunities;
        }
    }

    private static void updateDescription(List<Account> newAccounts, List<Account> oldAccounts) {
        Integer indexForOldAccounts = 0;
        for(Account account : newAccounts) {
            if(account.Phone != oldAccounts[indexForOldAccounts].Phone) {
                account.Description = 'Phone is Updated! Old Value : ' + oldAccounts[indexForOldAccounts].Phone + ' New Value : ' + account.Phone;
                indexForOldAccounts++;
            }
            else {
                account.Description = '';
            }
        }
    }
    
    private static void updatePhoneOnRelatedContact(List<Account> accountList, Map<Id, Account> accountMap) {
        Map<Id, String> accountIdToPhoneMap = new Map<Id, String>();
        for (Account account : accountList) {
            if (account.Phone != accountMap.get(account.Id).Phone) {
                accountIdToPhoneMap.put(account.Id, account.Phone);
            }
        }

        if(!accountIdToPhoneMap.isEmpty()){
            List<Contact> relatedContactList = AccountService.getUpdateContactHomePhone(accountIdToPhoneMap);
            if(!relatedContactList.isEmpty()){
                update relatedContactList;
            }
        }
    }


    private static void updatePhoneUsingParentChildUsingSoql(List<Account> accounts,Map<Id,Account> accountMap){
        Set<Id> accountIds = new Set<Id>();
        for(Account account : accounts){
            if(account.Phone != accountMap.get(account.Id).Phone) {
                accountIds.add(account.Id);
            }
        }
        List<Contact> contactList = new List<Contact>();
        List<Account> accountToContact = [Select Id ,Phone ,(Select Id, HomePhone from Contacts) from Account where Id IN :accountIds];
        for(Account account : accountToContact){
            for(Contact contact : account.Contacts){
                Contact c = new Contact();
                c.Id = contact.Id;
                c.HomePhone = account.Phone;
                contactList.add(c);
            }
        }
        update contactList;
    }

    private static void updateMailingAddressForRelatedContact(List<Account> accounts, Map<Id,Account> accountMap) {
        Map<Id, Account> updatedAccountMap = new  Map<Id, Account>();
        Set<Id> accountIds = new Set<Id>();
        for(Account account : accounts) {
            if(account != null) {
                if (account.BillingStreet != accountMap.get(account.id).BillingStreet || 
                    account.BillingCity != accountMap.get(account.id).BillingCity ||
                    account.BillingState != accountMap.get(account.id).BillingState ||
                    account.BillingPostalCode != accountMap.get(account.id).BillingPostalCode ||
                    account.BillingCountry != accountMap.get(account.id).BillingCountry) {

                    updatedAccountMap.put(account.Id, account);
                    accountIds.add(account.Id);
                }
            }
        }    
    
        List<Contact> contactsToUpdate = ContactSelector.getMailingDetailForRelatedContact(accountIds);
        List<Contact> updatedContacts = AccountService.copyBillingAddressToMailingAddress(contactsToUpdate,updatedAccountMap);
        if(updatedContacts != NULL) {
            update updatedContacts;
        }
    }
//8
    private static void checkAndUpdateRelatedOpportunity(List<Account> newAccounts,Map< Id,Account> oldAccountMap) {
        Set<Id> accountIds = new Set<Id>();
        for (Account account : newAccounts) {
            if(account.Active__c == 'No' && oldAccountMap.get(account.id).Active__c == 'Yes') {
                accountIds.add(account.id);
            }
        }
        List<Opportunity> opportunities = OpportunitySelector.getRelatedOpportunity(accountIds);
        for(Opportunity opportunity : opportunities) {
            opportunity.StageName = 'Closed Lost';
        }
        if(!opportunities.isEmpty()) {
            update opportunities;
        }
    }

    private static void checkAccountIsActive(List<Account> accounts) {
        for(Account account : accounts) {
            if(account.Active__c == 'Yes') {
                account.addError('Account cannot be deleted till it is ACTIVE');
            }
        }
    }

    private static void checkAccountCreatedSevenDaysBefore(List<Account> accounts) {
        for(Account account : accounts) {
            if(account.CreatedDate.addDays(7) > System.today()) {
                FeedItem post = new FeedItem();
                post.ParentId = account.id;
                post.Body = 'Cannot delete account older than 7 days';
                insert post;
            }
        }
    }

    private static void checkAccountDeleterIsSystemAdmin(List<Account> accounts) {
        Id profileId = userinfo.getProfileId();
        Id systemAdminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        for(Account account : accounts) {
            if(profileId != systemAdminId ) {
                account.addError('You Don\'t have permission to delete this account,'+ 
                                +'Please contact SYstem Admin ');
            }
        }
    }

    private static void checkRelatedOpportunityExists(List<Account> accounts) {
        List<Opportunity> opportunities = [SELECT AccountId FROM Opportunity ];
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opportunity : opportunities) {
            accountIds.add(opportunity.AccountId);
        }
        for(Account account : accounts) {
            if(accountIds.contains(account.Id)) {
                account.addError('Opportunity Exists Cannot delete account');
            }
        }
        // List<Opportunity> opportunities = [SELECT Id,AccountId from Opportunity WHERE AccountId IN :accounts];
        // if(opportunities.size()>0) {
        //     for(Account account : accounts) {
        //         account.addError('cannot delete account, Opportunity Exists');
        //     }
        // }
    }

    private static void checkRelatedCaseExists(List<Account> accounts) {
        List<Case> cases = [SELECT AccountId FROM Case];
        Set<Id> accountIds = new Set<Id>();
        for(Case currentCase : cases) {
            accountIds.add(currentCase.AccountId);
        }
        for(Account account : accounts) {
            if(accountIds.contains(account.Id)) {
                account.addError('Case Exists Cannot delete account');
            }
        }
    }

    private static void changeOwnerOfRelatedContact(List<Account> newAccounts , Map<Id,Account> oldAccounts) {
        Set<Id> accountIds = new Set<Id>();
        for(Account account : newAccounts) {
            if(account.OwnerId != oldAccounts.get(account.Id).OwnerId) {
                accountIds.add(account.Id);
            }
        }
        List<Contact> contactsToUpdate = [SELECT Id, OwnerId, Account.OwnerId FROM Contact WHERE AccountId IN :accountIds];
        for (Contact contact : contactsToUpdate) {
            contact.OwnerId = contact.Account.OwnerId;
        }
        
        update contactsToUpdate;
        }
    
    public static void shareWithStandardUsers(List<Account> newAccounts) { //Q31
        List<AccountShare> accountSharesToInsert = new List<AccountShare>();
        List<User> standardUsers = [SELECT Id FROM User WHERE Profile.Name = 'Standard User'];
        
        for (Account newAccount : newAccounts) {
            for (User standardUser : standardUsers) {
                AccountShare accountShare = new AccountShare();
                accountShare.AccountId = newAccount.Id;
                accountShare.UserOrGroupId = standardUser.Id;
                accountShare.AccountAccessLevel = 'Read';
                accountShare.RowCause = Schema.AccountShare.RowCause.Manual;
                accountSharesToInsert.add(accountShare);
            }
        }
            
        insert accountSharesToInsert;
    }
}
