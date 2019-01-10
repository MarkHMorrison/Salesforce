global class TransactionBatchService implements Database.Batchable<sObject>, Database.Stateful {
  global Integer recordsProcessed = 0;
  global Integer recordsNotProcessed = 0;
  global String errorMessages = '';
  String query;

  public TransactionBatchService() {
    query = 'SELECT Id ' +
      'FROM causeview__Gift__c ' +
      'WHERE PaymentTypeCreditACH__c > 0 ' +
        'AND causeview__Amount__c > 0 ' +
        'AND causeview__Gift_Type__c = \'One Time Gift\' ' +
        'AND Id IN (' +
          'SELECT causeview__Gift__c FROM causeview__Receipt__c ' +
          'WHERE causeview__Status__c != \'Issued\' ' +
          'AND causeview__Receipt_Email_Address__c != null ' +
          'AND causeview__Receipt_Type__c != \'Consolidated\' ' +
          'AND causeview__Receipt_Date__c = LAST_N_DAYS:5' +
        ') ' +
        'AND Id IN (' +
          'SELECT causeview__Donation__c FROM causeview__Payment__c ' +
          'WHERE Email_Receipts_Sent__c = null' +
        ')';
  }

  global Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext bc, List<causeview__Gift__c> scope) {
    // Set all Transaction Id's from the scope
    Set<Id> transactionIds = new Set<Id>(new Map<Id, causeview__Gift__c>(scope).keySet());
    // Get all Receipts
    List<causeview__Receipt__c> receipts = [
      SELECT Id 
      FROM causeview__Receipt__c 
      WHERE causeview__Gift__c IN :transactionIds
        AND causeview__Status__c != 'Issued'
        AND causeview__Receipt_Email_Address__c != null
        AND causeview__Receipt_Type__c != 'Consolidated'
    ];
    if (!receipts.isEmpty()) {
      List<Database.SaveResult> saveResults = Database.update(receipts,false);
      Integer recordId = 0;
      for (Database.SaveResult saveResult : saveResults) {
        if (!saveResult.isSuccess()) {
          errorMessages += '\nReceipt Record Id: ' + receipts[recordId].Id;
          for (Database.Error error: saveResult.getErrors()) {
            errorMessages += '\n - ' + error.getMessage();
          }
          recordsNotProcessed++;
        }
        recordsProcessed++;
        recordId++;
      }    
    }
  }

  global void finish(Database.BatchableContext bc) {
    AsyncApexJob jobResult = [
      SELECT Id, Status, ExtendedStatus, NumberOfErrors, JobItemsProcessed, TotalJobItems
      FROM AsyncApexJob
      WHERE Id = :bc.getJobId()
    ];

    String mailMessage = 'Transaction Batch Service status: ' + jobResult.Status;
    mailMessage += '\n\n - Total Job Items: ' + jobResult.TotalJobItems;
    mailMessage += '\n - Jobs Items Processed: ' + jobResult.JobItemsProcessed;
    mailMessage += '\n - Number of errors: ' + jobResult.NumberOfErrors;
    if (jobResult.ExtendedStatus != null) mailMessage += '\n\n' + jobResult.ExtendedStatus;
    mailMessage += '\n\nRecord Counts:';
    mailMessage += '\n\n - Total: ' + recordsProcessed;
    mailMessage += '\n - Errors: ' + recordsNotProcessed;
    mailMessage += '\n' + errorMessages;
    sendMessage(UserInfo.getOrganizationName() + ' Transaction Batch Service ' + jobResult.Status, mailMessage);
  }

  private void sendMessage(String subject, String body) {
    Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
    emailMessage.setToAddresses(new String[] { 'markhmorrison@gmail.com' });
    emailMessage.setSubject(subject);
    emailMessage.setPlainTextBody(body);
    if (Test.isRunningTest()) System.debug(subject + ': ' + body);
    else Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMessage });
  }
}
