/**
 * @description Helper functions for Lookup Controller
 * @author Jitendra Zaa https://www.jitendrazaa.com/blog/salesforce/embed-lightning-component-in-flow/
 * @author Mark H. Morrison
 * @date Tue Jul 03 2018
 */
({
  /**
   * @description Handles the response from the server and set variable on the component
   * @param {callback response} response  - response from the server callback 
   * @param {[aura]}            component - gives access to the main conponent 
   * @param {[aura]}            helper    - gives access to the helper methods
   */
  handleResponse : function(response, component, helper) {
    if(response.getState() === 'SUCCESS') {
      var retObj = JSON.parse(response.getReturnValue());
      if(retObj.length <= 0){
        var noResult = JSON.parse('[{"text":"No Results Found"}]');
        component.set("v.serverResult",noResult); 
        component.set("v.lastServerResult",noResult);
      } else {
        component.set("v.serverResult",retObj); 
        component.set("v.lastServerResult",retObj);
      }  
    } else if(response.getState() === 'ERROR') {
      var errors = response.getError();
      if(errors) {
        if(errors[0] && errors[0].message) {
          alert(errors[0].message);
        }
      } 
    }
  },
  /**
   * @description Gets the index of the target item passed in and returns is
   * @param  {target}    target          - response from the server callback 
   * @param  {[aura]}    helper          - gives access to the helper methods
   * @param  {string}    attributeToFind - name of attribute to find
   * @return {attribute} selectedIndex   - the index of the target
   */
  getIndexFromParent : function(target, helper, attributeToFind) {
    //User can click on any child element, so traverse till intended parent found
    var selectedIndex = target.getAttribute(attributeToFind);
    while(!selectedIndex) {
      target = target.parentNode ;
      selectedIndex = helper.getIndexFromParent(target, helper, attributeToFind);           
    }
    return selectedIndex;
  },
  /**
   * @description Sets component variables to null
   * @param {[aura]} component - gives access to the main conponent 
   * @param {event}  event     - the event info
   * @param {[aura]} helper    - gives access to the helper methods
   */
  clearSelection : function(component, event, helper) {
    component.set("v.selectedItem",null);
    component.set("v.selectedValue",null);
    component.set("v.serverResult",null);
  } 
})