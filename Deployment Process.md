# Deployments in Salesforce are handled through Change Sets and Deployment Steps.  

Change Sets are created in the Salesforce instance and include most of the changes created 

## Important: All development must start in a Dev sandbox at the lowest level.  Either your own NameDev sandbox or one that is being shared for the sprint: Sprint3Dev.

### From the Developer sandbox:

- Run all local tests from Apex Test Execution(all tests should pass) before you begin development. 
  - Find root cause of failure, Make appropriate changes(Refresh, Development changes) until all tests pass
- Implement new process
  - As you work, update current sprint's Change Set and Deployment Steps with any necessary info.
- Run all tests from Apex again to verify all is passing.
Test manually
- Deploy Change Set with every object, field, record type that was affected by your changes to the Test sandbox, 
  - DO NOT ADD  PROFILES TO CHANGE SETs. Add any changes to the Deployment Steps

### From the Test sandbox:

- Run Validate on the Change Set:
  - Select Run all local tests
- Once Validated use the Quick Deploy link to deploy to Test.
- Validate the Deployment Steps by executing all Post Deployment steps on the Test sandbox including: 
  - Update all profiles to include any Fields, Object, and user permissions
  - Check Page Layout assignments
  - Verify all picklist changes per profile
- Run all tests from Apex Test Execution.  This will validate Post Deployment Steps
- Manually test and validate changes
- Begin Product Owner(PO) review
- If Testing Fails, run updates in Dev sandbox for changes, creating a new Change Set with the updates to start the deploy to Test.
- Once all testing is complete and PO's have signed off then we are ready to combine this with other updates into a complete Change Set for QA.
- Add all updates to the Sprint Change Set 
- Deploy Sprint Change Set to QA

### From the QA sandbox:

- Run Validate on the Sprint Change Set:
  - Select Run all local tests
- Once Validated use the Quick Deploy link to deploy to QA.
- Validate the Deployment Steps by executing all Post Deployment steps on the QA sandbox including: 
  - Update all profiles to include any Fields, Object, and user permissions
  - Check Page Layout assignments
  - Verify all picklist changes per profile
- Run all tests from Apex Test Execution.  This will validate Post Deployment Steps
- Manually test and validate changes
- Begin UAT if necessary.
- Once all testing is complete and UATs have been completed then we are ready to move to Production.
- If any updates are found...  either:
  - The process starts over from Dev sandbox and works its way back up to QA with a single Change Set from Test
  - A new ticket is added to the backlog and prepped for a different sprint.

### To Production:

- Once QA has been validated and and we are ready to move to move changes to Production
- From the Test sandbox, deploy the same Sprint Change Set to Production
- Run Validate on the Sprint Change Set
  - Select Run all local tests
- Once Validated we can coordinate with users and other integrations to use the Quick Deploy link to deploy to Production.
- Validate the Deployment Steps by executing all Post Deployment steps on the Production sandbox including: 
  - Update all profiles to include any Fields, Object, and user permissions
  - Check Page Layout assignments
  - Verify all picklist changes per profile
- Run all tests from Apex Test Execution.  This will validate Post Deployment Steps
- Monitor Production to be sure all changes are running smoothly
