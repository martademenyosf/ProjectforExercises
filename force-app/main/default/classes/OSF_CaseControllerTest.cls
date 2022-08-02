/**********************************************************************
 * @Name         : OSF_CaseControllerTest
 * @Description  : test class for OSF_CaseController.
 *
 * @Created By   : Marta Demeny
 * @Created Date : 05 jul. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
@isTest
 public with sharing class OSF_CaseControllerTest {
/**********************************************************************
 * @Name         : setup
 * @Description  : Helper method to create the testing data.
 * @Created By   : Marta Demeny
 * @Created Date : 05 jul. 2022
 *
 *********************************************************************/ 
    @testSetup 
    private static void setup() {
        Profile pf = [Select Id from profile where Name='System Administrator']; 
      
        User caseOwner = createTestempUser(pf.Id, 'Test', 'User');

        List<Case> caseList = new List<Case>();
        for ( Integer i = 0; i < 3; i++) {
            Case cs = new Case(Origin = 'Web', Status = 'New', Subject = 'Subject ' + i, OwnerId = caseOwner.Id);
            caseList.add(cs);
        }
        insert caseList;
    }
    /**********************************************************************
     * @Name         : createTestempUser
     * @Description  : Create a temporary user with unique username.
     * @Created By   : Marta Demeny
     * @Created Date : 05 jul. 2022
     * 
     * @param Id - contains the profil Id
     * @param String - string contains the user first name
     * @param String - string contains the user last name
     * @return User - User object containing the created user
     *
     *********************************************************************/
    public static User createTestTempUser(Id profilId, String fName, String lName) {  
  
        String orgId = UserInfo.getOrganizationId();  
        String dateString =   
        String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt;  
        User tempUser = new User(FirstName = fName,  
                                LastName = lName,  
                                email = uniqueName + '@test' + orgId + '.org',  
                                Username = uniqueName + '@test' + orgId + '.org',                                 
                                ProfileId = profilId, 
                                EmailEncodingKey = 'ISO-8859-1', 
                                Alias = uniqueName.substring(18, 23), 
                                TimeZoneSidKey = 'America/Los_Angeles', 
                                LocaleSidKey = 'en_US', 
                                LanguageLocaleKey = 'en_US'
                                );  
        insert tempUser;  
        return tempUser;  
          
    }    
    /**********************************************************************
     * @Name         : testGetCases
     * @Description  : Test method for getCases.
     * @Created By   : Marta Demeny
     * @Created Date : 05 jul. 2022
     *
     *********************************************************************/
    @isTest
    private static void testGetCases() {
        User ownerUser = [SELECT Name FROM User WHERE Name = 'Test User'];
        List<Case> openCases = OSF_CaseController.getCases(ownerUser.Id);
        System.assertEquals(3, openCases.size());
    }
    /**********************************************************************
     * @Name         : testGetCustomFields
     * @Description  : Test method for getCustomFields.
     * @Created By   : Marta Demeny
     * @Created Date : 05 jul. 2022
     *
     *********************************************************************/
    @isTest
    private static void testGetCustomFields() {
        List<Component_Fields__mdt> customFields = OSF_CaseController.getCustomFields();
        System.assert(customFields.size() > 0);
    }    
}