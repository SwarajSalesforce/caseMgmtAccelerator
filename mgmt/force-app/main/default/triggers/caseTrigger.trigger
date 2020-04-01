trigger caseTrigger on Case (Before Insert, Before Update) {
    new caseTriggerHandler().run();
}