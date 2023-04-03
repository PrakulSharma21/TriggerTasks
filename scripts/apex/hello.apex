// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Account> Accounts = [SELECT Id ,(SELECT Id, AccountId FROM Opportunities) FROM Account];

for (Account account : Accounts) {
    System.debug(account.Opportunities.size());
}