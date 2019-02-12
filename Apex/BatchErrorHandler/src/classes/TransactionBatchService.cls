global class TransactionBatchService implements Database.Batchable<sObject>, Database.Stateful {
  global Integer recordsProcessed = 0;
  global Integer recordsNotProcessed = 0;
  global String errorMessages = '';
  String batchQuery;

  public TransactionBatchService() {
    batchQuery = 'SELECT Id ' +
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
    System.debug('constructor batchQuery: ' + batchQuery);
  }

  global Database.QueryLocator start(Database.BatchableContext bc) {
    System.debug('start batchQuery: ' + batchQuery);
    return Database.getQueryLocator(batchQuery);
  }

  global void execute(Database.BatchableContext bc, causeview__Gift__c[] scope) {
    // Set all Transaction Id's from the scope
    Set<Id> transactionIds = new Set<Id>(new Map<Id, causeview__Gift__c>(scope).keySet());
    // Get all Receipts
    causeview__Receipt__c[] receipts = [
      SELECT Id 
      FROM causeview__Receipt__c 
      WHERE causeview__Gift__c IN :transactionIds
        AND causeview__Status__c != 'Issued'
        AND causeview__Receipt_Email_Address__c != null
        AND causeview__Receipt_Type__c != 'Consolidated'
    ];
    if(!receipts.isEmpty()) {
      Database.SaveResult[] saveResults = Database.update(receipts,false);
      Integer recordId = 0;
      for(Database.SaveResult saveResult : saveResults) {
        if(!saveResult.isSuccess()) {
          errorMessages += '\nReceipt Record Id: ' + receipts[recordId].Id;
          for(Database.Error error: saveResult.getErrors()) errorMessages += '\n - ' + error.getMessage();
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

    String emailBody = '\n\nJob Items (Batches):';
    emailBody += '\n - Total: ' + jobResult.TotalJobItems;
    emailBody += '\n - Processed: ' + jobResult.JobItemsProcessed;
    emailBody += '\n - Errors: ' + jobResult.NumberOfErrors;
    if(jobResult.ExtendedStatus != null) emailBody += '\n\n' + jobResult.ExtendedStatus;
    emailBody += '\n\nRecord Counts:';
    emailBody += '\n - Total: ' + recordsProcessed;
    emailBody += '\n - Errors: ' + recordsNotProcessed;
    emailBody += '\n' + errorMessages;
 
    Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
    emailMessage.setToAddresses(new String[] {'yourName@gmail.com'});
    emailMessage.setSubject(UserInfo.getOrganizationName() + ': TransactionBatchService: ' + jobResult.Status);
    emailMessage.setPlainTextBody(emailMessage.getSubject() + emailBody);
    if(!Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailBody});
    else System.debug(emailMessage.getPlainTextBody());
  }
}
