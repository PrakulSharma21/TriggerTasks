@isTest
public class Test {
@isTest 
    public static void testAccountTrigger() {
        List<Account> accounts = new List<Account>();
        for(integer i=0;i<200;i++){
            accounts.add(new Account(Name='Test '+i,Industry='Media'));
        }
        insert accounts;
        AccountTriggerHandler.beforeInsert(accounts);
    }
@isTest     
    public static void testOpportunityTrigger() {
        List<Opportunity> opportunities=new List<Opportunity>();
        for(integer i=0;i<200;i++){
            opportunities.add(new Opportunity(Name='Test '+i,CloseDate=System.today(),stageName='Closed Won',Amount=12345678));
        }
        insert opportunities;
        OpportunityTriggerHandler.beforeInsert(opportunities);
    }
@isTest
    public static void testOpportunityTrigger1() {
        List<Account> accounts = [SELECT ID ,name FROM account];
        System.debug(accounts.size());
        List<Opportunity> opportunities = new List<Opportunity>();
        for(integer i=0;i<30;i++) {
            opportunities.add(new Opportunity(AccountId = accounts[i].ID, Name = 'Opportunity for account '+ i , CloseDate = System.today(), StageName = 'Prospecting'));
        }
        insert opportunities;
    }
}