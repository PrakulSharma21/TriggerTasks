public with sharing class OpportunityService {

    public static List<Account> updateLatestOpportunityOnAccount(List<Opportunity> opportunities) {
        List<Account> updatedAccounts = new List<Account> ();
        for(Opportunity opportunity : opportunities) {
            Account account = new Account();
            account.Recent_Opportunity_Amount__c = opportunity.Amount;
            updatedAccounts.add(account);
        }
        return !updatedAccounts.isEmpty() ? updatedAccounts : NULL;
        
    }

    public static Task createTaskForOpportunity(Opportunity opportunity) {
        if(opportunity == null) {
            return NULL;

        }
        Task newTask = new Task();
        newTask.Subject = 'Call';
        newTask.Status = 'Not Started';
        newTask.Priority = 'High';
        newTask.OwnerId = UserInfo.getUserId();
        newTask.whatId = opportunity.id;
        newTask.Description = 'Task Generated for '+opportunity.name;
        return newTask;
    }
}