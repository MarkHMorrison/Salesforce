import { LightningElement, api, track, wire } from 'lwc';
import getMembers from '@salesforce/apex/CampaignContactsViewController.getCampaignMembers';

export default class CampaignContactsView extends LightningElement {
  @api name;
  @track contacts;
  @track contactLength;
  @track error;

  @wire(getMembers) 
  wiredGetMembers(result) {
    let members = [];
    if(result.data) {
      result.data.forEach(campaignMember => {
        let member = {
          Id: campaignMember.Id,
          Name: campaignMember.Name,
          Account: campaignMember.Contact.Account.Name,
          CampaignName: campaignMember.Campaign.Name,
          Division: campaignMember.Contact.MailingState, 
          Link: location.protocol + '//' + location.host + '/' + campaignMember.ContactId
        };
        members.push(member);
      });
      // Set page variable with returned data
      this.contacts = members;
      this.contactLength = result.data.length;
      this.error = undefined;
    } else if(result.error) {
      this.contacts = undefined;
      this.error = 'No Advisors found in current active Campaigns for you.';
    }
  }
}