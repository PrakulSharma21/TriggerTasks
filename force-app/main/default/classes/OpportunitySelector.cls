public with sharing class OpportunitySelector {
    public static List<Opportunity> getRelatedOpportunity(Set<Id> accountIds) {
        List<Opportunity> opportunities = [SELECT Id, StageName FROM Opportunity WHERE StageName NOT IN ('Closed Won') AND AccountId IN : accountIds];
        return !opportunities.isEmpty() ? opportunities : NULL;
    }
}