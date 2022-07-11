Feature: Display stato on Admin panel 
  Scenario: Display a registered user's stato on Admin panel 
    Given access to Admin Panel with Admin
    When search a registered user's Codice Fiscale 
    Then the user is displayed
    And field registered is displayed 

   @prova
  Scenario: Display a SPID user's stato on Admin panel 
    Given access to Admin Panel with Admin
    When search a SPID user's Codice Fiscale 
    Then the user is displayed
    And field Registered_Spid is displayed 
  