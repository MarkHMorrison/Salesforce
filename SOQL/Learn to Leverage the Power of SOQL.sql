-- Base
SELECT Id, Name, Phone FROM Account

-- WHERE
SELECT Id, Name, Phone From Account
WHERE Phone = null

-- AND
SELECT Id, Name, Phone, Type From Account
WHERE Phone = null
  AND Type = ‘Prospect’

-- OR
SELECT Id, Name, Phone, Type, Industry, BillingState From Account
WHERE Phone = null
  AND Type = 'Prospect'
  AND (Industry = 'Energy' OR BillingState = 'CA')

-- LIMIT
SELECT Id, Name FROM Account
LIMIT 250

-- ORDER BY (ASC / DESC)
SELECT Id, Name FROM Account
ORDER BY Name ASC

-- IN ()
SELECT Id, Name FROM Account
WHERE BillingState IN ('TN','GA','NC')

-- NOT IN ()
SELECT Id, Name FROM Account
WHERE BillingState NOT IN ('TN','GA','NC')

-- LIKE (% / _)
SELECT Id, Name FROM Contact
WHERE  Email LIKE '%@g_ail.com'

-- COUNT()
SELECT COUNT() FROM Account
WHERE Phone != null

-- GROUP BY
SELECT BillingState, COUNT(Id) FROM Account
GROUP BY  BillingState

-- SUM(), MIN(), MAX(), AVG()
SELECT SUM(Amount), MIN(Amount), MAX(Amount), AVG(Amount) FROM Opportunity

-- Querying a Parent Object Using Dot Notation
SELECT Id, Name, Account.Name
FROM Contact

-- Querying a Related Object Using Dot Notation
SELECT Invoice__c, Merchandise__r.Name
FROM Line_Item__c

-- Querying a Child Object Using Sub Queries
SELECT Id, Name, 
  (SELECT Name, Title FROM Contacts)
FROM Account

-- Querying a Child Object Using Sub Queries
SELECT Id, Name, Owner.Name,
  (
    SELECT Id, Merchandise__r.Name 
    FROM Line_Items__r
  )
FROM Invoice__c

-- Id field Semi-Join
SELECT Id, Name FROM Account
WHERE Id IN 
  ( 
    SELECT AccountId FROM Opportunity
    WHERE StageName = 'Closed Lost'
  )

-- Reference Field Anti-Join
SELECT Id FROM Opportunity
WHERE AccountId NOT IN 
 ( 
   SELECT AccountId FROM Contact
   WHERE LeadSource = 'Web'
 )

-- Use FIELDS(ALL)
SELECT FIELDS(ALL) FROM Contact LIMIT 200

-- Use FIELDS(STANDARD)
SELECT FIELDS(STANDARD) FROM Contact LIMIT 200

-- Use FIELDS(CUSTOM)
SELECT FIELDS(CUSTOM) FROM Contact LIMIT 200
