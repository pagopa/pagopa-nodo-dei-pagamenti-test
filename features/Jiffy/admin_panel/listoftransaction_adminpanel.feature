Feature: Search on Admin panel 
  Scenario: Search a list of 20 transaction on Admin panel
  Given access to Admin Panel with Admin
  When search fiscal code of registered user
  And click on view transactions
  Then the list of transactions is displayed