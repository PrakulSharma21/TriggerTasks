public with sharing class UserTriggerHandler {
    public static void beforeInsert(List<User> users) {//NOPMD -- Blank Function
        
    }

    public static void afterInsert(List<User> users) {
        checkAdminAndIsActive(users);
    }

    public static void beforeUpdate() {//NOPMD -- Blank Function
        
    }

    public static void afterUpdate() {//NOPMD -- Blank Function
        
    }

    public static void beforeDelete() {//NOPMD -- Blank Function
        
    }

    public static void afterDelete() {//NOPMD -- Blank Function
        
    }

    private static void checkAdminAndIsActive(List<User> userList) {
        List<GroupMember> groupMembers = new List<GroupMember>();
        Group adminGroup = [SELECT Id FROM Group WHERE DeveloperName = 'Admins' AND Type = 'Regular' LIMIT 1];
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        for (User user : userList) {
            if(user.ProfileId == profileId.Id && user.IsActive == true){
                groupMembers.add(
                    new GroupMember(
                        GroupId = adminGroup.Id, 
                        UserOrGroupId = user.Id
                        ));
            }
        }    
        if(!groupMembers.isEmpty()){
            insert groupMembers;
        }
    }        
}