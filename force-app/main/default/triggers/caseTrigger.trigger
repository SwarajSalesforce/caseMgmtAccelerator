trigger caseTrigger on Case (Before Insert, Before Update,After update) {
    new caseTriggerHandler().run();
}