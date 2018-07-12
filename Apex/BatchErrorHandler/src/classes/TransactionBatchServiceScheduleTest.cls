@isTest
public class TestTransactionBatchScheduleService {
  static final String CRON_EXP = '0 0 0 15 3 ? 2022';

  @testSetup
  static void setupData() {
  }
    
  @isTest
  static void testTransactionBatchSchedule() {
    Test.startTest();
      TransactionBatchScheduleService scheduleService = new TransactionBatchScheduleService();
      // Schedule the test job
      String jobId = System.schedule('ScheduleTransactionBatchTest', CRON_EXP, scheduleService);
      // Get the information from the CronTrigger API object
      CronTrigger cron = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, cron.CronExpression);
      // Verify the job has not run
      System.assertEquals(0, cron.TimesTriggered);
      // Verify the next time the job will run
      System.assertEquals('2022-03-15 00:00:00', String.valueOf(cron.NextFireTime));
      scheduleService.execute(null);
    Test.stopTest();
  }
}