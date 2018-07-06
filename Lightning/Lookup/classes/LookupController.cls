/**
 * @description : Controller for Lighting Lookup Component
 * @author :      Jitendra Zaa https://www.jitendrazaa.com/blog/salesforce/embed-lightning-component-in-flow/
 * @author :      Mark H. Morrison
 * @date :        Fri Jun 29 2018
 */
public class LookupController {
  /**
   * @description Returns JSON of list of ObjectWrapper to Lex Components
   * @author Mark H. Morrison
   * @param objectName   = Name of SObject
   * @param displayField = API name of field to display to user while searching
   * @param valueField   = API name of field to be returned by Lookup Component
   * @param searchField  = API name of field to be searched
   * @param filterField  = API name of field to filter by
   * @param filterValue  = Value what to filter 
   * @param whereClause  = Where clasue to be used to customize the search
   * @param searchLimit  = Total number of record to be returned
   * @param searchText   = text to be searched
   * @return JSON serialized results string
   */
  @AuraEnabled 
  public static String lookupRecords(
    String objectName, String displayField, String valueField, String searchField, 
    String filterField, String filterValue, String whereClause, Integer searchLimit, 
    String searchText) {
    
    searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
    
    String soql = 'SELECT ' + displayField + ' ,' + valueField + 
      ' FROM ' + objectName +
      ' WHERE ' + searchField + ' LIKE ' + searchText;

    Boolean isFilter = (filterField != null && filterField != '' && filterValue != null && filterValue != '');
    if(isFilter) {
      soql += ' AND ' + filterField + ' =\'' + filterValue + '\'';
    }

    Boolean isWhereClause = (whereClause != null && whereClause != '');
    if(isWhereClause) {
      soql += ' AND ' + whereClause;
    }

    soql += ' ORDER BY ' + displayField + ' LIMIT ' + searchLimit;
    System.debug('========> soql = ' + soql);

    sObject[] sObjects = Database.query(soql);
    ObjectWrapper[] objectWrappers = new ObjectWrapper[]{};
    
    for(SObject sObj : sObjects){
      ObjectWrapper resWrapper = new ObjectWrapper();
      resWrapper.objName = objectName;
      resWrapper.text = String.valueOf(sObj.get(displayField)) ;
      resWrapper.val = String.valueOf(sObj.get(valueField))  ;
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