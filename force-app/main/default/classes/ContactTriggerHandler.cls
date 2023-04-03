public with sharing class ContactTriggerHandler {
    
    public static void beforeInsert(List<Contact> newContacts) {
        checkDuplicateEmail(newContacts);
        sendEmail(newContacts);
    }

    public static void afterInsert(List<Contact> newContacts) {
        
    }

    public static void beforeUpdate(List<Contact> newContacts, List<Contact> oldContacts) {//NOPMD -- Blank Function
        
    }

    public static void afterUpdate(List<Contact> newContacts, List<Contact> oldContacts, Map<Id,Contact> employeeMap) {
        
    }

    public static void beforeDelete(List<Contact> oldContacts) {//NOPMD -- Blank Function
      
    }

    public static void afterDelete(List<Contact> oldContacts) {//NOPMD -- Blank Function
       
    }
    
    public static void afterUndelete(List<Contact> oldContacts) {
        //updateLeftNumberOfEmployees(oldEmployees);
        //undeleteEmployee(oldContacts);
    }
    
    private static void sendEmail(List<Contact> newContacts) {
        List<Messaging.Email> emailList = new List<Messaging.Email>();
        for(Contact contact : newContacts) {
            if(String.isNotBlank(contact.Email)) {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String[] toAddress = new String[] {contact.Email};
                message.setToAddresses(toAddress);
                message.setSubject('Hello ' + contact.firstName + contact.lastName);
                message.plainTextBody = 'Your account has been succesfully created';
                emailList.add(message);
            }
        }
        Messaging.sendEmail(emailList);
    }
    //30
    private static void checkDuplicateEmail(List<Contact> contacts) {
        List<Contact> contactQuery = [SELECT email FROM Contact];
        Set<String> emailList = new Set<String>();
        for(Contact contact : contactQuery) {
            if(String.isNotBlank(contact.email))
            emailList.add(contact.email);
        }
        for(Contact contact : contacts) {
            if(emailList.contains(contact.email)){
                contact.Email.addError('Duplicate Email');
            }
        }
    }
}   