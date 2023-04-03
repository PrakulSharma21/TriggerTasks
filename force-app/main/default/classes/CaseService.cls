public with sharing class CaseService {

    public static List<Account> getUpdatedAccountList(List<Case> cases) {
        List<Account> updatedAccounts = new List<Account>();
        for(Case caseInstance : cases) {
            Account account = new Account();
            account.id = caseInstance.accountId;
            account.Latest_Case_Number__c = caseInstance.CaseNumber;
            updatedAccounts.add(account);
        }
        return !updatedAccounts.isEmpty() ? updatedAccounts : NULL;
          
    } 
}