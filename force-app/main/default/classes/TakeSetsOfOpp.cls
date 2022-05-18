public class TakeSetsOfOpp {
   public static void createTask(List<Opportunity> opportunities) {
  
        Id userId = UserInfo.getUserId();
        User u = [
            SELECT Id, ManagerId, AccountId FROM User WHERE Id =: userId
        ];
       
        Account acc = [
            SELECT Id, Category__c FROM Account WHERE Id =: u.AccountId
        ];
    
        
       List<Opportunity_Task_Set_Definition__mdt> taskDefinitions;
        for (Opportunity_Task_Sets_Definiti__mdt definition : [SELECT id,Account_Category__c,(SELECT Subject__c,Due_Date_Offset__c from Sets_Definitions__r) from Opportunity_Task_Sets_Definiti__mdt]) {
            if (definition.Account_Category__c == acc.Category__c) {
         			taskDefinitions = definition.Sets_Definitions__r;
            }
        }
       
       
       
        List<Task> tasksToInsert = new List<Task>();
        for (Opportunity opportunity : opportunities) {
           
            for(Opportunity_Task_Set_Definition__mdt taskDefinition : taskDefinitions) {
                Task task = new Task();
                task.ActivityDate = date.today().addDays((Integer)taskDefinition.Due_Date_Offset__c);
                task.OwnerId = u.ManagerId;  
                task.Subject = taskDefinition.Subject__c;
                task.WhatId = opportunity.Id;
                tasksToInsert.add(task);
            }
        }

        if (tasksToInsert.size() > 0) {
            insert tasksToInsert;
        }
    }
}