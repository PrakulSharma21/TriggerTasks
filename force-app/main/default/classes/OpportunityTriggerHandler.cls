public with sharing class OpportunityTriggerHandler {
    public static void beforeInsert(List<Opportunity> newOpportunities) { //NOPMD -- Blank Function
       //updateDescriptionWithStageName(newOpportunities);
    }
    public static void afterInsert(List<Opportunity> newOpportunities) {
        //updateLatestOpportunityOnAccount(newOpportunities);
        // updateTotalAmountOnAccount(newOpportunities);
        // updateAccounts(newOpportunities);

    }
    public static void beforeUpdate(List<Opportunity> newOpportunities, Map<Id,Opportunity> oldOpportunities) { //NOPMD -- Blank Function
        //updateDescriptionWithStageName(newOpportunities);
        //updateClosedWonReason(newOpportunities, oldOpportunities);
    }
    public static void afterUpdate(List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities) { //NOPMD -- Blank Function
        //assignTaskToOpportunity(newOpportunities,oldOpportunities);
        // updateAccounts(newOpportunities);
    }
    public static void beforeDelete(List<Opportunity> oldOpportunities) { //NOPMD -- Blank Function
        //checkOpportunityDeleterIsSystemAdmin(oldOpportunities);
    }
    public static void afterDelete(List<Opportunity> oldOpportunities) { //NOPMD -- Blank Function
        updateAccounts(oldOpportunities);
    }
    private static void updateLatestOpportunityOnAccount(List<Opportunity> opportunities) {
        List<Account> accounts = OpportunityService.updateLatestOpportunityOnAccount(opportunities);
        if(!accounts.isEmpty()) {
            update accounts;//NOPMD
        }
    }

    private static void updateDescriptionWithStageName(List<Opportunity> opportunities) {
        for(Opportunity opportunity : opportunities) {
            if(opportunity != NULL) { 
                if(opportunity.StageName == 'Closed Won' || opportunity.StageName == 'Closed Lost') {
                    opportunity.Description = 'Opp is '+opportunity.StageName;
                    
                }
                else {
                    opportunity.Description = 'Opp is Open';
                }
            }
        }
    }

    public static void assignTaskToOpportunity(List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities) {
        List<Task> tasks = new List<Task>();
        for(integer i = 0; i<newOpportunities.size(); i++) {
            if(newOpportunities[i].AccountId == oldOpportunities[i].AccountId) {
                if(newOpportunities[i].StageName != oldOpportunities[i].StageName) {
                    tasks.add(OpportunityService.createTaskForOpportunity(newOpportunities[i]));
                }
            }   
        }
        insert tasks;
    }

    private static void updateClosedWonReason(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        for(Opportunity opportunity : opportunities) {
            if((opportunity.StageName == 'Closed Lost' 
            && opportunityMap.get(opportunity.id).StageName != 'Closed Lost'
            && opportunity.Closed_Lost_Reason__c == opportunityMap.get(opportunity.id).Closed_Lost_Reason__c)) {
                opportunity.Closed_Lost_Reason__c.addError('Please populate Closed Lost Reason');
            }
        }
    }

    private static void checkOpportunityDeleterIsSystemAdmin(List<Opportunity> opportunities) {
        Id profileId = userinfo.getProfileId();
        Id systemAdminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        for(Opportunity opportunity : opportunities) {
            if(opportunity.StageName != 'Closed Won' && opportunity.StageName !='Closed Lost')  {
                if(profileId != systemAdminId) {
                    opportunity.addError('You Don\'t have permission to delete this opportunity,'+ 
                                +'Please contact System Admin ');
                }
            }
        } 
    }

    //Ques 23 using Map
    // private static void updateTotalAmountOnAccount(List<Opportunity> opportunities) {
    //     Set<Id> accountIds = new Set<Id>();
    //     for(Opportunity opportunity : opportunities) {
    //         accountIds.add(opportunity.AccountId);
    //     }
    //     Map<Id,Account> accountMap = new Map<Id,Account> ( [SELECT Id, AnnualRevenue FROM Account WHERE Id In :accountIds] );
    //     List<Opportunity> opportunitylist = [SELECT Id,AccountId,Amount from opportunity WHERE Id = :opportunities];
    //     List<Account> accounts = new List<Account>();
    //     for(Opportunity opportunity : opportunitylist) {
    //         if(accountMap.get(opportunity.AccountId).AnnualRevenue == null) {
    //             accounts.add(new Account(ID = opportunity.AccountId,AnnualRevenue = opportunity.Amount));
    //         }
    //        	else {	
    //             accounts.add(new Account(ID = opportunity.AccountId , AnnualRevenue = (accountMap.get(opportunity.AccountId).AnnualRevenue)+opportunity.Amount));
    //         }
    //     }
    //     update accounts;
    // }

    //Ques 23 using Aggregate Query
    private static void updateAccounts(List<Opportunity> opportunities) {
    List<Account> accountsToUpdate = new List<Account>();
    Set<Id> accountIds = new Set<Id>();
        for (Opportunity opportunity : opportunities) {
            accountIds.add(opportunity.AccountId);
        }
    List<Opportunity> remainingOpportunity = [SELECT CountId from Opportunity Where AccountId In :accountIds];
    if(accountIds.size() == 1){
        Account acc = new Account(
        Id = (Id)opportunities[0].AccountId,
        AnnualRevenue = 0
        );
    }
    else {
        for (AggregateResult aggResult : [
            SELECT AccountId, SUM(Amount) totalAmount
            FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {

                Account acc = new Account(
                Id = (Id)aggResult.get('AccountId'),
                AnnualRevenue = (Decimal)aggResult.get('totalAmount')
                );
                accountsToUpdate.add(acc);
            }
    }    
    update accountsToUpdate;
    }
}