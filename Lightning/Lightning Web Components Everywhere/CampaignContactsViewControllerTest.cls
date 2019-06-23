/**
 * @description Test class for CampaignContactsViewController class.
 * @author Mark H. Morrison 
 * @date Fri Mar 1 2019
 */
@isTest
private class CampaignContactsViewControllerTest {

  @testSetup
  private static void setup(){
    User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
    thisUser.Division = 'CA';
    update thisUser;

    User[] testUsers = new User[]{};
    User testUser1 = (User)TestFactory.createSObject(
      new User(
        Division = 'TN'
      )
    );
    testUsers.add(testUser1);
    insert testUsers;
    System.assertNotEquals(null, testUsers[0].Id, 'Insert testUsers failed');

    System.runAs(testUser1) {
      Account testAccount = (Account)TestFactory.createSObject(
        new Account(), true
      );
      System.assertNotEquals(null, testAccount.Id, 'Insert testAccount failed');

      Contact[] testContacts = (Contact[])TestFactory.createSObjectList(
        new Contact(
          AccountId    = testAccount.Id, 
          MailingState = 'CA'
        ), 10, true
      );
      System.assertNotEquals(null, testContacts[0].Id, 'Insert Contacts failed');

      Campaign testCampaign = (Campaign)TestFactory.createSObject(
        new Campaign(), true
      );
      System.assertNotEquals(null, testCampaign.Id, 'Insert Campaign failed');

      CampaignMember[] testCampaignMembers = new CampaignMember[]{};
      for(Contact testContact : testContacts) {
        CampaignMember testCampaignMember = (CampaignMember)TestFactory.createSObject(
          new CampaignMember(
            ContactId  = testContact.Id, 
            CampaignId = testCampaign.Id, 
            Status     = 'Sent'
          )
        );
        testCampaignMembers.add(testCampaignMember);
      }
      insert testCampaignMembers;
      System.assertNotEquals(null, testCampaignMembers[0].Id, 'Insert Contacts failed');
    }
  }

  @isTest
  private static void when_CampaignMembersInState() {
    // when
    Test.startTest();
      CampaignMember[] contacts = CampaignContactsViewController.getCampaignMembers();
    Test.stopTest();
    // then
    System.assertEquals(10, contacts.size());
  }

  @isTest
  private static void when_NoCampaignMembersInState() {
    // when
    User testUser = [SELECT Id FROM User WHERE Name = 'Inigo Montoya Tester'];
    CampaignMember[] contacts;
    
    Test.startTest();
      System.runAs(testUser) {
        contacts = CampaignContactsViewController.getCampaignMembers();
      }
    Test.stopTest();
    // then
    System.assertEquals(0, contacts.size());
  }
}