public with sharing class CaseTriggerHandler {

    public static void beforeInsert() {//NOPMD -- Blank Function
        
    }

    public static void afterInsert(List<Case> newCases) {
        //updateCaseNumberOnAccount(newCases);
        populateNumberOfCaseOnAccount(newCases);
    }

    public static void beforeUpdate() {//NOPMD -- Blank Function
        
    }

    public static void afterUpdate() {//NOPMD -- Blank Function
        
    }

    public static void beforeDelete() {//NOPMD -- Blank Function
        
    }

    public static void afterDelete() {//NOPMD -- Blank Function
        
    }

    private static void updateCaseNumberOnAccount(List<Case> cases) {
        List<Account> updatedAccounts = CaseService.getUpdatedAccountList(cases);
        if(!updatedAccounts.isEmpty()) {
            update updatedAccounts; //NOPMD 
        }
    }

    private static void populateNumberOfCaseOnAccount(List<Case> cases) {
        RecordType partnerRecordId = [Select ID,Name from RecordType where Name = 'Partner Case'];
        RecordType customerRecordId = [Select ID,Name from RecordType where Name = 'Customer Case'];
        Map<Id, Account> accountMap = new Map<Id, Account>();
        Set<Id> partnerAccountIds = new Set<Id>();
        Set<Id> customerAccountIds = new Set<Id>();
        for (Case c : cases) {
            if (partnerRecordId.Id == c.RecordTypeId) {
                partnerAccountIds.add(c.AccountId);
            } else if (customerRecordId.Id == c.RecordTypeId) {
                customerAccountIds.add(c.AccountId);
            }
        }
        List<Account> partnerAccountsToUpdate = [SELECT Id, Total_Partner_Case__c FROM Account WHERE Id IN :partnerAccountIds];
        for (Account account : partnerAccountsToUpdate) {
            if(account.Total_Partner_Case__c == null) {
                account.Total_Partner_Case__c = 1;
            }
            else {
                account.Total_Partner_Case__c = account.Total_Partner_Case__c + 1;
            }
            accountMap.put(account.Id, account);
        }
        List<Account> customerAccountsToUpdate = [SELECT Id, Total_Customer_Case__c FROM Account WHERE Id IN :customerAccountIds];
        for (Account account : customerAccountsToUpdate) {
            if(account.Total_Customer_Case__c == null) {
                account.Total_Customer_Case__c = 1;
            }
            else {
                account.Total_Customer_Case__c = account.Total_Customer_Case__c + 1;
            }
            accountMap.put(account.Id, account);
        }
        update accountMap.values();
    }
}   