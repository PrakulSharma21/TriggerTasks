trigger UserTrigger on User (before insert, before update, before delete, after insert, after update, after delete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            
        }
        when BEFORE_UPDATE {
            
        }
        when BEFORE_DELETE {
           
        }
        when AFTER_INSERT {
            UserTriggerHandler.afterInsert(Trigger.new);
        }
        when AFTER_UPDATE {
        
        }
        when AFTER_DELETE {
            
        }
        when AFTER_UNDELETE {
            
        }
    }

}