trigger AccountTrigger on Account (before insert, after insert) {
    
    if(Trigger.isBefore) {

        TriggerHelperClass.triggerOneHelper(Trigger.new);
        TriggerHelperClass.triggerTwoHelper(Trigger.new);
       
    }

    if(Trigger.isAfter) {
        TriggerHelperClass.triggerThreeHelper(Trigger.new);
        TriggerHelperClass.triggerFourHelper(Trigger.new);
    }
}