Feature: Search on Admin panel 
  Scenario: Search a registered user on Admin panel 
    Given access to Admin Panel with Admin
    When search a user's Telephone
    Then the user is displayed