trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            //EmployeeTriggerHandler.afterDelete(Trigger.new);
            ContactTriggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            
        }
        when BEFORE_DELETE {
           
        }
        when AFTER_INSERT {
            
        }
        when AFTER_UPDATE {
        
        }
        when AFTER_DELETE {
            
        }    
    }
}