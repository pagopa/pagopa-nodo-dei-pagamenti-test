Feature: Search on Admin panel 
  Scenario: Search a registered user on Admin panel 
    Given access to Admin Panel with Admin
    When search fiscal code of registered user 
    Then the list is displayed
    

    