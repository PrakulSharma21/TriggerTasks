//Upon Account Creation, if Industry is not null and has value as ‘Media’ then populate Rating as Hot.
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete) { //NOPMD
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            //AccountTriggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.old);
        }
        when BEFORE_DELETE {
            AccountTriggerHandler.beforeDelete(Trigger.old);
        }
        when AFTER_INSERT {
            
        }
        when AFTER_UPDATE {
            AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.old, Trigger.oldMap);
        }
        when AFTER_DELETE {
            
        }
    }
}