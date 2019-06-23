/**
 * @description Test class for CampaignContactsViewController class.
 * @author Mark H. Morrison 
 * @date Fri Mar 1 2019
 */
public with sharing class CampaignContactsViewController {

  @AuraEnabled(cacheable=true)
  public static CampaignMember[] getCampaignMembers() {
    System.debug('Getting CampaignMembers');
    User thisUser = [SELECT Id, Name, Division FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    System.debug('thisUser: ' + thisUser + ' | Divison: ' + thisUser.Division);
    String[] userDivisions = thisUser.Division.remove(' ').split(',');
    System.debug('userDivisons: ' + userDivisions);

    String dynamicQuery = 
      'SELECT Id, Name, ' +
        'ContactId, Contact.Account.Name, Contact.MailingState, ' +
        'Campaign.Name ' +
      'FROM CampaignMember ' +
      'WHERE Campaign.IsActive = true ' +
        'AND Campaign.Status = \'In Progress\' ' +
        'AND Campaign.StartDate <= TODAY ' +
        'AND Campaign.EndDate >= TODAY ' +
        'AND Contact.MailingState IN :userDivisions ';

    dynamicQuery += 'ORDER BY Campaign.StartDate, Contact.MailingState';
    System.debug('dynamicSOQL: ' + dynamicQuery);

    return Database.query(dynamicQuery);
  }
}
