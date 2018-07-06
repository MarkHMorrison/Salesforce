/**
 * @description Controller for Lookup Component
 * @author Jitendra Zaa https://www.jitendrazaa.com/blog/salesforce/embed-lightning-component-in-flow/
 * @author Mark H. Morrison
 * @date Tue Jul 03 2018
 */
({
  /**
   * @description Gets selected item info and set variable for it
   * @param {[aura]} component - gives access to the main conponent 
   * @param {event}  event     - the event info
   * @param {[aura]} helper    - gives access to the helper methods
   */
  itemSelected : function(component, event, helper) {
    console.log('Item selected');
    var target   = event.target;   
    var SelIndex = helper.getIndexFromParent(target, helper, "data-selectedIndex");  
    if(SelIndex) {
      var serverResult = component.get("v.serverResult");
      var selectedItem = serverResult[SelIndex];
      if(selectedItem.val) {
        component.set("v.selectedValue", selectedItem.val); 
        component.set("v.selectedItem", selectedItem);
        component.set("v.lastServerResult", serverResult);
      }
      component.set("v.serverResult", null); 
    }
  }, 
  /**
   * @description Populates variables to send to server, gets a response, and updates component
   * @param {[aura]} component - gives access to the main conponent 
   * @param {event}  event     - the event info
   * @param {[aura]} helper    - gives access to the helper methods
   */
  serverCall : function(component, event, helper) {
    var target         = event.target;  
    var searchText     = target.value; 
    var lastSearchText = component.get("v.lastSearchText");
    //Escape button pressed 
    if(event.keyCode == 27 || !searchText.trim()) {
      helper.clearSelection(component, event, helper);
    } else if(searchText.trim() != lastSearchText) {
      //Save server call, if last text not changed

      var objectName   = component.get("v.objectName");
      var displayField = component.get("v.displayField");
      var valueField   = component.get("v.valueField");
      var searchField  = component.get("v.searchField");
      var filterField  = component.get("v.filterField");
      var filterValue  = component.get("v.filterValue");
      var whereClause  = component.get("v.whereClause");
      var searchLimit  = component.get("v.searchLimit");

      var action = component.get('c.lookupRecords');
      action.setStorable();
      
      action.setParams({
        objectName : objectName,
        displayField : displayField,
        valueField : valueField,
        searchField : searchField,
        filterField : filterField,
        filterValue : filterValue,
        whereClause : whereClause,
        searchLimit : searchLimit, 
        searchText : searchText        
      });
      
      action.setCallback(this, function(response){
        helper.handleResponse(response, component, helper);
      });
      
      component.set("v.lastSearchText", searchText.trim());
      console.log('Server call made');
      $A.enqueueAction(action); 
    } else if(searchText && lastSearchText && searchText.trim() == lastSearchText.trim()) { 
      component.set("v.serverResult",component.get("v.lastServerResult"));
      console.log('Server call saved');
    }         
  },
  /**
   * @description Makes a call to a helper method to cleat selections in the component
   * @param  {[aura]}  component [description]
   * @param  {Boolean} event    [if function is being called from init event]
   * @param  {Boolean} helper    [if function is being called from init event]
   * @return {[type]}            [void]
   */
  clearSelection : function(component, event, helper) {
    helper.clearSelection(component, event, helper);
  } 
})