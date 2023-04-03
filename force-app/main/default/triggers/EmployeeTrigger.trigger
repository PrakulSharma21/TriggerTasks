trigger EmployeeTrigger on Employee__c (before insert, before update, before delete, after insert, after update, after delete,after undelete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            //EmployeeTriggerHandler.afterDelete(Trigger.new);
        }
        when BEFORE_UPDATE {
            
        }
        when BEFORE_DELETE {
           
        }
        when AFTER_INSERT {
            EmployeeTriggerHandler.afterInsert(Trigger.new);
        }
        when AFTER_UPDATE {
        
        }
        when AFTER_DELETE {
            //EmployeeTriggerHandler.afterDelete(Trigger.old);
        }
        when AFTER_UNDELETE {
            //EmployeeTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}