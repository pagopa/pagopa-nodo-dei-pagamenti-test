Feature: Display username on Admin panel 
  Scenario: Display a different_user user's username on Admin panel 
    Given access to Admin Panel with Admin
    When search a different_user user's Codice Fiscale 
    Then the user is displayed
    And username is displayed 
    And username is not equal to mail

    
  Scenario: Display a SPID user's username on Admin panel 
    Given access to Admin Panel with Admin
    When search a SPID user's Codice Fiscale 
    Then the user is displayed
    And username is displayed 
    And username is equal to mail
    