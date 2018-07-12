@isTest
private class TransactionBatchServiceTest {

  @testSetup
  static void testSetup() {
    //create data for test
  }

  @isTest
  static void testTransactionBatchService() {
    Test.startTest();
      TransactionBatchService service = new TransactionBatchService();
      Database.executeBatch(service);
    Test.stopTest();
  }
}