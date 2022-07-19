Feature: Search mail on Admin panel 
  Scenario: Search a user's mail on Admin panel 
    Given access to Admin Panel with Admin
    When search a user's mail
    Then the mail is displayed