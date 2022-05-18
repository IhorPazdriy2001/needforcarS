public with sharing class priceValue {

    @AuraEnabled(cacheable = true)
    public static Decimal acountCategoryVal(String productId){

        Id userId = UserInfo.getUserId();

        User u = [
            SELECT Id, AccountId FROM User WHERE Id =: userId
        ];

        Account acc = [
            SELECT Id, Category__c FROM Account WHERE Id =: u.AccountId
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

        return entry.UnitPrice;
    }
    
}