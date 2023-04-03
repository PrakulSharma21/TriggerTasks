public with sharing class EmployeeTriggerHandler {
    public static void beforeInsert(List<Employee__c> newEmployees) {
        
    }

    public static void afterInsert(List<Employee__c> newEmployees) {
        //updatePresentEmployeeCount(newEmployees);
        updatePresentEmployeeCountUsingParentChildSoql(newEmployees);
    }

    public static void beforeUpdate(List<Employee__c> newEmployees, List<Employee__c> oldEmployees) {//NOPMD -- Blank Function
        
    }

    public static void afterUpdate(List<Employee__c> newEmployees, List<Employee__c> oldEmployees, Map<Id,Employee__c> employeeMap) {
        //updateLeftNumberOfEmployees(oldEmployees);
    }

    public static void beforeDelete(List<Employee__c> oldEmployees) {//NOPMD -- Blank Function
      
    }

    public static void afterDelete(List<Employee__c> oldEmployees) {//NOPMD -- Blank Function
       // updatePresentEmployeeCount(oldEmployees);
    }
    
    public static void afterUndelete(List<Employee__c> newEmployees) {
        //updateLeftNumberOfEmployees(newEmployees);
        //updatePresentEmployeeCount(newEmployees);
    }

    //17 //19
    private static void updateLeftNumberOfEmployees(List<Employee__c> employees){
        Set<Id> accountIds = new Set<Id>();
        for (Employee__c employee : employees) {
            accountIds.add(employee.AccountId__c);
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (AggregateResult resultArray : [SELECT AccountId__c accId, COUNT(Id) countEmployee FROM Employee__c
            WHERE AccountId__c IN :accountIds GROUP BY AccountId__c]) {
            accountsToUpdate.add(new Account(
                Id = (Id)resultArray.get('accId'),
                Left_Employee_Count__c = (Integer)resultArray.get('countEmployee')
            ));
        }
        update accountsToUpdate;
    }
    //18
    private static void undeleteEmployee(List<Employee__c> employees) {
        Set<String> employeeIds = new Set<String>();
        for (Employee__c employee : employees) {
            employeeIds.add(employee.Employee_ID__c);
        }
        List<Employee__c> employeeList = [SELECT Active_Employee__c FROM Employee__c WHERE Employee_ID__c IN :employeeIds];
        for(Employee__c employee : employeeList) {
            employee.Active_Employee__c	= True;
        }
        update employeeList;
    }
    //20
    private static void updatePresentEmployeeCount(List<Employee__c> employees){
        Set<Id> accountIds = new Set<Id>();
        for (Employee__c employee : employees) {
            accountIds.add(employee.AccountId__c);
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (AggregateResult resultArray : [SELECT AccountId__c accId, COUNT(Id) countEmployee FROM Employee__c
            WHERE AccountId__c IN :accountIds GROUP BY AccountId__c]) {
            accountsToUpdate.add(new Account(
                Id = (Id)resultArray.get('accId'),
                NumberOfEmployees = (Integer)resultArray.get('countEmployee')
            ));
        }
        update accountsToUpdate;
    }

    private static void updatePresentEmployeeCountUsingParentChildSoql(List<Employee__c> employees){
        Set<Id> accountIds = new Set<Id>();
        List<Account> accountsToUpdate = new List<Account>();
        for (Employee__c employee : employees) {
            accountIds.add(employee.AccountId__c);
        }
        List<Account> accountList = [SELECT Id,NumberOfEmployees,
                                    (SELECT Employee_ID__c FROM Employees__r) from 
                                    Account WHERE Id IN : accountIds];
        for(Account account : accountList) {
            Account a = new Account();
            a.id = account.id;
            a.NumberOfEmployees = account.Employees__r.size();
            accountsToUpdate.add(a);
        }
        update accountsToUpdate;
    }
}