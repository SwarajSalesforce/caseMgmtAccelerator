/**
* -------------------------------------------------------------------------------------------------+
* @description This open source trigger framework bundles a single TriggerHandlerExt base class that you can 
inherit from in all of your trigger handlers. The base class includes context-specific 
methods that are automatically called when a trigger is executed.
The base class also provides a secondary role as a supervisor for Trigger execution. 
It acts like a watchdog, monitoring trigger activity and providing an api for controlling 
certain aspects of execution and control flow.
* --------------------------------------------------------------------------------------------------
* @version        1.0
* @created        2020-03-20
* @modified       -
* @modified by    -
* -------------------------------------------------------------------------------------------------+
*/
public virtual class TriggerHandlerExt {
    
    // static map of handlername, times run() was invoked
    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;
    
    // the current context of the trigger, overridable in tests
    @TestVisible
    private TriggerContext context;
    
    // the current context of the trigger, overridable in tests
    @TestVisible
    private Boolean isTriggerExecuting;
    
    // static initialization
    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
    }
    
    // constructor
    public TriggerHandlerExt() {
        this.setTriggerContext();
    }
    
    /***************************************
* public instance methods
***************************************/
    
    // main method that will be called during execution
    public void run() {
        
        if (!validateRun()) {
            return;
        }
        
        addToLoopCount();
        
        // dispatch to the correct handler method
        if (this.context == TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        } else if (this.context == TriggerContext.BEFORE_UPDATE) {
            this.beforeUpdate();
        } else if (this.context == TriggerContext.BEFORE_DELETE) {
            this.beforeDelete();
        } else if (this.context == TriggerContext.AFTER_INSERT) {
            this.afterInsert();
        } else if (this.context == TriggerContext.AFTER_UPDATE) {
            this.afterUpdate();
        } else if (this.context == TriggerContext.AFTER_DELETE) {
            this.afterDelete();
        } else if (this.context == TriggerContext.AFTER_UNDELETE) {
            this.afterUndelete();
        }
        
    }
    
    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();
        if (!TriggerHandlerExt.loopCountMap.containsKey(handlerName)) {
            TriggerHandlerExt.loopCountMap.put(handlerName, new LoopCount(max));
        } else {
            TriggerHandlerExt.loopCountMap.get(handlerName).setMax(max);
        }
    }
    
    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }
    
    /***************************************
* public static methods
***************************************/
    
    public static void bypass(String handlerName) {
        TriggerHandlerExt.bypassedHandlers.add(handlerName);
    }
    
    public static void clearBypass(String handlerName) {
        TriggerHandlerExt.bypassedHandlers.remove(handlerName);
    }
    
    public static Boolean isBypassed(String handlerName) {
        return TriggerHandlerExt.bypassedHandlers.contains(handlerName);
    }
    
    public static void clearAllBypasses() {
        TriggerHandlerExt.bypassedHandlers.clear();
    }
    
    /***************************************
* private instancemethods
***************************************/
    
    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }
    
    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {
        
        this.isTriggerExecuting = true;
        
        if (!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        }
        
        if (ctx!=null){
            this.context = TriggerHandlerHelper.CONTEXTBYCONTEXTNAME.get(ctx);
            return;
        }
        
        this.context = TriggerHandlerHelper.CONTEXTBYCONTEXTNAME.get(TriggerHandlerHelper.createContextString());
        
    }
    
    // increment the loop count
    @TestVisible
    private void addToLoopCount() {
        String handlerName = getHandlerName();
        if (TriggerHandlerExt.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandlerExt.loopCountMap.get(handlerName).increment();
            if (exceeded) {
                Integer max = TriggerHandlerExt.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }
    
    
    
    // make sure this trigger should continue to run
    @TestVisible
    private Boolean validateRun() {
        if (!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        if (TriggerHandlerExt.bypassedHandlers.contains(getHandlerName())) {
            return false;
        }
        return true;
    }
    
    @TestVisible
    private String getHandlerName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }
    
    /***************************************
* context methods
***************************************/
    
    // context-specific methods for override
    @TestVisible
    protected virtual void beforeInsert() {
        System.debug('Before Insert Context running');
    }
    @TestVisible
    protected virtual void beforeUpdate() {
        System.debug('Before Update context running');
    }
    @TestVisible
    protected virtual void beforeDelete() {
        System.debug('Before Delete Context running');
    }
    @TestVisible
    protected virtual void afterInsert() {
        System.debug('After Insert Context running');
    }
    @TestVisible
    protected virtual void afterUpdate() {
        System.debug('After Update Context running');
    }
    @TestVisible
    protected virtual void afterDelete() {
        System.debug('After Delete Context running');
    }
    @TestVisible
    protected virtual void afterUndelete() {
        System.debug('After Undelete Context running');
    }
    
    /***************************************
* inner classes
***************************************/
    
    // inner class for managing the loop count per handler
    @TestVisible
    private class LoopCount {
        private Integer max;
        private Integer count;
        
        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }
        
        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }
        
        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }
        
        public Boolean exceeded() {
            if (this.max < 0) {
                return false;
            }
            if (this.count > this.max) {
                return true;
            }
            return false;
        }
        
        public Integer getMax() {
            return this.max;
        }
        
        public Integer getCount() {
            return this.count;
        }
        
        public void setMax(Integer max) {
            this.max = max;
        }
    }
    
    // possible trigger contexts
    @TestVisible
    public enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
            AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
            AFTER_UNDELETE
            }
    
    // exception class
    public class TriggerHandlerException extends Exception {
    }
    
      
}