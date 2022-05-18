public with sharing class SendMailForOrder {
   
   
   
    @AuraEnabled()
    public static void sendMail(String subject, String body) {



        Id userId = UserInfo.getUserId();

        User u = [
            SELECT Id, AccountId FROM User WHERE Id =: userId
        ];

        Account acc = [
            SELECT Id, Name FROM Account WHERE Id =: u.AccountId
        ];
        
        Contact conn = [
            SELECT Email from Contact WHERE AccountId =: acc.Id 
                ];




        // Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        // message.toAddresses = new String[] {con.Email};
        // message.optOutPolicy = 'FILTER';
        // message.subject = 'Opt Out Test Message';
        // message.plainTextBody = 'This is the message body.';
        // Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        // Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {conn.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject(subject);
                mail.setPlainTextBody(body);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(
                                         new Messaging.SingleEmailMessage[] { mail });
   

            }


        }

    // }
// }