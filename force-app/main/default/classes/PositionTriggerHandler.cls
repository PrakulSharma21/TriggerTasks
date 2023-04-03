public with sharing class PositionTriggerHandler {
    
    public static void beforeInsert(List<Position__c> positions) {
        populateDefaultValues(positions);
    }

    public static void afterInsert() { //NOPMD -- BLANK FUNCTION BODY
        
    }

    public static void beforeUpdate() {//NOPMD -- BLANK FUNCTION BODY
        
    }

    public static void afterUpdate() {//NOPMD -- BLANK FUNCTION BODY
        
    }

    public static void beforeDelete() {//NOPMD -- BLANK FUNCTION BODY
        
    }

    public static void afterDelete() {//NOPMD -- BLANK FUNCTION BODY
        
    }
    
    private static void populateDefaultValues(List<Position__c> positions) { // populating default values in Open Date , Max_Pay , Min_pay if not entered by user.
        for(Position__c position : positions ) {
            if(position.Open_Date__c == NULL && position.Max_Pay__c == NULL && position.Min_Pay__c == NULL) {
                position.Open_Date__c = System.Today();
                position.Max_Pay__c = 15000;
                position.Min_Pay__c = 10000;
            }
        }
    }
}