/**
 * @description : Controller for Lookup Lighting Component
 * @author :      Mark H. Morrison
 * @date :        Fri Jun 29 2018
 * Copyright (c) 2018 Jackson
 */
public class LightningLookupController {

  /**
   * @description Returns JSON of list of ObjectWrapper to Lex Components
   * @author Mark H. Morrison
   * @param objectName -     Name of SObject
   * @param fld_API_Text -   API name of field to display to user while searching
   * @param fld_API_Val -    API name of field to be returned by Lookup COmponent
   * @param lim -            Total number of record to be returned
   * @param fld_API_Search - API name of field to be searched
   * @param searchText -     text to be searched
   * @return JSON serialized results string
   */
  @AuraEnabled 
  public static String lookupRecords(String objectName, String fld_API_Text, String fld_API_Val, Integer lim, String fld_API_Search, String searchText ) {
    
    searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
    
    String query = 'SELECT ' + fld_API_Text + ' ,' + fld_API_Val + 
      ' FROM ' + objectName +
      ' WHERE ' + fld_API_Search + ' LIKE ' + searchText + ' LIMIT ' + lim;
    
    sObject[] sObjects = Database.query(query);
    ObjectWrapper[] objectWrappers = new ObjectWrapper[]{};
    
    for(SObject sObj : sObjects){
      ObjectWrapper resWrapper = new ObjectWrapper();
      resWrapper.objName = objectName;
      resWrapper.text = String.valueOf(sObj.get(fld_API_Text)) ;
      resWrapper.val = String.valueOf(sObj.get(fld_API_Val))  ;
      objectWrappers.add(resWrapper);
    } 
     return JSON.serialize(objectWrappers) ;
  }
  
  public class ObjectWrapper{
    public String objName {get; set;}
    public String text {get; set;}
    public String val {get; set;}
  }
}
