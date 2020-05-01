public with sharing class TriggerHandlerHelper {
/*
This method will only be tested if a test actually passes the context.
No auto covery for this :(
 */
    public static String createContextString(){
        String timming='before';
        String operation = 'insert';

        if(Trigger.isAfter){
            timming='after';
        }

        if(Trigger.isUpdate){
            operation='update';
        }

        if(Trigger.isUndelete){
            operation='undelete';
        }
        return timming + ' '+operation;

    }

    public static final Map <String, TriggerHandlerExt.TriggerContext> CONTEXTBYCONTEXTNAME = new Map<String,TriggerHandlerExt.TriggerContext>{
            'before insert'=>TriggerHandlerExt.TriggerContext.BEFORE_INSERT,
            'before update'=>TriggerHandlerExt.TriggerContext.BEFORE_UPDATE,
            'before delete'=>TriggerHandlerExt.TriggerContext.BEFORE_DELETE,
            'after insert'=>TriggerHandlerExt.TriggerContext.AFTER_INSERT,
            'after update'=>TriggerHandlerExt.TriggerContext.AFTER_UPDATE,
            'after delete'=>TriggerHandlerExt.TriggerContext.AFTER_DELETE,
            'after undelete'=>TriggerHandlerExt.TriggerContext.AFTER_UNDELETE
    };

}