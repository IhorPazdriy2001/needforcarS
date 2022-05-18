public with sharing class CreateOpportunity {

    @AuraEnabled()
    public static void createOpp(String productId, Decimal expectpr, Decimal quntitycar, String yearOfCar, String regionOfCar) {

        Id userId = UserInfo.getUserId();

        User u = [
            SELECT Id, AccountId FROM User WHERE Id =: userId
        ];

        Account acc = [
            SELECT Id, Category__c FROM Account WHERE Id =: u.AccountId
        ];

        Account accname = [
            SELECT Name FROM Account WHERE Id =: u.AccountId
        ];
    

        List<Pricebook_Definition__mdt> definitions = Pricebook_Definition__mdt.getAll().values();

        String pricebookName;

        for (Pricebook_Definition__mdt definition : definitions) {
            if (definition.Account_Category__c == acc.Category__c) {
                pricebookName = definition.Pricebook_Name__c;
                break;
            }
        }

        PricebookEntry entry = [
            SELECT Id, UnitPrice FROM PricebookEntry
             WHERE Product2Id =: productId AND Pricebook2.Name =: pricebookName
              LIMIT 1
        ];
        

    Opportunity opp = new Opportunity();
    opp.CloseDate=date.today().addMonths(2);
    opp.Name= 'Test' + '' + 'order';
    opp.StageName= 'Closed Won'; 
    opp.YearOfCar__c = yearOfCar;
    opp.Region_of_by__c = regionOfCar;
    insert opp;


        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.PricebookEntryId = entry.Id;
        oppLineItem.Quantity = quntitycar;
        oppLineItem.TotalPrice = expectpr;
        insert oppLineItem;
    }




}