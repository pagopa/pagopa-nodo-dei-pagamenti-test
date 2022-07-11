Feature: Search on Admin panel 
  Scenario: Search a not registered user on Admin panel 
    Given access to Admin Panel with Admin
    When search fiscal code of not registered user
    Then the user is not displayed
    

    