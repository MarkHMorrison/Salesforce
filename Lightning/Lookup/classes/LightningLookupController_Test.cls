/**
 * @description Test for LightningLookupController
 * @author Mark H. Morrison
 * @date Fri Jun 29 2018
 * Copyright (c) 2018 Crusader Ent.
 */
@isTest
private class LightningLookupController_Test {

  @testSetup
  static void setup() {
    Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
  }

  @isTest
  static void testLookupRecords() {
    String results = LightningLookupController.lookupRecords('Account', 'Name', 'Id', 10, 'Name', 'Test');
    LightningLookupController.ObjectWrapper[] objectWrappers = (LightningLookupController.ObjectWrapper[]) JSON.deserialize(results, List<LightningLookupController.ObjectWrapper>.class);
    System.debug('Results: ' + results);
    System.debug('Results JSON D: ' + objectWrappers);
    System.assertEquals(1, objectWrappers.size());
    System.assertEquals(72, results.length());
  }
}