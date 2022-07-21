Feature: Search on Admin panel 
  Scenario: Search a list of 20 transaction on Admin panel
  Given access to Admin Panel with Admin
  When Search a user's Codice Fiscale
  And click on view transactions
  Then the list of transactions is displayed