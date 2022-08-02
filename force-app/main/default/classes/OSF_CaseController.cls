/**********************************************************************
 * @Name         : OSF_CaseController
 * @Description  : Class containing callable functions from LWC.
 *
 * @Created By   : Marta Demeny
 * @Created Date : 01 jul. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
public with sharing class OSF_CaseController {
/**********************************************************************
 * @Name         : getCases
 * @Description  : Returns list of not closed cases 
 *
 * @Created By   : Marta Demeny
 * @Created Date : 01 jul. 2022
 *
 * @param String - string containing customer id
 * @return List<Case> - list of result objects
 *********************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(String ownerId) {

        return [
            SELECT Id, CaseNumber, Origin, Status
            FROM Case
            WHERE Status != 'Closed'
            AND createdbyid = :ownerId
        ];
    }

/**********************************************************************
 * @Name         : getCustomFields
 * @Description  : Returns the records from  Component_Fields__mdt custom metadata
 *
 * @Created By   : Marta Demeny
 * @Created Date : 01 jul. 2022
 *
 * @return List<Component_Fields__mdt> - list of result objects
 *********************************************************************/
@AuraEnabled(cacheable=true)
public static List<Component_Fields__mdt> getCustomFields() {

//    return Component_Fields__mdt.getAll().values();
    return [SELECT Field_Name__c, Default_Value__c, Field_Api_Name__c, isReadOnly__c FROM Component_Fields__mdt];
}    
}
