trigger OpportunityTrigger on Opportunity (before update, before delete) {

    if(Trigger.isBefore && Trigger.isUpdate) {
        TriggerHelperClass.triggerFiveHelper(Trigger.new);
        TriggerHelperClass.triggerSevenHelper(Trigger.new);
    }

    if(Trigger.isBefore && Trigger.isDelete) {
        TriggerHelperClass.triggerSixHelper(Trigger.old);
    }
}