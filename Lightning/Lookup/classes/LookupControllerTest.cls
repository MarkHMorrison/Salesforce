/**
 * @description Test for LookupController
 * @author Mark H. Morrison
 * @date Fri Jun 29 2018
 */
@isTest
private class LookupControllerTest {

  @testSetup
  static void setup() {
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;
  }

  @isTest
  static void testLookupRecords() {
    String results = LookupController.lookupRecords('Account', 'Name', 'Id', 'Name', '', '', '', 10, 'Test');
    LookupController.ObjectWrapper[] objectWrappers = (LookupController.ObjectWrapper[]) JSON.deserialize(results, List<LookupController.ObjectWrapper>.class);
    System.debug('Results: ' + results);
    System.debug('Results JSON D: ' + objectWrappers);
    System.assertEquals(1, objectWrappers.size());
  }

  @isTest
  static void testLookupRecordsWithFilters() {
    String results = LookupController.lookupRecords('Account', 'Name', 'Id', 'Name', 'Name', 'New', '', 10, 'Test');
    LookupController.ObjectWrapper[] objectWrappers = (LookupController.ObjectWrapper[]) JSON.deserialize(results, List<LookupController.ObjectWrapper>.class);
    System.debug('Results: ' + results);
    System.debug('Results JSON D: ' + objectWrappers);
    System.assertEquals(0, objectWrappers.size());
  }

  @isTest
  static void testLookupRecordsWhereClause() {
    String results = LookupController.lookupRecords('Account', 'Name', 'Id', 'Name', '', '', 'Industry = \'\'', 10, 'Test');
    LookupController.ObjectWrapper[] objectWrappers = (LookupController.ObjectWrapper[]) JSON.deserialize(results, List<LookupController.ObjectWrapper>.class);
    System.debug('Results: ' + results);
    System.debug('Results JSON D: ' + objectWrappers);
    System.assertEquals(1, objectWrappers.size());
  }
}